Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab3JXTUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 15:20:33 -0400
Received: from smtprelay0058.hostedemail.com ([216.40.44.58]:58055 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754844Ab3JXTUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 15:20:30 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:69:355:379:541:599:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:4605:5007:7652:9592:10004:10400:10848:11026:11232:11473:11658:11914:12043:12114:12296:12438
X-HE-Tag: jump54_3e3e547866742
X-Filterd-Recvd-Size: 3927
Message-ID: <1382642425.22433.79.camel@joe-AO722>
Subject: Re: [PATCH 4/8] input: Remove OOM message after
 input_allocate_device
From: Joe Perches <joe@perches.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Wan ZongShun <mcuos.com@gmail.com>,
        Andrey Moiseev <o2g.org.ru@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Josh Wu <josh.wu@atmel.com>,
        Ferruh Yigit <fery@cypress.com>, Pau Oliva Fora <pof@eslack.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-input@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Date: Thu, 24 Oct 2013 12:20:25 -0700
In-Reply-To: <20131024191032.GA5553@core.coreip.homeip.net>
References: <cover.1382555436.git.joe@perches.com>
	 <cc5e6a317bc9ef33cfdfae3ed9d3a47b5319a47b.1382555436.git.joe@perches.com>
	 <20131024183707.GA5281@core.coreip.homeip.net>
	 <1382640339.22433.73.camel@joe-AO722>
	 <20131024191032.GA5553@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-24 at 12:10 -0700, Dmitry Torokhov wrote:
> On Thu, Oct 24, 2013 at 11:45:39AM -0700, Joe Perches wrote:
> > On Thu, 2013-10-24 at 11:37 -0700, Dmitry Torokhov wrote:
> > > Hi Joe,
> > > 
> > > On Wed, Oct 23, 2013 at 12:14:50PM -0700, Joe Perches wrote:
> > > > Emitting an OOM message isn't necessary after input_allocate_device
> > > > as there's a generic OOM and a dump_stack already done.
> > > 
> > > No, please don't. The kzalloc may get changed in the future to not dump
> > > stack (that was added originally because not everyone was handling OOM
> > > properly, right?), input core might get changed to use something else
> > > than kzalloc, etc, etc.
> > > 
> > > The majority of errors use dev_err so we also get idea what device
> > > failed (if there are several), and more.
> > 
> > I think that's not valuable as input_allocate_device already has
> > dozens of locations that don't emit a specific OOM and centralizing
> > the location for any generic message would work anyway.
> 
> Not having diagnostic messages in some of the drivers is hardly a
> justification to remove them from everywhere else.

But standardization is.

If a diagnostic message is really desired
without the already existing dump_stack(),
it's a small matter of adding something like:

 drivers/input/input.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index c044699..98570c2 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1736,19 +1736,23 @@ struct input_dev *input_allocate_device(void)
 {
 	struct input_dev *dev;
 
-	dev = kzalloc(sizeof(struct input_dev), GFP_KERNEL);
-	if (dev) {
-		dev->dev.type = &input_dev_type;
-		dev->dev.class = &input_class;
-		device_initialize(&dev->dev);
-		mutex_init(&dev->mutex);
-		spin_lock_init(&dev->event_lock);
-		INIT_LIST_HEAD(&dev->h_list);
-		INIT_LIST_HEAD(&dev->node);
-
-		__module_get(THIS_MODULE);
+	dev = kzalloc(sizeof(struct input_dev), GFP_KERNEL | __GFP_NOWARN);
+	if (!dev) {
+		pr_err("%pf: input_allocate_device failed\n",
+		       __builtin_return_address(1));
+		return NULL;
 	}
 
+	dev->dev.type = &input_dev_type;
+	dev->dev.class = &input_class;
+	device_initialize(&dev->dev);
+	mutex_init(&dev->mutex);
+	spin_lock_init(&dev->event_lock);
+	INIT_LIST_HEAD(&dev->h_list);
+	INIT_LIST_HEAD(&dev->node);
+
+	__module_get(THIS_MODULE);
+
 	return dev;
 }
 EXPORT_SYMBOL(input_allocate_device);



