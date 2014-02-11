Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbaBKQHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:07:50 -0500
Received: from www.linutronix.de ([62.245.132.108]:43016 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaBKQHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:07:48 -0500
Date: Tue, 11 Feb 2014 17:07:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: poma <pomidorabelisima@gmail.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org, Olaf Hering <olaf@aepfle.de>,
        Dave Jones <davej@redhat.com>, "Justin M. Forbes" <jforbes@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>
Subject: Re: WARNING: CPU: 1 PID: 0 at kernel/time/tick-broadcast.c:668
 tick_broadcast_oneshot_control+0x17d/0x190()
In-Reply-To: <20140211082306.GA1528@redhat.com>
Message-ID: <alpine.DEB.2.02.1402111702090.21991@ionos.tec.linutronix.de>
References: <52F84A9B.5020008@gmail.com> <alpine.DEB.2.02.1402101056260.21991@ionos.tec.linutronix.de> <52F9219B.5020003@gmail.com> <20140211082306.GA1528@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014, Stanislaw Gruszka wrote:

> On Mon, Feb 10, 2014 at 07:59:39PM +0100, poma wrote:
> > On 10.02.2014 11:06, Thomas Gleixner wrote:
> > > On Mon, 10 Feb 2014, poma wrote:
> > > 
> > >> [   83.558551]  [<ffffffff81025b17>] amd_e400_idle+0x87/0x130
> > > 
> > > So this seems to happen only on AMD machines which use that e400 idle
> > > mode. I have no idea at the moment whats wrong there. I'll find one of
> > > those machines and try to reproduce.
> 
> I tried to debug that warn as well. Even if I found machine with proper
> family and model number, HW C1E bug do not happen there, hence I just
> hack kernel to always use amd_e400_idle (and remove AMD rdmsr specific
> instructions to do not crash). That make issue 100% reproducible when
> suspend/resume.

It's also reproducible on cpu online/offline.
 
> It happens when cpu become idle, call CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
> but before CLOCK_EVT_NOTIFY_BROADCAST_EXIT, interrupt trigger on that
> cpu. IRQ is handled by hrtimer code, which want to switch to hres and
> call:
> 
> tick_switch_to_oneshot() -> ... -> tick_broadcast_setup_oneshot()
> 
> Since we have already proper handler there, last procedure clear
> tick_broadcast_oneshot_mask, but tick_broadcast_pending_mask stay
> set. When amd_e400_idle next time call CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
> the warning will happen.
> 
> I came with a below patch, which also clear pending mask, but perhaps

Fun. I came up with the exact same solution independent of you and I
tested it on real C1E contaminated hardware.

> oneshot_mask should not be cleared on tick_broadcast_setup_oneshot(),
> or should be cleared only conditionally, or some other solution is

We can do it unconditionally. It creates consistent state in all
corner cases.

There are other solutions to the problem, but that needs a major
rework of the broadcast code. I so wish that this mess would have
never been necessary at all ...

Thanks,

	tglx
