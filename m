Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934120Ab3CZHTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 03:19:11 -0400
Received: from ams-iport-4.cisco.com ([144.254.224.147]:37885 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab3CZHTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 03:19:10 -0400
X-IronPort-AV: E=Sophos;i="4.84,910,1355097600"; 
   d="scan'208";a="12896809"
From: Henrik Austad <haustad@cisco.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Henrik Austad <haustad@cisco.com>
Subject: [PATCH] tile: ns2cycles should use __raw_get_cpu_var
Date: Tue, 26 Mar 2013 08:16:42 +0100
Message-Id: <1364282202-8031-1-git-send-email-haustad@cisco.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <514DB895.9010201@tilera.com>
References: <514DB895.9010201@tilera.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ns2cycles use per_cpu variables, and will, eventually, find its way into
smp_processord_id(). This is not safe in a preemptible kernel,
preemption should ideally be disabled.

BUG: using smp_processor_id() in preemptible [00000000] code:
systemd-modules/367
caller is ns2cycles+0x40/0xb8

Starting stack dump of tid 367, pid 367 (systemd-modules) on cpu 2 at
cycle 20969956421
 frame 0: 0xfffffff70004b860 dump_stack+0x0/0x20 (sp 0xfffffe407993fa90)
 frame 1: 0xfffffff7006abc28 debug_smp_processor_id+0x1a8/0x1e0 (sp
0xfffffe407993fa90)
 frame 2: 0xfffffff7004d7b40 ns2cycles+0x40/0xb8 (sp 0xfffffe407993fab8)
 frame 3: 0xfffffff7004dc578 __ndelay+0x38/0x80 (sp 0xfffffe407993fae0)

However, in this case:

- the frequency is the same accross all cores
- we use the data read-only
- we do not scale the frequency

Which means that we can use the __raw_get_cpu_var instead.

Signed-off-by: Henrik Austad <haustad@cisco.com>
---
 arch/tile/kernel/time.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/tile/kernel/time.c b/arch/tile/kernel/time.c
index 42297f6..1dc1d61 100644
--- a/arch/tile/kernel/time.c
+++ b/arch/tile/kernel/time.c
@@ -234,7 +234,11 @@ int setup_profiling_timer(unsigned int multiplier)
  */
 cycles_t ns2cycles(unsigned long nsecs)
 {
-	struct clock_event_device *dev = &__get_cpu_var(tile_timer);
+	/*
+	 * We do not have to disable preemptions here as each core has the same
+	 * clock frequency.
+	 */
+	struct clock_event_device *dev = &__raw_get_cpu_var(tile_timer);
 	return ((u64)nsecs * dev->mult) >> dev->shift;
 }
 
-- 
1.7.1

