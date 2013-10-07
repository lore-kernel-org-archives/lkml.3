Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab3JGScz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 14:32:55 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:36786 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754477Ab3JGScy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 14:32:54 -0400
Message-Id: <0000014194317eed-362a9207-eef4-4a16-80ae-0f01a16e2fb3-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Mon, 7 Oct 2013 18:32:53 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, Eric Dumazet <edumazet@google.com>
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [raw v1 4/4] net: __this_cpu_inc in route.c
References: <20131007183226.334180014@linux.com>
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I do not see any synchronization however commit
dbd2915ce87e811165da0717f8e159276ebb803e by Andrew justifies
the use of raw_smp_processor_id() here because "we do not care"

So lets use raw_cpu ops here and hope for the best. The use of
__this_cpu op improves the situation already from what commit
dbd2915ce87e811165da0717f8e159276ebb803e did since the single instruction
emitted on x86 does not allow the race to occur anymore. However,
non x86 platforms could still experience a race here.

Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/net/ipv4/route.c
===================================================================
--- linux.orig/net/ipv4/route.c	2013-10-07 10:27:25.000000000 -0500
+++ linux/net/ipv4/route.c	2013-10-07 12:41:23.993823743 -0500
@@ -197,7 +197,7 @@ const __u8 ip_tos2prio[16] = {
 EXPORT_SYMBOL(ip_tos2prio);
 
 static DEFINE_PER_CPU(struct rt_cache_stat, rt_cache_stat);
-#define RT_CACHE_STAT_INC(field) __this_cpu_inc(rt_cache_stat.field)
+#define RT_CACHE_STAT_INC(field) raw_cpu_inc(rt_cache_stat.field)
 
 #ifdef CONFIG_PROC_FS
 static void *rt_cache_seq_start(struct seq_file *seq, loff_t *pos)

