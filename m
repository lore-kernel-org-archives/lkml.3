Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab3FDJvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:51:35 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54071 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab3FDJvd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:51:33 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: Kevin Hilman <khilman@linaro.org>
CC: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>,
        "Rajashekhara, Sudhakar" <sudhakar.raj@ti.com>,
        Tony Lindgren <tony@atomide.com>, Wolfram Sang <wsa@the-dreams.de>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: RE: [PATCH 11/11] i2c: omap: enhance pinctrl support
Thread-Topic: [PATCH 11/11] i2c: omap: enhance pinctrl support
Thread-Index: AQHOXimmVxfgXGT07Eyasoe5jzaNzZklVYTg
Date: Tue, 4 Jun 2013 09:50:49 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EC22349@DBDE04.ent.ti.com>
References: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
	<1369995191-20855-12-git-send-email-gururaja.hebbar@ti.com>
 <87bo7r10s9.fsf@linaro.org>
In-Reply-To: <87bo7r10s9.fsf@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 23:37:02, Kevin Hilman wrote:
> +Linus Walleij (pinctrl maintainer)
> 
> Hebbar Gururaja <gururaja.hebbar@ti.com> writes:
> 
> > Amend the I2C omap pin controller to optionally take a pin control
> > handle and set the state of the pins to:
> >
> > - "default" on boot, resume and before performing an i2c transfer
> > - "idle" after initial default, after resume default, and after each
> > i2c xfer
> > - "sleep" on suspend()
> >
> > By optionally putting the pins into sleep state in the suspend callback
> > we can accomplish two things.
> > - One is to minimize current leakage from pins and thus save power,
> > - second, we can prevent the IP from driving pins output in an
> > uncontrolled manner, which may happen if the power domain drops the
> > domain regulator.
> >
> > Note:
> > A .suspend & .resume callback is added which simply puts the pins to sleep
> > state upon suspend & are moved to default & idle state upon resume.
> >
> > If any of the above pin states are missing in dt, a warning message
> > about the missing state is displayed.
> > If certain pin-states are not available, to remove this warning message
> > pass respective state name with null phandler.
> >
> > (Changes based on i2c-nomadik.c)
> >
> > Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
> > Cc: Tony Lindgren <tony@atomide.com>
> > Cc: Wolfram Sang <wsa@the-dreams.de>
> > Cc: linux-omap@vger.kernel.org
> > Cc: linux-i2c@vger.kernel.org
> 
> [...]
> 
> > @@ -1123,14 +1138,47 @@ omap_i2c_probe(struct platform_device *pdev)
> >  		dev->set_mpu_wkup_lat = pdata->set_mpu_wkup_lat;
> >  	}
> >  
> > -	dev->pins = devm_pinctrl_get_select_default(&pdev->dev);
> > -	if (IS_ERR(dev->pins)) {
> > -		if (PTR_ERR(dev->pins) == -EPROBE_DEFER)
> > +	dev->pinctrl = devm_pinctrl_get(&pdev->dev);
> > +	if (!IS_ERR(dev->pinctrl)) {
> > +		dev->pins_default = pinctrl_lookup_state(dev->pinctrl,
> > +							 PINCTRL_STATE_DEFAULT);
> 
> This part is already done by probe in driver core, why does it need to
> be done again.  dev->pins->default_state should already have this.
> (c.f. pinctrl_bind_pins() in drivers/base/pinctrl.c)
> 
> But that brings up a bigger question about whether or not we should be
> doing the rest of this (idle/sleep) pin management in the drivers or in
> the driver core as well.  I would much prefer it be handled by the
> driver core.
> 
> In fact, since these are all PM related events, it should probably be
> handled by the PM core and seems pretty straight forward to do so.

Let me pull out some info about these and come back

> 
> Kevin
> 


Regards, 
Gururaja
