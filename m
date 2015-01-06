Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbbAFJIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 04:08:11 -0500
Received: from laurent.telenet-ops.be ([195.130.137.89]:53404 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbbAFJIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 04:08:04 -0500
Message-ID: <54ABA5EB.80507@elis.ugent.be>
Date: Tue, 06 Jan 2015 10:07:55 +0100
From: Stijn Volckaert <Stijn.Volckaert@elis.ugent.be>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>,
        Kees Cook <keescook@chromium.org>
CC: Roland McGrath <roland@hack.frob.com>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        John Johansen <john.johansen@canonical.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH RFC] Allow introspection to already attached ptracer in
 __ptrace_may_access
References: <549ABF87.8060905@elis.ugent.be> <CAGXu5jJWFKK1oJg0iyZtTKSSzXGyDD5B=iA3y7vvyayqhbOP5Q@mail.gmail.com> <54AB29A4.8050500@schaufler-ca.com>
In-Reply-To: <54AB29A4.8050500@schaufler-ca.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 150106-0, 06/01/2015), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler schreef op 6/01/2015 om 1:17:
> On 1/5/2015 3:47 PM, Kees Cook wrote:
>> On Wed, Dec 24, 2014 at 5:28 AM, Stijn Volckaert
>> <Stijn.Volckaert@elis.ugent.be> wrote:
>>> Hello,
>>>
>>> I ran across the following problem recently but I'm not entirely sure
>>> whether this should be fixed in ptrace or in Yama. I'm working on a
>>> ptrace-based monitor that forks off its own tracee during startup. The
>>> monitor attaches to the tracee and then lets the tracee perform an execve
>>> call. This is much like running a program in gdb.
>>>
>>> My monitor is multi-threaded and uses one monitor thread for every tracee
>>> thread so whenever the tracee forks/vforks/clones, I fire up a new monitor
>>> thread, detach the old monitor thread from the tracee thread and attach the
>>> new monitor thread to the tracee thread.
>>>
>>> I have recently stumbled upon several applications in which the main process
>>> A forks off process B and then immediately exits. Under normal circumstances
>>> the following would happen:
>>>
>>> Monitor[0]  ---   FORKS OFF   ---> Monitor[0]'
>>> Monitor[0]  --- PTRACE_ATTACH ---> Monitor[0]'
>>> Monitor[0]' ---    EXECVE     ---> Process A
>>>
>>> Process A   ---   FORKS OFF   ---> Process B
>>> Monitor[0]  --- PTRACE_DETACH ---> Process B
>>> Monitor[1]  --- PTRACE_ATTACH ---> Process B
>>>
>>> With Yama enabled (and the scope set to YAMA_SCOPE_RELATIONAL) however, a
>>> few interesting things can (and usually do) happen:
>>>
>>> 1) If Process A dies before Monitor[1] is attached to Process B, the attach
>>> will fail since from Yama's point of view, Process B is no longer a
>>> descendant of Monitor[1]. This problem is probably hard to fix
>>> but I've circumvented it by delaying the death of Process A until Process B
>>> is attached to Monitor[1].
>> Just to make sure I understand this better, "Monitor" is the initial
>> process, and [0] and [1] are separate threads within that process? I
>> would expect B to have Monitor as its parent after A died, but I must
>> be misunderstanding something.
>>
>> Regardless, your "interesting thing 1" is certainly a side-effect of
>> YAMA_SCOPE_RELATIONAL trying to do its job.
Correct. Process B is obviously still descendant from the process that 
is ptracing it so you'd
think that this would work with YAMA_SCOPE_RELATIONAL. However, after 
process A dies,
/sbin/init becomes the new parent of Process B. If you want to see this 
yourselves, you can
reproduce this problem with this little test program:

$ cat ptrace_bug.c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>

void daemon_process() {
   printf("pre-open\n");
   int fd = open("test.txt", O_RDWR | O_CREAT, S_IRUSR | S_IWUSR);
   if (fd != -1) {
     write(fd, "post-open\n", strlen("post-open\n"));
     close(fd);
   }
   exit(0);
}

int main(int argc, char** argv) {
   if (fork() == 0)
       daemon_process();
   return 0;
}
$ gcc -o ptrace_bug ptrace_bug.c

If I strace this on a machine which I've patched with my proposed patch 
below, I see the following
output for the "daemon_process":

$ strace -o strace_out -ff ./ptrace_bug
$ cat strace_out.2815
...
write(1, "pre-open\n", 9)               = 9
open("test.txt", O_RDWR|O_CREAT, 0600)  = 3
write(3, "post-open\n", 10)             = 10
...

