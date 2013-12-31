Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab3LaPPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 10:15:34 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:44231 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682Ab3LaPPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 10:15:30 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, annie.li@oracle.com,
        msw@amazon.com
Subject: [PATCH] xen/grant-table: Force to use v1 of grants.
Date: Tue, 31 Dec 2013 10:15:19 -0500
Message-Id: <1388502919-8601-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1388502919-8601-1-git-send-email-konrad.wilk@oracle.com>
References: <1388502919-8601-1-git-send-email-konrad.wilk@oracle.com>
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

Oracle-bug: 16039922
CC: annie.li@oracle.com
CC: msw@amazon.com
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/grant-table.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index aa846a4..3005c17 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -1135,10 +1135,8 @@ static void gnttab_request_version(void)
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
1.8.3.1

