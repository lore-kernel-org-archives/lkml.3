Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbaIVROA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:14:00 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:51243 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213AbaIVRN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:13:57 -0400
Date: Mon, 22 Sep 2014 11:13:38 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Scot Doyle <lkml14@scotdoyle.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Luigi Semenzato <semenzato@google.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v8] tpm_tis: verify interrupt during init
Message-ID: <20140922171338.GB28082@obsidianresearch.com>
References: <20140827214743.GC11183@obsidianresearch.com>
 <alpine.LNX.2.11.1408280017420.1064@localhost.localdomain>
 <20140828165348.GE11183@obsidianresearch.com>
 <alpine.LNX.2.11.1408290234060.1020@localhost.localdomain>
 <20140830174920.GA26218@obsidianresearch.com>
 <alpine.LNX.2.11.1408302229001.579@localhost.localdomain>
 <20140902172015.GD13956@obsidianresearch.com>
 <alpine.LNX.2.11.1409021954110.1026@localhost.localdomain>
 <20140908220238.GB6204@obsidianresearch.com>
 <alpine.LNX.2.11.1409110010290.700@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.11.1409110010290.700@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 12:50:00AM +0000, Scot Doyle wrote:
> 
> On Mon, 8 Sep 2014, Jason Gunthorpe wrote:
> > On Tue, Sep 02, 2014 at 08:22:58PM +0000, Scot Doyle wrote:
> >
> >> It's spending that time (now 3 seconds) in tpm_tis_send_data.
> >
> > Due to request_locality?
> 
> The first command transmitted (TPM_CAP_PROP) in tpm_get_timeouts goes 
> through tpm_tis_send which calls tpm_tis_send_data before setting up 
> polling mode for the interrupt test. In tpm_tis_send_data, the last call 
> to wait_for_tpm_stat is still timing out.
> 
> One solution would be to move the test from tpm_tis_send to 
> tpm_tis_send_data. Another would be to expand the test in tpm_tis_send to 
> include the call to tpm_tis_send_data.
> 
> The latter seems safer, since it provides more opportunity for an IRQ to 
> be generated. E.g. I'm not sure if TPM_CAP_PROP always generates an IRQ. 
> But the problem with this approach is that tpm_tis_send becomes a bit 
> messy. So this patch wraps tpm_tis_send in an attempt to keep the code 
> clean. (Is there a better name for the wrapped function than 
> tpm_tis_send_main?)

This does look much nicer, lets use this version.

I think Peter were prefer a new clean patch that superceeds the
original.

> +	if (!priv->irq_tested) {

I think the sleep and check is still needed here, the IRQ delivery
could race relative to the MMIO read of completion, a sleep is the
only way we could attempt to synchronize them..

> +		disable_interrupts(chip);
> +		dev_err(chip->dev,
> +			FW_BUG "TPM interrupt not working, polling instead\n");
> +	}
> +	priv->irq_tested = true;
> +	return rc;
> +}

Thanks,
Jason
