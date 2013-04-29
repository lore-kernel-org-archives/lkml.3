Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760125Ab3D2Te2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:34:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759552Ab3D2TCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:02:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Greear <greearb@candelatech.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 37/42] net: rate-limit warn-bad-offload splats.
Date: Mon, 29 Apr 2013 12:02:19 -0700
Message-Id: <20130429184756.565350049@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184752.435249613@linuxfoundation.org>
References: <20130429184752.435249613@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Ben Greear <greearb@candelatech.com>

[ Upstream commit c846ad9b880ece01bb4d8d07ba917734edf0324f ]

If one does do something unfortunate and allow a
bad offload bug into the kernel, this the
skb_warn_bad_offload can effectively live-lock the
system, filling the logs with the same error over
and over.

Add rate limitation to this so that box remains otherwise
functional in this case.

Signed-off-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2018,6 +2018,9 @@ static void skb_warn_bad_offload(const s
 	struct net_device *dev = skb->dev;
 	const char *driver = "";
 
+	if (!net_ratelimit())
+		return;
+
 	if (dev && dev->dev.parent)
 		driver = dev_driver_string(dev->dev.parent);
 


