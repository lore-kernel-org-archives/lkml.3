Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbaLBKgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 05:36:46 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52186 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbaLBKgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 05:36:43 -0500
Date: Tue, 2 Dec 2014 11:36:40 +0100
From: Borislav Petkov <bp@alien8.de>
To: punnaiah choudary kalluri <punnaia@xilinx.com>
Cc: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>,
        dougthompson@xmission.com,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-edac@vger.kernel.org,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Punnaiah Choudary <kpc528@gmail.com>
Subject: Re: [PATCH v6] edac: synps: Added EDAC support for zynq ddr ecc
 controller
Message-ID: <20141202103640.GB14649@pd.tnic>
References: <a1c485c3bb214d5699fdbfc6180f96f8@BN1AFFO11FD044.protection.gbl>
 <20141201182611.GA4169@pd.tnic>
 <CAGnW=BaRuZvFYCz0=s_ENn_sbH4YPxZiHt1x4GvRcUAyO0s+Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGnW=BaRuZvFYCz0=s_ENn_sbH4YPxZiHt1x4GvRcUAyO0s+Jw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 10:51:22AM +0530, punnaiah choudary kalluri wrote:
> >> +/**
> >> + * synps_edac_get_eccstate - Return the controller ecc enable/disable status
> >> + * @base:    Pointer to the ddr memory contoller base address
> >> + *
> >> + * This routine returns the ECC enable/disable status for the controller
> >> + *
> >> + * Return: a ecc status boolean i.e true/false - enabled/disabled.
> >> + */
> >> +static bool synps_edac_get_eccstate(void __iomem *base)
> >> +{
> >> +     enum dev_type dt;
> >> +     u32 ecctype;
> >> +     bool state = false;
> >> +
> >> +     dt = synps_edac_get_dtype(base);
> >> +     if (dt == DEV_UNKNOWN)
> >> +             return state;
> >> +
> >> +     ecctype = readl(base + SCRUB_OFST) & SCRUB_MODE_MASK;
> >> +
> >> +     if ((ecctype == SCRUB_MODE_SECDED) && (dt == DEV_X2)) {
> >> +             state = true;
> >> +             writel(0x0, base + ECC_CTRL_OFST);
> >
> > Out of curiosity, why is that register write needed here? Maybe
> > forgotten? It looks unbalanced...
> 
> This is needed to start capturing the correctable and uncorrectable errors.
> Writing 1 to this register bits will clear the counters and writing 0 will start
> the counters.

So this definitely doesn't belong here then.

It should be the *last* thing you do after having initialized the whole
driver entirely and successfully and you're ready to start logging
errors.

Now you're calling it in synps_edac_mc_probe() so the counters will
start before you have even initialized the rest of the driver.

What is worse, if one of those things you do on the init path fails, you
enter prematurely and the counters are still running. Not good.

> It is crossing 80 cols. so, there is line break here. I feel the other
> way as the check patch throws warning for this.

And I'm saying you shouldn't follow checkpatch to the letter and think
for yourself instead.

What do you think is more readable?

This:

                       dimm = csi->channels[j]->dimm;
                       dimm->edac_mode = EDAC_FLAG_SECDED;
                       dimm->mtype = synps_edac_get_mtype(priv->baseaddr);
                       dimm->nr_pages =
                           (size >> PAGE_SHIFT) / csi->nr_channels;
                       dimm->grain = SYNPS_EDAC_ERR_GRAIN;
                       dimm->dtype = synps_edac_get_dtype(priv->baseaddr);

or this:

                       dimm		= csi->channels[j]->dimm;
                       dimm->mtype	= synps_edac_get_mtype(priv->baseaddr);
                       dimm->grain	= SYNPS_EDAC_ERR_GRAIN;
                       dimm->dtype	= synps_edac_get_dtype(priv->baseaddr);
                       dimm->nr_pages	= (size >> PAGE_SHIFT) / csi->nr_channels;
                       dimm->edac_mode	= EDAC_FLAG_SECDED;

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
