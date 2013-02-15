Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161377Ab3BONJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:09:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936018Ab3BOMpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:45:41 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC 12/13] ghes_edac.c: Don't credit the same memory dimm twice
Date: Fri, 15 Feb 2013 10:45:00 -0200
Message-Id: <636d636b8da2814df497ca29505a592d3ed6112a.1360931635.git.mchehab@redhat.com>
In-Reply-To: <cover.1360931635.git.mchehab@redhat.com>
References: <cover.1360931635.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my tests on a 4xE5-4650 CPU's system, the GHES
EDAC driver is called twice. As the SMBIOS DMI enumeration
call will seek for the entire DIMM sockets in the system, on
this machine, equipped with 128 GB of RAM, the memory is
displayed twice:

          +-----------------------+
          |    mc0    |    mc1    |
----------+-----------------------+
memory45: |  8192 MB  |  8192 MB  |
memory44: |     0 MB  |     0 MB  |
----------+-----------------------+
memory43: |     0 MB  |     0 MB  |
memory42: |  8192 MB  |  8192 MB  |
----------+-----------------------+
memory41: |     0 MB  |     0 MB  |
memory40: |     0 MB  |     0 MB  |
----------+-----------------------+
memory39: |  8192 MB  |  8192 MB  |
memory38: |     0 MB  |     0 MB  |
----------+-----------------------+
memory37: |     0 MB  |     0 MB  |
memory36: |  8192 MB  |  8192 MB  |
----------+-----------------------+
memory35: |     0 MB  |     0 MB  |
memory34: |     0 MB  |     0 MB  |
----------+-----------------------+
memory33: |  8192 MB  |  8192 MB  |
memory32: |     0 MB  |     0 MB  |
----------+-----------------------+
memory31: |     0 MB  |     0 MB  |
memory30: |  8192 MB  |  8192 MB  |
----------+-----------------------+
memory29: |     0 MB  |     0 MB  |
memory28: |     0 MB  |     0 MB  |
----------+-----------------------+
memory27: |  8192 MB  |  8192 MB  |
memory26: |     0 MB  |     0 MB  |
----------+-----------------------+
memory25: |     0 MB  |     0 MB  |
memory24: |  8192 MB  |  8192 MB  |
----------+-----------------------+
memory23: |     0 MB  |     0 MB  |
memory22: |     0 MB  |     0 MB  |
----------+-----------------------+
memory21: |  8192 MB  |  8192 MB  |
memory20: |     0 MB  |     0 MB  |
----------+-----------------------+
memory19: |     0 MB  |     0 MB  |
memory18: |  8192 MB  |  8192 MB  |
----------+-----------------------+
memory17: |     0 MB  |     0 MB  |
memory16: |     0 MB  |     0 MB  |
----------+-----------------------+
memory15: |  8192 MB  |  8192 MB  |
memory14: |     0 MB  |     0 MB  |
----------+-----------------------+
memory13: |     0 MB  |     0 MB  |
memory12: |  8192 MB  |  8192 MB  |
----------+-----------------------+
memory11: |     0 MB  |     0 MB  |
memory10: |     0 MB  |     0 MB  |
----------+-----------------------+
memory9:  |  8192 MB  |  8192 MB  |
memory8:  |     0 MB  |     0 MB  |
----------+-----------------------+
memory7:  |     0 MB  |     0 MB  |
memory6:  |  8192 MB  |  8192 MB  |
----------+-----------------------+
memory5:  |     0 MB  |     0 MB  |
memory4:  |     0 MB  |     0 MB  |
----------+-----------------------+
memory3:  |  8192 MB  |  8192 MB  |
memory2:  |     0 MB  |     0 MB  |
----------+-----------------------+
memory1:  |     0 MB  |     0 MB  |
memory0:  |  8192 MB  |  8192 MB  |
----------+-----------------------+

Total sum of 256 GB.

As there's no reliable way to credit DIMMS to the right memory
controller, just put everything on memory controller 0 (with should
always exist).

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/ghes_edac.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
index 7bd7161..97a0d53 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -245,10 +245,19 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 	mci->dev_name = "ghes";
 
 	if (!fake) {
-		/* Fill DIMM info from DMI */
-		dimm_fill.count = 0;
-		dimm_fill.mci = mci;
-		dmi_walk (ghes_edac_dmidecode, &dimm_fill);
+		/*
+		 * Fill DIMM info from DMI for the memory controller #0
+		 *
+		 * Keep it in blank for the other memory controllers, as
+		 * there's no reliable way to properly credit each DIMM to
+		 * the memory controller, as different BIOSes fill the
+		 * DMI bank location fields on different ways
+		 */
+		if (!ghes_edac_mc_num) {
+			dimm_fill.count = 0;
+			dimm_fill.mci = mci;
+			dmi_walk (ghes_edac_dmidecode, &dimm_fill);
+		}
 	} else {
 		struct dimm_info *dimm = EDAC_DIMM_PTR(mci->layers, mci->dimms,
 						       mci->n_layers, 0, 0, 0);
-- 
1.8.1.2

