Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3AaR1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 12:27:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48070 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab3AaRZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 12:25:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, Anton Blanchard <anton@au1.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>, linuxppc-dev@ozlabs.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 24/25] perf/POWER7: Make some POWER7 events available in sysfs
Date: Thu, 31 Jan 2013 14:25:27 -0300
Message-Id: <1359653128-10433-25-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359653128-10433-1-git-send-email-acme@infradead.org>
References: <1359653128-10433-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

Make some POWER7-specific perf events available in sysfs.

	$ /bin/ls -1 /sys/bus/event_source/devices/cpu/events/
	branch-instructions
	branch-misses
	cache-misses
	cache-references
	cpu-cycles
	instructions
	PM_BRU_FIN
	PM_BRU_MPRED
	PM_CMPLU_STALL
	PM_CYC
	PM_GCT_NOSLOT_CYC
	PM_INST_CMPL
	PM_LD_MISS_L1
	PM_LD_REF_L1
	stalled-cycles-backend
	stalled-cycles-frontend

where the 'PM_*' events are POWER specific and the others are the
generic events.

This will enable users to specify these events with their symbolic
names rather than with their raw code.

	perf stat -e 'cpu/PM_CYC' ...

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: linuxppc-dev@ozlabs.org
Link: http://lkml.kernel.org/r/20130123062528.GE13720@us.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 arch/powerpc/include/asm/perf_event_server.h |  3 +++
 arch/powerpc/perf/power7-pmu.c               | 18 ++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/powerpc/include/asm/perf_event_server.h b/arch/powerpc/include/asm/perf_event_server.h
index b9b6c55..b29fcc6 100644
--- a/arch/powerpc/include/asm/perf_event_server.h
+++ b/arch/powerpc/include/asm/perf_event_server.h
@@ -132,3 +132,6 @@ extern ssize_t power_events_sysfs_show(struct device *dev,
 
 #define	GENERIC_EVENT_ATTR(_name, _id)	EVENT_ATTR(_name, _id, _g)
 #define	GENERIC_EVENT_PTR(_id)		EVENT_PTR(_id, _g)
+
+#define	POWER_EVENT_ATTR(_name, _id)	EVENT_ATTR(PM_##_name, _id, _p)
+#define	POWER_EVENT_PTR(_id)		EVENT_PTR(_id, _p)
diff --git a/arch/powerpc/perf/power7-pmu.c b/arch/powerpc/perf/power7-pmu.c
index 269bf24..b554879 100644
--- a/arch/powerpc/perf/power7-pmu.c
+++ b/arch/powerpc/perf/power7-pmu.c
@@ -384,6 +384,15 @@ GENERIC_EVENT_ATTR(cache-misses,		LD_MISS_L1);
 GENERIC_EVENT_ATTR(branch-instructions,		BRU_FIN);
 GENERIC_EVENT_ATTR(branch-misses,		BRU_MPRED);
 
+POWER_EVENT_ATTR(CYC,				CYC);
+POWER_EVENT_ATTR(GCT_NOSLOT_CYC,		GCT_NOSLOT_CYC);
+POWER_EVENT_ATTR(CMPLU_STALL,			CMPLU_STALL);
+POWER_EVENT_ATTR(INST_CMPL,			INST_CMPL);
+POWER_EVENT_ATTR(LD_REF_L1,			LD_REF_L1);
+POWER_EVENT_ATTR(LD_MISS_L1,			LD_MISS_L1);
+POWER_EVENT_ATTR(BRU_FIN,			BRU_FIN)
+POWER_EVENT_ATTR(BRU_MPRED,			BRU_MPRED);
+
 static struct attribute *power7_events_attr[] = {
 	GENERIC_EVENT_PTR(CYC),
 	GENERIC_EVENT_PTR(GCT_NOSLOT_CYC),
@@ -393,6 +402,15 @@ static struct attribute *power7_events_attr[] = {
 	GENERIC_EVENT_PTR(LD_MISS_L1),
 	GENERIC_EVENT_PTR(BRU_FIN),
 	GENERIC_EVENT_PTR(BRU_MPRED),
+
+	POWER_EVENT_PTR(CYC),
+	POWER_EVENT_PTR(GCT_NOSLOT_CYC),
+	POWER_EVENT_PTR(CMPLU_STALL),
+	POWER_EVENT_PTR(INST_CMPL),
+	POWER_EVENT_PTR(LD_REF_L1),
+	POWER_EVENT_PTR(LD_MISS_L1),
+	POWER_EVENT_PTR(BRU_FIN),
+	POWER_EVENT_PTR(BRU_MPRED),
 	NULL
 };
 
-- 
1.8.1.1.361.gec3ae6e

