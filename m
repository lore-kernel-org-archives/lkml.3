Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab3H0J4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 05:56:55 -0400
Received: from mail-db8lp0189.outbound.messaging.microsoft.com ([213.199.154.189]:54979
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852Ab3H0J4x convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 05:56:53 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de097hz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Xiubo Li-B47053 <B47053@freescale.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Guo Shawn-R65073 <r65073@freescale.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Lu Jingchang-B35083 <B35083@freescale.com>
Subject: RE: [PATCH 1/4] pwm: add freescale ftm pwm driver support
Thread-Topic: [PATCH 1/4] pwm: add freescale ftm pwm driver support
Thread-Index: AQHOnhwdSdSsv5GKTkyhA3muKUAEeJmig5UAgASDWFCAAa5jgIAABp5A
Date: Tue, 27 Aug 2013 09:56:44 +0000
Message-ID: <1DD289F6464F0949A2FCA5AA6DC23F827E6994@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com>
 <1377054462-6283-2-git-send-email-Li.Xiubo@freescale.com>
 <20130823090523.GF3535@ulmo>
 <1DD289F6464F0949A2FCA5AA6DC23F827E42BD@039-SN2MPN1-012.039d.mgd.msft.net>
 <20130827074057.GC8686@ulmo>
In-Reply-To: <20130827074057.GC8686@ulmo>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.56]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually it should even be:
> 
> 	#define FTM_CSC(channel) \
> 		(FTM_CSC_BASE + ((channel) * 8))
> 

Well, yes, It should be, as Sascha has comment about this before, I have 
already revise it.


> > Firstly, we should be clear that the fpc->clk is chip's work clock.
> > If so, after the .request() is called and before .enable() is called,
> > the custumer will call .config(), in which will read/write the pwm chip
> registers, if the module clock is still disabled, then the system will
> hang up.
> 
> Okay. In that case perhaps the better thing to do is call clk_prepare()
> during driver probe and only clk_enable() here.
> 

Yes, it is.

> > > Perhaps time_ns should be "unsigned long"?
> > >
> >
> > Shouldn't this be same with "int duty_ns" and "int period_ns", which
> > are defined by struct pwm_ops { ...
> > 	int (*config)(struct pwm_chip *chip,
> >                     struct pwm_device *pwm,
> >                     int duty_ns, int period_ns); ...
> > }  ?
> 
> Well, the plan is to eventually make duty_ns and period_ns unsigned int
> or unsigned long because negative values don't make any sense for them.
> With that in mind I think it makes sense to use the proper type here now.
> 

Okey, I will think it over again and revise it.

> > > > +static int fsl_pwm_config_channel(struct pwm_chip *chip,
> > >
> > > I think you can safely drop the _channel suffix from the PWM
> operations.
> > >
> >
> > By adding _channel suffix just for more comprehensave about the pwm's
> muti-channel operation.
> > If this is redundant here, I will drop it.
> 
> The operations are implicitly per-channel operations. So yes, the
> _channel suffix is redundant here.
> 

Agree, I will drop it.

> > > > +	fpc = to_fsl_chip(chip);
> > > > +
> > > > +	if (WARN_ON(!test_bit(PWMF_REQUESTED, &pwm->flags)))
> > > > +		return -ESHUTDOWN;
> > >
> > > Erm... how do you think this could ever happen? Users need to
> > > request a PWM to obtain a struct pwm_device, in which case
> > > PWMF_REQUESTED will always be set. There are a few other occurrences
> > > throughout the rest of the driver that I haven't pointed out
> explicitly.
> > >
> >
> > Does the following case is exist ?
> > The customer in one thread has .free(pwm_1), while in another thread,
> > which maybe had slept in for some reason, will
> call .config/.enable/.disable?
> >
> > If so, as I have explained before, if the pwm_1 has been freed, the
> > module clock maybe disabled too, so if the .config is call the system
> will hang up.
> 
> While the above could possibly happen, there's no way the core could
> prevent it. And your explicit test couldn't either. So what usually
> happens is that a driver requests a PWM device and then has exclusive
> access to it. Any other driver that wants to use the same PWM device
> can't because it will get an -EBUSY return.
> 
> So in your hypothetical case above, if one driver does stuff like that
> with a PWM device then that's a driver bug, not something the PWM core
> should be required to handle.
> 

Okey, I will drop this.

> > While I think the following is better in code.
> >
> >  		dev_err(fpc->chip.dev,
> >  			"failed to parse <fsl,pwm-clk-ps> property: %d\n",
> >  			ret);
> 
> Why? You're quoting which property failed to parse so you should use the
> correct character for quoting, which is either the apostrophe (') or the
> quotation mark (").
> 

For my first impression, I just thought that maybe a little better.
Okey, I will adopt this in the feature.



--
Xiubo

