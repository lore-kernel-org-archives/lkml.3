Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbaACUbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 15:31:12 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23354 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbaACUaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 15:30:05 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, stefano.stabellini@eu.citrix.com,
        david.vrabel@citrix.com
Cc: hpa@zytor.com, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v13 15/19] xen/grant-table: Refactor gnttab_init
Date: Fri,  3 Jan 2014 14:38:32 -0500
Message-Id: <1388777916-1328-16-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com>
References: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have this odd scenario of where for PV paths we take a shortcut
but for the HVM paths we first ioremap xen_hvm_resume_frames, then
assign it to gnttab_shared.addr. This is needed because gnttab_map
uses gnttab_shared.addr.

Instead of having:
	if (pv)
		return gnttab_map
	if (hvm)
		...

	gnttab_map

Lets move the HVM part before the gnttab_map and remove the
first call to gnttab_map.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
---
 drivers/xen/grant-table.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 99399cb..cc1b4fa 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -1173,22 +1173,17 @@ static int gnttab_setup(void)
 	if (max_nr_gframes < nr_grant_frames)
 		return -ENOSYS;
 
-	if (xen_pv_domain())
-		return gnttab_map(0, nr_grant_frames - 1);
-
-	if (gnttab_shared.addr == NULL) {
+	if (xen_feature(XENFEAT_auto_translated_physmap) && gnttab_shared.addr == NULL)
+	{
 		gnttab_shared.addr = xen_remap(xen_hvm_resume_frames,
-						PAGE_SIZE * max_nr_gframes);
+					       PAGE_SIZE * max_nr_gframes);
 		if (gnttab_shared.addr == NULL) {
 			pr_warn("Failed to ioremap gnttab share frames (addr=0x%08lx)!\n",
 					xen_hvm_resume_frames);
 			return -ENOMEM;
 		}
 	}
-
-	gnttab_map(0, nr_grant_frames - 1);
-
-	return 0;
+	return gnttab_map(0, nr_grant_frames - 1);
 }
 
 int gnttab_resume(void)
-- 
1.8.3.1

