Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab3F1PJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 11:09:56 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:33480 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab3F1PJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 11:09:54 -0400
Date: Fri, 28 Jun 2013 17:09:41 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Chen Gang <gang.chen@asianux.com>,
        =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH] arch: tile: include: asm: add cmpxchg64() definition
Message-ID: <20130628150941.GA22767@linux-mips.org>
References: <51CA6D21.3090901@asianux.com>
 <51CC492C.1040105@tilera.com>
 <51CCD891.8000806@asianux.com>
 <51CCEC27.8050508@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51CCEC27.8050508@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 09:51:35AM +0800, Chen Gang wrote:

> Need add cmpxchg64(), or will cause compiling issue.
> 
> Just define it as cmpxchg(), since cmpxchg() can support 8 bytes.
> 
> The related error (with allmodconfig):
> 
>   drivers/block/blockconsole.c: In function ‘bcon_advance_console_bytes’:
>   drivers/block/blockconsole.c:164:2: error: implicit declaration of function ‘cmpxchg64’ [-Werror=implicit-function-declaration]
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/tile/include/asm/cmpxchg.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/tile/include/asm/cmpxchg.h b/arch/tile/include/asm/cmpxchg.h
> index 276f067..7688c28 100644
> --- a/arch/tile/include/asm/cmpxchg.h
> +++ b/arch/tile/include/asm/cmpxchg.h
> @@ -68,6 +68,8 @@ extern unsigned long __cmpxchg_called_with_bad_pointer(void);
>  
>  #define tas(ptr) (xchg((ptr), 1))
>  
> +#define cmpxchg64(ptr, o, n)		cmpxchg((ptr), (o), (n))

that's broken.  cmpxchg64 is suposed to work on 64 bit operands ONLY.  This
definition (used by MIPS and Alpha) will work properly:

#define cmpxchg64(ptr, o, n)                                            \
({                                                                      \
	BUILD_BUG_ON(sizeof(*(ptr)) != 8);                              \
	cmpxchg((ptr), (o), (n));                                       \
})

This should cure blockconsole on Tile but not on MIPS.

struct blockconsole {
...
           u64 console_bytes;
...
};

static void bcon_advance_console_bytes(struct blockconsole *bc, int bytes)
{
	u64 old, new;
	...
	} while (cmpxchg64(&bc->console_bytes, old, new) != old);
}

So it's using cmpxchg64() to operate on 64 bit objects - but that's not
going to work on every architecture.  Many 32 bit architectures only
provide atomic operations that operate on 32 bit quantities.

  Ralf
