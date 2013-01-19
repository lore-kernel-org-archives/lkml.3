Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab3ASMY4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 07:24:56 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:48153 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab3ASMYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 07:24:53 -0500
Message-ID: <50FA903B.30709@synopsys.com>
Date: Sat, 19 Jan 2013 17:53:23 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>,
        "jeremy.bennett@embecosm.com" <jeremy.bennett@embecosm.com>
Subject: Re: [PATCH v2 31/76] ARC: Build system: Makefiles, Kconfig, Linker
 script
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-32-git-send-email-vgupta@synopsys.com> <20130118190452.GA14433@merkur.ravnborg.org>
In-Reply-To: <20130118190452.GA14433@merkur.ravnborg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 January 2013 12:34 AM, Sam Ravnborg wrote:
>> +#
>> +
>> +config ARC
>> +	def_bool y
>> +	select ARCH_NO_VIRT_TO_BUS
>> +	# ARC Busybox based initramfs absolutely relies on DEVTMPFS for /dev
>> +	# DEVTMPS in turn needs HOTPLUG
>> +	select DEVTMPFS if !INITRAMFS_SOURCE=""
>> +	select GENERIC_ATOMIC64
>> +	select GENERIC_CLOCKEVENTS
>> +	select GENERIC_FIND_FIRST_BIT
>> +	# for now, we don't need GENERIC_IRQ_PROBE, CONFIG_GENERIC_IRQ_CHIP
>> +	select GENERIC_IRQ_SHOW
>> +	select GENERIC_PENDING_IRQ if SMP
>> +	select GENERIC_SMP_IDLE_THREAD
>> +	select HAVE_GENERIC_HARDIRQS
>> +	select HOTPLUG if !INITRAMFS_SOURCE=""
> HOTPLUG is alwyas y now.

Done !

>> +# Hacks to enable final link due to absence of link-time branch relexation
>> +# and gcc choosing optimal(shorter) branches at -O3
>> +#
>> +# vineetg Feb 2010: -mlong-calls switched off for overall kernel build
>> +# However lib/decompress_inflate.o (.init.text) calls
>> +# zlib_inflate_workspacesize (.text) causing relocation errors.
>> +# Thus forcing all exten calls in this file to be long calls
>> +export CFLAGS_decompress_inflate.o = -mmedium-calls
>> +export CFLAGS_initramfs.o = -mmedium-calls
> This is gross..
> But I see no better way to do this for now.

Precisely - there's no better way as of now. Our GNU tools team is aware of this
and likely to provide us the much needed fix in future. Link time branch
relaxation is particularly complicated for ARCompact ISA given that we can have
insns which are 2,4,6,8 bytes long in same compilation unit. Internally I have a
hack - a build script which extracts the offending file from build errors, appends
the corresponding line to makefile and rebuilds - this is done recursively until
all relo errors are gone.

>
>> +
>> +obj-y	:= arcksyms.o setup.o irq.o time.o reset.o ptrace.o entry.o process.o \
>> +	   signal.o traps.o sys.o troubleshoot.o stacktrace.o clk.o
> For new stuff I usually recommend to drop line continuation using \
>
> Just do the much prettier:
> obj-y := arcksyms.o setup.o irq.o time.o reset.o ptrace.o entry.o process.o
> obj-y += signal.o traps.o sys.o troubleshoot.o stacktrace.o clk.o
>
>> ....
>> +# published by the Free Software Foundation.
>> +
>> +lib-y	:= strchr-700.o strcmp.o strcpy-700.o strlen.o \
>> +	   memcmp.o memcpy-700.o memset.o
> Avoid '\'
>
>> ....
>> +
>> +obj-y	:= extable.o ioremap.o dma.o fault.o init.o \
>> +	   tlb.o tlbex.o cache_arc700.o
> Avoid '\'
>
> Other these small nits I did not notice anything.
> General impression is that this looks good!
>
> 	Sam

All line continuations fixed.

Thx for the review,
-Vineet
