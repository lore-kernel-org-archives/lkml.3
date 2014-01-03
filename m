Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbaACUbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 15:31:50 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23342 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbaACUaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 15:30:03 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, stefano.stabellini@eu.citrix.com,
        david.vrabel@citrix.com
Cc: hpa@zytor.com, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v13 14/19] xen/grants: Remove gnttab_max_grant_frames dependency on gnttab_init.
Date: Fri,  3 Jan 2014 14:38:31 -0500
Message-Id: <1388777916-1328-15-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com>
References: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function gnttab_max_grant_frames() returns the maximum amount
of frames (pages) of grants we can have. Unfortunatly it was
dependent on gnttab_init() having been run before to initialize
the boot max value (boot_max_nr_grant_frames).

This meant that users of gnttab_max_grant_frames would always
get a zero value if they called before gnttab_init() - such as
'platform_pci_init' (drivers/xen/platform-pci.c).

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
---
 drivers/xen/grant-table.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index aa846a4..99399cb 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -62,7 +62,6 @@
 
 static grant_ref_t **gnttab_list;
 static unsigned int nr_grant_frames;
-static unsigned int boot_max_nr_grant_frames;
 static int gnttab_free_count;
 static grant_ref_t gnttab_free_head;
 static DEFINE_SPINLOCK(gnttab_list_lock);
@@ -827,6 +826,11 @@ static unsigned int __max_nr_grant_frames(void)
 unsigned int gnttab_max_grant_frames(void)
 {
 	unsigned int xen_max = __max_nr_grant_frames();
+	static unsigned int boot_max_nr_grant_frames;
+
+	/* First time, initialize it properly. */
+	if (!boot_max_nr_grant_frames)
+		boot_max_nr_grant_frames = __max_nr_grant_frames();
 
 	if (xen_max > boot_max_nr_grant_frames)
 		return boot_max_nr_grant_frames;
@@ -1227,13 +1231,12 @@ int gnttab_init(void)
 
 	gnttab_request_version();
 	nr_grant_frames = 1;
-	boot_max_nr_grant_frames = __max_nr_grant_frames();
 
 	/* Determine the maximum number of frames required for the
 	 * grant reference free list on the current hypervisor.
 	 */
 	BUG_ON(grefs_per_grant_frame == 0);
-	max_nr_glist_frames = (boot_max_nr_grant_frames *
+	max_nr_glist_frames = (gnttab_max_grant_frames() *
 			       grefs_per_grant_frame / RPP);
 
 	gnttab_list = kmalloc(max_nr_glist_frames * sizeof(grant_ref_t *),
-- 
1.8.3.1

