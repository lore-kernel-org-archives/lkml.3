Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3CXLg7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 07:36:59 -0400
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:37556 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab3CXLg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 07:36:57 -0400
Message-ID: <514EE556.7020004@iki.fi>
Date: Sun, 24 Mar 2013 13:36:54 +0200
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>,
        Kirk Yap <kirk.s.yap@intel.com>, David Cote <david.m.cote@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 11/11] Create module providing optimized SHA512 routines
 using SSSE3, AVX or AVX2 instructions.
References: <cover.1363961999.git.tim.c.chen@linux.intel.com> <1363987779.8972.65.camel@schen9-DESK>
In-Reply-To: <1363987779.8972.65.camel@schen9-DESK>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.03.2013 23:29, Tim Chen wrote:
> We added glue code and config options to create crypto
> module that uses SSE/AVX/AVX2 optimized SHA512 x86_64 assembly routines.
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> ---
>  arch/x86/crypto/Makefile            |   2 +
>  arch/x86/crypto/sha512_ssse3_glue.c | 276 ++++++++++++++++++++++++++++++++++++
>  crypto/Kconfig                      |  11 ++
>  3 files changed, 289 insertions(+)
>  create mode 100644 arch/x86/crypto/sha512_ssse3_glue.c
> 
> diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
> index 02a664a..7d12625 100644
> --- a/arch/x86/crypto/Makefile
> +++ b/arch/x86/crypto/Makefile
> @@ -28,6 +28,7 @@ obj-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL) += ghash-clmulni-intel.o
>  obj-$(CONFIG_CRYPTO_CRC32C_INTEL) += crc32c-intel.o
>  obj-$(CONFIG_CRYPTO_SHA1_SSSE3) += sha1-ssse3.o
>  obj-$(CONFIG_CRYPTO_SHA256_SSSE3) += sha256-ssse3.o
> +obj-$(CONFIG_CRYPTO_SHA512_SSSE3) += sha512-ssse3.o
>  
>  aes-i586-y := aes-i586-asm_32.o aes_glue.o
>  twofish-i586-y := twofish-i586-asm_32.o twofish_glue.o
> @@ -54,3 +55,4 @@ sha1-ssse3-y := sha1_ssse3_asm.o sha1_ssse3_glue.o
>  crc32c-intel-y := crc32c-intel_glue.o
>  crc32c-intel-$(CONFIG_CRYPTO_CRC32C_X86_64) += crc32c-pcl-intel-asm_64.o
>  sha256-ssse3-y := sha256-ssse3-asm.o sha256-avx-asm.o sha256-avx2-asm.o sha256_ssse3_glue.o
> +sha512-ssse3-y := sha512-ssse3-asm.o sha512-avx-asm.o sha512-avx2-asm.o sha512_ssse3_glue.o
> diff --git a/arch/x86/crypto/sha512_ssse3_glue.c b/arch/x86/crypto/sha512_ssse3_glue.c
> new file mode 100644
> index 0000000..25a2e07
> --- /dev/null
> +++ b/arch/x86/crypto/sha512_ssse3_glue.c

...snip..

> +#include <linux/string.h>
> +
> +asmlinkage void sha512_transform_ssse3(const char *data, u64 *digest,
> +				     u64 rounds);
> +#ifdef CONFIG_AS_AVX
> +asmlinkage void sha512_transform_avx(const char *data, u64 *digest,
> +				     u64 rounds);
> +asmlinkage void sha512_transform_rorx(const char *data, u64 *digest,
> +				     u64 rounds);
> +#endif
> +

Is CONFIG_AS_AVX enough to ensure that rorx is supported by assembler?

You also have #ifdef CONFIG_AS_AVX / #endif missing in 'sha256-avx-asm.S', 'sha256-avx2-asm.S', 'sha512-avx-asm.S' and 'sha512-avx2-asm.S'.

-Jussi

