Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348AbaK1KbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:31:05 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:48222 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaK1KbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:31:00 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-ef-54784ee1b8d2
Message-id: <1417170655.18249.24.camel@AMDC1943>
Subject: Re: [PATCH v4 4/7] regulator: Use ena_gpio supplied with generic
 regulator bindings
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Fri, 28 Nov 2014 11:30:55 +0100
In-reply-to: <20141127184342.GC7712@sirena.org.uk>
References: <1417087253-12306-1-git-send-email-k.kozlowski@samsung.com>
 <1417087253-12306-5-git-send-email-k.kozlowski@samsung.com>
 <20141127184342.GC7712@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t/xa7oP/SpCDM4261hsnLGe1WLqwyds
	FvOPnGO16H/8mtnibNMbdov7X48yWny70sFksenxNVaLy7vmsFnMOL+PyWLtkbvsDtweO2fd
	ZffYtKqTzePOtT1sHpuX1Hv0bVnF6PF5k1wAWxSXTUpqTmZZapG+XQJXxpL2A6wFa2Qqpn5c
	w97AuF+si5GTQ0LARGLKgy1MELaYxIV769m6GLk4hASWMkqcbjnABpIQEvjMKDHzaSiIzStg
	IPHtzzN2EFtYIE5i3/7bzCA2m4CxxOblS8DqRQSUJa5+38sCMohZoJlZ4t+Df6wgCRYBVYln
	u8+CNXAKGEmcWbGKHWLbWkaJ73uuMYIkmAXUJSbNWwRUxAF0krJEY78bxGJBiR+T77FAlMhL
	bF7zlnkCo8AsJB2zkJTNQlK2gJF5FaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkZIXHzdwbj0
	mNUhRgEORiUe3gmWFSFCrIllxZW5hxglOJiVRHjFXIFCvCmJlVWpRfnxRaU5qcWHGJk4OKUa
	GPcyiITNOSu9+86PGv8iUaGdK06EbDl+ic1W2eXcE9d9jxrK7sVO15bVuaW81Ld2c9xps+fV
	8zm1Z+U41F2dpH16iebVYDU2k2XTL1859tZLqKnbcaam5HemSw+m+/Xelio8ta61ZnOYsYn9
	hx3eBmEXn36fL582lf3jwnDlWqGNe2In3XX8FaDEUpyRaKjFXFScCADSna2CaQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On czw, 2014-11-27 at 18:43 +0000, Mark Brown wrote:
> On Thu, Nov 27, 2014 at 12:20:50PM +0100, Krzysztof Kozlowski wrote:
> > Use ena_gpio from regulator constraints (filled by parsing generic
> > bindings) to initialize the GPIO enable control. Support also the old
> > way: ena_gpio supplied in regulator_config structure.
> > 
> > This also adds a new set_ena_gpio() callback in regulator_ops structure
> > which driver may provide to actually enable the GPIO control in
> > hardware.
> 
> This seems really confused like it's trying to work around some other
> problem - this all feels like it's at the wrong abstraction level.  As
> far as I can tell this is trying to fix bugs in the previous patch and
> do some other refactorings (the "also add this other random op" bit
> especially) but I'm really not clear what the goal is.
> 
> Please try to think if the code you're writing makes sense at the big
> picture level rather than just band aiding specific problems you see.
> It's also a good idea to keep random code motion separate from
> functional changes since it makes it much easier to follow what each is
> supposed to do.
> 
> > @@ -1044,6 +1045,14 @@ static int set_machine_constraints(struct regulator_dev *rdev,
> >  		}
> >  	}
> >  
> > +	if (rdev->constraints->use_ena_gpio && ops->set_ena_gpio) {
> > +		ret = ops->set_ena_gpio(rdev);
> > +		if (ret < 0) {
> > +			rdev_err(rdev, "failed to set enable GPIO control\n");
> > +			goto out;
> > +		}
> > +	}
> 
> Why do we need some special magic operation for GPIO based enables
> that's separate to any other enable operation?  This seems really
> confusing, if the constraint setting doesn't work somehow for GPIO based
> enables we should fix that.  Though since this operation takes no
> parameters it's hard to see how it's supposed to apply constraints
> unless it reparses them which doesn't seem like a good idea...

The regulator driver no longer parses GPIO control from DTS. So somehow
it should be notified that regulator core parsed this and GPIO should be
enabled.

That is the purpose of ops->set_ena_gpio() call.

> 
> >  static int regulator_ena_gpio_request(struct regulator_dev *rdev,
> > -				const struct regulator_config *config)
> 
> > -	ret = gpio_request_one(config->ena_gpio,
> > -				GPIOF_DIR_OUT | config->ena_gpio_flags,
> > +	ret = gpio_request_one(gpio, GPIOF_DIR_OUT | gpio_flags,
> >  				rdev_get_name(rdev));
> 
> > +/*
> > + * Request GPIO for enable control from regulator_config
> > + * or init_data->constraints.
> > + */
> > +static int regulator_ena_gpio_setup(struct regulator_dev *rdev,
> > +			const struct regulator_config *config,
> > +			const struct regulator_init_data *init_data)
> 
> Why is setting up the GPIO different to requesting it, especially given
> that we have an existing function called _request() which still exists?

Maybe the name was not a best choice. The setup calls request.

My patchset here tried to retain the compatibility with
"config.ena_gpio" way so the core would accept GPIOs passed in one of
two ways:
1. old: config.ena_gpio,
2. new: parsed by core from DTS.

The request function previously worked only on "config.ena_gpio" and I
changed it here to accept any GPIO. The setup uses one of GPIO methods
(old or new) and calls request with appropriate GPIO.

Anyway this will change after your comments about not using constraints
(patch 3/7). I'll keep your comments about big picture level in mind and
start working on next version.

Thanks for feedback!

Best regards,
Krzysztof


