Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab3FEJGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:06:20 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37379 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526Ab3FEJGR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:06:17 -0400
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
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: RE: [PATCH 11/11] i2c: omap: enhance pinctrl support
Thread-Topic: [PATCH 11/11] i2c: omap: enhance pinctrl support
Thread-Index: AQHOXiUsVxfgXGT07Eyasoe5jzaNzZkm20ig
Date: Wed, 5 Jun 2013 09:05:37 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EC2875B@DBDE04.ent.ti.com>
References: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
	<1369995191-20855-12-git-send-email-gururaja.hebbar@ti.com>
 <87k3mf2gu4.fsf@linaro.org>
In-Reply-To: <87k3mf2gu4.fsf@linaro.org>
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

On Fri, May 31, 2013 at 23:04:59, Kevin Hilman wrote:
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
> > @@ -664,7 +673,13 @@ omap_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
> >  
> >  out:
> >  	pm_runtime_mark_last_busy(dev->dev);
> > +
> >  	pm_runtime_put_autosuspend(dev->dev);
> > +	/* Optionally let pins go into idle state */
> > +	if (!IS_ERR(dev->pins_idle))
> > +		if (pinctrl_select_state(dev->pinctrl, dev->pins_idle))
> > +			dev_err(dev->dev, "could not set pins to idle state\n");
> 
> This is wrong.  You're changing the muxing before the device actually
> goes idle.  Anything you want to happen when the device actually idles
> for real has to be in runtime PM callbacks.
> 
> Looking below, I see it's already in the callbacks, so why is it here also?

Just to be double sure. Seems it is unwanted.

> 
> [...]
> 
> > @@ -1300,6 +1348,10 @@ static int omap_i2c_runtime_suspend(struct device *dev)
> >  		omap_i2c_read_reg(_dev, OMAP_I2C_STAT_REG);
> >  	}
> >  
> > +	if (!IS_ERR(_dev->pins_idle))
> > +		if (pinctrl_select_state(_dev->pinctrl, _dev->pins_idle))
> > +			dev_err(dev, "could not set pins to idle state\n");
> > +
> >  	return 0;
> >  }
> >  
> 
> Kevin
> 


Regards, 
Gururaja
