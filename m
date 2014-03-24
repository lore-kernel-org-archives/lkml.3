Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaCXEHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 00:07:36 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:57712
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750988AbaCXEGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 00:06:44 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Grant Likely <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
CC: "panto@antoniou-consulting.com" <panto@antoniou-consulting.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv2 2/2] of: fix of_update_property()
Thread-Topic: [PATCHv2 2/2] of: fix of_update_property()
Thread-Index: AQHPFz8Sq/yUThZFaUK54PYhkUsIIZrQ3IwAgB8hRlA=
Date: Mon, 24 Mar 2014 04:06:40 +0000
Message-ID: <d545df066db84eadbfa575a5bd8eca1f@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1390370260-11273-1-git-send-email-Li.Xiubo@freescale.com> <
 1390370260-11273-2-git-send-email-Li.Xiubo@freescale.com>
 <20140304084122.E3353C4308B@trevor.secretlab.ca>
In-Reply-To: <20140304084122.E3353C4308B@trevor.secretlab.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01604FB62B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(189002)(199002)(24454002)(79102001)(76576001)(49866001)(2656002)(81816001)(93516002)(81686001)(86362001)(20776003)(85306002)(94316002)(80976001)(81342001)(47736001)(47976001)(50986001)(59766001)(98676001)(87936001)(4396001)(97186001)(97336001)(56816005)(66066001)(81542001)(87266001)(63696002)(46102001)(80022001)(83072002)(74366001)(69226001)(90146001)(74662001)(74706001)(76482001)(95666003)(74502001)(47446002)(31966008)(74316001)(54356001)(74876001)(19580395003)(56776001)(94946001)(76786001)(33646001)(93136001)(76796001)(95416001)(53806001)(51856001)(85852003)(65816001)(83322001)(92566001)(54316002)(19580405001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB507;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:EC2DFA53.ADC2AD28.B1C7A37F.4AD5A601.202E6;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [PATCHv2 2/2] of: fix of_update_property()
> 
> On Wed, 22 Jan 2014 13:57:40 +0800, Xiubo Li <Li.Xiubo@freescale.com> wrote:
> > The of_update_property() is intented to update a property in a node
> > and if the property does not exist, will add it.
> >
> > The second search of the property is possibly won't be found, that
> > maybe removed by other thread just before the second search begain.
> >
> > Using the __of_find_property() and __of_add_property() instead and
> > move them into lock operations.
> >
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > Cc: Pantelis Antoniou <panto@antoniou-consulting.com>
> 
> I've had to revert this patch. See below...
> 
> > ---
> >  drivers/of/base.c | 36 ++++++++++++++----------------------
> >  1 file changed, 14 insertions(+), 22 deletions(-)
> >
> > diff --git a/drivers/of/base.c b/drivers/of/base.c
> > index b86b77a..458072d 100644
> > --- a/drivers/of/base.c
> > +++ b/drivers/of/base.c
> > @@ -1573,7 +1573,7 @@ int of_update_property(struct device_node *np, struct
> property *newprop)
> >  {
> >  	struct property **next, *oldprop;
> >  	unsigned long flags;
> > -	int rc, found = 0;
> > +	int rc = 0;
> >
> >  	rc = of_property_notify(OF_RECONFIG_UPDATE_PROPERTY, np, newprop);
> >  	if (rc)
> > @@ -1582,36 +1582,28 @@ int of_update_property(struct device_node *np,
> struct property *newprop)
> >  	if (!newprop->name)
> >  		return -EINVAL;
> >
> > -	oldprop = of_find_property(np, newprop->name, NULL);
> > -	if (!oldprop)
> > -		return of_add_property(np, newprop);
> > -
> >  	raw_spin_lock_irqsave(&devtree_lock, flags);
> > -	next = &np->properties;
> > -	while (*next) {
> > -		if (*next == oldprop) {
> > -			/* found the node */
> > -			newprop->next = oldprop->next;
> > -			*next = newprop;
> > -			oldprop->next = np->deadprops;
> > -			np->deadprops = oldprop;
> > -			found = 1;
> > -			break;
> > -		}
> > -		next = &(*next)->next;
> > +	oldprop = __of_find_property(np, newprop->name, NULL);
> > +	if (!oldprop) {
> > +		/* add the node */
> > +		rc = __of_add_property(np, newprop);
> > +	} else {
> > +		/* replace the node */
> > +		next = &oldprop;
> 
> Ugh. I just looked closer and the above line is completely broken.
> &oldprop is the address of 'oldprop' on the stack, *not* the address of
> the previous item in the list. The while loop is still required to find it.
> 

Yes, I'll fix this.

Thanks very much.

BRs
Xiubo


> g.
> 
> > +		newprop->next = oldprop->next;
> > +		*next = newprop;
> > +		oldprop->next = np->deadprops;
> > +		np->deadprops = oldprop;
> >  	}
> >  	raw_spin_unlock_irqrestore(&devtree_lock, flags);
> >
> > -	if (!found)
> > -		return -ENODEV;
> > -
> >  #ifdef CONFIG_PROC_DEVICETREE
> >  	/* try to add to proc as well if it was initialized */
> > -	if (np->pde)
> > +	if (!rc && np->pde)
> >  		proc_device_tree_update_prop(np->pde, newprop, oldprop);
> >  #endif /* CONFIG_PROC_DEVICETREE */
> >
> > -	return 0;
> > +	return rc;
> >  }
> >
> >  #if defined(CONFIG_OF_DYNAMIC)
> > --
> > 1.8.4
> >
> >
> 
> 

