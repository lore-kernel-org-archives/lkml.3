Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbaIBRUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:20:32 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:39598 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbaIBRUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:20:31 -0400
Date: Tue, 2 Sep 2014 11:20:15 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Scot Doyle <lkml14@scotdoyle.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Luigi Semenzato <semenzato@google.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v5] tpm_tis: verify interrupt during init
Message-ID: <20140902172015.GD13956@obsidianresearch.com>
References: <20140825182414.GB1298@obsidianresearch.com>
 <alpine.LNX.2.11.1408270410190.701@localhost.localdomain>
 <20140827173142.GA11183@obsidianresearch.com>
 <alpine.LNX.2.11.1408271755470.4371@localhost.localdomain>
 <20140827214743.GC11183@obsidianresearch.com>
 <alpine.LNX.2.11.1408280017420.1064@localhost.localdomain>
 <20140828165348.GE11183@obsidianresearch.com>
 <alpine.LNX.2.11.1408290234060.1020@localhost.localdomain>
 <20140830174920.GA26218@obsidianresearch.com>
 <alpine.LNX.2.11.1408302229001.579@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.11.1408302229001.579@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 11:23:56PM +0000, Scot Doyle wrote:
> On Sat, 30 Aug 2014, Jason Gunthorpe wrote:
> 
> > On Fri, Aug 29, 2014 at 11:59:32PM +0000, Scot Doyle wrote:
> >
> >> I tried calling tpm_get_timeouts only during the interrupt test, but again
> >> was timed out after 30 seconds. The interrupt wait in tis_send calls
> >> tpm_calc_ordinal_duration, which uses a default timeout of two minutes
> >> when chip->vendor.duration[duration_idx] hasn't been set. Thus the second
> >> call to tpm_get_timeouts in tpm_tis_init.
> >
> > So the strategy is to read the timeouts and hope that the chip reports
> > something small and reasonable, then do a second read?
> >
> > Seems reasonable, but with this new arrangement we could also use an
> > alternate polling logic for 'testing_int' that did the normal polling
> > loop unconditionally and then checked if the interrupt was
> > delivered. This would give a minimal dealy.
> 
> I like the idea. And then tpm_do_selftest could be used for the interrupt 
> verification instead of a second tpm_get_timeouts?

Yes, or the first tpm_get_timeouts can be used - Long term I would
like to see the entire tpm_get_timeouts,self_test,startup, etc
sequence moved into core code, so I don't really want to see drivers
splitting the sequence up.

Ideally the driver will just automatically test the IRQ on the very
first command it executes. That is now a very small easy step, so lets
just do that..

> The output is now
> [    1.526798] tpm_tis 00:08: 1.2 TPM (device-id 0xB, rev-id 16)
> [    5.914732] tpm_tis 00:08: [Firmware Bug]: TPM interrupt not working, polling instead

Cool, why did it take 4 seconds though?
 
> +struct priv_data {
> +	int test_irq;

Probably don't need this...

> @@ -358,13 +379,27 @@ static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
>

And this can probably just become:

bool test_irq = priv->int_count == 0;
int oldirq = chip->vendor.irq;

> +	((struct priv_data*)chip->vendor.priv)->int_count++;

.. Seems like there was no need for it to count, this can just be =
true?

> -	if (tpm_do_selftest(chip)) {
> -		dev_err(dev, "TPM self test failed\n");
> -		rc = -ENODEV;
> -		goto out_err;
> -	}

And move tpm_get_timeouts down too.. Keep the sequence together.

Looks really good to me, I can try and test the next version here this
week.

Jason
