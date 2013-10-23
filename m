Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab3JWCx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 22:53:27 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54980 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab3JWCx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 22:53:26 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <52673A1E.60005@roeck-us.net>
Date: Tue, 22 Oct 2013 19:53:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Andrew Boie <andrew.p.boie@intel.com>,
        linux-kernel@vger.kernel.org
CC: tglx@linutronix.de, mmarek@suse.cz
Subject: Re: [PATCH 1/1] x86: boot: support minigzip bzImage compression
References: <1382476041-1115-1-git-send-email-andrew.p.boie@intel.com> <1382476041-1115-2-git-send-email-andrew.p.boie@intel.com> <e7a2d995-e90f-4912-a0b9-4cf5725b246b@email.android.com>
In-Reply-To: <e7a2d995-e90f-4912-a0b9-4cf5725b246b@email.android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2013 05:26 PM, H. Peter Anvin wrote:
> Wouldn't it be better to fix gzip than hacking around this in the kernel?
>
Or just change the build system to have /bin/gzip point to minigzip if so
desired. I have done the same to replace it with pigz.
Debian/Ubuntu provides the update-alternatives command for that
purpose. If that is not available, just hard-link it.

In general, I don't think it would be a good idea to add tool variant
dependencies like this one to the kernel configuration.

Guenter

