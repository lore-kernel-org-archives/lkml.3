Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbaBGLtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:49:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41783 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657AbaBGLti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:49:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Huewe <peterhuewe@gmx.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 081/233] tpm/tpm_ppi: Do not compare strcmp(a,b) == -1
Date: Fri,  7 Feb 2014 11:45:00 +0000
Message-Id: <1391773652-25214-82-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Huewe <PeterHuewe@gmx.de>

commit 747d35bd9bb4ae6bd74b19baa5bbe32f3e0cee11 upstream.

Depending on the implementation strcmp might return the difference between
two strings not only -1,0,1 consequently
 if (strcmp (a,b) == -1)
might lead to taking the wrong branch

-> compare with < 0  instead,
which in any case is more canonical.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/char/tpm/tpm_ppi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tpm/tpm_ppi.c b/drivers/char/tpm/tpm_ppi.c
index 57a818b..811ad1e 100644
--- a/drivers/char/tpm/tpm_ppi.c
+++ b/drivers/char/tpm/tpm_ppi.c
@@ -172,7 +172,7 @@ static ssize_t tpm_store_ppi_request(struct device *dev,
 	 * is updated with function index from SUBREQ to SUBREQ2 since PPI
 	 * version 1.1
 	 */
-	if (strcmp(version, "1.1") == -1)
+	if (strcmp(version, "1.1") < 0)
 		params[2].integer.value = TPM_PPI_FN_SUBREQ;
 	else
 		params[2].integer.value = TPM_PPI_FN_SUBREQ2;
@@ -182,7 +182,7 @@ static ssize_t tpm_store_ppi_request(struct device *dev,
 	 * string/package type. For PPI version 1.0 and 1.1, use buffer type
 	 * for compatibility, and use package type since 1.2 according to spec.
 	 */
-	if (strcmp(version, "1.2") == -1) {
+	if (strcmp(version, "1.2") < 0) {
 		params[3].type = ACPI_TYPE_BUFFER;
 		params[3].buffer.length = sizeof(req);
 		sscanf(buf, "%d", &req);
@@ -248,7 +248,7 @@ static ssize_t tpm_show_ppi_transition_action(struct device *dev,
 	 * (e.g. Capella with PPI 1.0) need integer/string/buffer type, so for
 	 * compatibility, define params[3].type as buffer, if PPI version < 1.2
 	 */
-	if (strcmp(version, "1.2") == -1) {
+	if (strcmp(version, "1.2") < 0) {
 		params[3].type = ACPI_TYPE_BUFFER;
 		params[3].buffer.length =  0;
 		params[3].buffer.pointer = NULL;
@@ -390,7 +390,7 @@ static ssize_t show_ppi_operations(char *buf, u32 start, u32 end)
 	kfree(output.pointer);
 	output.length = ACPI_ALLOCATE_BUFFER;
 	output.pointer = NULL;
-	if (strcmp(version, "1.2") == -1)
+	if (strcmp(version, "1.2") < 0)
 		return -EPERM;
 
 	params[2].integer.value = TPM_PPI_FN_GETOPR;
-- 
1.8.3.2

