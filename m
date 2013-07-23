Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934536Ab3GWW1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:27:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934514Ab3GWW1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 020/103] powerpc/perf: Dont enable if we have zero events
Date: Tue, 23 Jul 2013 15:25:31 -0700
Message-Id: <20130723220420.830927751@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <michael@ellerman.id.au>

commit 4ea355b5368bde0574c12430df53334c4be3bdcf upstream.

In power_pmu_enable() we still enable the PMU even if we have zero
events. This should have no effect but doesn't make much sense. Instead
just return after telling the hypervisor that we are not using the PMCs.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/perf/core-book3s.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -926,6 +926,11 @@ static void power_pmu_enable(struct pmu
 	if (!cpuhw->disabled)
 		goto out;
 
+	if (cpuhw->n_events == 0) {
+		ppc_set_pmu_inuse(0);
+		goto out;
+	}
+
 	cpuhw->disabled = 0;
 
 	/*
@@ -937,8 +942,6 @@ static void power_pmu_enable(struct pmu
 	if (!cpuhw->n_added) {
 		mtspr(SPRN_MMCRA, cpuhw->mmcr[2] & ~MMCRA_SAMPLE_ENABLE);
 		mtspr(SPRN_MMCR1, cpuhw->mmcr[1]);
-		if (cpuhw->n_events == 0)
-			ppc_set_pmu_inuse(0);
 		goto out_enable;
 	}
 


