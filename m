Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab3HLMzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 08:55:22 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:36835 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756274Ab3HLMzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 08:55:17 -0400
Message-ID: <5208DB32.40304@hurleysoftware.com>
Date: Mon, 12 Aug 2013 08:55:14 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Belisko Marek <marek.belisko@gmail.com>
Subject: Re: [PATCH tty-next] n_tty: Fix termios_rwsem lockdep false positive
References: <20130731114726.GA11570@cpv436-motbuntu.spb.ea.mot-mobility.com> <1376222663-5666-1-git-send-email-peter@hurleysoftware.com> <20130812092810.GA26400@cpv436-motbuntu.spb.ea.mot-mobility.com> <20130812105041.GA2268@swordfish>
In-Reply-To: <20130812105041.GA2268@swordfish>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 06:50 AM, Sergey Senozhatsky wrote:
> On (08/12/13 13:28), Artem Savkov wrote:
>> Hi Peter,
>>
>> On Sun, Aug 11, 2013 at 08:04:23AM -0400, Peter Hurley wrote:
>>> Lockdep reports a circular lock dependency between
>>> atomic_read_lock and termios_rwsem [1]. However, a lock
>>> order deadlock is not possible since CPU1 only holds a
>>> read lock which cannot prevent CPU0 from also acquiring
>>> a read lock on the same r/w semaphore.
>>>
>>> Unfortunately, lockdep cannot currently distinguish whether
>>> the locks are read or write for any particular lock graph,
>>> merely that the locks _were_ previously read and/or write.
>>>
>>> Until lockdep is fixed, re-order atomic_read_lock so
>>> termios_rwsem can be dropped and reacquired without
>>> triggering lockdep.
>>
>> Works fine, thanks.
>>
>> Reported-and-tested-by: Artem Savkov <artem.savkov@gmail.com>
>>
>>> Reported-by: Artem Savkov <artem.savkov@gmail.com>
>>> Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
>>> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
>>>
>>> [1] Initial lockdep report from Artem Savkov <artem.savkov@gmail.com>
>>>
>>>   ======================================================
>>>   [ INFO: possible circular locking dependency detected ]
>>>   3.11.0-rc3-next-20130730+ #140 Tainted: G        W
>>>   -------------------------------------------------------
>>>   bash/1198 is trying to acquire lock:
>>>    (&tty->termios_rwsem){++++..}, at: [<ffffffff816aa3bb>] n_tty_read+0x49b/0x660
>>>
>>>   but task is already holding lock:
>>>    (&ldata->atomic_read_lock){+.+...}, at: [<ffffffff816aa0f0>] n_tty_read+0x1d0/0x660
>>>
>>>   which lock already depends on the new lock.
>>>
>>>   the existing dependency chain (in reverse order) is:
>>>
>>>   -> #1 (&ldata->atomic_read_lock){+.+...}:
>>>          [<ffffffff811111cc>] validate_chain+0x73c/0x850
>>>          [<ffffffff811117e0>] __lock_acquire+0x500/0x5d0
>>>          [<ffffffff81111a29>] lock_acquire+0x179/0x1d0
>>>          [<ffffffff81d34b9c>] mutex_lock_interruptible_nested+0x7c/0x540
>>>          [<ffffffff816aa0f0>] n_tty_read+0x1d0/0x660
>>>          [<ffffffff816a3bb6>] tty_read+0x86/0xf0
>>>          [<ffffffff811f21d3>] vfs_read+0xc3/0x130
>>>          [<ffffffff811f2702>] SyS_read+0x62/0xa0
>>>          [<ffffffff81d45259>] system_call_fastpath+0x16/0x1b
>>>
>>>   -> #0 (&tty->termios_rwsem){++++..}:
>>>          [<ffffffff8111064f>] check_prev_add+0x14f/0x590
>>>          [<ffffffff811111cc>] validate_chain+0x73c/0x850
>>>          [<ffffffff811117e0>] __lock_acquire+0x500/0x5d0
>>>          [<ffffffff81111a29>] lock_acquire+0x179/0x1d0
>>>          [<ffffffff81d372c1>] down_read+0x51/0xa0
>>>          [<ffffffff816aa3bb>] n_tty_read+0x49b/0x660
>>>          [<ffffffff816a3bb6>] tty_read+0x86/0xf0
>>>          [<ffffffff811f21d3>] vfs_read+0xc3/0x130
>>>          [<ffffffff811f2702>] SyS_read+0x62/0xa0
>>>          [<ffffffff81d45259>] system_call_fastpath+0x16/0x1b
>>>
>>>   other info that might help us debug this:
>>>
>>>    Possible unsafe locking scenario:
>>>
>>>          CPU0                    CPU1
>>>          ----                    ----
>>>     lock(&ldata->atomic_read_lock);
>>>                                  lock(&tty->termios_rwsem);
>>>                                  lock(&ldata->atomic_read_lock);
>>>     lock(&tty->termios_rwsem);
>>>
>>>    *** DEADLOCK ***
>>>
>>>   2 locks held by bash/1198:
>>>    #0:  (&tty->ldisc_sem){.+.+.+}, at: [<ffffffff816ade04>] tty_ldisc_ref_wait+0x24/0x60
>>>    #1:  (&ldata->atomic_read_lock){+.+...}, at: [<ffffffff816aa0f0>] n_tty_read+0x1d0/0x660
>>>
>>>   stack backtrace:
>>>   CPU: 1 PID: 1198 Comm: bash Tainted: G        W    3.11.0-rc3-next-20130730+ #140
>>>   Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
>>>    0000000000000000 ffff880019acdb28 ffffffff81d34074 0000000000000002
>>>    0000000000000000 ffff880019acdb78 ffffffff8110ed75 ffff880019acdb98
>>>    ffff880019fd0000 ffff880019acdb78 ffff880019fd0638 ffff880019fd0670
>>>   Call Trace:
>>>    [<ffffffff81d34074>] dump_stack+0x59/0x7d
>>>    [<ffffffff8110ed75>] print_circular_bug+0x105/0x120
>>>    [<ffffffff8111064f>] check_prev_add+0x14f/0x590
>>>    [<ffffffff81d3ab5f>] ? _raw_spin_unlock_irq+0x4f/0x70
>>>    [<ffffffff811111cc>] validate_chain+0x73c/0x850
>>>    [<ffffffff8110ae0f>] ? trace_hardirqs_off_caller+0x1f/0x190
>>>    [<ffffffff811117e0>] __lock_acquire+0x500/0x5d0
>>>    [<ffffffff81111a29>] lock_acquire+0x179/0x1d0
>>>    [<ffffffff816aa3bb>] ? n_tty_read+0x49b/0x660
>>>    [<ffffffff81d372c1>] down_read+0x51/0xa0
>>>    [<ffffffff816aa3bb>] ? n_tty_read+0x49b/0x660
>>>    [<ffffffff816aa3bb>] n_tty_read+0x49b/0x660
>>>    [<ffffffff810e4130>] ? try_to_wake_up+0x210/0x210
>>>    [<ffffffff816a3bb6>] tty_read+0x86/0xf0
>>>    [<ffffffff811f21d3>] vfs_read+0xc3/0x130
>>>    [<ffffffff811f2702>] SyS_read+0x62/0xa0
>>>    [<ffffffff815e24ee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>>>    [<ffffffff81d45259>] system_call_fastpath+0x16/0x1b
>>> ---
>>>   drivers/tty/n_tty.c | 25 +++++++++++--------------
>>>   1 file changed, 11 insertions(+), 14 deletions(-)
>>>
>
> I hate to do this, but isn't it actually my patch posted here
> https://lkml.org/lkml/2013/8/1/510
>
> which was tagged as `wrong'?

Sergey,

My apologies; I was mistaken regarding this problem being a lockdep
regression (although it's still a false positive from lockdep). Once
I had worked around some issues with the nouveau driver, I was able to
reproduce the lockdep report on 3.10.

I included Artem's lockdep report in the changelog because I received
that first, on 30 July.

My patch below is not the same as your patch of 1 Aug. This patch
preserves the protected access of termios.c_cc[VMIN] and termios.c_cc[VTIME]
(via the MIN_CHAR() and TIME_CHAR() macros).

If you'd prefer, I could add to changelog:

    Patch based on original posted here https://lkml.org/lkml/2013/8/1/510
    by Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Regards,
Peter Hurley


>>> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
>>> index dd8ae0c..c9a9ddd 100644
>>> --- a/drivers/tty/n_tty.c
>>> +++ b/drivers/tty/n_tty.c
>>> @@ -2122,6 +2122,17 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
>>>   	if (c < 0)
>>>   		return c;
>>>
>>> +	/*
>>> +	 *	Internal serialization of reads.
>>> +	 */
>>> +	if (file->f_flags & O_NONBLOCK) {
>>> +		if (!mutex_trylock(&ldata->atomic_read_lock))
>>> +			return -EAGAIN;
>>> +	} else {
>>> +		if (mutex_lock_interruptible(&ldata->atomic_read_lock))
>>> +			return -ERESTARTSYS;
>>> +	}
>>> +
>>>   	down_read(&tty->termios_rwsem);
>>>
>>>   	minimum = time = 0;
>>> @@ -2141,20 +2152,6 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
>>>   		}
>>>   	}
>>>
>>> -	/*
>>> -	 *	Internal serialization of reads.
>>> -	 */
>>> -	if (file->f_flags & O_NONBLOCK) {
>>> -		if (!mutex_trylock(&ldata->atomic_read_lock)) {
>>> -			up_read(&tty->termios_rwsem);
>>> -			return -EAGAIN;
>>> -		}
>>> -	} else {
>>> -		if (mutex_lock_interruptible(&ldata->atomic_read_lock)) {
>>> -			up_read(&tty->termios_rwsem);
>>> -			return -ERESTARTSYS;
>>> -		}
>>> -	}
>>>   	packet = tty->packet;
>>>
>>>   	add_wait_queue(&tty->read_wait, &wait);
>>> --
>>> 1.8.1.2
>>>
>>
>> --
>> Regards,
>>      Artem
>>

