Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbaCaAOE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:14:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36407 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753052AbaC3XZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:02 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Grant Likely" <grant.likely@linaro.org>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.33465135@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 082/200] of: Fix address decoding on Bimini and js2x
 machines
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 6dd18e4684f3d188277bbbc27545248487472108 upstream.

 Commit:

  e38c0a1fbc5803cbacdaac0557c70ac8ca5152e7
  of/address: Handle #address-cells > 2 specially

broke real time clock access on Bimini, js2x, and similar powerpc
machines using the "maple" platform. That code was indirectly relying
on the old (broken) behaviour of the translation for the hypertransport
to ISA bridge.

This fixes it by treating hypertransport as a PCI bus

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/of/address.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -97,8 +97,12 @@ static unsigned int of_bus_default_get_f
 
 static int of_bus_pci_match(struct device_node *np)
 {
-	/* "vci" is for the /chaos bridge on 1st-gen PCI powermacs */
-	return !strcmp(np->type, "pci") || !strcmp(np->type, "vci");
+	/*
+	 * "vci" is for the /chaos bridge on 1st-gen PCI powermacs
+	 * "ht" is hypertransport
+	 */
+	return !strcmp(np->type, "pci") || !strcmp(np->type, "vci") ||
+		!strcmp(np->type, "ht");
 }
 
 static void of_bus_pci_count_cells(struct device_node *np,

