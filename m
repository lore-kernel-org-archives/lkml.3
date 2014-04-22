Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbaDVQJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:09:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51446 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757270AbaDVQJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:09:05 -0400
Date: Tue, 22 Apr 2014 17:08:21 +0100
From: Will Deacon <will.deacon@arm.com>
To: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "arnd@arndb.de" <arnd@arndb.de>, "monstr@monstr.eu" <monstr@monstr.eu>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 16/18] x86: io: implement dummy relaxed accessor macros
 for writes
Message-ID: <20140422160821.GA31322@arm.com>
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
 <1397742261-15621-17-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397742261-15621-17-git-send-email-will.deacon@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 02:44:19PM +0100, Will Deacon wrote:
> write{b,w,l,q}_relaxed are implemented by some architectures in order to
> permit memory-mapped I/O accesses with weaker barrier semantics than the
> non-relaxed variants.
> 
> This patch adds dummy macros for the write accessors to x86, in the
> same vein as the dummy definitions for the relaxed read accessors.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  arch/x86/include/asm/io.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
> index b8237d8a1e0c..2ea07f5ec7b7 100644
> --- a/arch/x86/include/asm/io.h
> +++ b/arch/x86/include/asm/io.h
> @@ -74,6 +74,9 @@ build_mmio_write(__writel, "l", unsigned int, "r", )
>  #define __raw_readw __readw
>  #define __raw_readl __readl
>  
> +#define writeb_relaxed(v, a) __writeb(v, a)
> +#define writew_relaxed(v, a) __writew(v, a)
> +#define writel_relaxed(v, a) __writel(v, a)
>  #define __raw_writeb __writeb
>  #define __raw_writew __writew
>  #define __raw_writel __writel
> @@ -86,6 +89,7 @@ build_mmio_read(readq, "q", unsigned long, "=r", :"memory")
>  build_mmio_write(writeq, "q", unsigned long, "r", :"memory")
>  
>  #define readq_relaxed(a)	readq(a)
> +#define writeq_relaxed(v, a)	writeq(v, a)

Actually, I should be using the regular (i.e. without the double underscore
prefix) accessors for the relaxed variants, including the existing read
flavours here. The proposed semantics are that the accessors are ordered
with respect to each other, which necessitates a compiler barrier.

Will
