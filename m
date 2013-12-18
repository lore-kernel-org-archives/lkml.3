Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab3LRV7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:59:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36097 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab3LRVMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:12:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 3.10 55/78] media: af9035: unlock on error in af9035_i2c_master_xfer()
Date: Wed, 18 Dec 2013 13:11:23 -0800
Message-Id: <20131218211113.448701115@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211111.903835960@linuxfoundation.org>
References: <20131218211111.903835960@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 3189ef0290dcc9f44782672fade35847cb30da00 upstream.

We introduced a couple new error paths which are missing unlocks.
Fixes: 7760e148350b ('[media] af9035: Don't use dynamic static allocation')

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/dvb-usb-v2/af9035.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -244,7 +244,8 @@ static int af9035_i2c_master_xfer(struct
 				dev_warn(&d->udev->dev,
 					 "%s: i2c xfer: len=%d is too big!\n",
 					 KBUILD_MODNAME, msg[0].len);
-				return -EOPNOTSUPP;
+				ret = -EOPNOTSUPP;
+				goto unlock;
 			}
 			req.mbox |= ((msg[0].addr & 0x80)  >>  3);
 			buf[0] = msg[1].len;
@@ -280,7 +281,8 @@ static int af9035_i2c_master_xfer(struct
 				dev_warn(&d->udev->dev,
 					 "%s: i2c xfer: len=%d is too big!\n",
 					 KBUILD_MODNAME, msg[0].len);
-				return -EOPNOTSUPP;
+				ret = -EOPNOTSUPP;
+				goto unlock;
 			}
 			req.mbox |= ((msg[0].addr & 0x80)  >>  3);
 			buf[0] = msg[0].len;
@@ -300,6 +302,7 @@ static int af9035_i2c_master_xfer(struct
 		ret = -EOPNOTSUPP;
 	}
 
+unlock:
 	mutex_unlock(&d->i2c_mutex);
 
 	if (ret < 0)


