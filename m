Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965033AbaH0VsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:48:09 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:49787 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932246AbaH0VsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:48:07 -0400
Date: Wed, 27 Aug 2014 15:47:43 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Scot Doyle <lkml14@scotdoyle.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Luigi Semenzato <semenzato@google.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3] tpm_tis: verify interrupt during init
Message-ID: <20140827214743.GC11183@obsidianresearch.com>
References: <alpine.LNX.2.11.1408220043560.1360@localhost.localdomain>
 <20140822160626.GA8477@obsidianresearch.com>
 <alpine.LNX.2.11.1408221924070.1046@localhost.localdomain>
 <20140822203241.GB1733@obsidianresearch.com>
 <alpine.LNX.2.11.1408250629110.1207@localhost.localdomain>
 <20140825182414.GB1298@obsidianresearch.com>
 <alpine.LNX.2.11.1408270410190.701@localhost.localdomain>
 <20140827173142.GA11183@obsidianresearch.com>
 <alpine.LNX.2.11.1408271755470.4371@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.11.1408271755470.4371@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 09:32:10PM +0000, Scot Doyle wrote:

> If suspend/resume occur before falling back to polling mode (within 30 
> seconds after module load), then the machine freezes on resume because 
> the module is waiting on the interrupts.

Okay, this is just a specific case of the broader TPM bug: the tpm
driver is registered with the system before it is actually ready to
drive the TPM.
 
> >> -    if (tpm_do_selftest(chip)) {
> >> -            dev_err(dev, "TPM self test failed\n");
> >> -            rc = -ENODEV;
> >> -            goto out_err;
> >> -    }
> >
> > Move gettimeout too
> 
> Can it be moved? It sends startup(clear) if the TPM isn't yet operational.

To move it means we have to understand why you are getting timeouts:

[   33.247720] tpm_tis 00:08: tpm_transmit: tpm_send: error -62
[   33.247731] tpm_tis 00:08: [Hardware Error]: TPM command timed out during continue self test

I had thought based on your other patch that these should not happen
since the raw register is polled after the timer expires?

What is going on here? Do you still have that other patch applied?

> 
> >> -    if (chip->vendor.irq) {
> >> +    if (interrupts && chip->vendor.irq) {
> >
> > Unrelated? Looks unnecessary:
> >
> >        if (!interrupts) {
> >                irq = 0;
> >
> >        chip->vendor.irq = irq;
> >
> >        if (chip->vendor.irq) {
> 
> Setting chip->vendor.irq would erase any we just found in probing?

Sorry, I ment the code I clipped is already present in the driver, in
that order, so the change is a NOP.

> Right, the TPM commands don't fail, but tpm_get_timeouts does. I've 
> simplified the section in this version.

I'm not quite sure what that means, but..

The reason you want to use tpm_get_timeouts to test the IRQ is because
it has a very short timeout. self test has one of the longest
timeouts, so it is not the best choice.

What I was hoping to see, is that get_timeouts would hit the timer, do
the final read of the completion register, complete normally, then the
tis driver would see successful completion with no IRQ and turn them
off.

Is that doable?

> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index e4d0888..6747a47 100644
> +++ b/drivers/char/tpm/tpm.h
> @@ -69,6 +69,7 @@ struct tpm_vendor_specific {
> 
>  	int irq;
>  	int probed_irq;
> +	bool int_received;

Ugh, yes, right, tis doesn't have its own driver private structure
yet.

Please add a comment 'FIXME: belongs in tpm_tis driver private data'

Or, better, add a driver private structure to hold this data.

Jason
