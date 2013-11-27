Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab3K0INK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 03:13:10 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:12319
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754045Ab3K0INH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 03:13:07 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(z579ehz1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de097hz2dh109h2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h21a6h2216h22d0hbe9i1155h)
From: Li Xiubo <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        Fabio Estevam <Fabio.Estevam@freescale.com>,
        "LW@KARO-electronics.de" <LW@KARO-electronics.de>,
        "oskar@scara.com" <oskar@scara.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv1] ASoC: SGTL5000: Fix kernel failed while getting
 regulator consumers
Thread-Topic: [PATCHv1] ASoC: SGTL5000: Fix kernel failed while getting
 regulator consumers
Thread-Index: AQHO6pRwzUzMP/nWTkmv/o3JfSCBM5o3hgOAgAD0umA=
Date: Wed, 27 Nov 2013 08:13:03 +0000
Message-ID: <1DD289F6464F0949A2FCA5AA6DC23F828CE2A8@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1385459713-6778-1-git-send-email-Li.Xiubo@freescale.com>
 <20131126134411.GQ14725@sirena.org.uk>
In-Reply-To: <20131126134411.GQ14725@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.78]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static int sgtl5000_external_vddd_used(struct snd_soc_codec *codec)
> > +{
> > +	struct regulator *consumer;
> > +	struct sgtl5000_priv *sgtl5000 = snd_soc_codec_get_drvdata(codec);
> > +
> > +	consumer = regulator_get(codec->dev, sgtl5000-
> >supplies[VDDD].supply);
> > +	if (IS_ERR(consumer)) {
> > +		return 0;
> > +	}
> > +	regulator_put(consumer);
> > +
> > +	return 1;
> > +}
> 
> This is going to fail to do what you expect if a dummy regulator is
> substituted which it will almost all of the time when the supply is
> genuinely absent.  It's also going to interact poorly with probe
> deferral.
> 

There is one dependency patch: "regulator: core: Provide a dummy regulator with full constraints".

>From the dependency patch, we can see that using regulator_get_optional() instead can resovle the problem you descripted above.

When or will this dependency patch be merged into the -next tree ?



> I'd expect to see a commit description that describes how the driver
> currently tries to handle this, why it doesn't work and how the patch
> fixes it.  

The SGTL5000 requires 2 external power supplies: VDDA and VDDIO. An optional third external power supply VDDD may be provided externally to achieve lower power.If an external supply is not used for VDDD, the SGTL5000 driver will register it's own non-DT regulator device, and then provides the VDDD supply consumer, and now there will be two register devices exist, non-DT regulator for VDDD and DT regulator for VDDIO, VDDA.   


		
+++++++++++++++++++
+			+------------|3.3V VDDIO
+			+
+  SGTL5000	codec	+---X   VDDD
+			+
+			+------------|3.3V VDDA
+++++++++++++++++++
		


If an external supply is not used for VDDD, in the DT file, only "VDDA-supply" and "VDDIO-supply" properties will be presented. This caused the following kernel failed while trying to get the external VDDD regulator consumer before trying to register it's own regulator device. 

sgtl5000 0-000a: Failed to get supply 'VDDD': -19

While if an external supply is used for VDDD, in the DT file, all the three "VDDA-supply", "VDDIO-supply" and "VDDD-supply" properties can absent, by just using the dummy regulator. 

IMO, the failed log will confuse most people(especially for those not familiar with the SGTL5000 driver) that why getting the 'VDDD' supply failed but it still works? or is there something wrong with it ? ,etc.


Yes, this is a buggy patch, and I will revise it later.


--
Best Regards,




