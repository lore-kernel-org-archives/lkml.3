Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581Ab3GRXEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 19:04:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:16127 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759404Ab3GRXEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 19:04:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,697,1367996400"; 
   d="scan'208";a="333573817"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, eranian@google.com
Subject: [PATCH] perf, x86: Enable PEBS mode automatically for mem-{loads,stores} v3
Date: Thu, 18 Jul 2013 16:03:39 -0700
Message-Id: <1374188619-19220-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

[The patch to enable this in the user tools has been sent separately]

With the earlier patches to automatically try cpu// and add
a precise sys attribute, we can now enable PEBS for the mem-loads,
mem-stores events everywhere.

This allows to use

perf record -e mem-loads ...

instead of

perf record -e cpu/mem-loads/p ...

Always use precise=2 even though it is costly pre-Haswell

Cc: eranian@google.com
v2: Different white space
v3: Always use precise=2, as people seem to think overhead doesn't matter.
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index fbc9210..ef9236b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -176,9 +176,12 @@ static struct extra_reg intel_snbep_extra_regs[] __read_mostly = {
 	EVENT_EXTRA_END
 };
 
-EVENT_ATTR_STR(mem-loads, mem_ld_nhm, "event=0x0b,umask=0x10,ldlat=3");
-EVENT_ATTR_STR(mem-loads, mem_ld_snb, "event=0xcd,umask=0x1,ldlat=3");
-EVENT_ATTR_STR(mem-stores, mem_st_snb, "event=0xcd,umask=0x2");
+EVENT_ATTR_STR(mem-loads, mem_ld_nhm,
+		"event=0x0b,umask=0x10,ldlat=3,precise=2");
+EVENT_ATTR_STR(mem-loads, mem_ld_snb,
+		"event=0xcd,umask=0x1,ldlat=3,precise=2");
+EVENT_ATTR_STR(mem-stores, mem_st_snb,
+		"event=0xcd,umask=0x2,precise=2");
 
 struct attribute *nhm_events_attrs[] = {
 	EVENT_PTR(mem_ld_nhm),
@@ -2034,8 +2037,9 @@ static __init void intel_nehalem_quirk(void)
 	}
 }
 
-EVENT_ATTR_STR(mem-loads,      mem_ld_hsw,     "event=0xcd,umask=0x1,ldlat=3");
-EVENT_ATTR_STR(mem-stores,     mem_st_hsw,     "event=0xd0,umask=0x82")
+EVENT_ATTR_STR(mem-loads,      mem_ld_hsw,
+		"event=0xcd,umask=0x1,ldlat=3,precise=2");
+EVENT_ATTR_STR(mem-stores,     mem_st_hsw,  "event=0xd0,umask=0x82,precise=2")
 
 static struct attribute *hsw_events_attrs[] = {
 	EVENT_PTR(mem_ld_hsw),
-- 
1.8.1.4

