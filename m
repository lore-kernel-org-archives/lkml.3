Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab3DMJQj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 05:16:39 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40531 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab3DMJQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 05:16:38 -0400
Date: Sat, 13 Apr 2013 12:16:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: David Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] agp: info leak in agpioc_info_wrap()
Message-ID: <20130413091611.GA11215@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 64 bit systems the agp_info struct has a hole between ->agp_mode and
->aper_base.  We need to clear it to avoid leaking stack information to
userspace.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/char/agp/frontend.c b/drivers/char/agp/frontend.c
index 2e04433..3fbce33 100644
--- a/drivers/char/agp/frontend.c
+++ b/drivers/char/agp/frontend.c
@@ -729,6 +729,7 @@ static int agpioc_info_wrap(struct agp_file_private *priv, void __user *arg)
 
 	agp_copy_info(agp_bridge, &kerninfo);
 
+	memset(&userinfo, 0, sizeof(userinfo));
 	userinfo.version.major = kerninfo.version.major;
 	userinfo.version.minor = kerninfo.version.minor;
 	userinfo.bridge_id = kerninfo.device->vendor |
