Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965267AbaDJDix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:38:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934320AbaDJDXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:23:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 122/134] sb_edac: Avoid overflow errors at memory size calculation
Date: Wed,  9 Apr 2014 20:23:58 -0700
Message-Id: <20140410032314.991147249@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab@redhat.com>

commit deb09ddaff1435f72dd598d38f9b58354c68a5ec upstream.

Sandy bridge EDAC is calculating the memory size with overflow.
Basically, the size field and the integer calculation is using 32 bits.
More bits are needed, when the DIMM memories have high density.

The net result is that memories are improperly reported there, when
high-density DIMMs are used:

EDAC DEBUG: in drivers/edac/sb_edac.c, line at 591: mc#0: channel 0, dimm 0, -16384 Mb (-4194304 pages) bank: 8, rank: 2, row: 0x10000, col: 0x800
EDAC DEBUG: in drivers/edac/sb_edac.c, line at 591: mc#0: channel 1, dimm 0, -16384 Mb (-4194304 pages) bank: 8, rank: 2, row: 0x10000, col: 0x800

As the number of pages value is handled at the EDAC core as unsigned
ints, the driver shows the 16 GB memories at sysfs interface as 16760832
MB! The fix is simple: calculate the number of pages as unsigned 64-bits
integer.

After the patch, the memory size (16 GB) is properly detected:

EDAC DEBUG: in drivers/edac/sb_edac.c, line at 592: mc#0: channel 0, dimm 0, 16384 Mb (4194304 pages) bank: 8, rank: 2, row: 0x10000, col: 0x800
EDAC DEBUG: in drivers/edac/sb_edac.c, line at 592: mc#0: channel 1, dimm 0, 16384 Mb (4194304 pages) bank: 8, rank: 2, row: 0x10000, col: 0x800

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
[bwh: Backported to 3.2:
 - Adjust context
 - Debug log function is debugf0(), not edac_dbg()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/edac/sb_edac.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -555,7 +555,8 @@ static int get_dimm_config(const struct
 {
 	struct sbridge_pvt *pvt = mci->pvt_info;
 	struct csrow_info *csr;
-	int i, j, banks, ranks, rows, cols, size, npages;
+	unsigned i, j, banks, ranks, rows, cols, npages;
+	u64 size;
 	int csrow = 0;
 	unsigned long last_page = 0;
 	u32 reg;
@@ -627,10 +628,10 @@ static int get_dimm_config(const struct
 				cols = numcol(mtr);
 
 				/* DDR3 has 8 I/O banks */
-				size = (rows * cols * banks * ranks) >> (20 - 3);
+				size = ((u64)rows * cols * banks * ranks) >> (20 - 3);
 				npages = MiB_TO_PAGES(size);
 
-				debugf0("mc#%d: channel %d, dimm %d, %d Mb (%d pages) bank: %d, rank: %d, row: %#x, col: %#x\n",
+				debugf0("mc#%d: channel %d, dimm %d, %Ld Mb (%d pages) bank: %d, rank: %d, row: %#x, col: %#x\n",
 					pvt->sbridge_dev->mc, i, j,
 					size, npages,
 					banks, ranks, rows, cols);


