Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935465AbaH0Rb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:31:57 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:57288 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933914AbaH0Rb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:31:56 -0400
Date: Wed, 27 Aug 2014 11:31:42 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Scot Doyle <lkml14@scotdoyle.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Luigi Semenzato <semenzato@google.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2] tpm_tis: verify interrupt during init
Message-ID: <20140827173142.GA11183@obsidianresearch.com>
References: <alpine.LNX.2.11.1408220043560.1360@localhost.localdomain>
 <20140822160626.GA8477@obsidianresearch.com>
 <alpine.LNX.2.11.1408221924070.1046@localhost.localdomain>
 <20140822203241.GB1733@obsidianresearch.com>
 <alpine.LNX.2.11.1408250629110.1207@localhost.localdomain>
 <20140825182414.GB1298@obsidianresearch.com>
 <alpine.LNX.2.11.1408270410190.701@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.11.1408270410190.701@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 04:31:56AM +0000, Scot Doyle wrote:
> > I think you'll have to directly test in the tis driver if the
> > interrupt is working.
> >
> > The ordering in the TIS driver is wrong, interrupts should be turned
> > on before any TPM commands are issued. This is what other drivers are
> > doing.
> >
> > If you fix this, tis can then just count interrupts recieved and check
> > if that is 0 to detect failure and then turn them off.
> 
> How about something like this?
> 
> It doesn't enable stock SeaBIOS machines to suspend/resume before the 30 
> second interrupt timeout, unless using interrupts=0 or force=1.

? Can you explain that a bit more? interrupts should be detected off
by suspend/resume time, surely?

> +static bool interrupted = false;
> +

This needs to be stored in the private data.

>  static irqreturn_t tis_int_handler(int dummy, void *dev_id)
>  {
>  	struct tpm_chip *chip = dev_id;
> @@ -511,6 +513,8 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
>  		for (i = 0; i < 5; i++)
>  			if (check_locality(chip, i) >= 0)
>  				break;
> +	if (interrupt & TPM_INTF_CMD_READY_INT)
> +		interrupted = true;

Hmm, I'd think any interrupt will do for this purpose, drop the if?

> -	if (tpm_do_selftest(chip)) {
> -		dev_err(dev, "TPM self test failed\n");
> -		rc = -ENODEV;
> -		goto out_err;
> -	}

Move gettimeout too

> -	if (chip->vendor.irq) {
> +	if (interrupts && chip->vendor.irq) {

Unrelated? Looks unnecessary:

        if (!interrupts) {
                irq = 0;

        chip->vendor.irq = irq;

        if (chip->vendor.irq) {

> +	/* Test interrupt and/or prepare for later save state */
> +	interrupted = false;
> +	if (tpm_do_selftest(chip)) {

As you pointed out before, the commands don't actually fail if
interrupts are not enabled, they just take a longer time to complete.

So this should just be:

if (!tpm_get_timeouts(chip))
   goto ..failed..;

if (!dev->interrupts) {
			/* Turn off interrupt */
			iowrite32(intmask,
				  chip->vendor.iobase +
				  TPM_INT_ENABLE(chip->vendor.locality));
			free_irq(chip->vendor.irq, chip);
			chip->vendor.irq = 0;
dev_err(dev, FIRMWARE_BUG "TPM interrupt is not working, polling instead\n");

// No retry needed, the command completed already.
}

Jason
