Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbaFSMjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:39:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57619 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbaFSMjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:39:11 -0400
Date: Thu, 19 Jun 2014 05:38:07 -0700
From: tip-bot for Vince Weaver <tipbot@zytor.com>
Message-ID: <tip-d7302ac28ba24eeac512c8f45107c962c701eb38@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, brueckner@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@kernel.org, schwidefsky@de.ibm.com, peterz@infradead.org,
        thuth@linux.vnet.ibm.com, vincent.weaver@maine.edu,
        heiko.carstens@de.ibm.com, tglx@linutronix.de,
        paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, hpa@zytor.com, brueckner@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        schwidefsky@de.ibm.com, thuth@linux.vnet.ibm.com,
        vincent.weaver@maine.edu, heiko.carstens@de.ibm.com,
        tglx@linutronix.de, paul.gortmaker@windriver.com
In-Reply-To: <alpine.DEB.2.10.1406150204290.16738@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1406150204290.16738@vincent-weaver-1.umelst.maine.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] s390, perf:
  Use common PMU interrupt disabled code
Git-Commit-ID: d7302ac28ba24eeac512c8f45107c962c701eb38
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d7302ac28ba24eeac512c8f45107c962c701eb38
Gitweb:     http://git.kernel.org/tip/d7302ac28ba24eeac512c8f45107c962c701eb38
Author:     Vince Weaver <vincent.weaver@maine.edu>
AuthorDate: Sun, 15 Jun 2014 02:05:23 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 18 Jun 2014 18:43:47 +0200

s390, perf: Use common PMU interrupt disabled code

Transition to using the new generic PERF_PMU_CAP_NO_INTERRUPT method for
failing a sampling event when no PMU interrupt is available.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Thomas Huth <thuth@linux.vnet.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1406150204290.16738@vincent-weaver-1.umelst.maine.edu
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/s390/kernel/perf_cpum_cf.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kernel/perf_cpum_cf.c b/arch/s390/kernel/perf_cpum_cf.c
index ea75d01..d3194de 100644
--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -411,12 +411,6 @@ static int cpumf_pmu_event_init(struct perf_event *event)
 	case PERF_TYPE_HARDWARE:
 	case PERF_TYPE_HW_CACHE:
 	case PERF_TYPE_RAW:
-		/* The CPU measurement counter facility does not have overflow
-		 * interrupts to do sampling.  Sampling must be provided by
-		 * external means, for example, by timers.
-		 */
-		if (is_sampling_event(event))
-			return -ENOENT;
 		err = __hw_perf_event_init(event);
 		break;
 	default:
@@ -681,6 +675,12 @@ static int __init cpumf_pmu_init(void)
 		goto out;
 	}
 
+	/* The CPU measurement counter facility does not have overflow
+	 * interrupts to do sampling.  Sampling must be provided by
+	 * external means, for example, by timers.
+	 */
+	cpumf_pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
+
 	cpumf_pmu.attr_groups = cpumf_cf_event_group();
 	rc = perf_pmu_register(&cpumf_pmu, "cpum_cf", PERF_TYPE_RAW);
 	if (rc) {
