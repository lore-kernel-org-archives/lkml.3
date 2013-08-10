Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab3HJRvw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 13:51:52 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36384 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328Ab3HJRvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 13:51:51 -0400
Date: Sat, 10 Aug 2013 10:51:23 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Stephane Eranian <eranian@google.com>, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH 4/7] powerpc/perf: Create mem-loads/mem-stores events for
 Power7
Message-ID: <20130810175123.GE15551@us.ibm.com>
References: <20130810174831.GA15551@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130810174831.GA15551@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081017-7182-0000-0000-0000080B11F7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 4/7] powerpc/perf: Create mem-loads/mem-stores events for Power7

'perf mem' command depends on the support for generic hardware events
'mem-loads' and 'mem-stores'.

Create those events for Power7 and map them both to the event PM_MRK_GRP_CMPL.
While PM_MRK_GRP_CMPL is strictly not restricted to loads and stores, that
seems to be a close/resonable match.

Cc: Stephane Eranian <eranian@google.com>
Cc: Paul Mckerras <paulus@samba.org>
Cc: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 arch/powerpc/perf/power7-pmu.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/perf/power7-pmu.c b/arch/powerpc/perf/power7-pmu.c
index 56c67bc..161861d 100644
--- a/arch/powerpc/perf/power7-pmu.c
+++ b/arch/powerpc/perf/power7-pmu.c
@@ -58,6 +58,18 @@
 
 enum {
 #include "power7-events-list.h"
+	/*
+	 * Normally, generic events like 'cycles' are aliases for a real
+	 * event PM_CYC. So we want both the event and the alias listed in
+	 * sysfs. But mem-loads and mem-stores are just aliases - they are
+	 * not listed in  power7_generic_events[] for instance. Adding them
+	 * to power7-events-list.h will unnecessariliy create PM_MEM_LOADS
+	 * and PM_MEM_STORES events in sysfs when that file is processed
+	 * again below. To save a couple of sysfs entries, define these
+	 * separately.
+	 */
+	EVENT(PM_MEM_LOADS,	0x40030)
+	EVENT(PM_MEM_STORES,	0x40030)
 };
 #undef EVENT
 
@@ -382,6 +394,8 @@ GENERIC_EVENT_ATTR(cache-references,		PM_LD_REF_L1);
 GENERIC_EVENT_ATTR(cache-misses,		PM_LD_MISS_L1);
 GENERIC_EVENT_ATTR(branch-instructions,		PM_BRU_FIN);
 GENERIC_EVENT_ATTR(branch-misses,		PM_BR_MPRED);
+GENERIC_EVENT_ATTR(mem-loads,			PM_MEM_LOADS);
+GENERIC_EVENT_ATTR(mem-stores,			PM_MEM_STORES);
 
 #define EVENT(_name, _code)     POWER_EVENT_ATTR(_name, _name);
 #include "power7-events-list.h"
@@ -398,6 +412,8 @@ static struct attribute *power7_events_attr[] = {
 	GENERIC_EVENT_PTR(PM_LD_MISS_L1),
 	GENERIC_EVENT_PTR(PM_BRU_FIN),
 	GENERIC_EVENT_PTR(PM_BR_MPRED),
+	GENERIC_EVENT_PTR(PM_MEM_LOADS),
+	GENERIC_EVENT_PTR(PM_MEM_STORES),
 
 	#include "power7-events-list.h"
 	#undef EVENT
-- 
1.7.1

