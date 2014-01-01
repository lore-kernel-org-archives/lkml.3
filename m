Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbaAAEkw (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 31 Dec 2013 23:40:52 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:19642 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaAAEhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 23:37:04 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v12 13/18] xen/grant-table: Refactor gnttab_init
Date: Tue, 31 Dec 2013 23:35:40 -0500
Message-Id: <1388550945-25499-14-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
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

