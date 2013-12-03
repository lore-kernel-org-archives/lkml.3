Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab3LCXPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:15:34 -0500
Received: from relay3.sgi.com ([192.48.152.1]:50191 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754950Ab3LCXPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:15:32 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86, UV: null pointer in uv_flush_tlb_others()
Cc: mingo@elte.hu, x86@kernel.org
Message-Id: <E1VnzBi-0005yF-MU@eag09.americas.sgi.com>
From: cpw <cpw@sgi.com>
Date: Tue, 03 Dec 2013 17:15:30 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The SGI UV tlb shootdown code panics the system with a null pointer
deference if 'nobau' is specified on the boot commandline.

uv_flush_tlb_other() gets called for every flush, whether the BAU is disabled
or not.  It should not be keeping the s_enters statistic while the BAU
is disabled.
The panic occurs because, during initialization, init_per_cpu_tunables()
does not set the bcp->statp pointer if nobau was specified.

The code is the same in the 3.12.2 tree.

Cc: <stable@vger.kernel.org> # 3.12.x
Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/platform/uv/tlb_uv.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/platform/uv/tlb_uv.c
+++ linux/arch/x86/platform/uv/tlb_uv.c
@@ -1070,12 +1070,13 @@ const struct cpumask *uv_flush_tlb_other
 	unsigned long status;
 
 	bcp = &per_cpu(bau_control, cpu);
-	stat = bcp->statp;
-	stat->s_enters++;
 
 	if (bcp->nobau)
 		return cpumask;
 
+	stat = bcp->statp;
+	stat->s_enters++;
+
 	if (bcp->busy) {
 		descriptor_status =
 			read_lmmr(UVH_LB_BAU_SB_ACTIVATION_STATUS_0);
