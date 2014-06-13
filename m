Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaFMODP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 10:03:15 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:57602 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaFMODO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 10:03:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Pawel Moll <pawel.moll@arm.com>
Subject: Re: [patch v2] mfd: vexpress: fix error handling vexpress_syscfg_regmap_init()
Date: Fri, 13 Jun 2014 16:02:46 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Olof Johansson <olof@lixom.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
References: <20140611101740.GA13148@mwanda> <1402482800.3523.20.camel@hornet>
In-Reply-To: <1402482800.3523.20.camel@hornet>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201406131602.46893.arnd@arndb.de>
X-Provags-ID: V02:K0:RspqcI2y5JRt/BbHT0ppRoBjZyHuWHlsVbtgt0sOS8D
 Xe+Og6ziXasj6FznkIlFmh1VjcNgh61lUXBHQtOrh3RnvcFkHJ
 IAzmsJpZuW4NCnZh4xufIfTY5CqqkyEqBfNT84+5jAiOzOGYiT
 71g3Ie840D54AwBCoFw2+IMS9t75W6MPOTNZaxeO2nAQ2zDaX8
 vj4UgFoPtC4e49pFHfyqJ3m2DibPEJJYCpRmwZ1y8QsB2bbS6C
 VnAj46dd3KsJ9hKgKx2Qvwd18OUME/QxgzQNrf4U9p8kfotKL3
 hobm3mv2Q5B+DvvyEwYklu9JS8C/q1dkHcIkQhG1tOvtf/zeq7
 nc8hb+sK4CWIS0Ec5Iek=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 June 2014, Pawel Moll wrote:
> On Wed, 2014-06-11 at 11:17 +0100, Dan Carpenter wrote:
> > This function should be returning an ERR_PTR() on failure instead of
> > NULL.  Also there is a use after free bug if regmap_init() fails because
> > we free "func" and then dereference doing the return.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > diff --git a/drivers/misc/vexpress-syscfg.c b/drivers/misc/vexpress-syscfg.c
> > index 73068e5..3250fc1 100644
> > --- a/drivers/misc/vexpress-syscfg.c
> > +++ b/drivers/misc/vexpress-syscfg.c
> > @@ -199,7 +199,7 @@ static struct regmap *vexpress_syscfg_regmap_init(struct device *dev,
> >       func = kzalloc(sizeof(*func) + sizeof(*func->template) * num,
> >                       GFP_KERNEL);
> >       if (!func)
> > -             return NULL;
> > +             return ERR_PTR(-ENOMEM);
> >  
> >       func->syscfg = syscfg;
> >       func->num_templates = num;
> > @@ -231,10 +231,14 @@ static struct regmap *vexpress_syscfg_regmap_init(struct device *dev,
> >       func->regmap = regmap_init(dev, NULL, func,
> >                       &vexpress_syscfg_regmap_config);
> >  
> > -     if (IS_ERR(func->regmap))
> > +     if (IS_ERR(func->regmap)) {
> > +             void *err = func->regmap;
> > +
> >               kfree(func);
> > -     else
> > -             list_add(&func->list, &syscfg->funcs);
> > +             return err;
> > +     }
> > +
> > +     list_add(&func->list, &syscfg->funcs);
> >  
> >       return func->regmap;
> >  }
> 
> Uh, right. Dereferencing a freed structure. My bad. Thanks for spotting
> this!
> 
> Acked-by: Pawel Moll <pawel.moll@arm.com>
> 
> (nit: the subject should be "misc: vexpress:" rather then "mfd:")
> 
> Arnd, Olof, can you pick this one as an early fix or do you want me to
> queue it for rc1-based fixes branch?

I've applied it to the fixes branch now. Thanks!

	Arnd
