Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab3BALDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 06:03:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52275 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626Ab3BALDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 06:03:13 -0500
Date: Fri, 1 Feb 2013 03:02:46 -0800
From: tip-bot for Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Message-ID: <tip-886c3b2d677fe248cce8101fa66a1b3e05c3ba16@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, robert.richter@amd.com,
        anton@au1.ibm.com, ak@linux.intel.com, tglx@linutronix.de,
        sukadev@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, robert.richter@amd.com,
        anton@au1.ibm.com, ak@linux.intel.com, sukadev@linux.vnet.ibm.com,
        tglx@linutronix.de
In-Reply-To: <20130123062528.GE13720@us.ibm.com>
References: <20130123062528.GE13720@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/POWER7:
  Make some POWER7 events available in sysfs
Git-Commit-ID: 886c3b2d677fe248cce8101fa66a1b3e05c3ba16
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 01 Feb 2013 03:02:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  886c3b2d677fe248cce8101fa66a1b3e05c3ba16
Gitweb:     http://git.kernel.org/tip/886c3b2d677fe248cce8101fa66a1b3e05c3ba16
Author:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
AuthorDate: Tue, 22 Jan 2013 22:25:29 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 Jan 2013 13:07:51 -0300

perf/POWER7: Make some POWER7 events available in sysfs

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
 
