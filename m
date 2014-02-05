Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbaBEUHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:07:25 -0500
Received: from mail.windriver.com ([147.11.1.11]:55301 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155AbaBEUHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:11 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 153/213] USB: kaweth.c: use GFP_ATOMIC under spin_lock
Date: Wed, 5 Feb 2014 15:01:48 -0500
Message-ID: <1391630568-49251-154-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit e4c7f259c5be99dcfc3d98f913590663b0305bf8 upstream.

The problem is that we call this with a spin lock held.  The call tree
is:
	kaweth_start_xmit() holds kaweth->device_lock.
	-> kaweth_async_set_rx_mode()
	   -> kaweth_control()
	      -> kaweth_internal_control_msg()

The kaweth_internal_control_msg() function is only called from
kaweth_control() which used GFP_ATOMIC for its allocations.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/usb/kaweth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/kaweth.c b/drivers/net/usb/kaweth.c
index c4c334d9770f..72906eb06b0a 100644
--- a/drivers/net/usb/kaweth.c
+++ b/drivers/net/usb/kaweth.c
@@ -1317,7 +1317,7 @@ static int kaweth_internal_control_msg(struct usb_device *usb_dev,
         int retv;
         int length = 0; /* shut up GCC */
 
-        urb = usb_alloc_urb(0, GFP_NOIO);
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
         if (!urb)
                 return -ENOMEM;
 
-- 
1.8.5.2

