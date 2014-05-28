Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbaE1WdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 18:33:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:42131 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbaE1WdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 18:33:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,931,1392192000"; 
   d="scan'208";a="548042034"
Subject: Re: [RFC PATCH] crypto: crc32c-pclmul - Use pmovzxdq to shrink
 K_table
From: Tim Chen <tim.c.chen@linux.intel.com>
To: George Spelvin <linux@horizon.com>
Cc: herbert@gondor.apana.org.au, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, sandyw@twitter.com,
        James Guilford <james.guilford@intel.com>
In-Reply-To: <20140528144000.28686.qmail@ns.horizon.com>
References: <20140528144000.28686.qmail@ns.horizon.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 May 2014 15:32:59 -0700
Message-ID: <1401316379.2970.387.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-28 at 10:40 -0400, George Spelvin wrote:
> While following a number of tangents in the code (I was figuring out
> how to edit lib/Kconfig; don't ask), I came across a table of 256 64-bit
> words, all of which had the high half set to zero.
> 
> Since the code depends on both pclmulq and crc32, SSE 4.1 is obviously
> present, so it could use pmovzxdq and save 1K of kernel data.
> 
> The following patch obviously lacks the kludges for old binutils,
> but should convey the general idea.
> 
> Jan: Is support for SLE10's pre-2.18 binutils still required?
> Your PEXTRD fix was only a year ago, so I expect, but I wanted to ask.
> 
> Two other minor additional changes:
> 
> 1. The current code unnecessarily puts the table in the read-write
>    .data section.  Moved to .text.
> 2. I'm also not sure why it's necessary to force such large alignment
>    on K_table.  Comments on reducing it?
> 
> Signed-off-by: George Spelvin <linux@horizon.com>
> 
> 
> diff --git a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
> index dbc4339b..9f885ee4 100644
> --- a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
> +++ b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
> @@ -216,15 +216,11 @@ LABEL crc_ %i
>  	## 4) Combine three results:
>  	################################################################
>  
> -	lea	(K_table-16)(%rip), bufp	# first entry is for idx 1
> +	lea	(K_table-8)(%rip), bufp		# first entry is for idx 1
>  	shlq    $3, %rax			# rax *= 8
> -	subq    %rax, tmp			# tmp -= rax*8
> -	shlq    $1, %rax
> -	subq    %rax, tmp			# tmp -= rax*16
> -						# (total tmp -= rax*24)
> -	addq    %rax, bufp
> -
> -	movdqa  (bufp), %xmm0			# 2 consts: K1:K2
> +	pmovzxdq (bufp,%rax), %xmm0		# 2 consts: K1:K2

Changing from the aligned move (movdqa) to unaligned move and zeroing
(pmovzxdq), is going to make things slower.  If the table is aligned
on 8 byte boundary, some of the table can span 2 cache lines, which
can slow things further.

We are trading speed for only 4096 bytes of memory save,
which is likely not a good trade for most systems except for 
those really constrained of memory.  For this kind of non-performance
critical system, it may as well use the generic crc32c algorithm and
compile out this module.

Thanks.

Tim



