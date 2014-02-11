Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaBKIYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 03:24:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbaBKIYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 03:24:09 -0500
Date: Tue, 11 Feb 2014 09:23:08 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: poma <pomidorabelisima@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org, Olaf Hering <olaf@aepfle.de>,
        Dave Jones <davej@redhat.com>, "Justin M. Forbes" <jforbes@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>
Subject: Re: WARNING: CPU: 1 PID: 0 at kernel/time/tick-broadcast.c:668
 tick_broadcast_oneshot_control+0x17d/0x190()
Message-ID: <20140211082306.GA1528@redhat.com>
References: <52F84A9B.5020008@gmail.com>
 <alpine.DEB.2.02.1402101056260.21991@ionos.tec.linutronix.de>
 <52F9219B.5020003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F9219B.5020003@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 07:59:39PM +0100, poma wrote:
> On 10.02.2014 11:06, Thomas Gleixner wrote:
> > On Mon, 10 Feb 2014, poma wrote:
> > 
> >> [   83.558551]  [<ffffffff81025b17>] amd_e400_idle+0x87/0x130
> > 
> > So this seems to happen only on AMD machines which use that e400 idle
> > mode. I have no idea at the moment whats wrong there. I'll find one of
> > those machines and try to reproduce.

I tried to debug that warn as well. Even if I found machine with proper
family and model number, HW C1E bug do not happen there, hence I just
hack kernel to always use amd_e400_idle (and remove AMD rdmsr specific
instructions to do not crash). That make issue 100% reproducible when
suspend/resume.

It happens when cpu become idle, call CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
but before CLOCK_EVT_NOTIFY_BROADCAST_EXIT, interrupt trigger on that
cpu. IRQ is handled by hrtimer code, which want to switch to hres and
call:

tick_switch_to_oneshot() -> ... -> tick_broadcast_setup_oneshot()

Since we have already proper handler there, last procedure clear
tick_broadcast_oneshot_mask, but tick_broadcast_pending_mask stay
set. When amd_e400_idle next time call CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
the warning will happen.

I came with a below patch, which also clear pending mask, but perhaps
oneshot_mask should not be cleared on tick_broadcast_setup_oneshot(),
or should be cleared only conditionally, or some other solution is
needed. Anyway, patch make the warning gone on my hacked setup, I was
waiting for testing results on real C1E hardware.

Thanks
Stanislaw

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 43780ab..98977a5 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -756,6 +756,7 @@ out:
 static void tick_broadcast_clear_oneshot(int cpu)
 {
 	cpumask_clear_cpu(cpu, tick_broadcast_oneshot_mask);
+	cpumask_clear_cpu(cpu, tick_broadcast_pending_mask);
 }
 
 static void tick_broadcast_init_next_event(struct cpumask *mask,
