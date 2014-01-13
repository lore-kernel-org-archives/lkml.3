Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbaAMO2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:28:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51599 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbaAMO1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:27:05 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wenliang Fan <fanwlexca@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 87/96] drivers/net/hamradio: Integer overflow in hdlcdrv_ioctl()
Date: Mon, 13 Jan 2014 14:24:50 +0000
Message-Id: <1389623099-18783-88-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenliang Fan <fanwlexca@gmail.com>

commit e9db5c21d3646a6454fcd04938dd215ac3ab620a upstream.

The local variable 'bi' comes from userspace. If userspace passed a
large number to 'bi.data.calibrate', there would be an integer overflow
in the following line:
	s->hdlctx.calibrate = bi.data.calibrate * s->par.bitrate / 16;

Signed-off-by: Wenliang Fan <fanwlexca@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/hamradio/hdlcdrv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/hamradio/hdlcdrv.c b/drivers/net/hamradio/hdlcdrv.c
index a4a3516..3b3a7e0 100644
--- a/drivers/net/hamradio/hdlcdrv.c
+++ b/drivers/net/hamradio/hdlcdrv.c
@@ -571,6 +571,8 @@ static int hdlcdrv_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	case HDLCDRVCTL_CALIBRATE:
 		if(!capable(CAP_SYS_RAWIO))
 			return -EPERM;
+		if (bi.data.calibrate > INT_MAX / s->par.bitrate)
+			return -EINVAL;
 		s->hdlctx.calibrate = bi.data.calibrate * s->par.bitrate / 16;
 		return 0;
 
-- 
1.8.3.2

