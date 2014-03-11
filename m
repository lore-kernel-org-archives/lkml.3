Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbaCKLeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 07:34:07 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:43591
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753018AbaCKLeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 07:34:04 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI154dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
Date: Tue, 11 Mar 2014 19:11:51 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "brian.austin@cirrus.com" <brian.austin@cirrus.com>,
        "Paul.Handrigan@cirrus.com" <Paul.Handrigan@cirrus.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "lars@metafoo.de" <lars@metafoo.de>
Subject: Re: [PATCH v2] ASoC: cs42888: Add codec driver support
Message-ID: <20140311111150.GB799@MrMyself>
References: <1394536791-8381-1-git-send-email-Guangyu.Chen@freescale.com>
 <20140311113053.GA1036@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140311113053.GA1036@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 11:30:53AM +0000, Mark Rutland wrote:
> On Tue, Mar 11, 2014 at 11:19:51AM +0000, Nicolin Chen wrote:
> > This patch adds support for the Cirrus Logic CS42888 Audio CODEC that
> > has four 24-bit A/D and eight 24-bit D/A converters.
> > 
> > [ CS42888 supports both I2C and SPI control ports. As initial patch,
> >   this patch only adds the support for I2C. ]
> > 
> > Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
> > ---
> > 
> > Changelog
> > v2:
> >  * Separated driver into I2C and main part drivers.
> >  * Added error out if failed to get clock.
> >  * Enabled Auto-mute function as default.
> >  * Disabled runtime-pm in remove().
> >  * Added return value checking for regcache_sync().
> >  * Fixed some trival parts like 'const' as Lars mentioned.
> > 
> >  .../devicetree/bindings/sound/cs42888.txt          |  27 ++
> >  sound/soc/codecs/Kconfig                           |  10 +
> >  sound/soc/codecs/Makefile                          |   4 +
> >  sound/soc/codecs/cs42888-i2c.c                     |  68 +++
> >  sound/soc/codecs/cs42888.c                         | 536 +++++++++++++++++++++
> >  sound/soc/codecs/cs42888.h                         | 213 ++++++++
> >  6 files changed, 858 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/sound/cs42888.txt
> >  create mode 100644 sound/soc/codecs/cs42888-i2c.c
> >  create mode 100644 sound/soc/codecs/cs42888.c
> >  create mode 100644 sound/soc/codecs/cs42888.h
> > 
> > diff --git a/Documentation/devicetree/bindings/sound/cs42888.txt b/Documentation/devicetree/bindings/sound/cs42888.txt
> > new file mode 100644
> > index 0000000..7736527
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/sound/cs42888.txt
> > @@ -0,0 +1,27 @@
> > +CS42888 audio CODEC
> > +
> > +Required properties:
> > +
> > +  - compatible : "cirrus,cs42888"
> > +
> > +  - reg : the I2C address of the device for I2C
> > +
> > +  - clocks : phandle to the clock source for MCLK
> > +
> > +  - clock-names : must contain "mclk".
> 
> If you use clock-names, please define the clocks property in terms of
> clock-names to avoid redundancy. e.g.
> 
> - clocks: a list of phandles + clock-specifiers, one for each entry in
>   clock-names.
> 
> It makes the relationship between the two clearer, and makes it far
> easier to alter the binding in future if required.

Thank you for the quick reply.

Will fix it in a minute.

Best regards,
Nicolin Chen


