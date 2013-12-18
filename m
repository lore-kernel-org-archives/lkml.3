Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab3LRVN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:13:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab3LRVNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 3.12 077/118] media: af9035: unlock on error in af9035_i2c_master_xfer()
Date: Wed, 18 Dec 2013 13:11:54 -0800
Message-Id: <20131218211221.627980589@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -245,7 +245,8 @@ static int af9035_i2c_master_xfer(struct
 				dev_warn(&d->udev->dev,
 					 "%s: i2c xfer: len=%d is too big!\n",
 					 KBUILD_MODNAME, msg[0].len);
-				return -EOPNOTSUPP;
+				ret = -EOPNOTSUPP;
+				goto unlock;
 			}
 			req.mbox |= ((msg[0].addr & 0x80)  >>  3);
 			buf[0] = msg[1].len;
@@ -281,7 +282,8 @@ static int af9035_i2c_master_xfer(struct
 				dev_warn(&d->udev->dev,
 					 "%s: i2c xfer: len=%d is too big!\n",
 					 KBUILD_MODNAME, msg[0].len);
-				return -EOPNOTSUPP;
+				ret = -EOPNOTSUPP;
+				goto unlock;
 			}
 			req.mbox |= ((msg[0].addr & 0x80)  >>  3);
 			buf[0] = msg[0].len;
@@ -319,6 +321,7 @@ static int af9035_i2c_master_xfer(struct
 		ret = -EOPNOTSUPP;
 	}
 
+unlock:
 	mutex_unlock(&d->i2c_mutex);
 
 	if (ret < 0)


