Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131Ab3GDA6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 20:58:31 -0400
Received: from intranet.asianux.com ([58.214.24.6]:15435 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab3GDA6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 20:58:30 -0400
X-Spam-Score: -100.8
Message-ID: <51D4C87E.5070605@asianux.com>
Date: Thu, 04 Jul 2013 08:57:34 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>,
        David Sharp <dhsharp@google.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        uml-user <user-mode-linux-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <trivial@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] include/asm-generic/io.h: add dummy fuctions to support
 'COMPILE_TEST' in 'asm-generic'.
References: <51CA8AB8.7080504@asianux.com> <CAMuHMdW58CZ0m-10ibs2Vyh8exqP1nSH+-ZOr5J58tx=uorM+Q@mail.gmail.com> <51D375AA.5060300@asianux.com> <201307031014.12583.arnd@arndb.de> <51D3E440.7090105@asianux.com>
In-Reply-To: <51D3E440.7090105@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'asm-generic' neither belongs to architectures nor belongs to modules,
it provides public services to both modules and architectures.


'COMPILE_TEST=y' will let 'asm-generic' provide self checking sevices to
both modules and architectures (especially with allmodconfig and
"EXTRA_CFLAGS=-W")

For modules (especially which will run under the specific architecture
soon), the developer can find more compiling issues before they really
support it.

For architectures, can let modules compile as much as possible (if
"COMPILE_TEST=y"), it will give a better check for the architectures.


At present, most of architectures (include various machine/cpu in an
architecture) can not pass compiling with 'allmodconfig'. One of the
main reasons is the HW of the specific architecture does not support.

It is neither architectures issue nor modules issue, the root cause is:
"now, 'asm-generic' doesn't provide the related necessary public
services for it".


Thanks.

On 07/03/2013 04:43 PM, Chen Gang wrote:
> On 07/03/2013 04:14 PM, Arnd Bergmann wrote:
>> On Wednesday 03 July 2013, Chen Gang wrote:
>>>> On 07/02/2013 06:57 PM, Geert Uytterhoeven wrote:
>>>>>> On Tue, Jul 2, 2013 at 10:00 AM, Chen Gang <gang.chen@asianux.com> wrote:
>>>>>>>>>> On 07/02/2013 03:19 PM, Geert Uytterhoeven wrote:
>>>>>>>>>>>>>> On Tue, Jul 2, 2013 at 4:13 AM, Chen Gang <gang.chen@asianux.com> wrote:
>>>>>> I mean that COMPILE_TEST should exist in Kconfig files only.
>>>>>> It's only meant to have more compile coverage, not to "fix" (through #ifdef)
>>>>>> more code to make it compile.
>>>>
>>>> If so, can we allow the module to 'COMPILE_TEST' under one platform
>>>> which not support the related HW ?
>>>>
>>>>   e.g. "...Despite they cannot be loaded there (or even when they load
>>>> they cannot be used due to missing HW support)...".
>> There is a reason why ioremap and the associated functions make no
>> sense on UML, and it remains important to not provide them here
>> so we can find drivers that accidentally use them and are missing
>> a dependency on HAS_IOMEM.
>>  
> 
> Yeah, it is necessary for "asm-generic" to provide the configuration
> checking features (e.g. check HAS_IOMEM, HAS_IOMAP, ...).
> 
> And it really make no sense on UML.
> 
>>>> 'asm-generic' need provide generic layer to users (both architecture
>>>> guys and module guys).
>> No. It's a set of examples for the architectures to look at and
>> include if they want to.
>>
> 
> If really just like what you said, I recommend to use "asm-default"
> instead of "asm-generic".
> 
> And for module guys, they have to use another 'generic' files instead
> of current 'asm-generic', they really need some 'generic' things to
> prevent the various definitions/implementations spread into anywhere.
> 
>>>> So for 'default', it can depend on some conditions (e.g. HW support);
>>>> but for 'generic', it need try to be independent from any conditions.
>>>>
>>>> And it is also necessary for 'generic' to provide the configuration
>>>> checking features, but this checking must be no negative effect (or
>>>> consistent) with its 'generic' services.
>>>>
>>>> So it is necessary to check 'NOMMU', 'CONFIG_HAS_IOMEM' ..., but it
>>>> also necessary to consider about 'COMPILE_TEST' to be consistent with
>>>> its 'generic' services.
>> The important distinction is between drivers we want to enable in
>> COMPILE_TEST because they are written in a portable way but are just
>> useless if you don't have the hardware, and other drivers that rely
>> on an interface and that should not be built when that interface
>> is not available.
> 
> For user/distributor, they are just like what you said above, but for
> some of developers ...
> 
> The comments of 'COMPILE_TEST' in init/Kconfig:
> 
> config COMPILE_TEST
>        bool "Compile also drivers which will not load"
>        default n
>        help
>          Some drivers can be compiled on a different platform than they are
>          intended to be run on. Despite they cannot be loaded there (or even
>          when they load they cannot be used due to missing HW support),
>          developers still, opposing to distributors, might want to build such
>          drivers to compile-test them.
> 
>          If you are a developer and want to build everything available, say Y
>          here. If you are a user/distributor, say N here to exclude useless
>          drivers to be distributed.
> 
> 
> Thanks.
> 


-- 
Chen Gang
