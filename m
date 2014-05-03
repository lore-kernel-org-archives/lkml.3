Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbaECU1X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 16:27:23 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:18737 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaECU1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 16:27:22 -0400
Date: Sat, 3 May 2014 23:27:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: David Airlie <airlied@linux.ie>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch resend] agp: info leak in agpioc_info_wrap()
Message-ID: <20140503202700.GF32753@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 64 bit systems the agp_info struct has a 4 byte hole between
->agp_mode and ->aper_base.  We need to clear it to avoid disclosing
stack information to userspace.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I sent this before on 13 Apr 2013 and a reminder on 31 May 2013 so now
I'm going to try sneak it in through the akpm tree.

diff --git a/drivers/char/agp/frontend.c b/drivers/char/agp/frontend.c
index 8121b4c..b297033 100644
--- a/drivers/char/agp/frontend.c
+++ b/drivers/char/agp/frontend.c
@@ -730,6 +730,7 @@ static int agpioc_info_wrap(struct agp_file_private *priv, void __user *arg)
 
 	agp_copy_info(agp_bridge, &kerninfo);
 
+	memset(&userinfo, 0, sizeof(userinfo));
 	userinfo.version.major = kerninfo.version.major;
 	userinfo.version.minor = kerninfo.version.minor;
 	userinfo.bridge_id = kerninfo.device->vendor |
