Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934707AbaBDVMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:12:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57247 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932882AbaBDVLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:11:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, jidanni@jidanni.org
Subject: [PATCH 3.13 063/140] xhci: Set scatter-gather limit to avoid failed block writes.
Date: Tue,  4 Feb 2014 13:10:50 -0800
Message-Id: <20140204211038.759522948@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit f2d9b991c549f159dc9ae81f77d8206c790cbfee upstream.

Commit 35773dac5f862cb1c82ea151eba3e2f6de51ec3e "usb: xhci: Link TRB
must not occur within a USB payload burst" attempted to fix an issue
found with USB ethernet adapters, and inadvertently broke USB storage
devices.  The patch attempts to ensure that transfers never span a
segment, and rejects transfers that have more than 63 entries (or
possibly less, if some entries cross 64KB boundaries).

usb-storage limits the maximum transfer size to 120K, and we had assumed
the block layer would pass a scatter-gather list of 4K entries,
resulting in no more than 31 sglist entries:

http://marc.info/?l=linux-usb&m=138498190419312&w=2

That assumption was wrong, since we've seen the driver reject a write
that was 218 sectors long (of probably 512 bytes each):

Jan  1 07:04:49 jidanni5 kernel: [  559.624704] xhci_hcd 0000:00:14.0: Too many fragments 79, max 63
...
Jan  1 07:04:58 jidanni5 kernel: [  568.622583] Write(10): 2a 00 00 06 85 0e 00 00 da 00

Limit the number of scatter-gather entries to half a ring segment.  That
should be margin enough in case some entries cross 64KB boundaries.
Increase the number of TRBs per segment from 64 to 256, which should
result in ring segments fitting on a 4K page.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-by: jidanni@jidanni.org
References: http://bugs.debian.org/733907
Fixes: 35773dac5f86 ('usb: xhci: Link TRB must not occur within a USB payload burst')
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci.c |    4 ++--
 drivers/usb/host/xhci.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4716,8 +4716,8 @@ int xhci_gen_setup(struct usb_hcd *hcd,
 	struct device		*dev = hcd->self.controller;
 	int			retval;
 
-	/* Accept arbitrarily long scatter-gather lists */
-	hcd->self.sg_tablesize = ~0;
+	/* Limit the block layer scatter-gather lists to half a segment. */
+	hcd->self.sg_tablesize = TRBS_PER_SEGMENT / 2;
 
 	/* support to build packet from discontinuous buffers */
 	hcd->self.no_sg_constraint = 1;
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1260,7 +1260,7 @@ union xhci_trb {
  * since the command ring is 64-byte aligned.
  * It must also be greater than 16.
  */
-#define TRBS_PER_SEGMENT	64
+#define TRBS_PER_SEGMENT	256
 /* Allow two commands + a link TRB, along with any reserved command TRBs */
 #define MAX_RSVD_CMD_TRBS	(TRBS_PER_SEGMENT - 3)
 #define TRB_SEGMENT_SIZE	(TRBS_PER_SEGMENT*16)


