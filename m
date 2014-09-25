Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaIYHk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:40:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42541 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaIYHk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:40:56 -0400
Message-ID: <1411630851.5671.2.camel@pengutronix.de>
Subject: Re: [PATCH v3 1/8] [media] soc_camera: Do not decrement endpoint
 node refcount in the loop
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, kernel@pengutronix.de
Date: Thu, 25 Sep 2014 09:40:51 +0200
In-Reply-To: <Pine.LNX.4.64.1409200923160.21175@axis700.grange>
References: <1410449587-1677-1-git-send-email-p.zabel@pengutronix.de>
	 <1410449587-1677-2-git-send-email-p.zabel@pengutronix.de>
	 <Pine.LNX.4.64.1409200923160.21175@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

Am Samstag, den 20.09.2014, 09:24 +0200 schrieb Guennadi Liakhovetski:
> Hi Philippe,
> 
> On Thu, 11 Sep 2014, Philipp Zabel wrote:
> 
> > In preparation for a following patch, stop decrementing the endpoint node
> > refcount in the loop. This temporarily leaks a reference to the endpoint node,
> > which will be fixed by having of_graph_get_next_endpoint decrement the refcount
> > of its prev argument instead.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/media/platform/soc_camera/soc_camera.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> > index f4308fe..f752489 100644
> > --- a/drivers/media/platform/soc_camera/soc_camera.c
> > +++ b/drivers/media/platform/soc_camera/soc_camera.c
> > @@ -1696,11 +1696,11 @@ static void scan_of_host(struct soc_camera_host *ici)
> >  		if (!i)
> >  			soc_of_bind(ici, epn, ren->parent);
> >  
> > -		of_node_put(epn);
> >  		of_node_put(ren);
> >  
> >  		if (i) {
> >  			dev_err(dev, "multiple subdevices aren't supported yet!\n");
> > +			of_node_put(epn);
> 
> Sorry, this doesn't look right to me. I think you want to drop the last 
> reference _after_ the loop, not in this temporary check for multiple 
> endpoints, which your patch has nothing to do with.

Since we only ever break out of the loop here or if epn == NULL, it
won't make a difference. Would you prefer this:

--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1696,7 +1696,6 @@ static void scan_of_host(struct soc_camera_host *ici)
                if (!i)
                        soc_of_bind(ici, epn, ren->parent);
 
-               of_node_put(epn);
                of_node_put(ren);
 
                if (i) {
@@ -1704,6 +1703,8 @@ static void scan_of_host(struct soc_camera_host *ici)
                        break;
                }
        }
+
+       of_node_put(epn);
 }
 
 #else


regards
Philipp

