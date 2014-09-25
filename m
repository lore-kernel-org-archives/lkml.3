Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbaIYMmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 08:42:55 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:49402 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaIYMmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 08:42:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>,
        "'Dong Aisheng'" <b29396@freescale.com>,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        naushad@samsung.com, Li.Xiubo@freescale.com,
        linux-kernel@vger.kernel.org, tomasz.figa@gmail.com,
        thomas.ab@samsung.com, vikas.sajjan@samsung.com, chow.kim@samsung.com,
        joshi@samsung.com, lee.jones@linaro.org, kgene.kim@samsung.com
Subject: Re: [PATCH v5] mfd: syscon: Decouple syscon interface from platform devices
Date: Thu, 25 Sep 2014 14:42 +0200
Message-ID: <5439567.VeRyeUcp1j@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <000001cfd719$51e7e560$f5b7b020$@samsung.com>
References: <1411360807-7750-1-git-send-email-pankaj.dubey@samsung.com> <20140922091925.GA19778@shlinux1.ap.freescale.net> <000001cfd719$51e7e560$f5b7b020$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:8esy1Vl8Y65bNl5pl3drxTf0koyVt4QA/ZUxn16VXXq
 PSAfhyd7TFgACm/WeMRSlIaPkT21bGiCacJQz5MzjrlmZRBw8M
 cw2Bb44Giz105sOM8efHApubaXBSDZXtkWwf3v96leZhS8OLNC
 z2LX2efreIwXY/HlxEuuVRRPZfn+OA1rMlIBwq63yZXolcICrS
 4qxsVyF8ow/ySGUveUn03qz8fo6bLexPdQAdk0YH7gbxXGTaCG
 fbh+5Z8CKeJTFmPFeLOBXjqRJASEM1sIwIR9eQPumpKW4o4Rjh
 oNSIZH4xv2bthOFTRA9JnYAAT+4330MMB21mm28f4mcNFLRVne
 rhuNeQrCrgy3cKHubVvE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 15:59:43 Pankaj Dubey wrote:
> > > -static int syscon_match_node(struct device *dev, void *data)
> > > +static struct syscon *of_syscon_register(struct device_node *np)
> > >  {
> > > -   struct device_node *dn = data;
> > > +   struct platform_device *pdev = NULL;
> > > +   struct syscon *syscon;
> > > +   struct regmap *regmap;
> > > +   void __iomem *base;
> > > +   int ret;
> > > +
> > > +   if (!of_device_is_compatible(np, "syscon"))
> > > +           return ERR_PTR(-EINVAL);
> > > +
> > > +   syscon = kzalloc(sizeof(*syscon), GFP_KERNEL);
> > > +   if (!syscon)
> > > +           return ERR_PTR(-ENOMEM);
> > > +
> > > +   base = of_iomap(np, 0);
> > > +   if (!base) {
> > > +           ret = -ENOMEM;
> > > +           goto err_map;
> > > +   }
> > > +
> > > +   /* if device is already populated and available then use it */
> > > +   pdev = of_find_device_by_node(np);
> > > +   if (!pdev) {
> > > +           /* for early users create dummy syscon device and use it */
> > > +           pdev = platform_device_alloc("dummy-syscon", -1);
> > 
> > Can we create specific devices for each syscon device?
> > That looks more reasonable to me.
> > Then we can dump registers in regmap debugfs more clearly, just like other
> devices.
> > And i think it's better to follow device tree way to generate devices from
> node.
> > If DT core find a device is already created, it can ignore that device to
> avoid creating
> > duplicated device during of_platform_populate.
> > 
> 
> If you are referring to use "of_platform_device_create", then I am afraid
> that it can't be used
> in very early stage. For example, current patch I tested by calling
> syscon_lookup_by_phandle from
> "init_irq" hook of machine_desc, and it worked well, but If I use
> "of_platform_device_create"
> instead of dummy device, it fails to create pdev and this I verified on
> Exynos platform. The reason
> I selected "init_irq" is because this comes just before smp init and where
> once we tried to get regmap handle,
> but could not do so. 

I don't remember noticing the of_find_device_by_node or platform_device_alloc
in earlier versions of this patch, but that could just be me failing to
read it right.

I think this should get removed: it would be much better to ensure that
the regmap code can work without a device pointer, which I thought it
did. We should probably also skip the creation of the debugfs directory
in that case.

> Also if it was just a matter of creating platform_device at early stage then
> early initialization of
> syscon could have been solved till now.
> 
> So I would suggest if we really want this patch to cover early
> initialization of syscon
> (which is not it's main purpose) current patch is sufficient. 
> 
> @Arnd, since I have addressed crash issue as reported by Dong Aisheng, I
> would like to take your ack,
> but since there are some more code changes other than what you suggested I
> request you to check this
> and if you are ok, then I would like to your ack so that I can request to
> maintainer for taking this patch.

I think we first need to resolve the question of the platform device.

	Arnd
