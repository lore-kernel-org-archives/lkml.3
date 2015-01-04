Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbbADVhW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 16:37:22 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:42022 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbbADVhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 16:37:20 -0500
Date: Mon, 5 Jan 2015 08:35:38 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giel van Schijndel <me@mortis.eu>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steve French <sfrench@samba.org>,
        Rahul Bedarkar <rahulbedarkar89@gmail.com>,
        Thomas Pugliese <thomas.pugliese@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        "open list:CERTIFIED WIRELES..." <linux-usb@vger.kernel.org>,
        "open list:COMMON INTERNET F..." <linux-cifs@vger.kernel.org>,
        "moderated list:COMMON INTERNET F..." 
	<samba-technical@lists.samba.org>
Subject: Re: [PATCH] Use memzero_explicit to clear local buffers
Message-ID: <20150104213538.GA19906@gondor.apana.org.au>
References: <1420394744-20268-1-git-send-email-me@mortis.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420394744-20268-1-git-send-email-me@mortis.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2015 at 07:05:40PM +0100, Giel van Schijndel wrote:
> When leaving a function use memzero_explicit instead of memset(0) to
> clear locally allocated/owned buffers. memset(0) may be optimized away.
> 
> All of the affected buffers contain sensitive data, key material or
> derivatives of one of those two.

Nack.
 
> diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
> index 8fad72f..b616e63 100644
> --- a/arch/x86/crypto/sha256_ssse3_glue.c
> +++ b/arch/x86/crypto/sha256_ssse3_glue.c
> @@ -164,7 +164,7 @@ static int sha256_ssse3_final(struct shash_desc *desc, u8 *out)
>  		dst[i] = cpu_to_be32(sctx->state[i]);
>  
>  	/* Wipe context */
> -	memset(sctx, 0, sizeof(*sctx));
> +	memzero_explicit(sctx, sizeof(*sctx));

sctx does not point to stack memory so this is bogus.

Only stack memory cleared just before it goes out of scope needs
memzero_explicit.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
