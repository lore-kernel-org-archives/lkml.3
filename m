Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbaLAMfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:35:50 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47976 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbaLAMfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:35:48 -0500
Message-ID: <1417437343.4624.14.camel@pengutronix.de>
Subject: Re: [PATCH v5 1/6] of: Decrement refcount of previous endpoint in
 of_graph_get_next_endpoint
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Philipp Zabel <pza@pengutronix.de>, Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, kernel@pengutronix.de
Date: Mon, 01 Dec 2014 13:35:43 +0100
In-Reply-To: <Pine.LNX.4.64.1411091651210.17370@axis700.grange>
References: <1412013819-29181-1-git-send-email-p.zabel@pengutronix.de>
	 <1412013819-29181-2-git-send-email-p.zabel@pengutronix.de>
	 <Pine.LNX.4.64.1411072255130.4252@axis700.grange>
	 <20141109153644.GA3132@pengutronix.de>
	 <Pine.LNX.4.64.1411091651210.17370@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 09.11.2014, 16:51 +0100 schrieb Guennadi Liakhovetski:
> On Sun, 9 Nov 2014, Philipp Zabel wrote:
> 
> > Hi Guennadi,
> > 
> > On Fri, Nov 07, 2014 at 11:06:21PM +0100, Guennadi Liakhovetski wrote:
> > > Hi Philipp,
> > > 
> > > Thanks for the patch and sorry for a late reply. I did look at your 
> > > patches earlier too, but maybe not attentively enough, or maybe I'm 
> > > misunderstanding something now. In the scan_of_host() function in 
> > > soc_camera.c as of current -next I see:
> > > 
> > > 		epn = of_graph_get_next_endpoint(np, epn);
> > > 
> > > which already looks like a refcount leak to me. If epn != NULL, its 
> > > refcount is incremented, but then immediately the variable gets 
> > > overwritten, and there's no extra copy of that variable to fix this. If 
> > > I'm right, then that bug in itself should be fixed, ideally before your 
> > > patch is applied. But in fact, your patch fixes this, since it modifies 
> > > of_graph_get_next_endpoint() to return with prev's refcount not 
> > > incremented, right? Whereas the of_node_put(epn) later down in 
> > > scan_of_host() decrements refcount of the _next_ endpoint, not the 
> > > previous one, so, it should be left alone? I.e. AFAICT your modification 
> > > to of_graph_get_next_endpoint() fixes soc_camera.c with no further 
> > > modifications to it required?
> > 
> > You are right. With the old implementation, you'd have to do the
> > epn = of_graph_get_next_endpoint(np, prev); of_node_put(prev); prev = epn;
> > dance to avoid leaking a reference to the first endpoint. This series
> > accidentally fixes soc_camera by changing of_graph_get_next_endpoint
> > to decrement the reference count itself.
> 
> Right, so, the patch has to be adjusted not to touch soc_camera.c at all.

No. As of the current media-tree we still need move the of_node_put(epn)
out of the loop:

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index f4308fe..619b2d4 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1696,7 +1696,6 @@ static void scan_of_host(struct soc_camera_host *ici)
 		if (!i)
 			soc_of_bind(ici, epn, ren->parent);
 
-		of_node_put(epn);
 		of_node_put(ren);
 
 		if (i) {
@@ -1704,6 +1703,8 @@ static void scan_of_host(struct soc_camera_host *ici)
 			break;
 		}
 	}
+
+	of_node_put(epn);
 }
 
 #else

We can do this in two steps (step 1 fixing the current status quo, step
2 as part of this series). Step 1:

--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1691,11 +1691,13 @@ static void scan_of_host(struct soc_camera_host *ici)
 {
 	struct device *dev = ici->v4l2_dev.dev;
 	struct device_node *np = dev->of_node;
-	struct device_node *epn = NULL, *ren;
+	struct device_node *epn, *prev = NULL, *ren;
 	unsigned int i;
 
 	for (i = 0; ; i++) {
-		epn = of_graph_get_next_endpoint(np, epn);
+		epn = of_graph_get_next_endpoint(np, prev);
+		of_node_put(prev);
+		prev = epn;
 		if (!epn)
 			break;
 
@@ -1710,7 +1712,6 @@ static void scan_of_host(struct soc_camera_host *ici)
 		if (!i)
 			soc_of_bind(ici, epn, ren->parent);
 
-		of_node_put(epn);
 		of_node_put(ren);
 
 		if (i) {

And step 2:

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 3d44773..1de62bf 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1691,13 +1691,11 @@ static void scan_of_host(struct soc_camera_host *ici)
 {
 	struct device *dev = ici->v4l2_dev.dev;
 	struct device_node *np = dev->of_node;
-	struct device_node *epn, *prev = NULL, *ren;
+	struct device_node *epn = NULL, *ren;
 	unsigned int i;
 
 	for (i = 0; ; i++) {
-		epn = of_graph_get_next_endpoint(np, prev);
-		of_node_put(prev);
-		prev = epn;
+		epn = of_graph_get_next_endpoint(np, epn);
 		if (!epn)
 			break;
 
@@ -1719,6 +1717,8 @@ static void scan_of_host(struct soc_camera_host *ici)
 			break;
 		}
 	}
+
+	of_node_put(epn);
 }
 
 #else

Would you prefer that option?

regards
Philipp


