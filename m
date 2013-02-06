Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab3BFITr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 03:19:47 -0500
Received: from ozlabs.org ([203.10.76.45]:48336 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab3BFIT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 03:19:26 -0500
From: Michael Ellerman <michael@ellerman.id.au>
To: <penberg@kernel.org>
Cc: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/6] kvm tools: powerpc: Fix buglet in xics_init() handling of nrcpus
Date: Wed,  6 Feb 2013 19:19:14 +1100
Message-Id: <1360138756-1991-4-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360138756-1991-1-git-send-email-michael@ellerman.id.au>
References: <1360138756-1991-1-git-send-email-michael@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In xics_init() we set the maximum server to kvm->nrcpus, and then set
the nr_servers using maximum server + 1.

That is off by one, in the harmless direction.

Simplify it to just set nr_servers = kvm->nrcpus.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 tools/kvm/powerpc/xics.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/kvm/powerpc/xics.c b/tools/kvm/powerpc/xics.c
index d4b5caa..cf64a08 100644
--- a/tools/kvm/powerpc/xics.c
+++ b/tools/kvm/powerpc/xics.c
@@ -445,16 +445,13 @@ static void rtas_int_on(struct kvm_cpu *vcpu, uint32_t token,
 
 static int xics_init(struct kvm *kvm)
 {
-	int max_server_num;
 	unsigned int i;
 	struct icp_state *icp;
 	struct ics_state *ics;
 	int j;
 
-	max_server_num = kvm->nrcpus;
-
 	icp = malloc(sizeof(*icp));
-	icp->nr_servers = max_server_num + 1;
+	icp->nr_servers = kvm->nrcpus;
 	icp->ss = malloc(icp->nr_servers * sizeof(struct icp_server_state));
 
 	for (i = 0; i < icp->nr_servers; i++) {
-- 
1.7.10.4

