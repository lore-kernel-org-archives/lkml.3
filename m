Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaK3RGz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 12:06:55 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:6030 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752474AbaK3RFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 12:05:30 -0500
X-IronPort-AV: E=Sophos;i="5.07,488,1413237600"; 
   d="scan'208";a="91114608"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: dborkman@redhat.com, herbert@gondor.apana.org.au,
        kernel-janitors@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Julia Lawall <julia@diku.dk>
Subject: [PATCH 8/8] wusb: replace memset by memzero_explicit
Date: Sun, 30 Nov 2014 17:59:34 +0100
Message-Id: <1417366774-32412-9-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1417366774-32412-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1417366774-32412-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Memset on a local variable may be removed when it is called just before the
variable goes out of scope.  Using memzero_explicit defeats this
optimization.  A simplified version of the semantic patch that makes this
change is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier x;
type T;
@@

{
... when any
T x[...];
... when any
    when exists
- memset
+ memzero_explicit
  (x,
-0,
  ...)
... when != x
    when strict
}
// </smpl>

This change was suggested by Daniel Borkmann <dborkman@redhat.com>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
Daniel Borkmann suggested that these patches could go through Herbert Xu's
cryptodev tree.

 drivers/usb/wusbcore/dev-sysfs.c |    2 +-
 drivers/usb/wusbcore/security.c  |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/wusbcore/dev-sysfs.c b/drivers/usb/wusbcore/dev-sysfs.c
index 1018345..415b140 100644
--- a/drivers/usb/wusbcore/dev-sysfs.c
+++ b/drivers/usb/wusbcore/dev-sysfs.c
@@ -101,7 +101,7 @@ static ssize_t wusb_ck_store(struct device *dev,
 	if (wusbhc == NULL)
 		return -ENODEV;
 	result = wusb_dev_4way_handshake(wusbhc, usb_dev->wusb_dev, &ck);
-	memset(&ck, 0, sizeof(ck));
+	memzero_explicit(&ck, sizeof(ck));
 	wusbhc_put(wusbhc);
 	return result < 0 ? result : size;
 }
diff --git a/drivers/usb/wusbcore/security.c b/drivers/usb/wusbcore/security.c
index cc74d66..b66faaf 100644
--- a/drivers/usb/wusbcore/security.c
+++ b/drivers/usb/wusbcore/security.c
@@ -522,10 +522,10 @@ error_hs3:
 error_hs2:
 error_hs1:
 	memset(hs, 0, 3*sizeof(hs[0]));
-	memset(&keydvt_out, 0, sizeof(keydvt_out));
-	memset(&keydvt_in, 0, sizeof(keydvt_in));
-	memset(&ccm_n, 0, sizeof(ccm_n));
-	memset(mic, 0, sizeof(mic));
+	memzero_explicit(&keydvt_out, sizeof(keydvt_out));
+	memzero_explicit(&keydvt_in, sizeof(keydvt_in));
+	memzero_explicit(&ccm_n, sizeof(ccm_n));
+	memzero_explicit(mic, sizeof(mic));
 	if (result < 0)
 		wusb_dev_set_encryption(usb_dev, 0);
 error_dev_set_encryption:

