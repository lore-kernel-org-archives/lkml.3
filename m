Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbbAUPby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:31:54 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52029 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbbAUPbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:31:47 -0500
Date: Wed, 21 Jan 2015 16:31:31 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Eddie Huang <eddie.huang@mediatek.com>,
        Mark Rutland <mark.rutland@arm.com>, Wolfram Sang <wsa@the-dreams.de>,
        Andrew Bresticker <abrestic@chromium.org>,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, Jean Delvare <jdelvare@suse.de>,
        Xudong Chen <xudong.chen@mediatek.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, yh.chen@mediatek.com,
        Wei Yan <sledge.yanwei@huawei.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Neelesh Gupta <neelegup@linux.vnet.ibm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org, srv_heupstream@mediatek.com,
        Anders Berg <anders.berg@avagotech.com>,
        Jim Cromie <jim.cromie@gmail.com>, Simon Glass <sjg@chromium.org>,
        Max Schwarz <max.schwarz@online.de>,
        Doug Anderson <dianders@chromium.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v4 2/2] I2C: mediatek: Add driver for MediaTek I2C
 controller
Message-ID: <20150121153131.GV22880@pengutronix.de>
References: <1421404418-50718-1-git-send-email-eddie.huang@mediatek.com>
 <1421404418-50718-3-git-send-email-eddie.huang@mediatek.com>
 <20150118101816.GF22880@pengutronix.de>
 <1421810004.15468.825.camel@mtksdaap41>
 <1421821809.11671.117.camel@mtksdaap41>
 <20150121081519.GS22880@pengutronix.de>
 <1421844580.11671.145.camel@mtksdaap41>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1421844580.11671.145.camel@mtksdaap41>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 21, 2015 at 08:49:40PM +0800, Yingjoe Chen wrote:
> On Wed, 2015-01-21 at 09:15 +0100, Uwe Kleine-König wrote:
> > On Wed, Jan 21, 2015 at 02:30:09PM +0800, Yingjoe Chen wrote:
> > > On Wed, 2015-01-21 at 11:13 +0800, Eddie Huang wrote:
> > > <...>
> > > > > > +		ret = -EINVAL;
> > > > > > +		goto err_exit;
> > > > > > +	}
> > > > > > +
> > > > > > +	if (msgs->buf == NULL) {
> > > > > > +		dev_dbg(i2c->dev, " data buffer is NULL.\n");
> > > > > > +		ret = -EINVAL;
> > > > > > +		goto err_exit;
> > > > > > +	}
> > > > > > +
> > > > > > +	i2c->addr = msgs->addr;
> > > > > > +	i2c->msg_len = msgs->len;
> > > > > > +	i2c->msg_buf = msgs->buf;
> > > > > > +
> > > > > > +	if (msgs->flags & I2C_M_RD)
> > > > > > +		i2c->op = I2C_MASTER_RD;
> > > > > > +	else
> > > > > > +		i2c->op = I2C_MASTER_WR;
> > > > > > +
> > > > > > +	/* combined two messages into one transaction */
> > > > > > +	if (num > 1) {
> > > > > > +		i2c->msg_aux_len = (msgs + 1)->len;
> > > > > > +		i2c->op = I2C_MASTER_WRRD;
> > > > > > +	}
> > > > > This means "write then read", right? You should check here that the
> > > > > first message is really a write and the 2nd a read then.
> > > > > Can this happen at all with the quirks defined below (.max_num_msgs =
> > > > > 1)?
> > > > Yes, mean write then read. Indeed, add check is better.
> > > > If msg number is 1, means normal write or read, not "write then read".
> > > 
> > > The quirks will increase the message count and check 'write then read'
> > > for us. We don't have to add check here.
> > I have to admit I don't know that quirks stuff, so it's well possible
> > that I'm wrong here.
> >  
> > > > > > +static int mtk_i2c_remove(struct platform_device *pdev)
> > > > > > +{
> > > > > > +	struct mtk_i2c *i2c = platform_get_drvdata(pdev);
> > > > > > +
> > > > > > +	i2c_del_adapter(&i2c->adap);
> > > > > > +	free_i2c_dma_bufs(i2c);
> > > > > > +	platform_set_drvdata(pdev, NULL);
> > > > > > +
> > > > > Here you need to make sure that no irq is running when i2c_del_adapter
> > > > > is called.
> > > > OK, add check here
> > > 
> > > I thought after i2c_del_adapter() is complete, all i2c_transfer for this
> > > adapter is completed. If this is true, then i2c clock is already off and
> > > we won't have any on-going transfer/pending irq.
> > Consider that there is an ongoing transaction and before it completes
> > the adapter-device is unbound from the driver. Then i2c_del_adapter is
> > called which frees the resources managed by the core, then the device's
> > completion irq triggers and the freed adapter is used which probably
> > results in an oops.
> 
> Not sure if I missed anything. i2c_transfer() is a synchronize call. If
> we fixed timeout issue you mentioned in mtk_i2c_transfer(), it will turn
> off clock before it return, which disable any transaction and clear all
> pending irq.
There is no synchronization to prevent unbinding the i2c-bus device
while there is a i2c transfer on the wire. i2c_del_adapter only takes
i2c-core.c's &core_lock while i2c_transfer takes &adapter->bus_lock.
If you want to test for it: do something like that:

	while true; do dd if=/sys/bus/i2c/.../eeprom of=/dev/null; done

and while this is running do:

	cd /sys/bus/platform/drivers/mt-i2c
	while true; do
		echo 1100d000.i2c > unbind;
		sleep 1;
		echo 1100d000.i2c > bind;
		sleep 1;
	done
 
> Your scenario can only happens when one thread is still running in
> i2c_transfer/algo->master_xfer and the other thread is trying to remove
> the device. If that happened, then every device data access in
> mtk_i2c_transfer might cause oops. I looked at some i2c drivers and
> can't find any checking for this case, I can't find anything prevent i2c
> device removal before pending i2c_transfer complete either. Would you
> give me an example?
I just noticed that even "my" driver is affected. If the above recipe
makes your driver barf there is something to fix, if not ... hmm, then
maybe there is more synchronization than I'm aware of or my recipe is
wrong.

At least another driver author believed me:
http://thread.gmane.org/gmane.linux.drivers.i2c/21531/focus=21662

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
