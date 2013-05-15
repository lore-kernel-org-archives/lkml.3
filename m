Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038Ab3EOJK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:10:29 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:41487 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab3EOJKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:10:24 -0400
Date: Wed, 15 May 2013 11:10:21 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] HID
Message-ID: <20130515091020.GA6819@gmail.com>
References: <alpine.LNX.2.00.1304301023040.20139@pobox.suse.cz>
 <20130510114759.GA19857@gmail.com>
 <alpine.LNX.2.00.1305101349000.23038@pobox.suse.cz>
 <20130514183108.GA4904@gmail.com>
 <alpine.LNX.2.00.1305142319310.17873@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1305142319310.17873@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Kosina <jkosina@suse.cz> wrote:

> On Tue, 14 May 2013, Ingo Molnar wrote:
> 
> > > > FYI, there's a new HID related lockdep and RCU splat upstream, probably 
> > > > relatd to the debugfs locking fixes:
> > > > 
> > > > [   79.088631] ======================================================
> > > > [   79.088631] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
> > > > [   79.088631] 3.9.0-13694-g7cf229a-dirty #224212 Tainted: G        W   
> > > > [   79.088631] ------------------------------------------------------
> > > > [   79.088631] swapper/0/1 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> > > > [   79.088631]  (&hdev->debug_list_lock){+.+...}, at: [<ffffffff82e510d9>] hid_debug_event+0x2e/0xd0
> > > > [   79.088631] 
> > > > 
> > > > See the full bootlog below. It's from an allyesconfig x86-64 bootup log.
> > > 
> > > Hi Ingo,
> > > 
> > > thanks for the report. I have a fix for this in my tree already and am 
> > > going to send pull request to Linus shortly.
> > 
> > FYI, the fixes in your tree apparently did not fix the bug - I'm still 
> > getting the same lockdep splat below.
> 
> Hi Ingo,
> 
> which Linus' git tree topmost commit is that? The lockdep splat seems 
> highly suspicious to me, because:
> 
> [ ... snip ... ]
> > and this task is already holding:
> >  (&(&usbhid->lock)->rlock){-.....}, at: [<c1bc08e4>] usb_hidinput_input_event+0x7c/0xaf
> > which would create a new lock dependency:
> >  (&(&usbhid->lock)->rlock){-.....} -> (&hdev->debug_list_lock){+.+...}
> > 
> > but this new dependency connects a HARDIRQ-irq-safe lock:
> >  (&(&usbhid->lock)->rlock){-.....}
> > ... which became HARDIRQ-irq-safe at:
> >   [<c106974e>] __lock_acquire+0x241/0xd54
> >   [<c106a662>] lock_acquire+0x76/0x8a
> >   [<c1dbe21a>] _raw_spin_lock+0x3d/0x4a
> >   [<c1bc0764>] hid_ctrl+0x28/0x12c
> >   [<c19bfcec>] usb_hcd_giveback_urb+0x40/0x84
> >   [<c19e15cc>] finish_urb+0xbe/0xf4
> >   [<c19e163b>] takeback_td+0x39/0x99
> >   [<c19e1850>] dl_done_list+0x1b5/0x1e4
> >   [<c19e28a1>] ohci_irq+0x16c/0x27a
> >   [<c19bf46d>] usb_hcd_irq+0x26/0x4f
> >   [<c1088cc2>] handle_irq_event_percpu+0x24/0x11f
> >   [<c1088de9>] handle_irq_event+0x2c/0x43
> >   [<c108ad05>] handle_fasteoi_irq+0x6a/0x97
> > 
> > to a HARDIRQ-irq-unsafe lock:
> >  (&hdev->debug_list_lock){+.+...}
> > ... which became HARDIRQ-irq-unsafe at:
> > ...  [<c10697b1>] __lock_acquire+0x2a4/0xd54
> >   [<c106a662>] lock_acquire+0x76/0x8a
> >   [<c1dbc602>] __mutex_lock_common+0x4f/0x36f
> >   [<c1dbc960>] mutex_lock_nested+0x3e/0x44
> >   [<c1ba316b>] hid_debug_event+0x1e/0xa8
> 
> .. this is odd. In current Linus' tree we have
> 
> 	spin_lock_irqsave(&hdev->debug_list_lock, flags);
> 
> in hid_debug_event(), as commit 1deb9d341d turned debug_list_lock from 
> mutex to spinlock, but the trace implies that your kernel is trying to 
> acquire mutex.
> 
> Could you please check that you are running kernel which contains 
> 1deb9d341d? 
> 
> 	$ git describe --contains 1deb9d341d475
> 	v3.10-rc1~13^2
> 
> On Linus' tree.

Indeed, you are right, I was running a few days old kernel on that box. 
Sorry about the noise!

Thanks,

	Ingo
