Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbaIHOS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 10:18:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbaIHOS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:18:56 -0400
Date: Mon, 8 Sep 2014 10:18:51 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Seth Jennings <sjenning@redhat.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sb_edac: avoid INTERNAL ERROR message in EDAC with
 unspecified channel
Message-ID: <20140908141851.GL22290@redhat.com>
References: <1409945327-17989-1-git-send-email-sjenning@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409945327-17989-1-git-send-email-sjenning@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 02:28:47PM -0500, Seth Jennings wrote:
> Intel IA32 SDM Table 15-14 defines channel 0xf as 'not specified', but
> EDAC doesn't know about this and returns and INTERNAL ERROR when the
> channel is greater than NUM_CHANNELS:
> 
> kernel: [ 1538.886456] CPU 0: Machine Check Exception: 0 Bank 1: 940000000000009f
> kernel: [ 1538.886669] TSC 2bc68b22e7e812 ADDR 46dae7000 MISC 0 PROCESSOR 0:306e4 TIME 1390414572 SOCKET 0 APIC 0
> kernel: [ 1538.971948] EDAC MC1: INTERNAL ERROR: channel value is out of range (15 >= 4)
> kernel: [ 1538.972203] EDAC MC1: 0 CE memory read error on unknown memory (slot:0 page:0x46dae7 offset:0x0 grain:0 syndrome:0x0 -  area:DRAM err_code:0000:009f socket:1 channel_mask:1 rank:0)
> 
> This commit changes sb_edac to forward a channel of -1 to EDAC if the
> channel is not specified.  edac_mc_handle_error() sets the channel to -1
> internally after the error message anyway, so this commit should have no
> effect other than avoiding the INTERNAL ERROR message when the channel
> is not specified.
> 
> Signed-off-by: Seth Jennings <sjenning@redhat.com>
> Cc: Aristeu Rozanski <aris@redhat.com>
> Cc: linux-edac@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/edac/sb_edac.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
> index 0034c48..07efed4 100644
> --- a/drivers/edac/sb_edac.c
> +++ b/drivers/edac/sb_edac.c
> @@ -283,8 +283,9 @@ static const u32 correrrthrsld[] = {
>   * sbridge structs
>   */
>  
> -#define NUM_CHANNELS	4
> -#define MAX_DIMMS	3		/* Max DIMMS per channel */
> +#define NUM_CHANNELS		4
> +#define MAX_DIMMS		3	/* Max DIMMS per channel */
> +#define CHANNEL_UNSPECIFIED	0xf	/* Intel IA32 SDM 15-14 */
>  
>  enum type {
>  	SANDY_BRIDGE,
> @@ -1991,6 +1992,9 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
>  
>  	/* FIXME: need support for channel mask */
>  
> +	if (channel == CHANNEL_UNSPECIFIED)
> +		channel = -1;
> +
>  	/* Call the helper to output message */
>  	edac_mc_handle_error(tp_event, mci, core_err_cnt,
>  			     m->addr >> PAGE_SHIFT, m->addr & ~PAGE_MASK, 0,

Acked-by: Aristeu Rozanski <aris@redhat.com>

-- 
Aristeu

