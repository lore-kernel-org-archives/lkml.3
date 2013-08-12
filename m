Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab3HLLXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 07:23:49 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:32858 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab3HLLXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 07:23:46 -0400
Message-ID: <52087824.60002@ti.com>
Date: Mon, 12 Aug 2013 11:22:36 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Joel Fernandes <joelf@ti.com>
CC: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Mark Brown <broonie@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Balaji TK <balajitk@ti.com>,
        Gururaja Hebbar <gururaja.hebbar@ti.com>, Chris Ball <cjb@laptop.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v3 07/12] dma: edma: Add function to dump a PaRAM set
 from PaRAM
References: <1375719297-12871-1-git-send-email-joelf@ti.com> <1375719297-12871-8-git-send-email-joelf@ti.com>
In-Reply-To: <1375719297-12871-8-git-send-email-joelf@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 August 2013 09:44 PM, Joel Fernandes wrote:
> Previously, such a dump function was used but it wasn't reading
> from the PaRAM, rather just from a edmacc_param structure, we
> add a helpful function for debugging that directly reads from
> the PaRAM and gives the current state correctly (including links
> and interrupt information).
> 
> Signed-off-by: Joel Fernandes <joelf@ti.com>

You should convert existing instances of PaRAM set dump to use this new
function along with introducing it.

Thanks,
Sekhar

> ---
>  drivers/dma/edma.c |   31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
> index 080d669..a242269 100644
> --- a/drivers/dma/edma.c
> +++ b/drivers/dma/edma.c
> @@ -102,6 +102,37 @@ static void edma_desc_free(struct virt_dma_desc *vdesc)
>  	kfree(container_of(vdesc, struct edma_desc, vdesc));
>  }
>  
> +static inline void dump_pset(struct edma_chan *echan, int slot,
> +		     struct edmacc_param *pset_unused, int pset_idx)
> +{
> +	struct edmacc_param pset_local, *pset;
> +	pset = &pset_local;
> +
> +	edma_read_slot(slot, pset);
> +
> +	dev_dbg(echan->vchan.chan.device->dev,
> +		"\n pset[%d]:\n"
> +		"  chnum\t%d\n"
> +		"  slot\t%d\n"
> +		"  opt\t%08x\n"
> +		"  src\t%08x\n"
> +		"  dst\t%08x\n"
> +		"  abcnt\t%08x\n"
> +		"  ccnt\t%08x\n"
> +		"  bidx\t%08x\n"
> +		"  cidx\t%08x\n"
> +		"  lkrld\t%08x\n",
> +		pset_idx, echan->ch_num, slot,
> +		pset[0].opt,
> +		pset[0].src,
> +		pset[0].dst,
> +		pset[0].a_b_cnt,
> +		pset[0].ccnt,
> +		pset[0].src_dst_bidx,
> +		pset[0].src_dst_cidx,
> +		pset[0].link_bcntrld);
> +}
> +
>  /* Dispatch a queued descriptor to the controller (caller holds lock) */
>  static void edma_execute(struct edma_chan *echan)
>  {
> 

