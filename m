Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab3EPIL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 04:11:26 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:23325 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab3EPILV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 04:11:21 -0400
Date: Thu, 16 May 2013 11:11:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] pktcdvd: silence static checker warning
Message-ID: <20130516081108.GC7494@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Static checkers complain about widening the binary "not" operations here
because sectors are u64 and "(pd)->settings.size" is unsigned int.
It unintentionally clears the high 32 bits of the sector.  This means
that the driver won't work for devices with over 2TB of space.  Since
this is a DVD drive, we're unlikely to reach that limit, but we may as
well silence the warning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 898fa74..09142c4 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -83,7 +83,8 @@
 
 #define MAX_SPEED 0xffff
 
-#define ZONE(sector, pd) (((sector) + (pd)->offset) & ~((pd)->settings.size - 1))
+#define ZONE(sector, pd) (((sector) + (pd)->offset) & \
+			~(sector_t)((pd)->settings.size - 1))
 
 static DEFINE_MUTEX(pktcdvd_mutex);
 static struct pktcdvd_device *pkt_devs[MAX_WRITERS];
