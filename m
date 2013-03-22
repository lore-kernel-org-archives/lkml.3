Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422763Ab3CVRuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 13:50:07 -0400
Received: from ams-iport-1.cisco.com ([144.254.224.140]:12275 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422717Ab3CVRuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 13:50:04 -0400
X-Greylist: delayed 586 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Mar 2013 13:50:04 EDT
X-IronPort-AV: E=Sophos;i="4.84,893,1355097600"; 
   d="scan'208";a="152091224"
From: Henrik Austad <haustad@cisco.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Henrik Austad <haustad@cisco.com>
Subject: [PATCH] tile: ns2cycles must be called with preempt disabled.
Date: Fri, 22 Mar 2013 18:37:51 +0100
Message-Id: <1363973871-13199-1-git-send-email-haustad@cisco.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ns2cycles use per_cpu variables, and will, eventually, find its way into
smp_processord_id(). The latter must be called with either preempt
disabled, irq's off, from a thread locked to a single core or early in
the bootprocess (according to debug_smp_processor_id())

BUG: using smp_processor_id() in preemptible [00000000] code: systemd-modules/367
caller is ns2cycles+0x40/0xb8

Starting stack dump of tid 367, pid 367 (systemd-modules) on cpu 2 at cycle 20969956421
  frame 0: 0xfffffff70004b860 dump_stack+0x0/0x20 (sp 0xfffffe407993fa90)
  frame 1: 0xfffffff7006abc28 debug_smp_processor_id+0x1a8/0x1e0 (sp 0xfffffe407993fa90)
  frame 2: 0xfffffff7004d7b40 ns2cycles+0x40/0xb8 (sp 0xfffffe407993fab8)
  frame 3: 0xfffffff7004dc578 __ndelay+0x38/0x80 (sp 0xfffffe407993fae0)

Note: wrapping the -entire- delay-loop in a preempt-off section can be a
bad idea as long delays would case kernel lockups without being able to
preempt the thread at all.

Signed-off-by: Henrik Austad <haustad@cisco.com>
---
 arch/tile/lib/delay.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/tile/lib/delay.c b/arch/tile/lib/delay.c
index cdacdd1..a53cdcd 100644
--- a/arch/tile/lib/delay.c
+++ b/arch/tile/lib/delay.c
@@ -30,7 +30,9 @@ EXPORT_SYMBOL(__udelay);
 void __ndelay(unsigned long nsecs)
 {
 	cycles_t target = get_cycles();
+	preempt_disable();
 	target += ns2cycles(nsecs);
+	preempt_enable();
 	while (get_cycles() < target)
 		cpu_relax();
 }
-- 
1.7.2.5

