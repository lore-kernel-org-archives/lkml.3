Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab3KZVop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 16:44:45 -0500
Received: from hm1481-26.locaweb.com.br ([201.76.49.238]:8585 "EHLO
	hm1481-26.locaweb.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757468Ab3KZVom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 16:44:42 -0500
X-LocaWeb-COR: locaweb_2009_x-mail
Message-ID: <52951640.6080805@cesarb.eti.br>
Date: Tue, 26 Nov 2013 19:44:32 -0200
From: Cesar Eduardo Barros <cesarb@cesarb.eti.br>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Daniel Borkmann <dborkman@redhat.com>
CC: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        James Yonan <james@openvpn.net>, Florian Weimer <fw@deneb.enyo.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] crypto: more robust crypto_memneq
References: <1385424041-18064-1-git-send-email-cesarb@cesarb.eti.br> <5294F625.5040506@redhat.com>
In-Reply-To: <5294F625.5040506@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-locaweb-id: 5II90qkwcFl608adNSKU11Mhs1xf0MgAzPC-CIfMoteOMOLYZkorw41aZgtgCBGiz7JOWdNt-MIUbUFIqc5n_VfP5aYHWPJEum0HS-HjJOsqwBSdevEWTmlLT9a_wn7DAlDAu0cnb3aT8-Jj93bJMvdN7S_l1fKoy_NDSUB0G9MlAJ-q3FSdBS4J9BBFGU78k0F9fT43L9t5y9DwmsEOxw==
x-locaweb-id2: NjM2NTczNjE3MjYyNDA2MzY1NzM2MTcyNjIyZTY1NzQ2OTJlNjI3Mg==
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=e46xv9V/ c=1 sm=1 a=huL5MBmc9G6gl4i1lwt7pA==:17
	a=AizhB-pfR1kA:10 a=ofYueeIUwPYA:10 a=IkcTkHD0fZMA:10 a=5-0HuVhfmKQA:10
	a=7MAGVB2D-n1pAV5-IHgA:9 a=QEXdDO2ut3YA:10 a=huL5MBmc9G6gl4i1lwt7pA==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 26-11-2013 17:27, Daniel Borkmann escreveu:
> On 11/26/2013 01:00 AM, Cesar Eduardo Barros wrote:
>> Compile-tested on x86_64.
>
> Actually with yet another version, I hoped that the "compile-tested"-only
> statement would eventually disappear, ohh well. ;)

I did compile test each version ;-) including verifying (with "make 
crypto/memneq.i") that the macro was really generating the expected 
inline assembly (with these #ifdef chains, one has to be careful with 
typos).

(Actually, I compile tested with "make crypto/memneq.o crypto/memneq.s 
crypto/memneq.i". I took a peek at the assembly to see if it made sense.)

> Resolving the OPTIMIZER_HIDE_VAR() macro for others than GCC jnto a
> barrier() seems a bit suboptimal, but assuming 99% of people will use
> GCC anyway, then for the minority of the remaining, they will worst case
> have a clever compiler and eventually mimic memcmp() in some situations,
> or have a not-so-clever compiler and execute the full code as is.

I do not think any compiler other than gcc and icc can compile 
unmodified upstream kernel code. LLVM's clang would be the one which 
comes closest, but it has gcc-compatible inline assembly, as does icc AFAIK.

The #define to barrier() within compiler-intel.h is for some compiler 
called ECC (not icc). From what I could find about it on a quick search, 
it appears to be some kind of Itanium compiler.

That part of the header was added back in 2003, and I do not believe it 
is still relevant. A comment within that #ifdef block says "Intel ECC 
compiler doesn't support gcc specific asm stmts", but there are many 
uses of unprotected inline assembly all over the kernel (including on 
the ia64 headers), so if that comment is true, the kernel will not 
compile with that compiler. It is probably a piece of leftover dead 
code. I only added to it because I am following RELOC_HIDE's example, 
and RELOC_HIDE is there.

> Anyway, I think still better than the rather ugly Makefile workaround
> imho, so I'm generally fine with this.

-- 
Cesar Eduardo Barros
cesarb@cesarb.eti.br
