Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaKIPwL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 10:52:11 -0500
Received: from mout.gmx.net ([212.227.17.20]:61752 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaKIPwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 10:52:09 -0500
Date: Sun, 9 Nov 2014 16:51:42 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Philipp Zabel <pza@pengutronix.de>
cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, kernel@pengutronix.de
Subject: Re: [PATCH v5 1/6] of: Decrement refcount of previous endpoint in
 of_graph_get_next_endpoint
In-Reply-To: <20141109153644.GA3132@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1411091651210.17370@axis700.grange>
References: <1412013819-29181-1-git-send-email-p.zabel@pengutronix.de>
 <1412013819-29181-2-git-send-email-p.zabel@pengutronix.de>
 <Pine.LNX.4.64.1411072255130.4252@axis700.grange> <20141109153644.GA3132@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V03:K0:A3KmNYQEp2gDLv0iFxaqu9983Qf7kr8lzfTPIjmfAYELKs4y4hQ
 jbQ53Zdbukom9X/UInHSSoxu/DH80+2i+qgCP5tOk2PG3re2oszvOXX5oahzXEZ2w4v+WSI
 lg9+sohUw+8zjxf8wmAHgRuHLkJJLDl0vi22V/EmMKv4ANHeGaDQaRUmREuX2hO+bAzcGbY
 QUyGJ+2g7md7rbUXqi8Yg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Nov 2014, Philipp Zabel wrote:

> Hi Guennadi,
> 
> On Fri, Nov 07, 2014 at 11:06:21PM +0100, Guennadi Liakhovetski wrote:
> > Hi Philipp,
> > 
> > Thanks for the patch and sorry for a late reply. I did look at your 
> > patches earlier too, but maybe not attentively enough, or maybe I'm 
> > misunderstanding something now. In the scan_of_host() function in 
> > soc_camera.c as of current -next I see:
> > 
> > 		epn = of_graph_get_next_endpoint(np, epn);
> > 
> > which already looks like a refcount leak to me. If epn != NULL, its 
> > refcount is incremented, but then immediately the variable gets 
> > overwritten, and there's no extra copy of that variable to fix this. If 
> > I'm right, then that bug in itself should be fixed, ideally before your 
> > patch is applied. But in fact, your patch fixes this, since it modifies 
> > of_graph_get_next_endpoint() to return with prev's refcount not 
> > incremented, right? Whereas the of_node_put(epn) later down in 
> > scan_of_host() decrements refcount of the _next_ endpoint, not the 
> > previous one, so, it should be left alone? I.e. AFAICT your modification 
> > to of_graph_get_next_endpoint() fixes soc_camera.c with no further 
> > modifications to it required?
> 
> You are right. With the old implementation, you'd have to do the
> epn = of_graph_get_next_endpoint(np, prev); of_node_put(prev); prev = epn;
> dance to avoid leaking a reference to the first endpoint. This series
> accidentally fixes soc_camera by changing of_graph_get_next_endpoint
> to decrement the reference count itself.

Right, so, the patch has to be adjusted not to touch soc_camera.c at all.

Thanks
Guennadi

> 
> regards
> Philipp
> 
