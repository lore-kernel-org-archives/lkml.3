Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab3APVW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 16:22:59 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:29105 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273Ab3APVW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 16:22:58 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, annie.li@oracle.com,
        msw@amazon.com
Subject: [PATCH] xen/grant-table: Force to use v1 of grants.
Date: Wed, 16 Jan 2013 16:22:49 -0500
Message-Id: <1358371369-19089-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have the framework to use v2, but there are no backends that
actually use it. The end result is that on PV we use v2 grants
and on PVHVM v1. The v1 has a capacity of 512 grants per page while
the v2 has 256 grants per page. This means we lose about 50%
capacity - and if we want more than 16 VIFs (each VIF takes
512 grants), then we are hitting the max per guest of 32.

Note: The hypervisor provides an over-ride for the default
of 32 frames (pages) per guest: gnttab_max_nr_frames=X

Oracle-bug: 16039922
CC: annie.li@oracle.com
CC: msw@amazon.com
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/grant-table.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 95ce9d0..568fd8f 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -1108,10 +1108,8 @@ static void gnttab_request_version(void)
 	int rc;
 	struct gnttab_set_version gsv;
 
-	if (xen_hvm_domain())
-		gsv.version = 1;
-	else
-		gsv.version = 2;
+	gsv.version = 1;
+
 	rc = HYPERVISOR_grant_table_op(GNTTABOP_set_version, &gsv, 1);
 	if (rc == 0 && gsv.version == 2) {
 		grant_table_version = 2;
-- 
1.8.0.2

