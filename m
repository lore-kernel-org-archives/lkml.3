Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbaC1RqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:46:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbaC1RbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:31:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.13 11/46] media: cxusb: unlock on error in cxusb_i2c_xfer()
Date: Fri, 28 Mar 2014 10:31:55 -0700
Message-Id: <20140328173136.165964130@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173134.630198216@linuxfoundation.org>
References: <20140328173134.630198216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 1cdbcc5db4e6d51ce9bb1313195167cada9aa6e9 upstream.

We recently introduced some new error paths which are missing their
unlocks.
Fixes: 64f7ef8afbf8 ('[media] cxusb: Don't use dynamic static allocation')

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/dvb-usb/cxusb.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -149,6 +149,7 @@ static int cxusb_i2c_xfer(struct i2c_ada
 			  int num)
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
+	int ret;
 	int i;
 
 	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
@@ -173,7 +174,8 @@ static int cxusb_i2c_xfer(struct i2c_ada
 			if (1 + msg[i].len > sizeof(ibuf)) {
 				warn("i2c rd: len=%d is too big!\n",
 				     msg[i].len);
-				return -EOPNOTSUPP;
+				ret = -EOPNOTSUPP;
+				goto unlock;
 			}
 			obuf[0] = 0;
 			obuf[1] = msg[i].len;
@@ -193,12 +195,14 @@ static int cxusb_i2c_xfer(struct i2c_ada
 			if (3 + msg[i].len > sizeof(obuf)) {
 				warn("i2c wr: len=%d is too big!\n",
 				     msg[i].len);
-				return -EOPNOTSUPP;
+				ret = -EOPNOTSUPP;
+				goto unlock;
 			}
 			if (1 + msg[i + 1].len > sizeof(ibuf)) {
 				warn("i2c rd: len=%d is too big!\n",
 				     msg[i + 1].len);
-				return -EOPNOTSUPP;
+				ret = -EOPNOTSUPP;
+				goto unlock;
 			}
 			obuf[0] = msg[i].len;
 			obuf[1] = msg[i+1].len;
@@ -223,7 +227,8 @@ static int cxusb_i2c_xfer(struct i2c_ada
 			if (2 + msg[i].len > sizeof(obuf)) {
 				warn("i2c wr: len=%d is too big!\n",
 				     msg[i].len);
-				return -EOPNOTSUPP;
+				ret = -EOPNOTSUPP;
+				goto unlock;
 			}
 			obuf[0] = msg[i].addr;
 			obuf[1] = msg[i].len;
@@ -237,8 +242,14 @@ static int cxusb_i2c_xfer(struct i2c_ada
 		}
 	}
 
+	if (i == num)
+		ret = num;
+	else
+		ret = -EREMOTEIO;
+
+unlock:
 	mutex_unlock(&d->i2c_mutex);
-	return i == num ? num : -EREMOTEIO;
+	return ret;
 }
 
 static u32 cxusb_i2c_func(struct i2c_adapter *adapter)


