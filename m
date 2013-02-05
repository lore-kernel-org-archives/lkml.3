Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab3BEGhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 01:37:09 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57848 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595Ab3BEGhC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 01:37:02 -0500
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: Tony Lindgren <tony@atomide.com>, Linus Walleij <linus.walleij@linaro.org>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "hs@denx.de" <hs@denx.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH V2 1/6] pinctrl: pinctrl-single: use arch_initcall and
 module_exit
Thread-Topic: [PATCH V2 1/6] pinctrl: pinctrl-single: use arch_initcall and
 module_exit
Thread-Index: AQHN/fOatoDuxwofTUaND8395mrFe5hfx24AgAUeJgCAAACkAIAF8NDQ
Date: Tue, 5 Feb 2013 06:36:34 +0000
Message-ID: <A4887BF146CD57468F700B415D2F47015828C7@DBDE01.ent.ti.com>
References: <1359445134-13323-1-git-send-email-manishv.b@ti.com>
 <1359445134-13323-2-git-send-email-manishv.b@ti.com>
 <CACRpkdbf7TwrjfT2rhqQFGc3yh_Nt117RtzQO2y6g5Ddx5Ay_w@mail.gmail.com>
 <20130201170906.GE22517@atomide.com> <20130201171124.GF22517@atomide.com>
In-Reply-To: <20130201171124.GF22517@atomide.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 22:41:24, Tony Lindgren wrote:
> * Tony Lindgren <tony@atomide.com> [130201 09:12]:
> > * Linus Walleij <linus.walleij@linaro.org> [130129 03:03]:
> > > On Tue, Jan 29, 2013 at 8:38 AM, Vishwanathrao Badarkhe, Manish 
> > > <manishv.b@ti.com> wrote:
> > > 
> > > > Currently, I2C driver gets probed before pinctrl driver.
> > > > To achieve I2C pin muxing via pinctrl driver before I2C probe get 
> > > > called, register pinctrl driver in arch_initcall.
> > > > Also, add module_exit to unregister pinctrl driver.
> > > >
> > > > Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
> > > 
> > > So your I2C driver is not returning -EPROBE_DEFER if it cannot find 
> > > its pins?
> > > 
> > > Hm, well I can live with this, if Tony ACKs it.
> > 
> > Hmm pinctrl is before i2c in drivers/Makefile.
> > Making initcalls happen earlier and earlier is usually the wrong way 
> > to go. Sounds like there's some other issue here that needs to be 
> > fixed instead.
> 
> Let me guess: The i2c driver is wrongly set to run with arch_initcall?
>  

Hi Tony

No, Currently i2c driver is set to subsys_initcall. I have seen some
problem while using pin control grab functionality. Please see detailed
explanation as below.

Hi Linus

I am using auto grab pin control facility to do pin muxing of I2C0 
pins and seen problem as below:

Currently, probe of I2C0 driver gets called before pin control driver. 
Hence, while calling I2C0 probe because of unavailability of  
pin control node information, its probe get deferred giving following 
messages:

"i2c_davinci i2c_davinci.1: could not find pctldev for node /soc/pinmux@1c14120
/pinmux_i2c0_pins, deferring probe"

As I2C0 is in deferred list (as auto grab patch handle this), its probe 
get called once again, During this second time probe of I2C0, I have 
observed following crash:

"Unable to handle kernel paging request at virtual address fffffe07"

As per code analysis of auto grab functionality, I have seen in 
"pinctrl_bind_pin" function, pin control handle (dpi->p) is returned by 
"devm_pinctrl_get" function.

Pin control handle is assigned with error pointer during 1st time probing of 
I2C0 (as pin control information is not available at this time). 
During 2nd time probing (deferred probe) of I2C0, same pin control handle 
(which was get assigned during 1st probe) is getting used instead of getting 
updated to correct pin control handle which leads to system crash.

I made following changes, in order to update "dip->p" pointer with 
correct value:

-       if (!dpi->p) {
+       if (IS_ERR_OR_NULL(dpi->p)) {
                dpi->p = devm_pinctrl_get(dev);
-               if (IS_ERR_OR_NULL(dpi->p)) {
-                       int ret = PTR_ERR(dpi->p);
-
-                       dev_dbg(dev, "no pinctrl handle\n");
-                       /* Only return deferrals */
-                       if (ret == -EPROBE_DEFER)
-                               return ret;
-                       return 0;
-               }
+               ret = PTR_ERR(dpi->p);
+               dev_dbg(dev, "no pinctrl handle\n");
+               /* Only return deferrals */
+               if (ret == -EPROBE_DEFER)
+                       return ret;
+               return 0;

Is this intended change? or am I missing something in order to use this auto grab
functionality?

With the above change, now deferred probing is working fine and there is no need
to register pin control driver in arch_initcall.


Regards, 
Manish
