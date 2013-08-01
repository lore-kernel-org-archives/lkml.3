Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab3HAUGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 16:06:20 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:56886 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751723Ab3HAUGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 16:06:18 -0400
Message-ID: <51FABFB7.9070409@hurleysoftware.com>
Date: Thu, 01 Aug 2013 16:06:15 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>,
        Artem Savkov <artem.savkov@gmail.com>
CC: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] n_tty: release atomic_read_lock before calling schedule_timeout()
References: <1375198500-17414-1-git-send-email-artem.savkov@gmail.com> <51F7EC5A.2030609@hurleysoftware.com> <20130731114726.GA11570@cpv436-motbuntu.spb.ea.mot-mobility.com>
In-Reply-To: <20130731114726.GA11570@cpv436-motbuntu.spb.ea.mot-mobility.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 07:47 AM, Artem Savkov wrote:
> On Tue, Jul 30, 2013 at 12:39:54PM -0400, Peter Hurley wrote:
>> On 07/30/2013 11:35 AM, Artem Savkov wrote:
>>> ldata->atomic_read_lock should be released before scheduling as well as
>>> tty->termios_rwsem, otherwise there is a potential deadlock detected by lockdep
>>
>> False positive.
>>
>>> Introduced in "n_tty: Access termios values safely"
>>> (9356b535fcb71db494fc434acceb79f56d15bda2 in linux-next.git)
>>>
>>> [   16.822058] ======================================================
>>> [   16.822058] [ INFO: possible circular locking dependency detected ]
>>> [   16.822058] 3.11.0-rc3-next-20130730+ #140 Tainted: G        W
>>> [   16.822058] -------------------------------------------------------
>>> [   16.822058] bash/1198 is trying to acquire lock:
>>> [   16.822058]  (&tty->termios_rwsem){++++..}, at: [<ffffffff816aa3bb>] n_tty_read+0x49b/0x660
>>> [   16.822058]
>>> [   16.822058] but task is already holding lock:
>>> [   16.822058]  (&ldata->atomic_read_lock){+.+...}, at: [<ffffffff816aa0f0>] n_tty_read+0x1d0/0x660
>>> [   16.822058]
>>> [   16.822058] which lock already depends on the new lock.
>>> [   16.822058]
>>> [   16.822058]
>>> [   16.822058] the existing dependency chain (in reverse order) is:
>>> [   16.822058]
>>> -> #1 (&ldata->atomic_read_lock){+.+...}:
>>> [   16.822058]        [<ffffffff811111cc>] validate_chain+0x73c/0x850
>>> [   16.822058]        [<ffffffff811117e0>] __lock_acquire+0x500/0x5d0
>>> [   16.822058]        [<ffffffff81111a29>] lock_acquire+0x179/0x1d0
>>> [   16.822058]        [<ffffffff81d34b9c>] mutex_lock_interruptible_nested+0x7c/0x540
>>> [   16.822058]        [<ffffffff816aa0f0>] n_tty_read+0x1d0/0x660
>>> [   16.822058]        [<ffffffff816a3bb6>] tty_read+0x86/0xf0
>>> [   16.822058]        [<ffffffff811f21d3>] vfs_read+0xc3/0x130
>>> [   16.822058]        [<ffffffff811f2702>] SyS_read+0x62/0xa0
>>> [   16.822058]        [<ffffffff81d45259>] system_call_fastpath+0x16/0x1b
>>> [   16.822058]
>>> -> #0 (&tty->termios_rwsem){++++..}:
>>> [   16.822058]        [<ffffffff8111064f>] check_prev_add+0x14f/0x590
>>> [   16.822058]        [<ffffffff811111cc>] validate_chain+0x73c/0x850
>>> [   16.822058]        [<ffffffff811117e0>] __lock_acquire+0x500/0x5d0
>>> [   16.822058]        [<ffffffff81111a29>] lock_acquire+0x179/0x1d0
>>> [   16.822058]        [<ffffffff81d372c1>] down_read+0x51/0xa0
>>> [   16.822058]        [<ffffffff816aa3bb>] n_tty_read+0x49b/0x660
>>> [   16.822058]        [<ffffffff816a3bb6>] tty_read+0x86/0xf0
>>> [   16.822058]        [<ffffffff811f21d3>] vfs_read+0xc3/0x130
>>> [   16.822058]        [<ffffffff811f2702>] SyS_read+0x62/0xa0
>>> [   16.822058]        [<ffffffff81d45259>] system_call_fastpath+0x16/0x1b
>>> [   16.822058]
>>> [   16.822058] other info that might help us debug this:
>>> [   16.822058]
>>> [   16.822058]  Possible unsafe locking scenario:
>>> [   16.822058]
>>> [   16.822058]        CPU0                    CPU1
>>> [   16.822058]        ----                    ----
>>> [   16.822058]   lock(&ldata->atomic_read_lock);
>>> [   16.822058]                                lock(&tty->termios_rwsem);
>>> [   16.822058]                                lock(&ldata->atomic_read_lock);
>>> [   16.822058]   lock(&tty->termios_rwsem);
>>> [   16.822058]
>>> [   16.822058]  *** DEADLOCK ***
>>
>> This situation is not possible since termios_rwsem is a read/write semaphore;
>> CPU1 cannot prevent CPU0 from obtaining a read lock on termios_rwsem.
> Oops, yes, sorry.
>
>> This looks like a regression caused by:
>>
>> commit a51805efae5dda0da66f79268ffcf0715f9dbea4
>> Author: Michel Lespinasse <walken@google.com>
>> Date:   Mon Jul 8 14:23:49 2013 -0700
>>
>>      lockdep: Introduce lock_acquire_exclusive()/shared() helper macros
> Doesn't seem to be this commit. I see nothing wrong here and just to be
> sure I've checked the kernel with this commit reverted. The issue is
> still there.

Yes, you're right. Apologies to Michel for the too-hasty blame.

Thanks for the report anyway. I'll track down the lockdep regression
as soon as I fix a real deadlock in the nouveau driver that disables
lockdep.

Regards,
Peter Hurley

