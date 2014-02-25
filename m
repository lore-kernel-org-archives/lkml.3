Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbaBYCuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 21:50:09 -0500
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:53133
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753183AbaBYCuD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 21:50:03 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371Ic89bh1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839h93fhd25hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh1155h)
Date: Tue, 25 Feb 2014 10:32:21 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: "Austin, Brian" <Brian.Austin@cirrus.com>
CC: Mark Brown <broonie@kernel.org>,
        "Handrigan, Paul" <Paul.Handrigan@cirrus.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH] ASoC: cs42888: Add codec driver support
Message-ID: <20140225023219.GA7229@MrMyself>
References: <1393224929-7555-1-git-send-email-Guangyu.Chen@freescale.com>
 <20140224113011.GE25940@sirena.org.uk>
 <B745DBDD-8A64-4B98-819B-72F8AFF602DE@cirrus.com>
 <20140224160648.GC6132@MrMyself>
 <FF523989-CEF7-4A91-92A0-63D5FB90D897@cirrus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <FF523989-CEF7-4A91-92A0-63D5FB90D897@cirrus.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 04:32:06PM +0000, Austin, Brian wrote:
> 
> On Feb 24, 2014, at 10:06 AM, Nicolin Chen <Guangyu.Chen@freescale.com> wrote:
> 
> > On Mon, Feb 24, 2014 at 03:52:24PM +0000, Austin, Brian wrote:
> >>>> +	if (!IS_ERR(cs42888->clk))
> >>>> +		clk_disable_unprepare(cs42888->clk);
> >>> 
> >>> Does the device work without MCLK?
> >> Yes, MCLK is required. If you can’t get the clock you should error out.
> > 
> > Wait...Regarding this clock part, I just forgot the reason I put the code:
> > 
> > 385         cs42888->clk = devm_clk_get(&i2c->dev, "mclk");
> > 386         if (IS_ERR(cs42888->clk))
> > 387                 dev_warn(&i2c->dev, "failed to get the clock: %ld\n",
> > 388                                 PTR_ERR(cs42888->clk));
> > 
> > was because the MCLK might be provided from SoC (DAI master) so it could
> > be totally controlled by CPU DAI driver, ESAI for example has its own
> > dividers to derive the HCKT clock (MCLK for Tx) from ahb clock in SoC
> > clock tree, in which case we might not easily pass a valid clock phandle
> > via DT. (RFC to this thought.)
> OK, It’s an external MCLK source, so why not just handle that in the machine driver? 
> Usually you would want the clock enabled/disabled in the machine driver so if you don’t get it, you can bail out there. 
> At least that is how I do our MCLK’s. Since you are only using the freq of the clock to derive modes, just put the clock initialization outside and just pass in the freq like you do in set_sysclk

Letting codec handle the clock here is trying to en/disable it only when using
it -- pm_runtime_resume/suspend() so that we can save power during idle states,
while putting it into machine driver, quite common in lots of machine drivers
though, would need us to enable it in the probe(), otherwise machine driver
can't finish the clock enabling before codec driver's pm_runtime_resume() as
pm_runtime_get_sync(codec_dai->dev) is almost the head of soc_pcm_open().

At first place, I did let this codec driver be totally exempt from this clock
handling. And it's quite fair and neat to do that in the machine driver till
this second thought came to me....

Thank you,
Nicolin Chen


