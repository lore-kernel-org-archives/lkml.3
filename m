Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbaHSSXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 14:23:44 -0400
Received: from mail.eperm.de ([89.247.134.16]:58719 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054AbaHSSXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 14:23:43 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Kernel crypto API: cryptoperf performance measurement
Date: Tue, 19 Aug 2014 20:23:37 +0200
Message-ID: <1477690.toHy6ei3xC@myon.chronox.de>
User-Agent: KMail/4.13.3 (Linux/3.15.10-200.fc20.x86_64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <53F2FA10.2000300@iki.fi>
References: <56334718.JSiBY74glM@myon.chronox.de> <53F2FA10.2000300@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 19. August 2014, 10:17:36 schrieb Jussi Kivilinna:

Hi Jussi,

> Hello,
> 
> On 2014-08-17 18:55, Stephan Mueller wrote:
> > Hi,
> > 
> > during playing around with the kernel crypto API, I implemented a
> > performance measurement tool kit for the various kernel crypto API cipher
> > types. The cryptoperf tool kit is provided in [1].
> > 
> > Comments are welcome.
> 
> Your results are quite slow compared to, for example "cryptsetup
> benchmark", which uses kernel crypto from userspace.
> 
> With Intel i5-2450M (turbo enabled), I get:
> 
> #  Algorithm | Key |  Encryption |  Decryption
>      aes-cbc   128b   524,0 MiB/s  11909,1 MiB/s
>  serpent-cbc   128b    60,9 MiB/s   219,4 MiB/s
>  twofish-cbc   128b   143,4 MiB/s   240,3 MiB/s
>      aes-cbc   256b   330,4 MiB/s  1242,8 MiB/s
>  serpent-cbc   256b    66,1 MiB/s   220,3 MiB/s
>  twofish-cbc   256b   143,5 MiB/s   221,8 MiB/s
>      aes-xts   256b  1268,7 MiB/s  4193,0 MiB/s
>  serpent-xts   256b   234,8 MiB/s   224,6 MiB/s
>  twofish-xts   256b   253,5 MiB/s   254,7 MiB/s
>      aes-xts   512b  2535,0 MiB/s  2945,0 MiB/s
>  serpent-xts   512b   274,2 MiB/s   242,3 MiB/s
>  twofish-xts   512b   250,0 MiB/s   245,8 MiB/s

One to four GB per second for XTS? 12 GB per second for AES CBC? Somehow that 
does not sound right.
> 
> > In general, the results are as expected, i.e. the assembler
> > implementations
> > are faster than the pure C implementations. However, there are curious
> > results which probably should be checked by the maintainers of the
> > respective ciphers (hoping that my tool works correctly ;-) ):
> > 
> > ablkcipher
> > ----------
> > 
> > - cryptd is slower by factor 10 across the board
> > 
> > blkcipher
> > ---------
> > 
> > - Blowfish x86_64 assembler together with the generic C block chaining
> > modes is significantly slower than Blowfish implemented in generic C
> > 
> > - Blowfish x86_64 assembler in ECB is significantly slower than generic C
> > Blowfish ECB
> > 
> > - Serpent assembler implementations are not significantly faster than
> > generic C implementations
> > 
> > - AES-NI ECB, LRW, CTR is significantly slower than AES i586 assembler.
> > 
> > - AES-NI ECB, LRW, CTR is not significantly faster than AES generic C
> 
> Quite many assembly implementations get speed up from processing
> parallel block cipher blocks, which modes of operation that (CTR, XTS,
> LWR, CBC(dec)). For small buffer sizes, these implementations will use
> the non-parallel implementation of cipher.

Thanks for the pointer, I will rerun my tests with multiple of the block size 
(e.g. 1024 blocks).
-- 
Ciao
Stephan
