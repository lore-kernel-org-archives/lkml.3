Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbaADCmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 21:42:46 -0500
Received: from mout.gmx.net ([212.227.17.21]:50619 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815AbaADCmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 21:42:45 -0500
From: Peter Huewe <peterhuewe@gmx.de>
To: James Morris <jmorris@namei.org>
Cc: Ashley Lai <ashley@ashleylai.com>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Peter Huewe <PeterHuewe@gmx.de>,
        stable@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 01/15] tpm/tpm_ppi: Do not compare strcmp(a,b) == -1
Date: Sat,  4 Jan 2014 03:44:35 +0100
Message-Id: <1388803489-13258-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <201401040335.04980.PeterHuewe@gmx.de>
References: <201401040335.04980.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:hrJ45H+JpwzdjfwdEFJB0VJFALZS5Vitt7P3BvAovuSE+JOZML/
 5Wd1UBoGHnkV63E+xyXKnfwX92eAlvTa/vlG0nIIvM2laXwwDbU21pfQP9C7AJ2Iij405RG
 Kfneaa3pK30y66B0fOyRN9p4I18dS6rEq1CZ0ecaFK6BD+WWBNo1/jrsslkpw9rRjVy19G+
 UuCTN87qm4ZsH10B0nlug==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <PeterHuewe@gmx.de>

Depending on the implementation strcmp might return the difference between
two strings not only -1,0,1 consequently
 if (strcmp (a,b) == -1)
might lead to taking the wrong branch

-> compare with < 0  instead,
which in any case is more canonical.

Cc: stable@vger.kernel.org
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/tpm_ppi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tpm/tpm_ppi.c b/drivers/char/tpm/tpm_ppi.c
index 8e562dc..18c5810 100644
--- a/drivers/char/tpm/tpm_ppi.c
+++ b/drivers/char/tpm/tpm_ppi.c
@@ -169,7 +169,7 @@ static ssize_t tpm_store_ppi_request(struct device *dev,
 	 * is updated with function index from SUBREQ to SUBREQ2 since PPI
 	 * version 1.1
 	 */
-	if (strcmp(version, "1.1") == -1)
+	if (strcmp(version, "1.1") < 0)
 		params[2].integer.value = TPM_PPI_FN_SUBREQ;
 	else
 		params[2].integer.value = TPM_PPI_FN_SUBREQ2;
@@ -179,7 +179,7 @@ static ssize_t tpm_store_ppi_request(struct device *dev,
 	 * string/package type. For PPI version 1.0 and 1.1, use buffer type
 	 * for compatibility, and use package type since 1.2 according to spec.
 	 */
-	if (strcmp(version, "1.2") == -1) {
+	if (strcmp(version, "1.2") < 0) {
 		params[3].type = ACPI_TYPE_BUFFER;
 		params[3].buffer.length = sizeof(req);
 		sscanf(buf, "%d", &req);
@@ -245,7 +245,7 @@ static ssize_t tpm_show_ppi_transition_action(struct device *dev,
 	 * (e.g. Capella with PPI 1.0) need integer/string/buffer type, so for
 	 * compatibility, define params[3].type as buffer, if PPI version < 1.2
 	 */
-	if (strcmp(version, "1.2") == -1) {
+	if (strcmp(version, "1.2") < 0) {
 		params[3].type = ACPI_TYPE_BUFFER;
 		params[3].buffer.length =  0;
 		params[3].buffer.pointer = NULL;
@@ -387,7 +387,7 @@ static ssize_t show_ppi_operations(char *buf, u32 start, u32 end)
 	kfree(output.pointer);
 	output.length = ACPI_ALLOCATE_BUFFER;
 	output.pointer = NULL;
-	if (strcmp(version, "1.2") == -1)
+	if (strcmp(version, "1.2") < 0)
 		return -EPERM;
 
 	params[2].integer.value = TPM_PPI_FN_GETOPR;
-- 
1.8.1.5

