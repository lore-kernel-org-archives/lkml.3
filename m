Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab3DWJGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 05:06:11 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:50840
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755907Ab3DWJGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 05:06:08 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(z3121kzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1082kzzz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH V3 0/9] mtd: add datasheet's ECC information to nand_chip{}
Date: Tue, 23 Apr 2013 16:54:48 +0800
Message-ID: <1366707297-31309-1-git-send-email-b32955@freescale.com>
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
   		This patch adds some comment for the two fields which can be
		treated as the initial semantics.

   2.2) patch 2 ~ patch 5:
	       Parse out the ecc info from the extended parameter page for
	       ONFI nand.
	       
   2.2) patch 6 ~ patch 8:
               Add the ECC info for full-id nand.

   2.3) patch 9
               The gpmi uses the ecc info to set the BCH module. and with this
	       patch set, the gpmi can supports the MT29F64G08CBABA now.


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

Huang Shijie (9):
  mtd: add more comment for ecc_strength/ecc_size
  mtd: add data structures for Extended Parameter Page
  mtd: add a helper to get the supported features for ONFI nand
  mtd: get the ECC info from the Extended Parameter Page
  mtd: replace the hardcode with the onfi_feature()
  mtd: add a new field for ecc info in the nand_flash_dev{}
  mtd: parse out the ECC info for the full-id nand chips
  mtd: add the ecc info for some full-id nand chips
  mtd: gpmi: set the BCH's geometry with the ecc info

 drivers/mtd/nand/gpmi-nand/gpmi-nand.c |  128 +++++++++++++++++++++++++++++++-
 drivers/mtd/nand/nand_base.c           |   80 +++++++++++++++++++-
 drivers/mtd/nand/nand_ids.c            |    8 +-
 include/linux/mtd/nand.h               |   63 +++++++++++++++-
 4 files changed, 269 insertions(+), 10 deletions(-)


