Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbaIDFXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 01:23:13 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:32829 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbaIDFXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 01:23:11 -0400
MIME-Version: 1.0
In-Reply-To: <1409778695.5546.55.camel@x220>
References: <20140901065916.28909.35097.stgit@zurg>
	<20140901071639.28909.88888.stgit@zurg>
	<1409778695.5546.55.camel@x220>
Date: Thu, 4 Sep 2014 09:23:10 +0400
Message-ID: <CALYGNiOrTRHYbirZ1CNrvzsN9qKC3TgHnQQp9Am8pQqbZvdQ_A@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] kconfig: link CONFIG_CROSS_COMPILE with
 environment variable
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Michal Marek <mmarek@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 1:11 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Hi Konstantin,
>
> On Mon, 2014-09-01 at 11:16 +0400, Konstantin Khlebnikov wrote:
>> Cross-compiler tool prefix can be set in command line, in the environment
>> variable CROSS_COMPILE or in config file, in option CONFIG_COROSS_COMPILE.
>> Also some arch/*/Makefile provides default value.
>>
>> This patch links config option CONFIG_CROSS_COMPILE and variable CROSS_COMPILE
>> in both directions: environment/command line has higher priority and updates
>> value saved in the config file, config option acts as default value for it.
>>
>> This is especially useful together with option O=dir which allows to create
>> separate directory for each target architecture and kernel flavor:
>>
>> # make O=build/arm ARCH=arm CROSS_COMPILE=arm-none-eabi- defconfig
>> # make -C build/arm
>>
>> Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
>
> I have only had a quick glance at this series. Just a quick question to
> help me understand where it is going.
>
> Would this patch mean that, if a (def)config file has both ARCH and
> CROSS_COMPILE set, one could use that (def)config file and invoke "make
> $whatever_target" and expect it to do the right thing (provided a
> suitable cross compiler is installed)?
>
> This implies cross compiler prefixes are standardized across
> distributions, I guess. Maybe they're not.

As I know they are not strictly standardized.
Naming convention is arch[-vendor][-os]-abi, but there is a lot of
possible combinations.

>
>> ---
>>  Makefile     |    6 +++++-
>>  init/Kconfig |    1 +
>>  2 files changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/Makefile b/Makefile
>> index f648405..1044f40 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -263,7 +263,11 @@ endif
>>  # "make" in the configured kernel build directory always uses that.
>>  # Default value for CROSS_COMPILE is not to prefix executables
>>  # Note: Some architectures assign CROSS_COMPILE in their arch/*/Makefile
>> -CROSS_COMPILE        ?= $(CONFIG_CROSS_COMPILE:"%"=%)
>> +ifndef CROSS_COMPILE
>> +     CROSS_COMPILE := $(shell $(srctree)/scripts/config \
>> +                             --file $(KBUILD_OUTPUT)$(KCONFIG_CONFIG) \
>> +                             --if-undef "" --state "CROSS_COMPILE")
>> +endif
>>
>>  # Architecture as present in compile.h
>>  UTS_MACHINE  := $(ARCH)
>> diff --git a/init/Kconfig b/init/Kconfig
>> index e84c642..1c2f621 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -47,6 +47,7 @@ config INIT_ENV_ARG_LIMIT
>>
>>  config CROSS_COMPILE
>>       string "Cross-compiler tool prefix"
>> +     option env="CROSS_COMPILE"
>>       help
>>         Same as running 'make CROSS_COMPILE=prefix-' but stored for
>>         default make runs in this kernel build directory.  You don't
>>
>
>
> Paul Bolle
>
