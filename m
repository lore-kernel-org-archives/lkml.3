Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbaANAtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:49:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbaANA2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:28:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wenliang Fan <fanwlexca@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 24/77] drivers/net/hamradio: Integer overflow in hdlcdrv_ioctl()
Date: Mon, 13 Jan 2014 16:27:45 -0800
Message-Id: <20140114002753.193854889@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002752.497010554@linuxfoundation.org>
References: <20140114002752.497010554@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenliang Fan <fanwlexca@gmail.com>

[ Upstream commit e9db5c21d3646a6454fcd04938dd215ac3ab620a ]

The local variable 'bi' comes from userspace. If userspace passed a
large number to 'bi.data.calibrate', there would be an integer overflow
in the following line:
	s->hdlctx.calibrate = bi.data.calibrate * s->par.bitrate / 16;

Signed-off-by: Wenliang Fan <fanwlexca@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hamradio/hdlcdrv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/hamradio/hdlcdrv.c
+++ b/drivers/net/hamradio/hdlcdrv.c
@@ -571,6 +571,8 @@ static int hdlcdrv_ioctl(struct net_devi
 	case HDLCDRVCTL_CALIBRATE:
 		if(!capable(CAP_SYS_RAWIO))
 			return -EPERM;
+		if (bi.data.calibrate > INT_MAX / s->par.bitrate)
+			return -EINVAL;
 		s->hdlctx.calibrate = bi.data.calibrate * s->par.bitrate / 16;
 		return 0;
 


