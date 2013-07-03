Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965088Ab3GCTGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:06:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10139 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965013Ab3GCTA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:29 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=aarct4RCfEMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=VnNyYq6S5X8A:10 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=wMNdZWldAAAA:8 a=jPL08FsF-1G90BaU5qQA:9 a=jeBq3FmKZ4MA:10 a=Th6SlBt7gdAw19XM:21 a=HPSTfw0bzketonQf:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184100.094979481@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Robert Knight <knight@princeton.edu>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [090/141] powerpc/eeh: Dont check RTAS token to get PE addr
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0090-powerpc-eeh-Don-t-check-RTAS-token-to-get-PE-addr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Gavin Shan <shangw@linux.vnet.ibm.com>

[ Upstream commit b8b3de224f194005ad87ede6fd022fcc2bef3b1a ]

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

Cc: <stable@vger.kernel.org> # v3.4+
Reported-by: Robert Knight <knight@princeton.edu>
Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Tested-by: Robert Knight <knight@princeton.edu>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/powerpc/platforms/pseries/eeh_pseries.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/eeh_pseries.c b/arch/powerpc/platforms/pseries/eeh_pseries.c
index c33360ec..a81ebd3 100644
--- a/arch/powerpc/platforms/pseries/eeh_pseries.c
+++ b/arch/powerpc/platforms/pseries/eeh_pseries.c
@@ -83,7 +83,11 @@ static int pseries_eeh_init(void)
 	ibm_configure_pe		= rtas_token("ibm,configure-pe");
 	ibm_configure_bridge		= rtas_token("ibm,configure-bridge");
 
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
1.7.10.4


