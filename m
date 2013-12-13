Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab3LMO5L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:57:11 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:58704 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab3LMO5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:57:09 -0500
MIME-Version: 1.0
In-Reply-To: <52AB1875.2090207@tycho.nsa.gov>
References: <1386018639-18916-1-git-send-email-wroberts@tresys.com>
	<1386018639-18916-3-git-send-email-wroberts@tresys.com>
	<52AB1875.2090207@tycho.nsa.gov>
Date: Fri, 13 Dec 2013 09:57:07 -0500
Message-ID: <CAFftDdoqGbuO3uifsvjyRHNQbRqq7FuGiA5s8qjFk=0ZcWexMQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] proc: Update get proc_pid_cmdline() to use mm.h helpers
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

On Fri, Dec 13, 2013 at 9:23 AM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> On 12/02/2013 04:10 PM, William Roberts wrote:
>> Re-factor proc_pid_cmdline() to use get_cmdline_length() and
>> copy_cmdline() helpers from mm.h
>>
>> Signed-off-by: William Roberts <wroberts@tresys.com>
>> ---
>>  fs/proc/base.c |   35 ++++++++++-------------------------
>>  1 file changed, 10 insertions(+), 25 deletions(-)
>>
>> diff --git a/fs/proc/base.c b/fs/proc/base.c
>> index 03c8d74..fb4eda5 100644
>> --- a/fs/proc/base.c
>> +++ b/fs/proc/base.c
>> @@ -203,37 +203,22 @@ static int proc_root_link(struct dentry *dentry, struct path *path)
>>  static int proc_pid_cmdline(struct task_struct *task, char * buffer)
>>  {
>>       int res = 0;
>> -     unsigned int len;
>> +     unsigned int len = 0;
>
> Why?  You set len below before first use, so this is redundant.
>
Yep you're right.

>>       struct mm_struct *mm = get_task_mm(task);
>>       if (!mm)
>> -             goto out;
>> -     if (!mm->arg_end)
>> -             goto out_mm;    /* Shh! No looking before we're done */
>> +             return 0;
>
> Equivalent to goto out in the original code, so why change it?  Don't
> make unnecessary changes.
>
> Also, I think the get_task_mm() ought to move into the helper (or all of
> proc_pid_cmdline() should just become the helper).  In what situation
> will you not be calling get_task_mm() and mmput() around every call to
> the helper?

Again my thought on this is to reduce get_task_mm() and mmput() calls.
How expensive are they, etc. However, just to recap the other email. If we
move to saying the audit cache of this can be capped at PATH_MAX even
if it results in some wasted memory, we can just take the original procfs code
and add a length argument.

>
>>
>> -     len = mm->arg_end - mm->arg_start;
>> -
>> +     len = get_cmdline_length(mm);
>> +     if (!len)
>> +             goto mm_out;
>
> Could be moved into the helper.  Not sure how the inline function helps
> readability or maintainability.

Sure... mostly for readability.

>
>> +
>> +     /*The caller of this allocates a page */
>>       if (len > PAGE_SIZE)
>>               len = PAGE_SIZE;
>
> If the capping of len is handled by the caller, then pass an int to your
> helper rather than an unsigned int to avoid problems later with
> access_process_vm().

Ok... just weird that lengths are signed to me. when will you ever have negative
space?

>
>> -out_mm:
>> +
>> +     res = copy_cmdline(task, mm, buffer, len);
>> +mm_out:
>>       mmput(mm);
>
> Odd style.  If there is only one exit path, just call it out; if there
> are two, keep them as out_mm and out.
>

Yes their is only 1 jmp label. Your right, this is odd.

>> -out:
>>       return res;
>>  }
>>
>>
>



-- 
Respectfully,

William C Roberts
