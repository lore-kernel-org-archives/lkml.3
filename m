Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbaFXMF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 08:05:27 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54972 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752520AbaFXMF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 08:05:26 -0400
Date: Tue, 24 Jun 2014 14:05:19 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/12] reset: add the Berlin reset controller driver
Message-ID: <20140624120519.GE7368@kwain>
References: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com>
 <1403606121-6368-2-git-send-email-antoine.tenart@free-electrons.com>
 <1403608416.2910.15.camel@paszta.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403608416.2910.15.camel@paszta.hi.pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On Tue, Jun 24, 2014 at 01:13:36PM +0200, Philipp Zabel wrote:
> Am Dienstag, den 24.06.2014, 12:35 +0200 schrieb Antoine Ténart:
> > +
> > +struct berlin_reset_priv {
> > +	spinlock_t			lock;
> 
> lock is not used anymore.

Oops. I'll remove it.

> 
> [...]
> > +static int berlin_reset_xlate(struct reset_controller_dev *rcdev,
> > +			      const struct of_phandle_args *reset_spec)
> > +{
> > +	struct berlin_reset_priv *priv = to_berlin_reset_priv(rcdev);
> > +	unsigned offset, bit;
> > +
> > +	if (WARN_ON(reset_spec->args_count != rcdev->of_reset_n_cells))
> > +		return -EINVAL;
> > +
> > +	offset = reset_spec->args[0];
> > +	bit = reset_spec->args[1];
> > +
> > +	if (offset >= priv->size)
> > +		return -EINVAL;
> > +
> > +	if (bit >= rcdev->nr_resets)
> > +		return -EINVAL;
> 
> This could be considered a misuse of nr_resets, even if the core only
> ever uses nr_resets in the _xlate function. Maybe it would be more clear
> to just leave nr_resets empty if you don't know the actual number and
> hardcode 32 here.
> 
> [...]
> > +static int __berlin_reset_init(struct device_node *np)
> > +{
> > +	struct berlin_reset_priv *priv;
> > +	struct resource res;
> > +	resource_size_t size;
> > +	int ret;
> > +
> > +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> > +	if (!priv)
> > +		return -ENOMEM;
> > +
> > +	ret = of_address_to_resource(np, 0, &res);
> > +	if (ret)
> > +		goto err;
> > +
> > +	size = resource_size(&res);
> > +	priv->base = ioremap(res.start, size);
> > +	if (!priv->base) {
> > +		ret = -ENOMEM;
> > +		goto err;
> > +	}
> > +	priv->size = size;
> > +
> > +	priv->rcdev.owner = THIS_MODULE;
> > +	priv->rcdev.nr_resets = 32;
> 
> Leave nr_resets empty, use the correct value, or at least add a comment
> that this is not the number of resets in the rcdev as documented in the
> structure documentation.

Ok. I'll hardcode the value in the driver then.

> 
> Other than the above, and with the understanding that this is going to
> be turned into a platform driver at some point in the future,
> 
> Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

Sure, that's the plan.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
