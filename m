Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933981Ab3BTBmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 20:42:01 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:38519 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933930Ab3BTBmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 20:42:00 -0500
MIME-Version: 1.0
In-Reply-To: <CACBanvr6ji+rQBpNUJ-3YQsH=WMcNf6n+RVapg-zV5=h8Wc3-Q@mail.gmail.com>
References: <1361008406-2307-1-git-send-email-msb@chromium.org>
	<20130216170545.GB4910@redhat.com>
	<CACBanvr6ji+rQBpNUJ-3YQsH=WMcNf6n+RVapg-zV5=h8Wc3-Q@mail.gmail.com>
Date: Tue, 19 Feb 2013 17:41:59 -0800
X-Google-Sender-Auth: kKOoqcmSm4F_GTykDRKHcxUqUJQ
Message-ID: <CACBanvpR6jE=46VAMrMvT+Oz797W0-A+EqNXHmZ6DmKHuBM+Dw@mail.gmail.com>
Subject: Re: [PATCH 1/5] vfork: don't freezer_count() for in-kernel users of CLONE_VFORK
From: Mandeep Singh Baines <msb@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 4:07 PM, Mandeep Singh Baines <msb@chromium.org> wrote:
> On Sat, Feb 16, 2013 at 9:05 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> On 02/16, Mandeep Singh Baines wrote:
>>>
>>> We don't need to call freezer_do_not_count() for in-kernel users
>>> of CLONE_VFORK since exec will get called in bounded time.
>>>
>>> We don't want to call freezer_count() for in-kernel users because
>>> they may be holding locks. freezer_count() calls try_to_freeze().
>>> We don't want to freeze an in-kernel user because it may be
>>> holding locks.
>>
>> I can only repeat my question ;)
>>
>>         Who? We should not do this anyway. And __call_usermodehelper() doesn't
>>         afaics.
>>
>>         OK, its caller (process_one_work) does lock_map_acquire() for debugging
>>         purposes, this can "confuse" print_held_locks_bug(). But this thread is
>>         PF_NOFREEZE ?
>>
>> Previously this was needed to suppress the false positive. Now that 2/5
>> checks PF_NOFREEZE, why do we need this change?
>>
>
> After applying the PF_NOFREEZE check, I still get the following:
>
> [    1.001030] =======================================
> [    1.001039] [ BUG: lock held while trying to freeze! ]
> [    1.001048] 3.4.0 #24 Not tainted
> [    1.001053] ---------------------------------------
> [    1.001060] kworker/u:0/5 is exiting with locks still held!
> [    1.001068] 2 locks held by kworker/u:0/5:
> [    1.001073]  #0:  (khelper){.+.+.+}, at: [<8103896f>]
> process_one_work+0x108/0
> x2ee
> [    1.001095]  #1:  ((&sub_info->work)){+.+.+.}, at: [<8103896f>]
> process_one_wo
> rk+0x108/0x2ee
> [    1.001111]
> [    1.001113] stack backtrace:
> [    1.001119] Pid: 5, comm: kworker/u:0 Not tainted 3.4.0 #24
> [    1.001124] Call Trace:
> [    1.001135]  [<81025bd6>] ? console_unlock+0x17a/0x18b
> [    1.001146]  [<8105d68e>] debug_check_no_locks_held+0x82/0x8a
> [    1.001156]  [<8102493f>] do_fork+0x20d/0x2ac
> [    1.001167]  [<810366cb>] ? call_usermodehelper_setup+0x8c/0x8c
> [    1.001177]  [<81008310>] kernel_thread+0x7a/0x82
> [    1.001186]  [<810366cb>] ? call_usermodehelper_setup+0x8c/0x8c
> [    1.001198]  [<814b45dc>] ? common_interrupt+0x3c/0x3c
> [    1.001208]  [<810365e8>] __call_usermodehelper+0x3b/0x71
> [    1.001216]  [<810389ce>] process_one_work+0x167/0x2ee
> [    1.001226]  [<810365ad>] ? call_usermodehelper_freeinfo+0x1e/0x1e
> [    1.001235]  [<81038dbc>] worker_thread+0xbd/0x18b
> [    1.001244]  [<81038cff>] ? rescuer_thread+0x184/0x184
> [    1.001254]  [<8103c636>] kthread+0x77/0x7c
> [    1.001264]  [<8103c5bf>] ? kthread_freezable_should_stop+0x4a/0x4a
> [    1.001273]  [<814b45e2>] kernel_thread_helper+0x6/0x10
>

D'oh. I had the logic in my patch inverted. Ignore the trace.

> Regards,
> Mandeep
>
>>> @@ -722,9 +722,11 @@ static int wait_for_vfork_done(struct task_struct *child,
>>>  {
>>>       int killed;
>>>
>>> -     freezer_do_not_count();
>>> +     if (!(current->flags & PF_KTHREAD))
>>> +             freezer_do_not_count();
>>
>> If I missed something and we really need this, imho this needs a comment.
>>
>> Oleg.
>>
