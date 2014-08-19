Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaHSHRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 03:17:50 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:39351 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbaHSHRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 03:17:48 -0400
Message-ID: <53F2FA10.2000300@iki.fi>
Date: Tue, 19 Aug 2014 10:17:36 +0300
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Kernel crypto API: cryptoperf performance measurement
References: <56334718.JSiBY74glM@myon.chronox.de>
In-Reply-To: <56334718.JSiBY74glM@myon.chronox.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 193.67.103.254
X-SA-Exim-Mail-From: jussi.kivilinna@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-08-17 18:55, Stephan Mueller wrote:
> Hi,
> 
> during playing around with the kernel crypto API, I implemented a performance 
> measurement tool kit for the various kernel crypto API cipher types. The 
> cryptoperf tool kit is provided in [1].
> 
> Comments are welcome.

Your results are quite slow compared to, for example "cryptsetup
benchmark", which uses kernel crypto from userspace.

With Intel i5-2450M (turbo enabled), I get:

#  Algorithm | Key |  Encryption |  Decryption
     aes-cbc   128b   524,0 MiB/s  11909,1 MiB/s
 serpent-cbc   128b    60,9 MiB/s   219,4 MiB/s
 twofish-cbc   128b   143,4 MiB/s   240,3 MiB/s
     aes-cbc   256b   330,4 MiB/s  1242,8 MiB/s
 serpent-cbc   256b    66,1 MiB/s   220,3 MiB/s
 twofish-cbc   256b   143,5 MiB/s   221,8 MiB/s
     aes-xts   256b  1268,7 MiB/s  4193,0 MiB/s
 serpent-xts   256b   234,8 MiB/s   224,6 MiB/s
 twofish-xts   256b   253,5 MiB/s   254,7 MiB/s
     aes-xts   512b  2535,0 MiB/s  2945,0 MiB/s
 serpent-xts   512b   274,2 MiB/s   242,3 MiB/s
 twofish-xts   512b   250,0 MiB/s   245,8 MiB/s

> 
> In general, the results are as expected, i.e. the assembler implementations 
> are faster than the pure C implementations. However, there are curious results 
> which probably should be checked by the maintainers of the respective ciphers 
> (hoping that my tool works correctly ;-) ):
> 
> ablkcipher
> ----------
> 
> - cryptd is slower by factor 10 across the board
> 
> blkcipher
> ---------
> 
> - Blowfish x86_64 assembler together with the generic C block chaining modes 
> is significantly slower than Blowfish implemented in generic C
> 
> - Blowfish x86_64 assembler in ECB is significantly slower than generic C 
> Blowfish ECB
> 
> - Serpent assembler implementations are not significantly faster than generic 
> C implementations
> 
> - AES-NI ECB, LRW, CTR is significantly slower than AES i586 assembler.
> 
> - AES-NI ECB, LRW, CTR is not significantly faster than AES generic C
> 

Quite many assembly implementations get speed up from processing
parallel block cipher blocks, which modes of operation that (CTR, XTS,
LWR, CBC(dec)). For small buffer sizes, these implementations will use
the non-parallel implementation of cipher.

-Jussi

> rng
> ---
> 
> - The ANSI X9.31 RNG seems to work massively faster than the underlying AES 
> cipher (by about a factor of 5). I am unsure about the cause of this.
> 
> 
> Caveat
> ------
> 
> Please note that there is one small error which I am unsure how to fix it as 
> documented in the TODO file.
> 
> [1] http://www.chronox.de/cryptoperf.html
> 
