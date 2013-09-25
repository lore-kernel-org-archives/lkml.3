Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab3IYAs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:48:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39427 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448Ab3IYATz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:19:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [ 016/117] ARM: xen: only set pm function ptrs for Xen guests
Date: Tue, 24 Sep 2013 17:18:02 -0700
Message-Id: <20130925001742.627159232@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <rob.herring@calxeda.com>

commit 9dd4b2944c46e1fdbd0a516c221c8a2670cbf005 upstream.

xen_pm_init was unconditionally setting pm_power_off and arm_pm_restart
function pointers. This breaks multi-platform kernels. Make this
conditional on running as a Xen guest and make it a late_initcall to
ensure it is setup after platform code for Dom0.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/xen/enlighten.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -273,12 +273,15 @@ core_initcall(xen_guest_init);
 
 static int __init xen_pm_init(void)
 {
+	if (!xen_domain())
+		return -ENODEV;
+
 	pm_power_off = xen_power_off;
 	arm_pm_restart = xen_restart;
 
 	return 0;
 }
-subsys_initcall(xen_pm_init);
+late_initcall(xen_pm_init);
 
 static irqreturn_t xen_arm_callback(int irq, void *arg)
 {


