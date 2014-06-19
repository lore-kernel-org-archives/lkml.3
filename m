Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324AbaFSMjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:39:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57617 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbaFSMjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:39:06 -0400
Date: Thu, 19 Jun 2014 05:37:53 -0700
From: tip-bot for Vince Weaver <tipbot@zytor.com>
Message-ID: <tip-703daddffe550121e607c8294176ad2b12661147@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, cody@linux.vnet.ibm.com, peterz@infradead.org,
        mpe@ellerman.id.au, vincent.weaver@maine.edu, benh@kernel.crashing.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, cody@linux.vnet.ibm.com,
        peterz@infradead.org, mpe@ellerman.id.au, benh@kernel.crashing.org,
        vincent.weaver@maine.edu, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.10.1406150203210.16738@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1406150203210.16738@vincent-weaver-1.umelst.maine.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] powerpc, perf:
  Use common PMU interrupt disabled code
Git-Commit-ID: 703daddffe550121e607c8294176ad2b12661147
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

Commit-ID:  703daddffe550121e607c8294176ad2b12661147
Gitweb:     http://git.kernel.org/tip/703daddffe550121e607c8294176ad2b12661147
Author:     Vince Weaver <vincent.weaver@maine.edu>
AuthorDate: Sun, 15 Jun 2014 02:04:25 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 18 Jun 2014 18:43:46 +0200

powerpc, perf: Use common PMU interrupt disabled code

Transition to using the new generic PERF_PMU_CAP_NO_INTERRUPT method for
failing a sampling event when no PMU interrupt is available.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1406150203210.16738@vincent-weaver-1.umelst.maine.edu
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/powerpc/perf/hv-24x7.c | 6 ++++--
 arch/powerpc/perf/hv-gpci.c | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
index e0766b8..3de7920 100644
--- a/arch/powerpc/perf/hv-24x7.c
+++ b/arch/powerpc/perf/hv-24x7.c
@@ -387,8 +387,7 @@ static int h_24x7_event_init(struct perf_event *event)
 	    event->attr.exclude_hv     ||
 	    event->attr.exclude_idle   ||
 	    event->attr.exclude_host   ||
-	    event->attr.exclude_guest  ||
-	    is_sampling_event(event)) /* no sampling */
+	    event->attr.exclude_guest
 		return -EINVAL;
 
 	/* no branch sampling */
@@ -513,6 +512,9 @@ static int hv_24x7_init(void)
 	if (!hv_page_cache)
 		return -ENOMEM;
 
+	/* sampling not supported */
+	h_24x7_pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
+
 	r = perf_pmu_register(&h_24x7_pmu, h_24x7_pmu.name, -1);
 	if (r)
 		return r;
diff --git a/arch/powerpc/perf/hv-gpci.c b/arch/powerpc/perf/hv-gpci.c
index c9d399a..6d9c8e4 100644
--- a/arch/powerpc/perf/hv-gpci.c
+++ b/arch/powerpc/perf/hv-gpci.c
@@ -210,8 +210,7 @@ static int h_gpci_event_init(struct perf_event *event)
 	    event->attr.exclude_hv     ||
 	    event->attr.exclude_idle   ||
 	    event->attr.exclude_host   ||
-	    event->attr.exclude_guest  ||
-	    is_sampling_event(event)) /* no sampling */
+	    event->attr.exclude_guest
 		return -EINVAL;
 
 	/* no branch sampling */
@@ -284,6 +283,9 @@ static int hv_gpci_init(void)
 		return -ENODEV;
 	}
 
+	/* sampling not supported */
+	h_gpci_pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
+
 	r = perf_pmu_register(&h_gpci_pmu, h_gpci_pmu.name, -1);
 	if (r)
 		return r;
