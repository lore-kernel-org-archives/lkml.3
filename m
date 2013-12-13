Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab3LMOvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:51:10 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:57971 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab3LMOvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:51:08 -0500
MIME-Version: 1.0
In-Reply-To: <52AB15C0.7090701@tycho.nsa.gov>
References: <1386018639-18916-1-git-send-email-wroberts@tresys.com>
	<1386018639-18916-2-git-send-email-wroberts@tresys.com>
	<52AB15C0.7090701@tycho.nsa.gov>
Date: Fri, 13 Dec 2013 09:51:07 -0500
Message-ID: <CAFftDdquPe9dE_4x_mr0BT2jziUAEtdyjk4DqXvt2-nnBf73zg@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm: Create utility functions for accessing a tasks
 commandline value
From: William Roberts <bill.c.roberts@gmail.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Guy Briggs <rgb@redhat.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        William Roberts <wroberts@tresys.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 9:12 AM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> On 12/02/2013 04:10 PM, William Roberts wrote:
>> Add two new functions to mm.h:
>> * copy_cmdline()
>> * get_cmdline_length()
>>
>> Signed-off-by: William Roberts <wroberts@tresys.com>
>> ---
>>  include/linux/mm.h |    7 +++++++
>>  mm/util.c          |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 55 insertions(+)
>>
>> index f7bc209..c8cad32 100644
>> --- a/mm/util.c
>> +++ b/mm/util.c
>> @@ -410,6 +411,53 @@ unsigned long vm_commit_limit(void)
>>               * sysctl_overcommit_ratio / 100) + total_swap_pages;
>>  }
>>
>> +/**
>> + * copy_cmdline - Copy's the tasks commandline value to a buffer
>
> spelling: Copies, task's, command-line or command line
>
>> + * @task: The task whose command line to copy
>
> is to be copied?
>
>> + * @mm: The mm struct refering to task with proper semaphores held
>
> referring
>
>> + * @buf: The buffer to copy the value into
>
>> + * @buflen: The length og the buffer. It trucates the value to
>
> of, truncates
>
>> + *           buflen.
>> + * @return: The number of chars copied.
>> + */
>> +int copy_cmdline(struct task_struct *task, struct mm_struct *mm,
>> +              char *buf, unsigned int buflen)
>> +{
>> +     int res = 0;
>> +     unsigned int len;
>> +
>> +     if (!task || !mm || !buf)
>> +             return -1;
>
> Typically these kinds of tests are frowned upon in the kernel unless
> there is a legal usage where NULL is valid.  Otherwise you may just be
> covering up a bug.
>
> Also, why not just get_task_mm(task) within the function rather than
> pass it in by the caller?
>

Yes I was debating whether or not to drop the pointer checks... np

WRT the locking and moving it into the function. You need to take the lock
to determine the size of the cmdline area. The idea on the interface is you
would take the locks, acquire the size via the inline func, alloc memory and
then call the copy function. In some cases, like proc/pid/cmdline, they just
alloc a page and truncate on that boundary. However, one may with to truncate
on an arbitrary boundry, especially when cacheing the values, as you don't want
to allocate too much. So inbetween functions calls that get the length and copy,
one can make a decision based on their allocation scheme. Moving the locks
to the functions would require multiple locks and unlocks in the common case.


>> +
>> +     res = access_process_vm(task, mm->arg_start, buf, buflen, 0);
>
> Unsigned int buflen passed as int len argument without a range check?
> Note that in the proc_pid_cmdline() code, they first cap it at PAGE_SIZE
> before passing it.
>

buflen is passed by the caller. So if you look in the following patch
introducing its
use in proc/fs/base.c, their is a check.
        /*The caller of this allocates a page */
        if (len > PAGE_SIZE)
                len = PAGE_SIZE;

        res = copy_cmdline(task, mm, buffer, len);

> The closer you can keep your code to the original proc_pid_cmdline()
> code, the better (less chance for new bugs to be introduced).
>
>> +     if (res <= 0)
>> +             return 0;
>> +
>> +     if (res > buflen)
>> +             res = buflen;
>
> Is this a possible condition?  Under what circumstances?

for  (res <= 0), in that case, the underlying call
to __access_remote_vm() returns an int. Most of the mm functions look
like they are using
ints for probably some historical reason I am not aware of. I tried to
pick the strongest invariant,
however, I don't think < 0 is possible.

For the res > buflen check, that might might be an artifact from the
PAGE_SIZE cap from the original
code. It would only be possible if a process was able to write to
their mm when the semaphores are held.
I am assuming the case of:
kernel gets size
kernel allocs buffer
kernel copys but size has differed. I guess if I broke the locking out
it could happen, you need size and copy
to be autonomous.


>
>> +     /*
>> +      * If the nul at the end of args had been overwritten, then
>> +      * assume application is using setproctitle(3).
>> +      */
>> +     if (buf[res-1] != '\0') {
>
> Lost the len < PAGE_SIZE check from proc_pid_cmdline() here, and that
> isn't the same as the check above.
>
>> +             /* Nul between start and end of vm space?
>> +                If so then truncate */
>
> Not sure where these comments are coming from.  Isn't the issue that
> lack of NUL at the end of args indicates that the cmdline extends
> further into the environ and thus they need to copy in the rest?

Their is no guarantee that their is a NULL from what I understand. So you need
to look for it, and copy from there. I have no qualms about dropping
the comments
their not very useful, as well as moving the block back to what the
original procfs
code had.

>
>> +             len = strnlen(buf, res);
>> +             if (len < res) {
>> +                     res = len;
>> +             } else {
>> +                     /* No nul, truncate buflen if to big */
>
> It isn't truncating buflen but rather copying the remainder of the
> cmdline from the environ, right?
>
>> +                     len = mm->env_end - mm->env_start;
>> +                     if (len > buflen - res)
>> +                             len = buflen - res;
>> +                     /* Copy any remaining data */
>> +                     res += access_process_vm(task, mm->env_start, buf+res,
>> +                                              len, 0);
>> +                     res = strnlen(buf, res);
>> +             }
>> +     }
>> +     return res;
>> +}
>
> I think you are better off just copying proc_pid_cmdline() exactly as is
> into a common helper function and then reusing it for audit.  Far less
> work, and far less potential for mistakes.

I don't like caching a whole page in that audit context. So most of
the complexity relates to
determining the size of the cache. Steve Grub was in favor of limiting
the cmdline value to
PATH_MAX. So if that is an acceptable cache size, we can take the
existing code from
procfs/base.c and just add an argument indicating the size of the
buffer. procfs will be
PAGE_SIZE and audit will be PATH_MAX. Thoughts?

>
>>
>>  /* Tracepoints definitions. */
>>  EXPORT_TRACEPOINT_SYMBOL(kmalloc);
>>
>



-- 
Respectfully,

William C Roberts
