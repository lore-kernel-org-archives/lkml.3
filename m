Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaIXMDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:03:52 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40750 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752722AbaIXMDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:03:51 -0400
Date: Wed, 24 Sep 2014 13:03:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Jingchang Lu <jingchang.lu@freescale.com>, vinod.koul@intel.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3] dmaengine: fsl-edma: fixup reg offset and hw S/G
	support in big-endian model
Message-ID: <20140924120338.GW5182@n2100.arm.linux.org.uk>
References: <1411550642-12577-1-git-send-email-jingchang.lu@freescale.com> <20140924130510.62d78440@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140924130510.62d78440@ipc1.ka-ro>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 01:05:10PM +0200, Lothar Waßmann wrote:
> Hi,
> 
> Jingchang Lu wrote:
> > +	 * eDMA hardware SGs requires the TCDs to be auto loaded
> > +	 * in the little endian whenver the register endian model,
> "in little endian whatever the register endian model"

Even that took several reads to work it out.

	eDMA hardware SGs require the TCDs to be stored in little endian
	format irrespective of the register endian model.

and I think that's all that needs to be said here.

However, as I realdy suggested, running this ruddy thing through sparse
would be a /very/ good idea, because it'll warn with:

+       tcd->daddr = cpu_to_le32(dst);

The reason it'll warn on that is because daddr is not declared with
__le32, etc - the types used in struct fsl_edma_hw_tcd tell sparse that
the values to be stored there are in _host_ endian format, but they're
being assigned little endian formatted data.

> > +	 * for fsl_set_tcd_params doing the swap.
> fsl_set_tcd_params()

That's the wrong function name anyway.  It's fsl_edma_set_tcd_params().

However, let's look at this a little more:

        fsl_edma_set_tcd_params(fsl_chan, tcd->saddr, tcd->daddr, tcd->attr,
                        tcd->soff, tcd->nbytes, tcd->slast, tcd->citer,
                        tcd->biter, tcd->doff, tcd->dlast_sga, tcd->csr);

Is it /really/ a good idea to read all that data out of the structure,
only to then have most of it saved into the stack, which
fsl_edma_set_tcd_params() then has to read back off the stack again?
With stuff like this, one has to wonder if there is much clue how to
write optimal C code in this driver.

This should be passing the tcd structure into fsl_edma_set_tcd_params().

Now, this function contains this comment:

        /*
         * TCD parameters have been swapped in fill_tcd_params(),
         * so just write them to registers in the cpu endian here
         */

Which is almost reasonable, but let's update it:

	TCD parameters are stored in struct fsl_edma_hw_tcd in little
	endian format.  However, we need to load the registers in
	<insert appropriate endianness - big|little|cpu> endian.

Now, remember that writel() and friends expect native CPU endian formatted
data (and yes, sparse checks this too) so that needs to be considered more.

Lastly, the driver seems to be a total mess of accessors.  In some places
it uses io{read,write}*, in other places, it uses plain {read,write}*.  It
should use either one set or the other set, and not mix these two.

I just spotted this badly formatted code too:

        for (i = 0; i < fsl_desc->n_tcds; i++)
                        dma_pool_free(fsl_desc->echan->tcd_pool,
                                        fsl_desc->tcd[i].vtcd,
                                        fsl_desc->tcd[i].ptcd);
...
                edma_writeb(fsl_chan->edma,
                                EDMAMUX_CHCFG_ENBL | EDMAMUX_CHCFG_SOURCE(slot),
                                muxaddr + ch_off);

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
