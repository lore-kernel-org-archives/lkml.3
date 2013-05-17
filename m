Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab3EQDKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 23:10:00 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:64948 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab3EQDJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 23:09:57 -0400
MIME-Version: 1.0
In-Reply-To: <1368727412.27102.289.camel@schen9-DESK>
References: <20130515132627.817585a3d9fb3a3e502eb586@canb.auug.org.au>
	<5193CCEC.7070909@infradead.org>
	<alpine.DEB.2.02.1305161152530.31865@M2420>
	<CAMuHMdUmD2DMNeezetHNbe9DgQXpTN4BEfEmJSztyzCivQpyXQ@mail.gmail.com>
	<1368723552.27102.286.camel@schen9-DESK>
	<1368727412.27102.289.camel@schen9-DESK>
Date: Fri, 17 May 2013 11:09:54 +0800
Message-ID: <CADJHv_tk3B=jSKBkpFYc+xjVs=1yC3RcXtdZUbz7sEYdWqbv=Q@mail.gmail.com>
Subject: Re: linux-next: Tree for May 15 (crypto /crct10dif)
From: Xiong Zhou <jencce.kernel@gmail.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/17 Tim Chen <tim.c.chen@linux.intel.com>:
> On Thu, 2013-05-16 at 09:59 -0700, Tim Chen wrote:
>> On Thu, 2013-05-16 at 09:22 +0200, Geert Uytterhoeven wrote:
>> > On Thu, May 16, 2013 at 5:57 AM, Xiong Zhou <jencce.kernel@gmail.com> wrote:
>> > > --- a/crypto/Kconfig
>> > > +++ b/crypto/Kconfig
>> > > @@ -378,6 +378,7 @@ config CRYPTO_CRC32_PCLMUL
>> > >
>> > >  config CRYPTO_CRCT10DIF
>> > >         tristate "CRCT10DIF algorithm"
>> > > +       depends on CRC_T10DIF
>> >
>> > This is a library symbol, so "select CRC_T10DIF"?
>> >
>> > >         select CRYPTO_HASH
>> > >         help
>> > >           CRC T10 Data Integrity Field computation is being cast as
>> >
>> > Gr{oetje,eeting}s,
>> >
>> >                         Geert
>> >
>>
>> This is the fix I think that will resolve the build issues.  The generic
>> crc-t10dif transform depends on the library function crc_t10dif_generic
>> in lib/crc-t10dif.c, so "depends on CRC_T10DIF" for CRYPTO_CRCT10DIF is
>> needed.
>>
>> Now for CRC_T10DIF, we should use select CRYPTO_HASH, so it can try to
>> allocate a T10DIF transform if it is available.  If not, it will simply
>> use the crc_t10dif_generic function. Loading the
>> generic t10dif crypto transform is not mandatory for the library
>> function crc_t10dif.
>>
>> Thanks for catching the issues.
>>
>> Tim
>>

cool.

>
> Need to also add select CRYPTO for CRC_T10DIF.  Updated fix below:
>
>
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> ---
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index d1ca631..015df24 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -379,6 +379,7 @@ config CRYPTO_CRC32_PCLMUL
>  config CRYPTO_CRCT10DIF
>         tristate "CRCT10DIF algorithm"
>         select CRYPTO_HASH
> +       depends on CRC_T10DIF
>         help
>           CRC T10 Data Integrity Field computation is being cast as
>           a crypto transform.  This allows for faster crc t10 diff
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 0cee056..6407793 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -63,7 +63,8 @@ config CRC16
>
>  config CRC_T10DIF
>         tristate "CRC calculation for the T10 Data Integrity Field"
> -       select CRYPTO_CRCT10DIF
> +       select CRYPTO
> +       select CRYPTO_HASH
>         help
>           This option is only needed if a module that's not in the
>           kernel tree needs to calculate CRC checks for use with the
>
>
