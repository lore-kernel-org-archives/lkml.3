Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab3IWRor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 13:44:47 -0400
Received: from smtprelay0099.hostedemail.com ([216.40.44.99]:51478 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752684Ab3IWRoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 13:44:46 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1981:2194:2198:2199:2200:2393:2551:2553:2559:2562:2828:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3870:3871:3872:4321:5007:7556:7652:7901:7903:8531:10004:10400:10848:11026:11232:11657:11658:11914:12043:12050:12296:12438:12517:12519:12679:12740:13019:13095,0,RBL:none,CacheIP:none,Bayesian:
X-HE-Tag: goose56_293eb50a4f835
X-Filterd-Recvd-Size: 4026
Message-ID: <1379958282.3575.31.camel@joe-AO722>
Subject: Re: [PATCH v5 1/4] media: s5p-tv: Replace mxr_ macro by default dev_
From: Joe Perches <joe@perches.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        m.chehab@samsung.com, t.figa@samsung.com, kyungmin.park@samsung.com,
        s.nawrocki@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 23 Sep 2013 10:44:42 -0700
In-Reply-To: <13162989.WhfDRzW6dg@amdc1032>
References: <1379775649-6331-1-git-send-email-m.krawczuk@partner.samsung.com>
	 <1379775649-6331-2-git-send-email-m.krawczuk@partner.samsung.com>
	 <52405519.3020504@samsung.com> <13162989.WhfDRzW6dg@amdc1032>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-23 at 17:48 +0200, Bartlomiej Zolnierkiewicz wrote:
> On Monday, September 23, 2013 04:50:01 PM Tomasz Stanislawski wrote:
> > May I ask what is the rationale for this patch?
> > To reduce a few lines of code?
> This patch makes source code more generic-like and easier to follow (mxd_r*
> macros currently only obfuscate the code and make them harder to read for
> everybody, maybe besides the original driver author ;). Removal of few
> superfluous lines of code is just a bonus.

I don't see any significant issue with this change.
Using generic mechanisms is good.

Few trivial nits:

I'd remove the trailing periods from some of the messages
at the same time.

Function tracing is better done by the function tracing
mechanism built in to the kernel.  Removing the
	dev_dbg(dev, "%s: enter\n", __func__)
lines would be good too.

Maybe look at the message levels of more of these
logging messages and determine which are actually
useful and what is mostly noise and should be dev_dbg
or deleted altogether.

> > > diff --git a/drivers/media/platform/s5p-tv/mixer_drv.c b/drivers/media/platform/s5p-tv/mixer_drv.c

> > > @@ -59,7 +59,7 @@ void mxr_streamer_get(struct mxr_device *mdev)
> > >  {
> > >  	mutex_lock(&mdev->mutex);
> > >  	++mdev->n_streamer;
> > > -	mxr_dbg(mdev, "%s(%d)\n", __func__, mdev->n_streamer);
> > > +	dev_dbg(mdev->dev, "%s(%d)\n", __func__, mdev->n_streamer);

not too useful

[]

> > > @@ -159,42 +159,42 @@ static int mxr_acquire_plat_resources(struct mxr_device *mdev,
> > >  
> > >  	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mxr");
> > >  	if (res == NULL) {
> > > -		mxr_err(mdev, "get memory resource failed.\n");
> > > +		dev_err(mdev->dev, "get memory resource failed.\n");

		dev_err(mdev->dev, "get memory resource failed\n");
etc... because of:

> > > @@ -252,27 +252,27 @@ static int mxr_acquire_clocks(struct mxr_device *mdev)
> > >  
> > >  	res->mixer = clk_get(dev, "mixer");
> > >  	if (IS_ERR(res->mixer)) {
> > > -		mxr_err(mdev, "failed to get clock 'mixer'\n");
> > > +		dev_err(mdev->dev, "failed to get clock 'mixer'\n");

Mixed use of messages with/without periods.

> > > @@ -295,13 +295,13 @@ static int mxr_acquire_resources(struct mxr_device *mdev,
> > >  	if (ret)
> > >  		goto fail_plat;
> > >  
> > > -	mxr_info(mdev, "resources acquired\n");
> > > +	dev_info(mdev->dev, "resources acquired\n");

This isn't really a useful message so I'd convert it
to dev_dbg

> > > @@ -391,7 +391,6 @@ static int mxr_probe(struct platform_device *pdev)
> > >  	struct mxr_device *mdev;
> > >  	int ret;
> > >  
> > > -	/* mdev does not exist yet so no mxr_dbg is used */
> > >  	dev_info(dev, "probe start\n");

Same with a lot of these...

Maybe in a separate patch.



