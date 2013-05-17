Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab3EQDfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 23:35:14 -0400
Received: from [213.199.154.185] ([213.199.154.185]:50825 "EHLO
	db8outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752656Ab3EQDfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 23:35:12 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(z3121kzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzzz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <vikram186@gmail.com>, Huang Shijie <b32955@freescale.com>
Subject: [PATCH v6 00/10] mtd: add datasheet's ECC information to nand_chip{}
Date: Fri, 17 May 2013 11:17:24 +0800
Message-ID: <1368760654-28754-1-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1.) Why add the ECC information to the nand_chip{} ?
   Each nand chip has its requirement for the ECC correctability, such as
   "4bit ECC for each 512Byte" or "40bit ECC for each 1024Byte".
   This ECC info is very important to the nand controller, such as gpmi.

   Take the Micron MT29F64G08CBABA for example, its geometry is
   8k page size, 744 bytes oob size and it requires 40bit ECC per 1K bytes.
   If we do not provide the ECC info to the gpmi nand driver, it has to
   calculate the ECC correctability itself. The gpmi driver will gets the 56bit
   ECC for per 1K bytes which is beyond its BCH's 40bit ecc capibility.
   The gpmi will quits in this case. But in actually, the gpmi can supports
   this nand chip if it can get the right ECC info.

2.) About the patch set:
   2.1) patch 1:
   	      The keynote patch.

   2.2) patch 2 ~ patch 6:
               These patches are for ONFI nand.
               Parse out the ecc info from the parameter page if we can, else
	       parse out the ecc info from the extended parameter page.
	       
   2.2) patch 7 ~ patch 9:
               Add the ECC info for full-id nand, and parse it out.

   2.3) patch 10 
               The gpmi uses the ecc info to set the BCH module. and with this
	       patch set, the gpmi can supports the MT29F64G08CBABA now.

v5 --> v6:
	[0] rename the ecc_strength/ecc_step to ecc_strength_ds/ecc_step_ds.
	[1] fix a case when "the codeword is 0".
	[2] fix typo.
	[3] add the 'O' to the diagram in the gpmi patch.

v4 --> v5:
	[0] rebase the new l2-mtd(dropped the 3 merged patches).
	[1] rename ecc_size to ecc_step.
	[2] change the comment for the new fields.

v3 --> v4:
	[0] remove the printk for "out of memory".
	[1] remove the hardcode nand_command_lp(). Update the chip->cmd_func
	    before we call the nand_flash_detect_ext_param_page().
	[2] split the ecc_info to two fields for full id nand.
	[3] update the comments for ecc_strength/ecc_size (from Brian).
	       
v2 --> v3:
	[0] add a new patch to define the semantics of the two fields.
	[1] Use the Change Read Column command to remove the "last" argument.
	[2] simplify the onfi_feature().
	[3] Use kmalloc() to replace kcalloc().
	[4] others.

v1 --> v2:
	[0] Since the first 3 patches are accepted, I do not send them in the
	    version 2.
	[1] add NAND_ prefix for macros used by the full-id nands.
	[2] add onfi_ prefix for the extend parameter page data structures.
	[3] rename the onfi_get_feature() to onfi_feature().
	[4] I re-test this patch set again.

Huang Shijie (10):
  mtd: add datasheet's ECC information to nand_chip{}
  mtd: get the ECC info from the parameter page for ONFI nand
  mtd: add data structures for Extended Parameter Page
  mtd: add a helper to get the supported features for ONFI nand
  mtd: get the ECC info from the Extended Parameter Page
  mtd: replace the hardcode with the onfi_feature()
  mtd: add ECC info for nand_flash_dev{}
  mtd: parse out the ECC info for the full-id nand chips
  mtd: add the ecc info for some full-id nand chips
  mtd: gpmi: set the BCH's geometry with the ecc info

 drivers/mtd/nand/gpmi-nand/gpmi-nand.c |  132 +++++++++++++++++++++++++++++++-
 drivers/mtd/nand/nand_base.c           |   93 ++++++++++++++++++++++-
 drivers/mtd/nand/nand_ids.c            |    8 +-
 include/linux/mtd/nand.h               |   72 +++++++++++++++++-
 4 files changed, 296 insertions(+), 9 deletions(-)


