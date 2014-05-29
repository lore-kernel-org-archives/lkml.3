Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609AbaE2LcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 07:32:10 -0400
Received: from relay.parallels.com ([195.214.232.42]:40424 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbaE2LcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 07:32:08 -0400
Message-ID: <53871A92.9000004@parallels.com>
Date: Thu, 29 May 2014 15:31:30 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Vasily Kulikov <segoon@openwall.com>
CC: Richard Weinberger <richard.weinberger@gmail.com>,
        <containers@lists.linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2] /proc/pid/status: show all sets of pid according to
 ns
References: <1401272683-1659-1-git-send-email-chenhanxiao@cn.fujitsu.com> <5385DA19.2060008@parallels.com> <20140528182824.GA5057@cachalot> <53863889.9080509@parallels.com> <20140529055954.GA10354@cachalot> <5386F8EA.8050501@parallels.com> <20140529111236.GA14576@cachalot>
In-Reply-To: <20140529111236.GA14576@cachalot>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.24.36.87]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 03:12 PM, Vasily Kulikov wrote:
> On Thu, May 29, 2014 at 13:07 +0400, Pavel Emelyanov wrote:
>> On 05/29/2014 09:59 AM, Vasily Kulikov wrote:
>>> On Wed, May 28, 2014 at 23:27 +0400, Pavel Emelyanov wrote:
>>> ] We need a direct method of getting the pid inside containers.
>>> ] If some issues occurred inside container guest, host user
>>> ] could not know which process is in trouble just by guest pid:
>>> ] the users of container guest only knew the pid inside containers.
>>> ] This will bring obstacle for trouble shooting.
>>>
>>> A new syscall might complicate trouble shooting by admin.
>>
>> Pure syscall -- yes. What if we teach the ps and top utilities to show additional
>> info? I think that would help.
> 
> I like the idea with low level non-shell API which can be used by
> utility like ps (or implementation of a new tool to work with complex
> namespace hierarchies).  It should fit for troublesooting.  Then there
> should be no reason to implement two different APIs for observation from
> shell via FS and from applications.

Maybe we can reuse the existing kcmp() system call? We would have to store
the collected pid values in some hash/tree anyway, and kcmp() provides us
good comparing function for doing this.

Like we can call kcmp(pid1, pid2, KCMP_PID, nsfd1, nsfd2) which will mean
"Are tasks with pid1 in namespace pointed by nsfd1 and with pid2 in namespace
nsfd2 the same?"

What do you think?

> However, maybe it is possible to implement not via new syscall but
> by implementation of new symlink in sysfs?  Then both ps-like tool and
> CRIU-like tool is able to obtain the ns information by the same means.
> Maybe sort of a symlink to a parent namespace or a process which is
> inside of the parent namespace?  Then a process may identify IDs using
> following steps:
> 
> 1) identify target NS by walking current procfs
> 2) do setns(2)/chroot(2)
> 3) look at procfs to identify target IDs in the target NS

Can you elaborate on this? Let's imagine we have picked two tasks with
init_pid_ns' PIDs being 11 and 12 and we've found out using /proc/pid/ns/pid
links that they both live in some non-init pid namespace.

Then we have to look at this ns' proc. It says that there are also two 
tasks -- 2 and 3. How can we determine which pid is which?


By the way, calling setns() doesn't change the pids we see in any proc -- the
namespace proc shows pids for is pinned at proc mount time. Neither you can
mount this other pidns' proc into temporary location after setns, kernel uses 
the pidns task really lives in -- the task_active_pid_ns(). But nonetheless, 
we have the proc we want.

> It would be impossible to identify foreign IDs for unprivileged
> processes, however.

Yes, that would be useful limitation.

Thanks,
Pavel
