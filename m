Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab3EHMLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 08:11:55 -0400
Received: from smtp.citrix.com ([66.165.176.89]:12593 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007Ab3EHMLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 08:11:30 -0400
X-IronPort-AV: E=Sophos;i="4.87,634,1363132800"; 
   d="scan'208";a="23987254"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <Stefano.Stabellini@eu.citrix.com>, <konrad.wilk@oracle.com>,
        <julien.grall@citrix.com>, <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 2/3] xen/arm: do not handle VCPUOP_register_vcpu_info failures
Date: Wed, 8 May 2013 13:11:19 +0100
Message-ID: <1368015080-5182-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1305081303310.18865@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305081303310.18865@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We expect VCPUOP_register_vcpu_info to succeed, do not try to handle
failures.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/xen/enlighten.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 83d13b0..519acf9 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -165,13 +165,10 @@ static int __init xen_secondary_init(unsigned int cpu)
 	info.offset = offset_in_page(vcpup);
 
 	err = HYPERVISOR_vcpu_op(VCPUOP_register_vcpu_info, cpu, &info);
-	if (err) {
-		pr_debug("register_vcpu_info failed: err=%d\n", err);
-	} else {
-		/* This cpu is using the registered vcpu info, even if
-		   later ones fail to. */
-		per_cpu(xen_vcpu, cpu) = vcpup;
-	}
+	if (err)
+		BUG();
+	per_cpu(xen_vcpu, cpu) = vcpup;
+
 	return 0;
 }
 
-- 
1.7.2.5

