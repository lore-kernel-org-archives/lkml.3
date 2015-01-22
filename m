Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbbAVBak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 20:30:40 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:48351 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751888AbbAVBab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 20:30:31 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v4 2/2] I2C: mediatek: Add driver for MediaTek I2C
 controller
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Wolfram Sang <wsa@the-dreams.de>
CC: Eddie Huang <eddie.huang@mediatek.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        <linux-kernel@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Jean Delvare <jdelvare@suse.de>,
        Xudong Chen <xudong.chen@mediatek.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, <yh.chen@mediatek.com>,
        Wei Yan <sledge.yanwei@huawei.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Neelesh Gupta <neelegup@linux.vnet.ibm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <srv_heupstream@mediatek.com>,
        Anders Berg <anders.berg@avagotech.com>,
        Jim Cromie <jim.cromie@gmail.com>, Simon Glass <sjg@chromium.org>,
        Max Schwarz <max.schwarz@online.de>,
        Doug Anderson <dianders@chromium.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20150121153131.GV22880@pengutronix.de>
References: <1421404418-50718-1-git-send-email-eddie.huang@mediatek.com>
	 <1421404418-50718-3-git-send-email-eddie.huang@mediatek.com>
	 <20150118101816.GF22880@pengutronix.de>
	 <1421810004.15468.825.camel@mtksdaap41>
	 <1421821809.11671.117.camel@mtksdaap41>
	 <20150121081519.GS22880@pengutronix.de>
	 <1421844580.11671.145.camel@mtksdaap41>
	 <20150121153131.GV22880@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jan 2015 09:30:26 +0800
Message-ID: <1421890226.5693.4.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wed, 2015-01-21 at 16:31 +0100, Uwe Kleine-König wrote:
> Hello,
> 
> On Wed, Jan 21, 2015 at 08:49:40PM +0800, Yingjoe Chen wrote:
> > On Wed, 2015-01-21 at 09:15 +0100, Uwe Kleine-König wrote:
<...>
> > > > > > > +static int mtk_i2c_remove(struct platform_device *pdev)
> > > > > > > +{
> > > > > > > +	struct mtk_i2c *i2c = platform_get_drvdata(pdev);
> > > > > > > +
> > > > > > > +	i2c_del_adapter(&i2c->adap);
> > > > > > > +	free_i2c_dma_bufs(i2c);
> > > > > > > +	platform_set_drvdata(pdev, NULL);
> > > > > > > +
> > > > > > Here you need to make sure that no irq is running when i2c_del_adapter
> > > > > > is called.
> > > > > OK, add check here
> > > > 
> > > > I thought after i2c_del_adapter() is complete, all i2c_transfer for this
> > > > adapter is completed. If this is true, then i2c clock is already off and
> > > > we won't have any on-going transfer/pending irq.
> > > Consider that there is an ongoing transaction and before it completes
> > > the adapter-device is unbound from the driver. Then i2c_del_adapter is
> > > called which frees the resources managed by the core, then the device's
> > > completion irq triggers and the freed adapter is used which probably
> > > results in an oops.
> > 
> > Not sure if I missed anything. i2c_transfer() is a synchronize call. If
> > we fixed timeout issue you mentioned in mtk_i2c_transfer(), it will turn
> > off clock before it return, which disable any transaction and clear all
> > pending irq.
> There is no synchronization to prevent unbinding the i2c-bus device
> while there is a i2c transfer on the wire. i2c_del_adapter only takes
> i2c-core.c's &core_lock while i2c_transfer takes &adapter->bus_lock.
> If you want to test for it: do something like that:
> 
> 	while true; do dd if=/sys/bus/i2c/.../eeprom of=/dev/null; done
> 
> and while this is running do:
> 
> 	cd /sys/bus/platform/drivers/mt-i2c
> 	while true; do
> 		echo 1100d000.i2c > unbind;
> 		sleep 1;
> 		echo 1100d000.i2c > bind;
> 		sleep 1;
> 	done
>  
> > Your scenario can only happens when one thread is still running in
> > i2c_transfer/algo->master_xfer and the other thread is trying to remove
> > the device. If that happened, then every device data access in
> > mtk_i2c_transfer might cause oops. I looked at some i2c drivers and
> > can't find any checking for this case, I can't find anything prevent i2c
> > device removal before pending i2c_transfer complete either. Would you
> > give me an example?
> I just noticed that even "my" driver is affected. If the above recipe
> makes your driver barf there is something to fix, if not ... hmm, then
> maybe there is more synchronization than I'm aware of or my recipe is
> wrong.
> 
> At least another driver author believed me:
> http://thread.gmane.org/gmane.linux.drivers.i2c/21531/focus=21662

If there is no synchronization mechanism then every driver is affected.
We should add the check in the core instead of fixing it in every
driver. We could take the bus_lock in i2c_del_adapter() and check if the
adapter is removed in __i2c_transfer(), this should fix the problem.

Wolfram, what do you think about this? Is there anything we are missing?

Joe.C


