Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759059Ab3BXXId (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 18:08:33 -0500
Received: from gloria.sntech.de ([95.129.55.99]:39321 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757280Ab3BXXIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 18:08:31 -0500
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl: return real error codes when pinctrl is not included
Date: Sun, 24 Feb 2013 23:34:42 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Tomasz Figa <t.figa@samsung.com>, Prathyush K <prathyush@chromium.org>,
        Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org
References: <201302231855.47560.heiko@sntech.de> <201302231856.35083.heiko@sntech.de> <CACRpkdbA-S7qYHnN72c65Wo_Q7qD3tUxUSNYEXkk4gHbpez4+Q@mail.gmail.com>
In-Reply-To: <CACRpkdbA-S7qYHnN72c65Wo_Q7qD3tUxUSNYEXkk4gHbpez4+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201302242334.42408.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 24. Februar 2013, 01:40:58 schrieb Linus Walleij:
> On Sat, Feb 23, 2013 at 6:56 PM, Heiko Stübner <heiko@sntech.de> wrote:
> > Currently the fallback functions when pinctrl is not being built do
> > return either NULL or 0, either no pinctrl handle or no error,
> > making them fail silently.
> > 
> > All drivers using pinctrl do only test for error conditions, which
> > made for example the i2c-s3c2410 driver fail on a devicetree based
> > machine without pinctrl, as the conditional
> > 
> >         if (IS_ERR(i2c->pctrl) && s3c24xx_i2c_parse_dt_gpio(i2c))
> > 
> > did not reach the second part to initialize the gpios from dt.
> > 
> > Therefore let the fallback pinctrl functions return -ENOTSUPP
> > or the equivalent ERR_PTR to indicate that pinctrl is not supported.
> 
> NAK.
> 
> You are abusing IS_ERR(i2c->pctrl) to check if pinctrl is available
> on the system which is *NOT* the intended usecase and that is
> why your code fails.
> 
> So I discussed the *exact* same thing with Tomasz and Pratyush a
> while back in a private thread, which teaches me to probably not
> waste time on responding to anything unless it's public.
> 
> This make me suspect that you have this ugly patch in some
> private repo and I will be seeing it again and again :-(

All my s3c24xx work is done is my spare time, so I have to confess I came up 
with this "ugly patch" all by myself when working on dt support for my machine 
and stumbling upon the described problem with the pin configuration.

So, as it is obviously wrong, I also won't hold onto it.

In any case, thanks for the thorough explanation, which I probably won't 
forget anytime soon.


Heiko


> Here is an excerpt of that conversation:
> 
> -------------8<---------------------------8<--------------------------8<---
> -------------------
> 
> On Mon, Dec 24, 2012 at 12:26 PM, Prathyush K <prathyush@chromium.org> 
wrote:
> > Exynos5250 does not yet support pinctrl so CONFIG_PINCTRL is not defined.
> > 
> > The i2c-s3c2410 driver calls 'devm_pinctrl_get_select_default' which
> > returns NULL.
> > While checking for error, we use IS_ERR and not IS_ERR_OR_NULL inside the
> > driver.
> > This was causing the i2c hdmi phy to fail.
> > 
> > I checked the other i2c drivers and realized, no-one is actually checking
> > for IS_ERR_OR_NULL.
> > 
> > Even ./Documentation/pinctrl.txt says:
> >         /* Setup */
> >         p = devm_pinctrl_get(&device);
> >         if (IS_ERR(p))
> > 
> > I think the consumer.h should be modified to return an error and not just
> > NULL if CONFIG_PINCTRL is not defined.
> 
> No. That is not the idea with compile-out stubs.
> 
> The idea is not to check at runtime whether you have this or that
> framework enabled, if you need this framework for the driver to work
> it should be depends on PINCTRL in Kconfig for the driver so it's
> non-optional. This seems to be the case here?
> 
> The stubs are for the case where pinctrl is optional for the driver(s) on
> the system, for example if one driver is used on many diverse systems,
> some which have pinctrl and some which does not.
> 
> We cannot have a shared driver, like drivers/tty/serial/amba-pl011.c
> fail on RealView just because the U300 need pins when using the
> same driver, that would be unmanageable.
> 
> Your reasoning above can only work in a world where e.g. all systems
> using that driver have pinctrl. And then you can just depend on it in
> Kconfig and problem is solved.
> 
> On Thu, Dec 27, 2012 at 10:58 AM, Tomasz Figa <t.figa@samsung.com> wrote:
> > I think that devm_pinctrl_get stub, as well as other pinctrl stubs,
> > should not return NULL, but rather a reasonable error code.
> 
> No. It is perfectly valid to not implement pinctrl on a system.
> And the driver stubs should then work without pins being controlled
> (for example as if they were set up at boot time by some bootloader,
> or ROM.)
> 
> If the driver does not work without pinctrl it should have
> depends on PINCTRL in Kconfig.
> 
> On Thu, Jan 17, 2013 at 9:50 AM, Tomasz Figa <t.figa@samsung.com> wrote:
> >> If the driver does not work without pinctrl it should have
> >> depends on PINCTRL in Kconfig.
> > 
> > What about drivers that support several pin configuration methods?
> 
> The platforms that use some other method shall call
> pinctrl_provide_dummies() in their machine set-up code.
> 
> Then they will get dummy regulators that appear to work
> but does nothing.
> 
> Then they shall be converted to use pinctrl proper.
> 
> On Thu, Jan 17, 2013 at 3:05 PM, Tomasz Figa <t.figa@samsung.com> wrote:
> > We have a bunch of drivers that should try pin control and if it is not
> > supported on given platform then it should fall back to legacy
> > configuration method (like cfg_gpio() callback passed through platform
> > data).
> > 
> > From what you are saying, it seems like there is no way to check if pin
> > control is supported on platform we are running on.
> 
> No we never saw that usecase before :-)
> 
> It's very hard to say whether pinctrl is available or not as well,
> as drivers can be deferred.
> 
> In any case the stubs are not designed to solve this type of problem.
> 
> > Of course this can be resolved by trying the legacy method first and try
> > pin control only if it is not provided (no platform data or NULL callback
> > pointer).
> 
> I would just set some bool value in platform_data like .use_legacy_pins
> if you need to support this.
> 
> -------------8<---------------------------8<--------------------------8<---
> -------------------
> 
> All chrystal clear now?
> 
> Plus, I think that now that the device core is handling pin control you
> should be able to just remove all this default-enabling from your
> drivers.
> 
> *NO* using of pinctrl to check if "do we need to do it some other
> way".
> 
> Yours,
> Linus Walleij

