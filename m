Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab3EJMjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 08:39:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:31478 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583Ab3EJMjr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 08:39:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,647,1363158000"; 
   d="scan'208";a="331936052"
Message-ID: <518CEA90.8080203@intel.com>
Date: Fri, 10 May 2013 14:39:44 +0200
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Flater <vger@flaterco.com>
CC: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v2 RESEND] pnp: restore automatic resolution of DMA conflicts
References: <517D915F.4060103@flaterco.com>
In-Reply-To: <517D915F.4060103@flaterco.com>
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/28/2013 11:15 PM, David Flater wrote:
> From: David Flater <dave@flaterco.com>
>
> To fix a 5-year-old regression, reverse the changes made in the
> following commit:
>
> commit 7ef36390fabe2168fe31f245e49eb4e5f3762622
> Author: Jan Beulich <jbeulich@novell.com>
> Date:   Tue Oct 16 23:31:07 2007 -0700
>
>      PNP: don't fail device init if no DMA channel available
>      
>      Most drivers for devices supporting ISA DMA can operate without
>      DMA as well (falling back zo PIO).  Thus it seems inappropriate
>      for PNP to fail device initialization in case none of the possible
>      DMA channels are available.  Instead, it should be left to the
>      driver to decide what to do if request_dma() fails.
>      
>      The patch at once adjusts the code to account for the fact that
>      pnp_assign_dma() now doesn't need to report failure anymore.
>
> As an example to show the problem, my sound card provides a
> prioritized list of PnP "dependent sets" of requested resources:
>
>    dependent set 0 (preferred) wants DMA 5.
>    dependent set 1 (acceptable) will take DMA 5, 6, or 7.
>    ...
>    dependent set 4 (acceptable) doesn't request a high DMA.
>
> If DMA 5 is not available, pnp_assign_dma has to fail on set 0 so that
> pnp_auto_config_dev will move on to set 1 and get DMA 6 or 7.
> Instead, pnp_assign_dma adds the resource with flags |=
> IORESOURCE_DISABLED and returns success.  pnp_auto_config_dev just
> sees success and therefore chooses set 0 with a disabled DMA and never
> tries the sets that would have resolved the conflict.
>
> Furthermore, this mode of "success" is unexpected and unhandled in
> sound/isa/sb and probably other drivers.  sb assumes that the returned
> DMA is enabled and obliviously uses the invalid DMA number.  Observed
> consequences were sb successfully grabbing a DMA that was expressly
> forbidden by the kernel parameter pnp_reserve_dma.
>
> The only upside to the original change would be as a kludge for
> devices that can operate in degraded mode without a DMA but that don't
> provide the corresponding non-preferred dependent set.  The right
> workaround for those devices is to synthesize the missing set in
> quirks.c; otherwise, you're reinventing PnP fallback functionality at
> the driver level for that device and all others.
>
> Signed-off-by: David Flater <dave@flaterco.com>
> Cc: Jaroslav Kysela <perex@perex.cz>
> Cc: Bjorn Helgaas <bhelgaas@google.com>

OK, tentatively queued up as v3.11 material.

Thanks,
Rafael


> ---
> History
> 2013-04-28  No feedback.  Resent v2 to new maintainer and LKML.
> 2013-03-28  v2: missed a spot (add back handling of empty map as really
>              disabled).
> 2013-03-28  Orig sent to LKML and maintainers of record.
>
> This patch still applies to the current git kernel.
> The affected file was last modified 2012-12-15.
>
>   drivers/pnp/manager.c | 14 +++++++++-----
>   1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/pnp/manager.c b/drivers/pnp/manager.c
> index 95cebf0..9357aa7 100644
> --- a/drivers/pnp/manager.c
> +++ b/drivers/pnp/manager.c
> @@ -211,6 +211,12 @@ static int pnp_assign_dma(struct pnp_dev *dev, struct pnp_dma *rule, int idx)
>   	res->start = -1;
>   	res->end = -1;
>   
> +	if (!rule->map) {
> +		res->flags |= IORESOURCE_DISABLED;
> +		pnp_dbg(&dev->dev, "  dma %d disabled\n", idx);
> +		goto __add;
> +	}
> +
>   	for (i = 0; i < 8; i++) {
>   		if (rule->map & (1 << xtab[i])) {
>   			res->start = res->end = xtab[i];
> @@ -218,11 +224,9 @@ static int pnp_assign_dma(struct pnp_dev *dev, struct pnp_dma *rule, int idx)
>   				goto __add;
>   		}
>   	}
> -#ifdef MAX_DMA_CHANNELS
> -	res->start = res->end = MAX_DMA_CHANNELS;
> -#endif
> -	res->flags |= IORESOURCE_DISABLED;
> -	pnp_dbg(&dev->dev, "  disable dma %d\n", idx);
> +
> +	pnp_dbg(&dev->dev, "  couldn't assign dma %d\n", idx);
> +	return -EBUSY;
>   
>   __add:
>   	pnp_add_dma_resource(dev, res->start, res->flags);

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

