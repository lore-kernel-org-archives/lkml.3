Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762205Ab3ECNCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 09:02:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:44947 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761723Ab3ECNCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 09:02:53 -0400
Date: Fri, 3 May 2013 15:02:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Prarit Bhargava <prarit@redhat.com>
cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>,
        Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH] NOHZ, check to see if tick device is initialized in IRQ
 handling path
In-Reply-To: <5183AECF.4070709@redhat.com>
Message-ID: <alpine.LFD.2.02.1305031451561.2886@ionos>
References: <1367325415-32283-1-git-send-email-prarit@redhat.com> <alpine.LFD.2.02.1305030054530.2891@ionos> <alpine.LFD.2.02.1305030923300.2886@ionos> <5183AECF.4070709@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 May 2013, Prarit Bhargava wrote:
> Down a cpu and then bring it back up.

Ahhhh. So the issue is, that we do not clear the per cpu ts->inidle
and friends when we bring the cpu down.

The patch below should address that.

Thanks,

	tglx

 
Index: linux-2.6/kernel/time/tick-common.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-common.c
+++ linux-2.6/kernel/time/tick-common.c
@@ -387,6 +387,7 @@ static int tick_notify(struct notifier_b
 		tick_shutdown_broadcast_oneshot(dev);
 		tick_shutdown_broadcast(dev);
 		tick_shutdown(dev);
+		tick_shutdown_nohz(dev);
 		break;
 
 	case CLOCK_EVT_NOTIFY_SUSPEND:
Index: linux-2.6/kernel/time/tick-internal.h
===================================================================
--- linux-2.6.orig/kernel/time/tick-internal.h
+++ linux-2.6/kernel/time/tick-internal.h
@@ -144,3 +144,9 @@ static inline int tick_device_is_functio
 #endif
 
 extern void do_timer(unsigned long ticks);
+
+#ifdef CONFIG_NO_HZ
+extern void tick_shutdown_nohz(unsigned int *cpup);
+#else
+static inline void tick_shutdown_nohz(unsigned int *cpup) { }
+#endif
Index: linux-2.6/kernel/time/tick-sched.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-sched.c
+++ linux-2.6/kernel/time/tick-sched.c
@@ -797,6 +797,13 @@ static inline void tick_check_nohz(int c
 	}
 }
 
+void tick_shutdown_nohz(unsigned int *cpup)
+{
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+
+	memset(ts, 0, sizeof(*ts));
+}
+
 #else
 
 static inline void tick_nohz_switch_to_nohz(void) { }
