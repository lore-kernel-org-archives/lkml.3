Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab3BNHRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 02:17:00 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:9684 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab3BNHQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 02:16:58 -0500
Date: Thu, 14 Feb 2013 08:15:58 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Doug Anderson <dianders@chromium.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Simon Glass <sjg@chromium.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Yuvaraj Kumar <yuvaraj.cd@gmail.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, u.kleine-koenig@pengutronix.de,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Girish Shivananjappa <girish.shivananjappa@linaro.org>,
        bhushan.r@samsung.com, sreekumar.c@samsung.com,
        Prashanth G <prashanth.g@samsung.com>, Olof Johansson <olof@lixom.net>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Grant Grundler <grundler@chromium.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Guenter Roeck <linux@roeck-us.net>,
        David Daney <david.daney@cavium.com>, Axel Lin <axel.lin@gmail.com>,
        Stephen Warren <swarren@nvidia.com>, Barry Song <baohua.song@csr.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 4/4] i2c-mux: i2c_add_mux_adapter() should use -1 for
  auto bus num
Message-ID: <20130214081558.5e3d636e@endymion.delvare>
In-Reply-To: <511C00F4.4080708@wwwdotorg.org>
References: <1360778532-7480-1-git-send-email-dianders@chromium.org>
	<1360778532-7480-4-git-send-email-dianders@chromium.org>
	<511C00F4.4080708@wwwdotorg.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2013 14:09:08 -0700, Stephen Warren wrote:
> On 02/13/2013 11:02 AM, Doug Anderson wrote:
> > The force_nr parameter to i2c_add_mux_adapter() uses 0 to signify that
> > we don't want to force the bus number of the adapter.  This is
> > non-ideal because:
> > * 0 is actually a valid bus number to request
> > * i2c_add_numbered_adapter() (which i2c_add_mux_adapter() calls) uses
> >   -1 to mean the same thing.  That means extra logic in
> >   i2c_add_mux_adapter().
> > 
> > Fix i2c_add_mux_adapter() to use -1 and update all mux drivers
> > accordingly.
> > 
> > Signed-off-by: Doug Anderson <dianders@chromium.org>
> > ---
> > Notes:
> > - If there's a good reason that force_nr uses 0 for auto then feel
> >   free to drop this patch.  I've place it at the end of the series to
> >   make it easy to just drop it.
> 
> IIRC (and I only vaguely do...) it's because:
> 
> > diff --git a/drivers/i2c/muxes/i2c-mux-gpio.c b/drivers/i2c/muxes/i2c-mux-gpio.c
> > index 9f50ef0..301ed0b 100644
> > --- a/drivers/i2c/muxes/i2c-mux-gpio.c
> > +++ b/drivers/i2c/muxes/i2c-mux-gpio.c
> > @@ -208,7 +208,7 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
> >  	}
> >  
> >  	for (i = 0; i < mux->data.n_values; i++) {
> > -		u32 nr = mux->data.base_nr ? (mux->data.base_nr + i) : 0;
> > +		int nr = mux->data.base_nr ? (mux->data.base_nr + i) : -1;
> 
> Here, mux->data.base_nr is platform data (or copied directly from it),
> and any field in a platform data struct stored in a global variable not
> explicitly initialized would be 0, hence 0 would typically mean "no
> explicit bus number desired". Since a mux can't exist without a parent
> I2C bus, it's unlikely anyone would want a mux to be I2C bus 0, but
> rather the parent to have that number.

Yes, as I recall this is exactly the reason why the current code is the
way it is.

-- 
Jean Delvare
