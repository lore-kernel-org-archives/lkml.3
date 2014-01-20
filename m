Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbaATFuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 00:50:23 -0500
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:36683
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750711AbaATFuU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 00:50:20 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Rob Herring <robherring2@gmail.com>
CC: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Pantelis Antoniou" <panto@antoniou-consulting.com>
Subject: RE: [PATCH] of: fix of_update_property()
Thread-Topic: [PATCH] of: fix of_update_property()
Thread-Index: AQHPE0dClIfvd+hKkU21M4x9OCudQ5qI//2AgAP8bbA=
Date: Mon, 20 Jan 2014 05:50:17 +0000
Message-ID: <b61be84c13ed4056a62743e16beb70f2@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1389933996-19306-1-git-send-email-Li.Xiubo@freescale.com>
 <CAL_JsqJuAv8=pBuzYO5ZGzroD1kq6gjmNsTjoVyXR=vcu+-pTA@mail.gmail.com>
In-Reply-To: <CAL_JsqJuAv8=pBuzYO5ZGzroD1kq6gjmNsTjoVyXR=vcu+-pTA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 00979FCB3A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(51704005)(24454002)(199002)(164054003)(189002)(377454003)(4396001)(87936001)(31966008)(80022001)(74316001)(47446002)(81342001)(74662001)(81686001)(76576001)(83072002)(74502001)(56816005)(90146001)(93516002)(74706001)(86362001)(575784001)(81542001)(77982001)(85852003)(74366001)(2656002)(69226001)(65816001)(85306002)(87266001)(74876001)(76796001)(1411001)(47736001)(19580395003)(66066001)(83322001)(76786001)(54356001)(46102001)(49866001)(79102001)(63696002)(19580405001)(53806001)(80976001)(51856001)(50986001)(54316002)(92566001)(59766001)(47976001)(76482001)(56776001)(33646001)(93136001)(81816001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB508;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [PATCH] of: fix of_update_property()
> 
> On Thu, Jan 16, 2014 at 10:46 PM, Xiubo Li <Li.Xiubo@freescale.com> wrote:
> > The of_update_property() is intent to update a property in a node
> 
> s/intent/indended/
> 
> > and if the property does not exist, will add it to the node.
> >
> > The second search of the property is possibly won't be found, that
> > maybe removed by other thread just before the second search begain,
> > if so just retry it.
> 
> How did you find this problem? Actual use or some artificial stress test?
>

Some artificial stress test at home.

 
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > ---
> >  drivers/of/base.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/of/base.c b/drivers/of/base.c
> > index f807d0e..d0c53bc 100644
> > --- a/drivers/of/base.c
> > +++ b/drivers/of/base.c
> > @@ -1572,6 +1572,7 @@ int of_update_property(struct device_node *np, struct
> property *newprop)
> >         if (!newprop->name)
> >                 return -EINVAL;
> >
> > +retry:
> >         oldprop = of_find_property(np, newprop->name, NULL);
> >         if (!oldprop)
> >                 return of_add_property(np, newprop);
> 
> Isn't there also a race that if you do 2 updates for a non-existent
> property and both threads try to add the property, the first one will
> succeed and the 2nd will fail. The 2nd one needs to retry as well.
> 

Well, yes, that will happen.

Maybe we could add one __of_add_property() without any locks, like
__of_find_property(). And then in of_update_prperty() move the searching
and adding operations to between lock and unlock, like:

	raw_spin_lock_irqsave();
	oldprop = __of_find_property();
      	if (!oldprop) {
              rc = __of_add_property(np, newprop);
		 ...
	}
	...
	replace the node...
	...
	raw_spin_unlock_irqrestore();

> Also, couldn't the node itself be removed while trying to do the update?
> 

For this is between the lock operations. I think this doesn't matter here.

> There seem to be multiple problems with this code, but doing multiple
> simultaneous, conflicting updates seems like an unlikely case.
> 

Yes, but this will happen in theory. 

Thanks,

Best Regards,
Xiubo
