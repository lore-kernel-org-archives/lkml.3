Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbaA3PzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 10:55:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59788 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623AbaA3PzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 10:55:12 -0500
Date: Thu, 30 Jan 2014 16:55:05 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Dave Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Subject: Re: [git pull] drm next tree
In-Reply-To: <alpine.DEB.2.00.1401300249130.13810@skynet.skynet.ie>
Message-ID: <alpine.LRH.2.00.1401301648050.15677@twin.jikos.cz>
References: <alpine.DEB.2.00.1401300249130.13810@skynet.skynet.ie>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014, Dave Airlie wrote:

>   git://people.freedesktop.org/~airlied/linux drm-next
[ ... snip ... ]
> Daniel Vetter (59):
[ ... snip ... ]
>       drm/i915: dp aux irq support for g4x/vlv

This commit causes all kinds of havoc on my ThinkPad x200s. It results in

 irq 16: nobody cared (try booting with the "irqpoll" option)
 CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.12.0-00854-g4aeebd7 #1
 Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
  ffff8800795186c0 ffff88007c203e08 ffffffff81582503 ffff88007c203e38
  ffffffff810a6a98 ffff88007c203e88 ffff880079518600 0000000000000000
  0000000000000010 ffff88007c203e78 ffffffff810a6d43 00000010ffc4af9d
 Call Trace:
  <IRQ>  [<ffffffff81582503>] dump_stack+0x7a/0x97
  [<ffffffff810a6a98>] __report_bad_irq+0x38/0xf0
  [<ffffffff810a6d43>] note_interrupt+0x1f3/0x240
  [<ffffffff810a42d2>] handle_irq_event_percpu+0x142/0x220
  [<ffffffff810a43f9>] handle_irq_event+0x49/0x70
  [<ffffffff810a7561>] handle_fasteoi_irq+0x61/0x100
  [<ffffffff81004a89>] handle_irq+0x59/0x150
  [<ffffffff81052b6e>] ? _local_bh_enable+0xe/0x10
  [<ffffffff81052bf1>] ? irq_enter+0x81/0x90
  [<ffffffff8100403b>] do_IRQ+0x5b/0xe0
  [<ffffffff81588aaf>] common_interrupt+0x6f/0x6f
  <EOI>  [<ffffffff81588b5c>] ? retint_restore_args+0xe/0xe
  [<ffffffff8146c767>] ? poll_idle+0x47/0x90
  [<ffffffff8146c740>] ? poll_idle+0x20/0x90
  [<ffffffff810acd96>] ? ktime_get+0x56/0xd0
  [<ffffffff8146c7f0>] cpuidle_enter_state+0x40/0xd0
  [<ffffffff8146cc0a>] cpuidle_idle_call+0x10a/0x160
  [<ffffffff8100b7b9>] arch_cpu_idle+0x9/0x30
  [<ffffffff810a370b>] cpu_idle_loop+0x8b/0x270
  [<ffffffff810a390e>] cpu_startup_entry+0x1e/0x20
  [<ffffffff8157a0c3>] rest_init+0xd3/0xe0
  [<ffffffff81579ff0>] ? csum_partial_copy_generic+0x170/0x170
  [<ffffffff81ad905c>] start_kernel+0x3b3/0x461
  [<ffffffff81ad8a96>] ? repair_env_string+0x58/0x58
  [<ffffffff81ad84d1>] x86_64_start_reservations+0x1b/0x32
  [<ffffffff81ad8622>] x86_64_start_kernel+0x13a/0x141
 handlers:
 [<ffffffffa00acbc0>] usb_hcd_irq [usbcore]
 Disabling IRQ #16

and things go south afterwards (the machine hangs randomly, I/O is 
horribly slow, etc etc).

This is the same machine that was the reason for

	commit c12aba5aa0e60b7947bc8b6ea25ef55c4acf81a4
	Author: Jiri Kosina <jkosina@suse.cz>
	Date:   Tue Mar 19 09:56:57 2013 +0100

	    drm/i915: stop using GMBUS IRQs on Gen4 chips

back then in 3.9 timeframe, so it might be somehow related. It's, at the 
end of the day, again IRQ 16 -- and see the changelog of c12aba5a why this 
is rather mysterious (IRQ 16 is assigned to the card when it's not using 
MSI, but it *is* in fact using MSI in all the cases).

-- 
Jiri Kosina
SUSE Labs

