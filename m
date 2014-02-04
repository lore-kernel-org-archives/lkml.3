Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934068AbaBDVI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:08:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56687 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933482AbaBDVIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:08:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        jidanni@jidanni.org, Ben Hutchings <ben@decadent.org.uk>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [PATCH 3.12 062/133] xhci: Avoid infinite loop when sg urb requires too many trbs
Date: Tue,  4 Feb 2014 13:07:43 -0800
Message-Id: <20140204210738.782301870@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit d6c9ea9069af684358efedcaf2f2f687f51c58ee upstream.

Currently prepare_ring() returns -ENOMEM if the urb won't fit into a
single ring segment.  usb_sg_wait() treats this error as a temporary
condition and will keep retrying until something else goes wrong.

The number of retries should be limited in usb_sg_wait(), but also
prepare_ring() should not return an error code that suggests it might
be worth retrying.  Change it to -EINVAL.

Reported-by: jidanni@jidanni.org
References: http://bugs.debian.org/733907
Fixes: 35773dac5f86 ('usb: xhci: Link TRB must not occur within a USB payload burst')
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2964,7 +2964,7 @@ static int prepare_ring(struct xhci_hcd
 			if (num_trbs >= TRBS_PER_SEGMENT) {
 				xhci_err(xhci, "Too many fragments %d, max %d\n",
 						num_trbs, TRBS_PER_SEGMENT - 1);
-				return -ENOMEM;
+				return -EINVAL;
 			}
 
 			nop_cmd = cpu_to_le32(TRB_TYPE(TRB_TR_NOOP) |


