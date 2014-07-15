Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbaGOVaC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:30:02 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:34637 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320AbaGOVaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:30:00 -0400
Date: Wed, 16 Jul 2014 02:59:53 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] saa7164-dvb: Remove unnecessary null test
Message-ID: <20140715212953.GA28003@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the null test on dvb. dvb is initialized at the
beginning of the function to &port->dvb. Since port is dereferenced
prior to the null test, port must be a valid pointer, and
&port->dvb cannot be null.

The following Coccinelle script is used for detecting the change:

@r@
expression e,f;
identifier g,y;
statement S1,S2;
@@

*e = &f->g
<+...
 f->y
 ...+>
*if (e != NULL || ...)
 S1 else S2

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/media/pci/saa7164/saa7164-dvb.c | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-dvb.c b/drivers/media/pci/saa7164/saa7164-dvb.c
index 5c5cc3e..16ae715 100644
--- a/drivers/media/pci/saa7164/saa7164-dvb.c
+++ b/drivers/media/pci/saa7164/saa7164-dvb.c
@@ -242,16 +242,14 @@ static int saa7164_dvb_start_feed(struct dvb_demux_feed *feed)
 	if (!demux->dmx.frontend)
 		return -EINVAL;
 
-	if (dvb) {
-		mutex_lock(&dvb->lock);
-		if (dvb->feeding++ == 0) {
-			/* Start transport */
-			ret = saa7164_dvb_start_port(port);
-		}
-		mutex_unlock(&dvb->lock);
-		dprintk(DBGLVL_DVB, "%s(port=%d) now feeding = %d\n",
-			__func__, port->nr, dvb->feeding);
+	mutex_lock(&dvb->lock);
+	if (dvb->feeding++ == 0) {
+		/* Start transport */
+		ret = saa7164_dvb_start_port(port);
 	}
+	mutex_unlock(&dvb->lock);
+	dprintk(DBGLVL_DVB, "%s(port=%d) now feeding = %d\n",
+		__func__, port->nr, dvb->feeding);
 
 	return ret;
 }
@@ -266,16 +264,14 @@ static int saa7164_dvb_stop_feed(struct dvb_demux_feed *feed)
 
 	dprintk(DBGLVL_DVB, "%s(port=%d)\n", __func__, port->nr);
 
-	if (dvb) {
-		mutex_lock(&dvb->lock);
-		if (--dvb->feeding == 0) {
-			/* Stop transport */
-			ret = saa7164_dvb_stop_streaming(port);
-		}
-		mutex_unlock(&dvb->lock);
-		dprintk(DBGLVL_DVB, "%s(port=%d) now feeding = %d\n",
-			__func__, port->nr, dvb->feeding);
+	mutex_lock(&dvb->lock);
+	if (--dvb->feeding == 0) {
+		/* Stop transport */
+		ret = saa7164_dvb_stop_streaming(port);
 	}
+	mutex_unlock(&dvb->lock);
+	dprintk(DBGLVL_DVB, "%s(port=%d) now feeding = %d\n",
+		__func__, port->nr, dvb->feeding);
 
 	return ret;
 }
-- 
1.9.1

