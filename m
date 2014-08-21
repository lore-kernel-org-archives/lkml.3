Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbaHUV2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 17:28:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54314 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbaHUV2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 17:28:46 -0400
Date: Thu, 21 Aug 2014 14:28:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Doug Thompson <dougthompson@xmission.com>, Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-edac@vger.kernel.org (open list:EDAC-CORE),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] edac: Fix build error caused by wrong member access
Message-Id: <20140821142844.741564f85014633db067408f@linux-foundation.org>
In-Reply-To: <1408482646-22541-1-git-send-email-bobby.prani@gmail.com>
References: <1408482646-22541-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2014 17:10:46 -0400 Pranith Kumar <bobby.prani@gmail.com> wrote:

> Fix the following error 
> 
> drivers/edac/ppc4xx_edac.c:977:45: error: request for member 'dimm' in something
> not a structure or union
> 
> by changing member access to pointer dereference
> 
> --- a/drivers/edac/ppc4xx_edac.c
> +++ b/drivers/edac/ppc4xx_edac.c
> @@ -974,7 +974,7 @@ static int ppc4xx_edac_init_csrows(struct mem_ctl_info *mci, u32 mcopt1)
>  		 * page size (PAGE_SIZE) or the memory width (2 or 4).
>  		 */
>  		for (j = 0; j < csi->nr_channels; j++) {
> -			struct dimm_info *dimm = csi->channels[j].dimm;
> +			struct dimm_info *dimm = csi->channels[j]->dimm;
>  
>  			dimm->nr_pages  = nr_pages / csi->nr_channels;
>  			dimm->grain	= 1;

This driver seems pretty unhealthy and I suspect it has been
broken for quite a while.

drivers/edac/ppc4xx_edac.c: In function 'mfsdram':
drivers/edac/ppc4xx_edac.c:249: error: implicit declaration of function '__mfdcri'
drivers/edac/ppc4xx_edac.c: In function 'mtsdram':
drivers/edac/ppc4xx_edac.c:266: error: implicit declaration of function '__mtdcri'
drivers/edac/ppc4xx_edac.c:269: warning: 'return' with a value, in function returning void
drivers/edac/ppc4xx_edac.c: In function 'ppc4xx_edac_init_csrows':
drivers/edac/ppc4xx_edac.c:924: warning: initialization from incompatible pointer type
drivers/edac/ppc4xx_edac.c:977: error: request for member 'dimm' in something not a structure or union
drivers/edac/ppc4xx_edac.c: In function 'ppc4xx_edac_map_dcrs':
drivers/edac/ppc4xx_edac.c:1209: warning: passing argument 1 of 'dcr_map_mmio' discards qualifiers from pointer target type