> Andrew Boie <andrew.p.boie@intel.com> wrote:
>> Android OTA system computes very efficient diffs of compressed files
>> if the deflate() algorithm it has access to is the same version as
>> used to create the original file. Here we add support for compressing
>> the kernel with 'minigzip' which uses the deflate() inside zlib.
>> This is much better than using 'gzip' as that tool has a very old
>> version of deflate() inside the gzip codebase instead of linking
>> against
>> zlib.
>>
>> Signed-off-by: Andrew Boie <andrew.p.boie@intel.com>
>> ---
>> arch/x86/Kconfig                  |  1 +
>> arch/x86/boot/compressed/Makefile |  3 +++
>> arch/x86/boot/compressed/misc.c   |  2 +-
>> init/Kconfig                      | 18 +++++++++++++++++-
>> scripts/Makefile.lib              |  7 +++++++
>> 5 files changed, 29 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index f67e839..aa91cef 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -62,6 +62,7 @@ config X86
>> 	select HAVE_REGS_AND_STACK_ACCESS_API
>> 	select HAVE_DMA_API_DEBUG
>> 	select HAVE_KERNEL_GZIP
>> +	select HAVE_KERNEL_MINIGZIP
>> 	select HAVE_KERNEL_BZIP2
>> 	select HAVE_KERNEL_LZMA
>> 	select HAVE_KERNEL_XZ
>> diff --git a/arch/x86/boot/compressed/Makefile
>> b/arch/x86/boot/compressed/Makefile
>> index dcd90df..f000791 100644
>> --- a/arch/x86/boot/compressed/Makefile
>> +++ b/arch/x86/boot/compressed/Makefile
>> @@ -56,6 +56,8 @@ vmlinux.bin.all-$(CONFIG_X86_NEED_RELOCS) +=
>> $(obj)/vmlinux.relocs
>>
>> $(obj)/vmlinux.bin.gz: $(vmlinux.bin.all-y) FORCE
>> 	$(call if_changed,gzip)
>> +$(obj)/vmlinux.bin.mgz: $(vmlinux.bin.all-y) FORCE
>> +	$(call if_changed,minigzip)
>> $(obj)/vmlinux.bin.bz2: $(vmlinux.bin.all-y) FORCE
>> 	$(call if_changed,bzip2)
>> $(obj)/vmlinux.bin.lzma: $(vmlinux.bin.all-y) FORCE
>> @@ -68,6 +70,7 @@ $(obj)/vmlinux.bin.lz4: $(vmlinux.bin.all-y) FORCE
>> 	$(call if_changed,lz4)
>>
>> suffix-$(CONFIG_KERNEL_GZIP)	:= gz
>> +suffix-$(CONFIG_KERNEL_MINIGZIP):= mgz
>> suffix-$(CONFIG_KERNEL_BZIP2)	:= bz2
>> suffix-$(CONFIG_KERNEL_LZMA)	:= lzma
>> suffix-$(CONFIG_KERNEL_XZ)	:= xz
>> diff --git a/arch/x86/boot/compressed/misc.c
>> b/arch/x86/boot/compressed/misc.c
>> index 434f077..4e55d32 100644
>> --- a/arch/x86/boot/compressed/misc.c
>> +++ b/arch/x86/boot/compressed/misc.c
>> @@ -125,7 +125,7 @@ static char *vidmem;
>> static int vidport;
>> static int lines, cols;
>>
>> -#ifdef CONFIG_KERNEL_GZIP
>> +#if defined(CONFIG_KERNEL_GZIP) || defined(CONFIG_KERNEL_MINIGZIP)
>> #include "../../../../lib/decompress_inflate.c"
>> #endif
>>
>> diff --git a/init/Kconfig b/init/Kconfig
>> index 3ecd8a1..818f225 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -100,6 +100,9 @@ config LOCALVERSION_AUTO
>> config HAVE_KERNEL_GZIP
>> 	bool
>>
>> +config HAVE_KERNEL_MINIGZIP
>> +	bool
>> +
>> config HAVE_KERNEL_BZIP2
>> 	bool
>>
>> @@ -118,7 +121,7 @@ config HAVE_KERNEL_LZ4
>> choice
>> 	prompt "Kernel compression mode"
>> 	default KERNEL_GZIP
>> -	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA
>> || HAVE_KERNEL_XZ || HAVE_KERNEL_LZO || HAVE_KERNEL_LZ4
>> +	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_MINIGZIP ||
>> HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA || HAVE_KERNEL_XZ ||
>> HAVE_KERNEL_LZO || HAVE_KERNEL_LZ4
>> 	help
>> 	  The linux kernel is a kind of self-extracting executable.
>> 	  Several compression algorithms are available, which differ
>> @@ -144,6 +147,19 @@ config KERNEL_GZIP
>> 	  The old and tried gzip compression. It provides a good balance
>> 	  between compression ratio and decompression speed.
>>
>> +config KERNEL_MINIGZIP
>> +	bool "Minigzip"
>> +	depends on HAVE_KERNEL_MINIGZIP
>> +	help
>> +	  Use minigzip to compress the bzImage. This is very similar to gzip
>> +	  but uses the zlib library to compress, rather than the very old
>> version
>> +	  of zlib inside the gzip codebase. This is used for Android kernels
>> +	  so that the same version of the deflate() algorithm is used when
>> +	  building the kernel and constructing diffs with OTA applypatch,
>> which
>> +	  uncompresses sections of files that it detects are gzipped before
>> computing
>> +	  the diffs. If the versions of deflate() are out of alignment the
>> binary
>> +	  diffs tend to be very large.
>> +
>> config KERNEL_BZIP2
>> 	bool "Bzip2"
>> 	depends on HAVE_KERNEL_BZIP2
>> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
>> index 49392ec..deb1bb8 100644
>> --- a/scripts/Makefile.lib
>> +++ b/scripts/Makefile.lib
>> @@ -240,6 +240,13 @@ quiet_cmd_gzip = GZIP    $@
>> cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -n -f -9 > $@) || \
>> 	(rm -f $@ ; false)
>>
>> +# Minigzip
>> +#
>> ---------------------------------------------------------------------------
>> +
>> +quiet_cmd_minigzip = MINGZIP $@
>> +cmd_minigzip = (cat $(filter-out FORCE,$^) | minigzip -c -9 > $@) || \
>> +	(rm -f $@ ; false)
>> +
>> # DTC
>> #
>> ---------------------------------------------------------------------------
>>
>

