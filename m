Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013Ab3BZJyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 04:54:38 -0500
Received: from sting.hengli.com.au ([178.18.18.71]:57852 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754637Ab3BZJyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 04:54:36 -0500
Date: Tue, 26 Feb 2013 17:54:24 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Chaohong Guo <chaohong.guo@intel.com>,
        Austin Zhang <austin_zhang@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>, Min Li <min.a.li@intel.com>,
        David Cote <david.m.cote@intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/3 v2] Optimize CRC32C calculation with PCLMULQDQ
 instruction
Message-ID: <20130226095424.GA19924@gondor.apana.org.au>
References: <cover.1348784343.git.tim.c.chen@linux.intel.com>
 <1348785862.17632.17.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348785862.17632.17.camel@schen9-DESK>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 03:44:22PM -0700, Tim Chen wrote:
> This patch adds the crc_pcl function that calculates CRC32C checksum using the
> PCLMULQDQ instruction on processors that support this feature. This will
> provide speedup over using CRC32 instruction only.
> The usage of PCLMULQDQ necessitate the invocation of kernel_fpu_begin and
> kernel_fpu_end and incur some overhead.  So the new crc_pcl function is only
> invoked for buffer size of 512 bytes or more.  Larger sized
> buffers will expect to see greater speedup.  This feature is best used coupled
> with eager_fpu which reduces the kernel_fpu_begin/end overhead.  For
> buffer size of 1K the speedup is around 1.6x and for buffer size greater than
> 4K, the speedup is around 3x compared to original implementation in crc32c-intel
> module. Test was performed on Sandy Bridge based platform with constant frequency
> set for cpu.
> 
> A white paper detailing the algorithm can be found here:
> http://download.intel.com/design/intarch/papers/323405.pdf
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> ---
>  arch/x86/crypto/Makefile                  |    1 +
>  arch/x86/crypto/crc32c-intel_glue.c       |   81 +++++
>  arch/x86/crypto/crc32c-pcl-intel-asm_64.S |  460 +++++++++++++++++++++++++++++
>  crypto/Kconfig                            |   10 +
>  4 files changed, 552 insertions(+), 0 deletions(-)
>  create mode 100644 arch/x86/crypto/crc32c-pcl-intel-asm_64.S
> 
> diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
> index edd2268..7b6db64 100644
> --- a/arch/x86/crypto/Makefile
> +++ b/arch/x86/crypto/Makefile
> @@ -44,3 +44,4 @@ aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o fpu.o
>  ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
>  sha1-ssse3-y := sha1_ssse3_asm.o sha1_ssse3_glue.o
>  crc32c-intel-y := crc32c-intel_glue.o
> +crc32c-intel-$(CONFIG_CRYPTO_CRC32C_X86_64) += crc32c-pcl-intel-asm_64.o

It seems that this option is redundant.  So I'd like to kill it
with the following patch.  If this breaks anything like i386, please
let me know.

Thanks!

commit ca81a1a1b8d79dd6706c9463a81e9491e940ca2b
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Tue Feb 26 17:52:15 2013 +0800

    crypto: crc32c - Kill pointless CRYPTO_CRC32C_X86_64 option
    
    This bool option can never be set to anything other than y.  So
    let's just kill it.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 63947a8..ca96761 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -52,5 +52,5 @@ aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o fpu.o
 ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
 sha1-ssse3-y := sha1_ssse3_asm.o sha1_ssse3_glue.o
 crc32c-intel-y := crc32c-intel_glue.o
-crc32c-intel-$(CONFIG_CRYPTO_CRC32C_X86_64) += crc32c-pcl-intel-asm_64.o
+crc32c-intel-$(CONFIG_64BIT) += crc32c-pcl-intel-asm_64.o
 crc32-pclmul-y := crc32-pclmul_asm.o crc32-pclmul_glue.o
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 05c0ce5..aed52b2 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -322,19 +322,9 @@ config CRYPTO_CRC32C
 	  by iSCSI for header and data digests and by others.
 	  See Castagnoli93.  Module will be crc32c.
 
-config CRYPTO_CRC32C_X86_64
-	bool
-	depends on X86 && 64BIT
-	select CRYPTO_HASH
-	help
-	  In Intel processor with SSE4.2 supported, the processor will
-	  support CRC32C calculation using hardware accelerated CRC32
-	  instruction optimized with PCLMULQDQ instruction when available.
-
 config CRYPTO_CRC32C_INTEL
 	tristate "CRC32c INTEL hardware acceleration"
 	depends on X86
-	select CRYPTO_CRC32C_X86_64 if 64BIT
 	select CRYPTO_HASH
 	help
 	  In Intel processor with SSE4.2 supported, the processor will
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
