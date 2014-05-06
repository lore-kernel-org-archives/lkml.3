Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaEFRhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:37:08 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:50739 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaEFRhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:37:06 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] usb: gadget: s3c-hsotg: Mark s3c_hsotg_map_dma()/s3c_hsotg_unmap_dma() inline
Date: Tue,  6 May 2014 19:37:01 +0200
Message-Id: <1399397822-351-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y, depending on the gcc version:

    drivers/built-in.o: In function `s3c_hsotg_map_dma':
    s3c-hsotg.c:(.text+0x375b2c): undefined reference to `usb_gadget_map_request'
    drivers/built-in.o: In function `s3c_hsotg_unmap_dma':
    s3c-hsotg.c:(.text+0x376a32): undefined reference to `usb_gadget_unmap_request'
    make[3]: *** [vmlinux] Error 1

The obvious fix of making USB_S3C_HSOTG depend on HAS_DMA is a bit overkill,
as DMA is never actually used. All (two) calls to s3c_hsotg_map_dma() and
s3c_hsotg_unmap_dma() are protected by a call into the using_dma() checking
function, which always returns false:

    static inline bool using_dma(struct s3c_hsotg *hsotg)
    {
            return false;   /* support is not complete */
    }

Due to the constant return value, gcc optimizes away the calls to
s3c_hsotg_map_dma() and s3c_hsotg_unmap_dma(). But some versions of gcc
(e.g. 4.1.2) still emit the functions themselves, causing link errors.

Marking s3c_hsotg_map_dma()/s3c_hsotg_unmap_dma() inline fixes this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
This replaces "[PATCH/RFC] usb: gadget: CONFIG_USB_S3C_HSOTG should depend on
HAS_DMA"

 drivers/usb/gadget/s3c-hsotg.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 2a9cb674926a..2740042228a4 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -437,9 +437,9 @@ static inline int is_ep_periodic(struct s3c_hsotg_ep *hs_ep)
  * This is the reverse of s3c_hsotg_map_dma(), called for the completion
  * of a request to ensure the buffer is ready for access by the caller.
  */
-static void s3c_hsotg_unmap_dma(struct s3c_hsotg *hsotg,
-				struct s3c_hsotg_ep *hs_ep,
-				struct s3c_hsotg_req *hs_req)
+static inline void s3c_hsotg_unmap_dma(struct s3c_hsotg *hsotg,
+				       struct s3c_hsotg_ep *hs_ep,
+				       struct s3c_hsotg_req *hs_req)
 {
 	struct usb_request *req = &hs_req->req;
 
@@ -861,9 +861,9 @@ static void s3c_hsotg_start_req(struct s3c_hsotg *hsotg,
  * DMA memory, then we map the memory and mark our request to allow us to
  * cleanup on completion.
  */
-static int s3c_hsotg_map_dma(struct s3c_hsotg *hsotg,
-			     struct s3c_hsotg_ep *hs_ep,
-			     struct usb_request *req)
+static inline int s3c_hsotg_map_dma(struct s3c_hsotg *hsotg,
+				    struct s3c_hsotg_ep *hs_ep,
+				    struct usb_request *req)
 {
 	struct s3c_hsotg_req *hs_req = our_req(req);
 	int ret;
-- 
1.7.9.5

