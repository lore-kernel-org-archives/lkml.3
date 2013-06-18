Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab3FRL4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:56:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56134 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab3FRLou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 50/93] powerpc/eeh: Don't check RTAS token to get PE addr
Date: Tue, 18 Jun 2013 12:42:58 +0100
Message-Id: <1371555821-12820-51-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavin Shan <shangw@linux.vnet.ibm.com>

commit b8b3de224f194005ad87ede6fd022fcc2bef3b1a upstream.

RTAS token "ibm,get-config-addr-info" or ibm,get-config-addr-info2"
are used to retrieve the PE address according to PCI address, which
made up of domain/bus/slot/function. If we don't have those 2 tokens,
the domain/bus/slot/function would be used as the address for EEH
RTAS operations. Some older f/w might not have those 2 tokens and
that blocks the EEH functionality to be initialized. It was introduced
by commit e2af155c ("powerpc/eeh: pseries platform EEH initialization").

The patch skips the check on those 2 tokens so we can bring up EEH
functionality successfully. And domain/bus/slot/function will be
used as address for EEH RTAS operations.

Reported-by: Robert Knight <knight@princeton.edu>
Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Tested-by: Robert Knight <knight@princeton.edu>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/platforms/pseries/eeh_pseries.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/eeh_pseries.c b/arch/powerpc/platforms/pseries/eeh_pseries.c
index 8752f79..8a811d9 100644
--- a/arch/powerpc/platforms/pseries/eeh_pseries.c
+++ b/arch/powerpc/platforms/pseries/eeh_pseries.c
@@ -83,7 +83,11 @@ static int pseries_eeh_init(void)
 	ibm_configure_pe		= rtas_token("ibm,configure-pe");
 	ibm_configure_bridge		= rtas_token ("ibm,configure-bridge");
 
-	/* necessary sanity check */
+	/*
+	 * Necessary sanity check. We needn't check "get-config-addr-info"
+	 * and its variant since the old firmware probably support address
+	 * of domain/bus/slot/function for EEH RTAS operations.
+	 */
 	if (ibm_set_eeh_option == RTAS_UNKNOWN_SERVICE) {
 		pr_warning("%s: RTAS service <ibm,set-eeh-option> invalid\n",
 			__func__);
@@ -102,12 +106,6 @@ static int pseries_eeh_init(void)
 		pr_warning("%s: RTAS service <ibm,slot-error-detail> invalid\n",
 			__func__);
 		return -EINVAL;
-	} else if (ibm_get_config_addr_info2 == RTAS_UNKNOWN_SERVICE &&
-		   ibm_get_config_addr_info == RTAS_UNKNOWN_SERVICE) {
-		pr_warning("%s: RTAS service <ibm,get-config-addr-info2> and "
-			"<ibm,get-config-addr-info> invalid\n",
-			__func__);
-		return -EINVAL;
 	} else if (ibm_configure_pe == RTAS_UNKNOWN_SERVICE &&
 		   ibm_configure_bridge == RTAS_UNKNOWN_SERVICE) {
 		pr_warning("%s: RTAS service <ibm,configure-pe> and "
-- 
1.8.1.2

