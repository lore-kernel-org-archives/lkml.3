Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbaEPVOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 17:14:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41832 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbaEPVOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 17:14:42 -0400
Message-ID: <53767FB9.5040508@infradead.org>
Date: Fri, 16 May 2014 14:14:33 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Building sh4 without CONFIG_EXPERT.
References: <53700D71.1090201@landley.net>
In-Reply-To: <53700D71.1090201@landley.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2014 04:53 PM, Rob Landley wrote:
> I got sh4 to work under QEMU years ago as part of my aboriginal linux
> project, which builds the smallest Linux system capable of rebuilding
> itself natively from source code. (You can download and run the system
> images from http://landley.net/aboriginal/bin if you're curious.)
> 
> One of the goals of Aboriginal is to make different architectures behave
> the same way, and one of the ways I do that is by having a basic kernel
> miniconfig file defining the config symbols common across platforms:
> 
>   http://landley.net/hg/aboriginal/file/1651/sources/baseconfig-linux
> 
> And then append target-specific chunks, ala the LINUX_CONFIG sections
> from each of:
> 
>   http://landley.net/hg/aboriginal/file/1651/sources/targets
> 
> The problem is, the sh4 target's target-specific chunk is an INSANE 45
> config symbols (armv5l needs 15 symbols, powerpc needs 16, i686 needs 7,
> mips needs 6...) and the reason for the verbosity is that sh4 forces on
> CONFIG_EXPERT.
> 
> As far as I can tell, the only reason sh4 is forcing on CONFIG_EXPERT is
> to get CONFIG_PATA_PLATFORM. The patch to make sh4 _not_ force on
> CONFIG_EXPERT is just:
> 
> diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
> index 834b67c..7d0d44d 100644
> --- a/arch/sh/Kconfig
> +++ b/arch/sh/Kconfig
> @@ -1,7 +1,7 @@
>  config SUPERH
>  	def_bool y
>  	select ARCH_MIGHT_HAVE_PC_PARPORT
> -	select EXPERT
> +	select HAVE_PATA_PLATFORM
>  	select CLKDEV_LOOKUP
>  	select HAVE_IDE if HAS_IOPORT_MAP
>  	select HAVE_MEMBLOCK

Since PATA_PLATFORM is:

config PATA_PLATFORM
	tristate "Generic platform device PATA support"
	depends on EXPERT || PPC || HAVE_PATA_PLATFORM

then any of EXPERT, PPC, or HAVE_PATA_PLATFORM should be sufficient.
and using HAVE_PATA_PLATFORM is more direct and obvious.

Acked-by: Randy Dunlap <rdunlap@infradead.org>


> Which swaps EXPERT for HAVE_PATA_PLATFORM, so I can still provide a hard
> drive qemu can see as /dev/sda. The result builds, boots, and works for
> me in very basic smoke testing, and lets me get my sh4-specific config
> symbol set down to 27 symbols.
> 
> (P.S. I have no idea why hitting ctrl-C kills the _emulator_ rather than
> passing it along to the emulated system. The other qemu targets don't do
> that...)
> 
> Rob
> 
> P.S. I'm using linux 3.14, qemu 2.0, and the sh4 cross compiler
> toolchain from the URL at the top of the post. I can be more explicit if
> you care...


-- 
~Randy
