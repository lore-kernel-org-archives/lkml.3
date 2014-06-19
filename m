Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934552AbaFSS1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 14:27:09 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:44605 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934205AbaFSS1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 14:27:05 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Olof Johansson <olof@lixom.net>,
        Linaro Networking <linaro-networking@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: zImage: ensure header in LE format for BE8 kernels
References: <1397147232-28516-1-git-send-email-taras.kondratiuk@linaro.org>
	<CAGa+x85P-M3qUD6L=kezkiQ1NJymEZ9P=u2ANUZJu2b3F+o5LA@mail.gmail.com>
	<53A1D701.8060404@codeaurora.org>
	<CAGa+x86DfDjQG8gN2-x7Kapt2ipsYt879R4OK6JWGoaT93VVig@mail.gmail.com>
	<53A1D8FE.6030404@codeaurora.org>
	<CAGa+x87rnQntQpTkR6dZr29NvEQ4x8SOAyo+z9xuYHEdxdG1xg@mail.gmail.com>
	<alpine.LFD.2.11.1406181720130.16842@knanqh.ubzr>
Date: Thu, 19 Jun 2014 11:27:02 -0700
In-Reply-To: <alpine.LFD.2.11.1406181720130.16842@knanqh.ubzr> (Nicolas
	Pitre's message of "Wed, 18 Jun 2014 17:35:08 -0400 (EDT)")
Message-ID: <7hk38cycuh.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre <nicolas.pitre@linaro.org> writes:

> On Wed, 18 Jun 2014, Kevin Hilman wrote:
>
>> On Wed, Jun 18, 2014 at 11:22 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> > On 06/18/14 11:21, Kevin Hilman wrote:
>> >> On Wed, Jun 18, 2014 at 11:14 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> >>> On 06/18/14 10:55, Kevin Hilman wrote:
>> >>>> All of that to say, with this patch applied, I need a new (and
>> >>>> reliable) way to determine the endianness of a kernel just by looking
>> >>>> at the zImage.  Recommendations welcome.
>> >>> Assuming that you have the .config configured to be built into the
>> >>> kernel you could use extract-ikconfig
>> >>>
>> >>> $ ./scripts/extract-ikconfig zImage | grep CONFIG_CPU_ENDIAN_BE8
>> >> Unfortunately, I can't rely on having that built in since I want the
>> >> boot tools to be as generic as possible.
>> >>
>> >>
>> >
>> > Yeah ok. Perhaps you can look for the 'setend be' instruction right
>> > after the magic values instead.
>> 
>> Yeah, that works, as long as I can always assume that instruction will
>> be at the same offset (currently at 0x30).
>
> Well... then you also have to test for the Thumb2 variant. 

Ah, right.

> And that forces this instruction to always be there.
>
> If we're to "officialize" this, I'd much prefer we add another magic 
> value like this:
>
> diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
> index c95feab6ce..413fd94b53 100644
> --- a/arch/arm/boot/compressed/head.S
> +++ b/arch/arm/boot/compressed/head.S
> @@ -128,6 +128,7 @@ start:
>  		.word	_magic_sig	@ Magic numbers to help the loader
>  		.word	_magic_start	@ absolute load/run zImage address
>  		.word	_magic_end	@ zImage end address
> +		.word	0x04030201	@ endianness flag
>  
>   THUMB(		.thumb			)
>  1:

I think this should probably be officialized since we've taken away the
ability for magic-number checking tools (like 'file') to distinguish
between big- and little-endian zImages.

For now, I've updated my tools to check for 'setend be' in ARM and
Thumb2 mode, but if this does get officialized, I'll gladly move over to
it.

Kevin

