Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab3FXN5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 09:57:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:49217 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3FXN5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 09:57:30 -0400
Date: Mon, 24 Jun 2013 15:57:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Prarit Bhargava <prarit@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, athorlton@sgi.com,
        CAI Qian <caiqian@redhat.com>
Subject: Re: BUG: tick device NULL pointer during system initialization and
 shutdown
In-Reply-To: <51C0AB09.2090605@redhat.com>
Message-ID: <alpine.DEB.2.02.1306241551020.4013@ionos.tec.linutronix.de>
References: <51C0AB09.2090605@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jun 2013, Prarit Bhargava wrote:

> Similar panics reported during bringup here:
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-May/166205.html
> http://lkml.org/lkml/2013/5/8/342
> 
> I've seen this a few times on 3.10 based kernels.
> 
> [  175.842027] Disabling non-boot CPUs ...
> [  475.827017] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000048

That looks like a stale bit in tick_broadcast_force_mask.

Does the patch below fix it?

Thanks,

	tglx
---

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 20d6fba..e01ca90 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -183,6 +183,8 @@ static void tick_do_broadcast(struct cpumask *mask)
 	int cpu = smp_processor_id();
 	struct tick_device *td;
 
+	cpumask_and(mask, mask, cpu_online_mask);
+
 	/*
 	 * Check, if the current cpu is in the mask
 	 */
@@ -212,7 +214,6 @@ static void tick_do_periodic_broadcast(void)
 {
 	raw_spin_lock(&tick_broadcast_lock);
 
-	cpumask_and(tmpmask, cpu_online_mask, tick_broadcast_mask);
 	tick_do_broadcast(tmpmask);
 
 	raw_spin_unlock(&tick_broadcast_lock);
