Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab3BEKZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:25:41 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:55872 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab3BEKZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:25:38 -0500
Date: Tue, 5 Feb 2013 11:25:40 +0100
From: Cong Ding <dinggnu@gmail.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Kyungmin Park <kmpark@infradead.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>, linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] i2c: busses/i2c-pxa.c: fix potential null pointer
 dereference error
Message-ID: <20130205102540.GC9969@gmail.com>
References: <1360015899-13706-1-git-send-email-dinggnu@gmail.com>
 <CAH9JG2XSpFJeUvv7cw-JWadmi=X0-4EsN5FFKuDkwo=-mmzHSQ@mail.gmail.com>
 <20130205000517.GB9969@gmail.com>
 <CAN1soZwM6qNTJn3vvMdc6TR1eJHc=K+_c0WuWOBBuFYMWB_oCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN1soZwM6qNTJn3vvMdc6TR1eJHc=K+_c0WuWOBBuFYMWB_oCA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 09:14:08AM +0800, Haojian Zhuang wrote:
> On Tue, Feb 5, 2013 at 8:05 AM, Cong Ding <dinggnu@gmail.com> wrote:
> > If it goes to eclk through line 1107, the variable res would be NULL. It will
> > cause a null pointer dereference error if we call release_mem_region.
> >
> > Signed-off-by: Cong Ding <dinggnu@gmail.com>
> > ---
> >  drivers/i2c/busses/i2c-pxa.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
> > index 1034d93..00df535 100644
> > --- a/drivers/i2c/busses/i2c-pxa.c
> > +++ b/drivers/i2c/busses/i2c-pxa.c
> > @@ -1211,7 +1211,8 @@ eremap:
> >  eclk:
> >         kfree(i2c);
> >  emalloc:
> > -       release_mem_region(res->start, resource_size(res));
> > +       if (res)
> > +               release_mem_region(res->start, resource_size(res));
> >         return ret;
> >  }
> >
> >
> 
> No. I don't agree on this. Your fix can't resolve all potential issues.
> 
>         i2c = kzalloc(sizeof(struct pxa_i2c), GFP_KERNEL);
>         if (!i2c) {
>                 ret = -ENOMEM;
>                 goto emalloc;
>         }
> 
>         ret = i2c_pxa_probe_dt(dev, i2c, &i2c_type);
>         if (ret > 0)
>                 ret = i2c_pxa_probe_pdata(dev, i2c, &i2c_type);
>         if (ret < 0)
>                 goto eclk;
> 
>         res = platform_get_resource(dev, IORESOURCE_MEM, 0);
>         irq = platform_get_irq(dev, 0);
>         if (res == NULL || irq < 0) {
>                 ret = -ENODEV;
>                 goto eclk;
>         }
> 
>         if (!request_mem_region(res->start, resource_size(res), res->name)) {
>                 ret = -ENOMEM;
>                 goto eclk;
>         }
> 
> We shouldn't jump to eclk for these error cases. Then we needn't to add
> checking on res.
So what do you suggest to do for these error cases?
 - cong

