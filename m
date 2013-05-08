Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab3EHMLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 08:11:31 -0400
Received: from smtp.citrix.com ([66.165.176.89]:12593 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab3EHML3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 08:11:29 -0400
X-IronPort-AV: E=Sophos;i="4.87,634,1363132800"; 
   d="scan'208";a="23987253"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <Stefano.Stabellini@eu.citrix.com>, <konrad.wilk@oracle.com>,
        <julien.grall@citrix.com>, <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 1/3] xen/arm: initialize pm functions later
Date: Wed, 8 May 2013 13:11:18 +0100
Message-ID: <1368015080-5182-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1305081303310.18865@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305081303310.18865@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we are running in dom0, we have to wait for the arch specific code to
complete the initialization in order for us to successfully reset the
power_off and pm_restart functions.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/xen/enlighten.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index d30042e..83d13b0 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -272,12 +272,18 @@ static int __init xen_guest_init(void)
 	if (!xen_initial_domain())
 		xenbus_probe(NULL);
 
+	return 0;
+}
+core_initcall(xen_guest_init);
+
+static int __init xen_pm_init(void)
+{
 	pm_power_off = xen_power_off;
 	arm_pm_restart = xen_restart;
 
 	return 0;
 }
-core_initcall(xen_guest_init);
+subsys_initcall(xen_pm_init);
 
 static irqreturn_t xen_arm_callback(int irq, void *arg)
 {
-- 
1.7.2.5

