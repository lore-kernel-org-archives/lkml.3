Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbaEDQCc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:02:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36640 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbaEDPmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nico Golde <nico@ngolde.de>, Fabian Yamaguchi <fabs@goesec.de>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.10 47/86] IB/ipath: Fix potential buffer overrun in sending diag packet routine
Date: Sun,  4 May 2014 11:41:22 -0400
Message-Id: <20140504154146.806265851@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154140.444932005@linuxfoundation.org>
References: <20140504154140.444932005@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dennis Dalessandro <dennis.dalessandro@intel.com>

commit a2cb0eb8a64adb29a99fd864013de957028f36ae upstream.

Guard against a potential buffer overrun.  The size to read from the
user is passed in, and due to the padding that needs to be taken into
account, as well as the place holder for the ICRC it is possible to
overflow the 32bit value which would cause more data to be copied from
user space than is allocated in the buffer.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/ipath/ipath_diag.c |   66 +++++++++++--------------------
 1 file changed, 25 insertions(+), 41 deletions(-)

--- a/drivers/infiniband/hw/ipath/ipath_diag.c
+++ b/drivers/infiniband/hw/ipath/ipath_diag.c
@@ -326,7 +326,7 @@ static ssize_t ipath_diagpkt_write(struc
 				   size_t count, loff_t *off)
 {
 	u32 __iomem *piobuf;
-	u32 plen, clen, pbufn;
+	u32 plen, pbufn, maxlen_reserve;
 	struct ipath_diag_pkt odp;
 	struct ipath_diag_xpkt dp;
 	u32 *tmpbuf = NULL;
@@ -335,51 +335,29 @@ static ssize_t ipath_diagpkt_write(struc
 	u64 val;
 	u32 l_state, lt_state; /* LinkState, LinkTrainingState */
 
-	if (count < sizeof(odp)) {
-		ret = -EINVAL;
-		goto bail;
-	}
 
 	if (count == sizeof(dp)) {
 		if (copy_from_user(&dp, data, sizeof(dp))) {
 			ret = -EFAULT;
 			goto bail;
 		}
-	} else if (copy_from_user(&odp, data, sizeof(odp))) {
-		ret = -EFAULT;
+	} else if (count == sizeof(odp)) {
+		if (copy_from_user(&odp, data, sizeof(odp))) {
+			ret = -EFAULT;
+			goto bail;
+		}
+	} else {
+		ret = -EINVAL;
 		goto bail;
 	}
 
-	/*
-	 * Due to padding/alignment issues (lessened with new struct)
-	 * the old and new structs are the same length. We need to
-	 * disambiguate them, which we can do because odp.len has never
-	 * been less than the total of LRH+BTH+DETH so far, while
-	 * dp.unit (same offset) unit is unlikely to get that high.
-	 * Similarly, dp.data, the pointer to user at the same offset
-	 * as odp.unit, is almost certainly at least one (512byte)page
-	 * "above" NULL. The if-block below can be omitted if compatibility
-	 * between a new driver and older diagnostic code is unimportant.
-	 * compatibility the other direction (new diags, old driver) is
-	 * handled in the diagnostic code, with a warning.
-	 */
-	if (dp.unit >= 20 && dp.data < 512) {
-		/* very probable version mismatch. Fix it up */
-		memcpy(&odp, &dp, sizeof(odp));
-		/* We got a legacy dp, copy elements to dp */
-		dp.unit = odp.unit;
-		dp.data = odp.data;
-		dp.len = odp.len;
-		dp.pbc_wd = 0; /* Indicate we need to compute PBC wd */
-	}
-
 	/* send count must be an exact number of dwords */
 	if (dp.len & 3) {
 		ret = -EINVAL;
 		goto bail;
 	}
 
-	clen = dp.len >> 2;
+	plen = dp.len >> 2;
 
 	dd = ipath_lookup(dp.unit);
 	if (!dd || !(dd->ipath_flags & IPATH_PRESENT) ||
@@ -422,16 +400,22 @@ static ssize_t ipath_diagpkt_write(struc
 		goto bail;
 	}
 
-	/* need total length before first word written */
-	/* +1 word is for the qword padding */
-	plen = sizeof(u32) + dp.len;
-
-	if ((plen + 4) > dd->ipath_ibmaxlen) {
+	/*
+	 * need total length before first word written, plus 2 Dwords. One Dword
+	 * is for padding so we get the full user data when not aligned on
+	 * a word boundary. The other Dword is to make sure we have room for the
+	 * ICRC which gets tacked on later.
+	 */
+	maxlen_reserve = 2 * sizeof(u32);
+	if (dp.len > dd->ipath_ibmaxlen - maxlen_reserve) {
 		ipath_dbg("Pkt len 0x%x > ibmaxlen %x\n",
-			  plen - 4, dd->ipath_ibmaxlen);
+			  dp.len, dd->ipath_ibmaxlen);
 		ret = -EINVAL;
-		goto bail;	/* before writing pbc */
+		goto bail;
 	}
+
+	plen = sizeof(u32) + dp.len;
+
 	tmpbuf = vmalloc(plen);
 	if (!tmpbuf) {
 		dev_info(&dd->pcidev->dev, "Unable to allocate tmp buffer, "
@@ -473,11 +457,11 @@ static ssize_t ipath_diagpkt_write(struc
 	 */
 	if (dd->ipath_flags & IPATH_PIO_FLUSH_WC) {
 		ipath_flush_wc();
-		__iowrite32_copy(piobuf + 2, tmpbuf, clen - 1);
+		__iowrite32_copy(piobuf + 2, tmpbuf, plen - 1);
 		ipath_flush_wc();
-		__raw_writel(tmpbuf[clen - 1], piobuf + clen + 1);
+		__raw_writel(tmpbuf[plen - 1], piobuf + plen + 1);
 	} else
-		__iowrite32_copy(piobuf + 2, tmpbuf, clen);
+		__iowrite32_copy(piobuf + 2, tmpbuf, plen);
 
 	ipath_flush_wc();
 


