Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab3FPLWZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 07:22:25 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:43060 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946Ab3FPLWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 07:22:24 -0400
Date: Sun, 16 Jun 2013 13:22:12 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-mips@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 21/31] mips/kvm: Allow set_except_vector() to be used
 from MIPSVZ code.
Message-ID: <20130616112211.GC20046@linux-mips.org>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
 <1370646215-6543-22-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370646215-6543-22-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 04:03:25PM -0700, David Daney wrote:

> From: David Daney <david.daney@cavium.com>
> 
> We need to move it out of __init so we don't have section mismatch problems.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
>  arch/mips/include/asm/uasm.h | 2 +-
>  arch/mips/kernel/traps.c     | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/mips/include/asm/uasm.h b/arch/mips/include/asm/uasm.h
> index 370d967..90b4f5e 100644
> --- a/arch/mips/include/asm/uasm.h
> +++ b/arch/mips/include/asm/uasm.h
> @@ -11,7 +11,7 @@
>  
>  #include <linux/types.h>
>  
> -#ifdef CONFIG_EXPORT_UASM
> +#if defined(CONFIG_EXPORT_UASM) || IS_ENABLED(CONFIG_KVM_MIPSVZ)
>  #include <linux/export.h>
>  #define __uasminit
>  #define __uasminitdata

I'd rather keep KVM bits out of uasm.h.  A select EXPORT_UASM in Kconfig
would have been cleaner - but read below.

> diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
> index f008795..fca0a2f 100644
> --- a/arch/mips/kernel/traps.c
> +++ b/arch/mips/kernel/traps.c
> @@ -1457,7 +1457,7 @@ unsigned long ebase;
>  unsigned long exception_handlers[32];
>  unsigned long vi_handlers[64];
>  
> -void __init *set_except_vector(int n, void *addr)
> +void __uasminit *set_except_vector(int n, void *addr)

A __uasminit tag is a bit unobvious because set_except_vector is not part of
uasm.  I could understand __cpuinit - but of course that doesn't sort your
problem.  Maybe we should just drop the __init tag alltogether?  Or if we
really want set_except_vector to become part of the uasm subsystem, then
probably it's declaration should move from setup.h to uasm.h.

  Ralf
