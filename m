Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbbA1CCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:02:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760038AbbA1BiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 3.14 21/77] can: dev: fix crtlmode_supported check
Date: Tue, 27 Jan 2015 17:26:59 -0800
Message-Id: <20150128012746.597397053@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 9b1087aa5e86448fe6ad40a58964e35f3ba423d5 upstream.

When changing flags in the CAN drivers ctrlmode the provided new content has to
be checked whether the bits are allowed to be changed. The bits that are to be
changed are given as a bitfield in cm->mask. Therefore checking against
cm->flags is wrong as the content can hold any kind of values.

The iproute2 tool sets the bits in cm->mask and cm->flags depending on the
detected command line options. To be robust against bogus user space
applications additionally sanitize the provided flags with the provided mask.

Cc: Wolfgang Grandegger <wg@grandegger.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/net/can/dev.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -664,10 +664,14 @@ static int can_changelink(struct net_dev
 		if (dev->flags & IFF_UP)
 			return -EBUSY;
 		cm = nla_data(data[IFLA_CAN_CTRLMODE]);
-		if (cm->flags & ~priv->ctrlmode_supported)
+
+		/* check whether changed bits are allowed to be modified */
+		if (cm->mask & ~priv->ctrlmode_supported)
 			return -EOPNOTSUPP;
+
+		/* clear bits to be modified and copy the flag values */
 		priv->ctrlmode &= ~cm->mask;
-		priv->ctrlmode |= cm->flags;
+		priv->ctrlmode |= (cm->flags & cm->mask);
 	}
 
 	if (data[IFLA_CAN_RESTART_MS]) {


