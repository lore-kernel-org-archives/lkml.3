Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769Ab3JAQ15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 12:27:57 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:49926 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab3JAQ1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 12:27:54 -0400
Date: Tue, 1 Oct 2013 19:27:43 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Yoichi Yuasa <yuasa@linux-mips.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.12-rc2 - MIPS regression
Message-ID: <20131001162743.GB14359@blackmetal.musicnaut.iki.fi>
References: <CA+55aFxoF75RJfkp0vnm-b9B0h7PGMitrQiLyTt315tKvG-wTQ@mail.gmail.com>
 <20130927231012.GB4572@blackmetal.musicnaut.iki.fi>
 <20131001142421.6cd0870138caf2fe5600a1ea@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001142421.6cd0870138caf2fe5600a1ea@linux-mips.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 02:24:21PM +0900, Yoichi Yuasa wrote:
> On Sat, 28 Sep 2013 02:10:12 +0300
> Aaro Koskinen <aaro.koskinen@iki.fi> wrote:
> > 3.12-rc2 breaks the boot (BUG: scheduling while atomic, see logs below)
> > on Lemote Mini-PC (MIPS). According to git bisect, this is caused by:
> > 
> > ff522058bd717506b2fa066fa564657f2b86477e is the first bad commit
> > commit ff522058bd717506b2fa066fa564657f2b86477e
> > Author: Ralf Baechle <ralf@linux-mips.org>
> > Date:   Tue Sep 17 12:44:31 2013 +0200
> > 
> >     MIPS: Fix accessing to per-cpu data when flushing the cache
> > 
> > Reverting the commit from v3.12-rc2 makes the board boot fine.
> 
> Please try this patch on top of rc2.
> 
> MIPS: Fix forgotten preempt_enable() when CPU has inclusive pcaches

Didn't work but making similar change to also r4k_dma_cache_inv() helps.
So both r4k_dma_cache_wback_inv() and r4k_dma_cache_inv() need to
be fixed.

A.

> Signed-off-by: Yoichi Yuasa <yuasa@linux-mips.org>
> 
> diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
> index 627883b..2492e60 100644
> --- a/arch/mips/mm/c-r4k.c
> +++ b/arch/mips/mm/c-r4k.c
> @@ -609,6 +609,7 @@ static void r4k_dma_cache_wback_inv(unsigned long addr, unsigned long size)
>  			r4k_blast_scache();
>  		else
>  			blast_scache_range(addr, addr + size);
> +		preempt_enable();
>  		__sync();
>  		return;
>  	}
