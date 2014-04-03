Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbaDCPnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:43:46 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:37570
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752674AbaDCPnf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:43:35 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zzbb2dI98dI9371Ic89bh936eI1432Izz1f42h2148h1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzzz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25f6h2605h268bh26d3h906i2673i1155h)
Date: Thu, 3 Apr 2014 08:42:43 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <monstr@monstr.eu>
CC: Wolfram Sang <wsa@the-dreams.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Mike Looijmans <mike.looijmans@topic.nl>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-doc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, Harini Katakam <harinik@xilinx.com>
Subject: Re: [PATCH v3 1/2] i2c: Add driver for Cadence I2C controller
References: <1394556613-11692-1-git-send-email-soren.brinkmann@xilinx.com>
 <533CF913.4020308@monstr.eu>
 <20140403071004.GA2571@katana>
 <533D0CFB.7050707@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <533D0CFB.7050707@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <d3723b56-61d7-4983-a5d5-6c885c0e9a8e@CH1EHSMHS002.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-03 at 09:25AM +0200, Michal Simek wrote:
> On 04/03/2014 09:10 AM, Wolfram Sang wrote:
> > 
> > Please don't quote large parts of the message f you are not referring to
> > it.
> 
> Normally I do it. Forgot sorry.
> 
> >>> +#ifdef CONFIG_PM_SLEEP
> >>> +/**
> >>> + * cdns_i2c_suspend - Suspend method for the driver
> >>> + * @_dev:	Address of the platform_device structure
> >>> + * Return: 0 always
> >>> + *
> >>> + * Put the driver into low power mode.
> >>> + */
> >>> +static int cdns_i2c_suspend(struct device *_dev)
> >>> +{
> >>> +	struct platform_device *pdev = container_of(_dev,
> >>> +			struct platform_device, dev);
> >>> +	struct cdns_i2c *xi2c = platform_get_drvdata(pdev);
> >>> +
> >>> +	clk_disable(xi2c->clk);
> >>> +	xi2c->suspended = 1;
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +
> >>> +/**
> >>> + * cdns_i2c_resume - Resume from suspend
> >>> + * @_dev:	Address of the platform_device structure
> >>> + * Return: 0 on success and error value on error
> >>> + *
> >>> + * Resume operation after suspend.
> >>> + */
> >>> +static int cdns_i2c_resume(struct device *_dev)
> >>> +{
> >>> +	struct platform_device *pdev = container_of(_dev,
> >>> +			struct platform_device, dev);
> >>> +	struct cdns_i2c *xi2c = platform_get_drvdata(pdev);
> >>> +	int ret;
> >>> +
> >>> +	ret = clk_enable(xi2c->clk);
> >>> +	if (ret) {
> >>> +		dev_err(_dev, "Cannot enable clock.\n");
> >>> +		return ret;
> >>> +	}
> >>> +
> >>> +	xi2c->suspended = 0;
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +#endif
> >>
> >> Can you also please remove this #ifdef and use __maybe_used
> >> instead? Better not to have any ifdef in the code.
> > 
> > Is this a new pattern? For PM_SLEEP, #ifdef seems to be quite common.
> 
> The first suggestion to do it came from CAN maintainer.
> It is valid in general for ifdef.
> I have checked all our drivers and we are changing them to use __maybe_used
> because then we can easily find out if there is any problem
> when function prototype has changed.

I already have that change in my current version. I hope to send v4 to the list
soon.

	Sören