However, on a machine which I haven't patched and with 
YAMA_SCOPE_RELATIONAL, I see:
...
write(1, 0x7f74338c0000, 9)             = 9
open(0x4007bd, O_RDWR|O_CREAT, 0600)    = 3
write(3, 0x4007c6, 10)                  = 10
...

This is the exact same problem: you can still read the regs and 
stop/resume tracees but
you can't do process_vm_{read,write}v or the ptrace ops that depend on it.

If I now add a pause() call just before the exit of the daemon process, 
you'll see the following
after process A dies:

$ ps u
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
stijn    29772  0.0  0.0   4852   820 pts/0    S+   09:41   0:00 strace 
-o strace_out -ff ./ptrace_bug
stijn    29778  0.0  0.0   4300    92 pts/0    S+   09:41   0:00 
./ptrace_bug

$ cat /proc/29778/status
Name:    ptrace_bug
State:    S (sleeping)
Tgid:    29778
Ngid:    0
Pid:    29778
PPid:    1
TracerPid:    29772

PPid is 1 so /sbin/init is now the real parent. As far as I can tell, 
this whole reparenting goes on
in kernel/exit.c due to:

do_exit
   -> exit_notify
     -> forget_original_parent
       -> find_new_reaper

 From my viewpoint, it would make more sense to reparent Process B to 
the ptracer that originally
forked off Process A. However, looking at the exit.c code, what actually 
goes on does seem like
the intended behavior.

>>> 2) More interestingly though, even if Process B does get attached to
>>> Monitor[1], as soon as Process A dies, all process_vm_readv and
>>> process_vm_writev calls on Process B start failing. Any other ptrace
>>> operations peformed on Process B do succeed.
>>>
>>> process_vm_readv|writev use __ptrace_may_access to check whether the
>>> operation is permitted, whereas other ptrace operations (with the exception
>>> of PTRACE_ATTACH) use ptrace_check_attach.
>> Right, process_vm_{read,write}v use PTRACE_MODE_ATTACH (which is what
>> Yama interposes via the LSM entry point in __ptrace_may_access).
>>
>>> To fix this problem, __ptrace_may_access should be forced to return 0 if the
>>> calling process is already attached to the target process.
>>>
>>> The question now is whether or not it's the security module's responsibility
>>> to check whether a tracee relationship is already in place or if ptrace
>>> itself should do it. For the latter case, which seems more logical to me,
>>> you could use the patch below.
>>>
>>> What do you guys think?
>>>
>>> Regards,
>>> Stijn Volckaert
>>>
>>> --
>>>
>>> Signed-off-by: Stijn Volckaert <Stijn.Volckaert@elis.ugent.be>
>>>
>>> --- a/kernel/ptrace.c   2014-12-24 13:53:23.055346526 +0100
>>> +++ b/kernel/ptrace.c   2014-12-24 14:17:20.617824840 +0100
>>> @@ -232,6 +232,9 @@ static int __ptrace_may_access(struct ta
>>>          /* Don't let security modules deny introspection */
>>>          if (same_thread_group(task, current))
>>>                  return 0;
>>> +       /* Don't deny introspection to already attached ptracer */
>>> +       if (!ptrace_check_attach(task, true))
>>> +               return 0;
>>>          rcu_read_lock();
>>>          tcred = __task_cred(task);
>>>          if (uid_eq(cred->uid, tcred->euid) &&
>>>
>> I'm nervous to add this (or Oleg's suggestion) generally to
>> __ptrace_may_access, as it would mean other LSMs would stop seeing
>> access checks even when attached. It does seem silly to deny ptrace
>> checks when already attached, but it does change the behavior here.
> An LSM may chose to do checks on a per access basis. Think in terms
> of access checks on read/write instead of open. Smack and SELinux
> do this for some network checks. It is reasonable to think that there
> is a case where a security attribute (or access rule) could change
> between the attach and the access.
>
> Example: You allow the access when the developer mode switch is
> set, but not when it isn't. Someone flips the switch.
That makes sense I guess. However, the problem in my case was not that 
the security policy
had change between the "open" and the "read/write" check. Instead, after 
the death of
Process A, the security check now lacks the context to see the 
relationship between
the tracer and the tracee.

>> If the other LSM folks don't see a problem here, then it should live
>> in the general case. Otherwise, I'm happy to add this check only in
>> Yama. The existing Yama scopes should ignore attach requests when
>> already attached.
>>
>> -Kees
>>

