Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab3CLLNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:13:05 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:19571 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752076Ab3CLLNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:13:04 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19KjOIw0MolaAFbnWTbjLbib2tIGoyHnbo=
Date: Tue, 12 Mar 2013 07:12:46 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: manual merge of the akpm tree with the arm-soc tree
Message-ID: <20130312111246.GD12700@titan.lakedaemon.net>
References: <20130312144714.39749c5b0bd1aea14c4d2ff8@canb.auug.org.au>
 <20130312062509.GQ21478@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312062509.GQ21478@lunn.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 07:25:09AM +0100, Andrew Lunn wrote:
> On Tue, Mar 12, 2013 at 02:47:14PM +1100, Stephen Rothwell wrote:
> > Hi Andrew,
> > 
> > Today's linux-next merge of the akpm tree got a conflict in
> > drivers/rtc/rtc-mv.c between commit 89c58c198b25 ("rtc: rtc-mv: Add
> > support for clk to avoid lockups") from the arm-soc tree and commit "rtc:
> > rtc-mv: use devm_rtc_device_register()" from the akpm tree.
> > 
> > I fixed it up (I think - see below) and can carry the fix as necessary
> > (no action is required).
> 
> Hi Stephan
> 
> Looks O.K. to me.
> 
> Acked-by: Andrew Lunn <andrew@lunn.ch>

Same here,

Acked-by: Jason Cooper <jason@lakedaemon.net>

> 
> > 
> > -- 
> > Cheers,
> > Stephen Rothwell                    sfr@canb.auug.org.au
> > 
> > diff --cc drivers/rtc/rtc-mv.c
> > index f378e17,1ee8551..0000000
> > --- a/drivers/rtc/rtc-mv.c
> > +++ b/drivers/rtc/rtc-mv.c
> > @@@ -272,16 -262,15 +272,17 @@@ static int __init mv_rtc_probe(struct p
> >   
> >   	if (pdata->irq >= 0) {
> >   		device_init_wakeup(&pdev->dev, 1);
> > - 		pdata->rtc = rtc_device_register(pdev->name, &pdev->dev,
> > + 		pdata->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
> >   						 &mv_rtc_alarm_ops,
> >   						 THIS_MODULE);
> > - 	} else
> > - 		pdata->rtc = rtc_device_register(pdev->name, &pdev->dev,
> > + 	} else {
> > + 		pdata->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
> >   						 &mv_rtc_ops, THIS_MODULE);
> > + 	}
> >  -	if (IS_ERR(pdata->rtc))
> >  -		return PTR_ERR(pdata->rtc);
> >  +	if (IS_ERR(pdata->rtc)) {
> >  +		ret = PTR_ERR(pdata->rtc);
> >  +		goto out;
> >  +	}
> >   
> >   	if (pdata->irq >= 0) {
> >   		writel(0, pdata->ioaddr + RTC_ALARM_INTERRUPT_MASK_REG_OFFS);
> > @@@ -308,10 -292,6 +309,9 @@@ static int __exit mv_rtc_remove(struct 
> >   	if (pdata->irq >= 0)
> >   		device_init_wakeup(&pdev->dev, 0);
> >   
> > - 	rtc_device_unregister(pdata->rtc);
> >  +	if (!IS_ERR(pdata->clk))
> >  +		clk_disable_unprepare(pdata->clk);
> >  +
> >   	return 0;
> >   }
> >   
> 
> 
