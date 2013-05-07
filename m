Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab3EGOOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:14:17 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:45236 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751245Ab3EGOOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:14:14 -0400
Message-ID: <51890C31.3000203@hurleysoftware.com>
Date: Tue, 07 May 2013 10:14:09 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: 3.9+ tty lockdep trace.
References: <20130501154723.GB11841@redhat.com> <20130506180020.GB1309@redhat.com> <20130506184059.GA22897@kroah.com>
In-Reply-To: <20130506184059.GA22897@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 02:40 PM, Greg Kroah-Hartman wrote:
> On Mon, May 06, 2013 at 02:00:20PM -0400, Dave Jones wrote:
>> On Wed, May 01, 2013 at 11:47:23AM -0400, Dave Jones wrote:
>>   > [ 6760.076083] ======================================================
>>   > [ 6760.076084] [ INFO: possible circular locking dependency detected ]
>>   > [ 6760.076086] 3.9.0+ #16 Not tainted
>>   > [ 6760.076086] -------------------------------------------------------
>>   > [ 6760.076087] (agetty)/26163 is trying to acquire lock:
>>   > [ 6760.076096] blocked:  ((&buf->work)){+.+...}, instance: ffff88011c8b0020, at: [<ffffffff81062065>] flush_work+0x5/0x2e0
>>   > [ 6760.076096]
>>   > but task is already holding lock:
>>   > [ 6760.076102] blocked:  (console_lock){+.+.+.}, instance: ffffffff81c2fde0, at: [<ffffffff813bc201>] vt_ioctl+0xb61/0x1230
>>   > [ 6760.076103]
>>   > which lock already depends on the new lock.
>>   >
>>   > [ 6760.076103]
>>   > the existing dependency chain (in reverse order) is:
>>   > [ 6760.076106]
>>   > -> #1 (console_lock){+.+.+.}:
>>   > [ 6760.076111]        [<ffffffff810b3f74>] lock_acquire+0xa4/0x210
>>   > [ 6760.076115]        [<ffffffff810416c7>] console_lock+0x77/0x80
>>   > [ 6760.076118]        [<ffffffff813c3dcd>] con_flush_chars+0x2d/0x50
>>   > [ 6760.076123]        [<ffffffff813b32b2>] n_tty_receive_buf+0x122/0x14d0
>>   > [ 6760.076126]        [<ffffffff813b7709>] flush_to_ldisc+0x119/0x170
>>   > [ 6760.076130]        [<ffffffff81064381>] process_one_work+0x211/0x700
>>   > [ 6760.076133]        [<ffffffff8106498b>] worker_thread+0x11b/0x3a0
>>   > [ 6760.076137]        [<ffffffff8106ce5d>] kthread+0xed/0x100
>>   > [ 6760.076141]        [<ffffffff81601cac>] ret_from_fork+0x7c/0xb0
>>   > [ 6760.076143]
>>   > -> #0 ((&buf->work)){+.+...}:
>>   > [ 6760.076146]        [<ffffffff810b349a>] __lock_acquire+0x193a/0x1c00
>>   > [ 6760.076149]        [<ffffffff810b3f74>] lock_acquire+0xa4/0x210
>>   > [ 6760.076151]        [<ffffffff810620ae>] flush_work+0x4e/0x2e0
>>   > [ 6760.076153]        [<ffffffff81065305>] __cancel_work_timer+0x95/0x130
>>   > [ 6760.076155]        [<ffffffff810653b0>] cancel_work_sync+0x10/0x20
>>   > [ 6760.076157]        [<ffffffff813b8212>] tty_port_destroy+0x12/0x20
>>   > [ 6760.076159]        [<ffffffff813c65e8>] vc_deallocate+0xf8/0x110
>>   > [ 6760.076162]        [<ffffffff813bc20c>] vt_ioctl+0xb6c/0x1230
>>   > [ 6760.076165]        [<ffffffff813b01a5>] tty_ioctl+0x285/0xd50
>>   > [ 6760.076168]        [<ffffffff811ba825>] do_vfs_ioctl+0x305/0x530
>>   > [ 6760.076170]        [<ffffffff811baad1>] sys_ioctl+0x81/0xa0
>>   > [ 6760.076174]        [<ffffffff81601d59>] system_call_fastpath+0x16/0x1b
>>   > [ 6760.076174]
>>   > other info that might help us debug this:
>>   >
>>   > [ 6760.076175]  Possible unsafe locking scenario:
>>   >
>>   > [ 6760.076175]        CPU0                    CPU1
>>   > [ 6760.076176]        ----                    ----
>>   > [ 6760.076177]   lock(console_lock);
>>   > [ 6760.076179]                                lock((&buf->work));
>>   > [ 6760.076180]                                lock(console_lock);
>>   > [ 6760.076181]   lock((&buf->work));
>>   > [ 6760.076182]
>>   >  *** DEADLOCK ***
>>   >
>>   > [ 6760.076183] 1 lock on stack by (agetty)/26163:
>>   > [ 6760.076188]  #0: blocked:  (console_lock){+.+.+.}, instance: ffffffff81c2fde0, at: [<ffffffff813bc201>] vt_ioctl+0xb61/0x1230
>>   > [ 6760.076188]
>>   > stack backtrace:
>>   > [ 6760.076190] Pid: 26163, comm: (agetty) Not tainted 3.9.0+ #16
>>   > [ 6760.076191] Call Trace:
>>   > [ 6760.076196]  [<ffffffff815edb14>] print_circular_bug+0x200/0x20e
>>   > [ 6760.076199]  [<ffffffff810b349a>] __lock_acquire+0x193a/0x1c00
>>   > [ 6760.076203]  [<ffffffff8100a269>] ? sched_clock+0x9/0x10
>>   > [ 6760.076206]  [<ffffffff8100a269>] ? sched_clock+0x9/0x10
>>   > [ 6760.076209]  [<ffffffff8100a200>] ? native_sched_clock+0x20/0x80
>>   > [ 6760.076213]  [<ffffffff810b3f74>] lock_acquire+0xa4/0x210
>>   > [ 6760.076215]  [<ffffffff81062065>] ? flush_work+0x5/0x2e0
>>   > [ 6760.076217]  [<ffffffff810620ae>] flush_work+0x4e/0x2e0
>>   > [ 6760.076219]  [<ffffffff81062065>] ? flush_work+0x5/0x2e0
>>   > [ 6760.076222]  [<ffffffff810b15db>] ? mark_held_locks+0xbb/0x140
>>   > [ 6760.076226]  [<ffffffff8113c8a3>] ? __free_pages_ok.part.57+0x93/0xc0
>>   > [ 6760.076229]  [<ffffffff810b15db>] ? mark_held_locks+0xbb/0x140
>>   > [ 6760.076231]  [<ffffffff810652f2>] ? __cancel_work_timer+0x82/0x130
>>   > [ 6760.076234]  [<ffffffff81065305>] __cancel_work_timer+0x95/0x130
>>   > [ 6760.076236]  [<ffffffff810653b0>] cancel_work_sync+0x10/0x20
>>   > [ 6760.076238]  [<ffffffff813b8212>] tty_port_destroy+0x12/0x20
>>   > [ 6760.076240]  [<ffffffff813c65e8>] vc_deallocate+0xf8/0x110
>>   > [ 6760.076243]  [<ffffffff813bc20c>] vt_ioctl+0xb6c/0x1230
>>   > [ 6760.076246]  [<ffffffff810aec41>] ? lock_release_holdtime.part.30+0xa1/0x170
>>   > [ 6760.076250]  [<ffffffff813b01a5>] tty_ioctl+0x285/0xd50
>>   > [ 6760.076254]  [<ffffffff812b00f6>] ? inode_has_perm.isra.46.constprop.61+0x56/0x80
>>   > [ 6760.076257]  [<ffffffff811ba825>] do_vfs_ioctl+0x305/0x530
>>   > [ 6760.076260]  [<ffffffff812b04db>] ? selinux_file_ioctl+0x5b/0x110
>>   > [ 6760.076263]  [<ffffffff811baad1>] sys_ioctl+0x81/0xa0
>>   > [ 6760.076266]  [<ffffffff81601d59>] system_call_fastpath+0x16/0x1b
>>
>> Just hit this again, by switching tty's during bootup.
>> The previous time was switching from X to console iirc, so that seems to be
>> the key to triggering this.
>
> Sorry for not getting back to this sooner, merge window fun...
>
> Anyway, Peter, could this be something that your ldisc patches are
> triggering?

Yes, although early analysis also suggests the lockdep splat is possible
regardless, just much less likely.

I looked at this over the weekend, but I wasn't able to determine (in
the limited time I had available) if the splat was valid; ie., if the
cpu states could actually be concurrent and result in deadlock.

I need to study the VT_DISALLOCATE ioctl in more detail which I plan
to do this week.

Regards,
Peter Hurley

