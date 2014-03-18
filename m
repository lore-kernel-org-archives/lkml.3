Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaCRFWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 01:22:47 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:12782
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751083AbaCRFWn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 01:22:43 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI9371I542I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h1de097hz2fh95h109h839h944hc61hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2216h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25f6h2605h262fh906i1155h)
From: Harini Katakam <harini.katakam@xilinx.com>
To: Mark Brown <broonie@kernel.org>, Josh Cartwright <joshc@codeaurora.org>
CC: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        Michal Simek <michals@xilinx.com>
Subject: RE: [PATCH] SPI: Add driver for Cadence SPI controller
Thread-Topic: [PATCH] SPI: Add driver for Cadence SPI controller
Thread-Index: AQHPQdlDwreFYNSC5UqDMedDfaXPCprlA1GAgAAIE4CAAARTAIABP7wA
Date: Tue, 18 Mar 2014 05:22:37 +0000
References: <1395057936-8643-1-git-send-email-harinik@xilinx.com>
 <20140317173017.GW11706@sirena.org.uk>
 <20140317175911.GU18529@joshc.qualcomm.com>
 <20140317181440.GY11706@sirena.org.uk>
In-Reply-To: <20140317181440.GY11706@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.95.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <554ccbca-f92e-454c-90c0-b8a4ddddf3fd@CH1EHSMHS001.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: Monday, March 17, 2014 11:45 PM
> To: Josh Cartwright
> Cc: Harini Katakam; robh+dt@kernel.org; pawel.moll@arm.com;
> mark.rutland@arm.com; ijc+devicetree@hellion.org.uk;
> galak@codeaurora.org; rob@landley.net; grant.likely@linaro.org;
> devicetree@vger.kernel.org; linux-doc@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-spi@vger.kernel.org; Michal Simek
> Subject: Re: [PATCH] SPI: Add driver for Cadence SPI controller
> 
> On Mon, Mar 17, 2014 at 12:59:11PM -0500, Josh Cartwright wrote:
> > On Mon, Mar 17, 2014 at 05:30:17PM +0000, Mark Brown wrote:
> > > On Mon, Mar 17, 2014 at 05:35:36PM +0530, Harini Katakam wrote:
> 
> > > > +static int __maybe_unused cdns_spi_suspend(struct device *dev) {
> 
> > > This needs to call spi_master_suspend() as well (and similarly on
> > > resume).
> 
> > I'm not that familiar with the SPI core, but this seems like an
> > inversion.  Is there a reason why the SPI master class doesn't
> > implement
> > suspend/resume() callbacks which handle stopping/starting the queue
> > automatically for all masters?
> 
> This is for users of an optional feature of the infrastructure.  We probably
> should just call it anyway since it does have checks for the feature being
> used (but given all the open coding around this stuff I'd need to verify that
> the class callbacks would reliably get called).
> 
> In any case that's not happening now and the driver as it stands is buggy
> since it's trampling all over the hardware without syncing with anything that
> isn't ongoing.

In case of a suspend, we are stopping an ongoing transfer and disabling the interface.
In case I add clock disable and anything else to unprepared too, it will be a cleaner 
exit but it will still stop the transfer right? What do you suggest?
Should we wait for transfer to complete or a timeout to occur?

Regards,
Harini


