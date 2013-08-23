Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab3HWVh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 17:37:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47525 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755844Ab3HWVh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 17:37:27 -0400
Date: Fri, 23 Aug 2013 23:37:25 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        dougthompson@xmission.com, bhelgaas@google.com, jbeulich@suse.com,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/1] AMD64_EDAC: Fix incorrect wrap arounds due to left
 shift beyond 32 bits.
Message-ID: <20130823213725.GC15521@pd.tnic>
References: <1376958472-2150-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <1376958472-2150-2-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1376958472-2150-2-git-send-email-Aravind.Gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 07:27:52PM -0500, Aravind Gopalakrishnan wrote:
> Link to the bug report:
> http://marc.info/?l=linux-edac&m=137692201732220&w=2
> 
> dct_base and dct_limit obtain 32 bit register values when they read their
> respective pci config space registers. A left shift beyond 32 bits will
> cause them to wrap around. Similar case for chan_addr as can be seen from
> the bug report. In the patch, we rectify this by casting chan_addr to u64
> and by comparing dct_base and dct_limit against (sys_addr >> 27)
> 
> Tested on F15h, M30h with ECC turned on and works fine.
> 
> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
> 
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index b86228c..eb4793e 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -1558,11 +1558,12 @@ static int f15_m30h_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
>  	}
>  
>  	/* Verify sys_addr is within DCT Range. */
> -	dct_base = (dct_sel_baseaddr(pvt) << 27);
> -	dct_limit = (((dct_cont_limit_reg >> 11) & 0x1FFF) << 27) | 0x7FFFFFF;
> +	dct_base = dct_sel_baseaddr(pvt);

This can't be correct.

So the original patch takes the shifted dct_base while your change
doesn't anymore...

> +	dct_limit = (dct_cont_limit_reg >> 11) & 0x1FFF;
>  
>  	if (!(dct_cont_base_reg & BIT(0)) &&
> -	    !(dct_base <= sys_addr && dct_limit >= sys_addr))
> +	    !(dct_base <= (sys_addr >> 27) &&
> +	      dct_limit >= (sys_addr >> 27)))

... and while this comparison shifts sys_addr to use the proper bits,
the code does this assignment later:

	chan_offset = dct_base;

Now, chan_offset has the << 27 version of dct_base which makes the following
calculation wrong:

	chan_addr = sys_addr - chan_offset;

because sys_addr is the full 64-bit, unshifted value.

The right thing to do would be to do:

	chan_offset = dct_base << 27;

Or am I missing something?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
