Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab3ICIk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 04:40:59 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:53100 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759748Ab3ICIky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 04:40:54 -0400
Message-ID: <5225A02B.6080901@linux.vnet.ibm.com>
Date: Tue, 03 Sep 2013 14:09:07 +0530
From: Janani Venkataraman <jananive@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>,
        Roland McGrath <roland@hack.frob.com>,
        Amerigo Wang <amwang@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, xemul@parallels.com,
        Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        avagin@openvz.org, gorcunov@openvz.org,
        James Hogan <james.hogan@imgtec.com>,
        Mike Frysinger <vapier@gentoo.org>,
        "Randy.Dunlap" <rdunlap@xenotime.net>, Eric Paris <eparis@redhat.com>,
        ananth@in.ibm.com, suzuki@in.ibm.com, aravinda@linux.vnet.ibm.com,
        tarundeep.singh@in.ibm.com
Subject: RFD: Non-Disruptive Core Dump Infrastructure
References: <522472DA.4000702@linux.vnet.ibm.com>
In-Reply-To: <522472DA.4000702@linux.vnet.ibm.com>
X-Forwarded-Message-Id: <522472DA.4000702@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090308-2674-0000-0000-00000A7D8A5E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We are working on an infrastructure to create a system core file of a specific 
process at run-time, non-disruptively. It can also be extended to a case where 
a process is able to take a self-core dump. 

gcore, an existing utility creates a core image of the specified process. It
attaches to the process using gdb and runs the gdb gcore command and then 
detaches. In gcore the dump cannot be issued from a signal handler context as
fork() is not signal safe and moreover it is disruptive in nature as the gdb 
attaches using ptrace which sends a SIGSTOP signal. Hence the gcore method 
cannot be used if the process wants to initiate a self dump. 

Previously the non-disruptive dump was tried with the Utrace approach [1]. 
First, all the threads would be assembled at a common place and quiesced using
UTRACE_INTERRUPT. Then the core dump would be triggered upon receiving the 
event, indicating that the last thread of the process has quiesced, from its 
quiesce callback. After several reviews and discussions, the Linux community 
decided not to accept this proposal and has not pushed it upstream due to 
various dependencies and potential risk of breaking existing implementations.
Hence the UTRACE approach is not being pursued. Also Roland had mentioned that
even if the approach worked smoothly,the pause could be a significant 
perturbation [2].

Another approach was using the Freezer subsystem[3]. The freezer functions in 
kernel essentially help start and stop sets of tasks and this approach 
exploited the existing freezer subsystem kernel interface effectively to 
quiesce all the threads of the application before triggering the core dump. 
This approach was not accepted due to the potential Dos attack. Also the 
community discussed that "freeze" is a bit dangerous because an application
which is frozen cannot be ended and while it's frozen and there is no 
information "its frozen" via usual user commands as 'ps' or 'top'.

So ideally what we are trying to do is to export the infrastructure using 
/proc/pid/core. Reading the file would give an ELF Format core-dump at that 
instant non-disruptively,without killing the process.

This would involve basically three operations:

1) Holding the threads of a process without sending a signal (SIGSTOP). At this 
point we can collect the register set snapshot and collect other information 
required to  create the ELF header. The above operation could be initiated with
the open() call.
2) Once the ELF header is created, read() can return the CORE DUMP data 
including, the process memory page-by-page, based on the fpos (file position).
3) The threads could be released upon a close().

So the sub-problem here would be "How to hold these threads,collect the data
and release them non-disruptively?" in order to take a consistent dump.

As Roland had mentioned we could have a user option of having a minimal dump or
a full dump. The minimal dump can get a full register snapshot of the threads 
running in user mode, and as much information as possible for those threads 
that are blocked. Wheres a full dump can additionally get a memory dump as well.

If we provide the user a way to abort the operation, say keeping the threads in
an interruptible state, we should be able to prevent the doS attack which was 
present in the method using the Freezer subsystem. For example we can send a 
signal to the process and it should abort the dump operation and release the 
threads. 

We have analyzed the following options and we would like to know what people 
think is the best or if there are any other mechanisms to perform the operation,
we would be happy to look at it.

1) Task work add 

task_work_add() is an interface and an API. The task work add will run any 
queued work before returning to user space from the kernel. So that work is 
guaranteed to be done before user space can run again. 

* Exploit this function to hold the threads when they are returning to the 
user space.
* Wait until all the threads of the process to be dumped, reach task_work_add.
* Once all the threads have reached, the dump is taken and they are released.

Disadvantage :
* A thread which is blocked in kernel space,would not return to user space soon
and hence wouldn't be trapped in the task_work_add function 
* The dump may be delayed as the other threads would be waiting for this 
specific blocked thread to reach.

Solution:
* A way to solve this problem is to make the other threads that are waiting, 
wait for a fixed time for the blocked thread and then just create a pt_note 
with zeroes to indicate the presence of the blocked thread.

2) CRIU Approach :

This makes use of the CRIU tool and checkpoints when a dump is called, collects 
the required details and continues the running process.
* A self dump cannot be initiated using the command line CRIU which is similar 
to the limitation of gcore.
* A system call to do the same is being implemented which would help us create 
a self dump.The system call is not upstream yet. We could explore that option as
well.

3) PTRACE (SEIZE + INTERRUPT) via kernel thread

In this approach, a kernel thread will play the role of seizing and registering
the states of the threads of the process to be dumped. We could make use of the 
PTRACE_SEIZE + PTRACE_INTERRUPT within the open() to stop the threads without 
SIGSTOP. However during self dump, we cannot make use of the PTRACE_SEIZE as a 
self seize isn't permitted. One option is to offload this to a kernel thread 
and let it capture the information. Once it is complete,the caller may be 
released, so that it could continue with the dump.

* The open call reaches the kernel space during a self dump, a kernel thread
is spawned to seize all the threads of the process including the caller (the 
process that called open) using a PTRACE_SEIZE.
* A PTRACE_INTERRUPT is issued and the required information is collected.
* On a self-dump, the kernel thread releases the caller, so that it can proceed 
with the dumping.


APPENDIX: 

[1] http://www.redhat.com/archives/utrace-devel/2009-July/msg00149.html 
[2] http://www.redhat.com/archives/utrace-devel/2009-August/msg00006.html  
[3] http://lwn.net/Articles/419756// 

Thanking You.
With Regards,
Janani Venkataraman


