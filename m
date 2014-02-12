Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbaBLIkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:40:37 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50052 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781AbaBLINt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:13:49 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Wenliang Fan" <fanwlexca@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.947630184@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 08/79] drivers/net/hamradio: Integer overflow in 
 hdlcdrv_ioctl()
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Wenliang Fan <fanwlexca@gmail.com>

[ Upstream commit e9db5c21d3646a6454fcd04938dd215ac3ab620a ]

The local variable 'bi' comes from userspace. If userspace passed a
large number to 'bi.data.calibrate', there would be an integer overflow
in the following line:
	s->hdlctx.calibrate = bi.data.calibrate * s->par.bitrate / 16;

Signed-off-by: Wenliang Fan <fanwlexca@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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
 

