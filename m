Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab3EVHd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 03:33:29 -0400
Received: from intranet.asianux.com ([58.214.24.6]:60068 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab3EVHd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 03:33:27 -0400
X-Spam-Score: -100.8
Message-ID: <519C7484.9020709@asianux.com>
Date: Wed, 22 May 2013 15:32:20 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] arm64: compiling issue for allmodconfig, need "asm/parport.h"
 by "drivers/parport/parport_pc.c"
References: <5177551D.8090007@asianux.com> <20130424082237.GA23397@arm.com> <5177B1F0.10106@asianux.com> <20130424102327.GF21850@mudshark.cambridge.arm.com> <5177BAD0.9000500@asianux.com> <20130424110511.GK23397@arm.com> <5199A453.4080402@asianux.com> <20130521131734.GD27002@arm.com> <519C1539.10908@asianux.com>
In-Reply-To: <519C1539.10908@asianux.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 08:45 AM, Chen Gang wrote:
> On 05/21/2013 09:17 PM, Catalin Marinas wrote:
>> On Mon, May 20, 2013 at 05:19:31AM +0100, Chen Gang wrote:
>>>
>>> Need add the default file in 'asm/Kbuild' just like arm has done.
>>>
>>> The build command is:
>>>   make EXTRA_CFLAGS=-W ARCH=arm64 allmodconfig
>>>   make EXTRA_CFLAGS=-W ARCH=arm64 menuconfig
>>>     set "aarch64-linux-gnu-" as cross compiling prefix.
>>>   make EXTRA_CFLAGS=-W ARCH=arm64
>>>
>>> The related error:
>>>   drivers/parport/parport_pc.c:67:25: fatal error: asm/parport.h: No such file or directory
>>
>> As I don't see when we'd need this driver, you can probably change the
>> Kconfig entry (similar to the VGA_CONSOLE one).
>>

After check the Kconfig in drivers, we can find quite a few using long
list args which related with ARCH.

And they are not only depend on ARCHs, but also depend on another
things (e.g. VGA_CONSOL also depend on !4xx && !8xx, and another
combinations).

We also can find another long list for depend on, but not related with
ARCH.

They seems not quit difficult for reading (in fact, if we separate them
into pieces and let them spread into another areas, the reader will not
see the whole dependency clearly)

For fixing bug, better as local as possible, as independent as possible,
it will be OK if only add !ARM64 for PARPORT_PC depend on, and it has
no any negative effect. But if we define CONFIG_HAVE_*, we have to let
it related with multiple platforms.

For design: if can bear current design, better not to touch it, I think
current design is still sustainable, and not complex for understanding,
so not need redesign.


The depends on samples which related with ARCH:

  ./ide/Kconfig:  depends on ALPHA || X86 || IA64 || M32R || MIPS || ARCH_RPC || ARCH_SHARK
  ./dma/Kconfig:  depends on ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX
  ./misc/Kconfig: depends on (IA64_GENERIC || IA64_SGI_SN2 || IA64_SGI_UV || X86_UV) && SMP
  ./gpio/Kconfig: depends on PPC_MPC512x || PPC_MPC831x || PPC_MPC834x || PPC_MPC837x || ...
  ./gpio/Kconfig: depends on GPIOLIB && ARCH_MSM && (ARCH_MSM7X00A || ARCH_MSM7X30 || ARCH_QSD8X50)
  ./mtd/onenand/Kconfig:        depends on ARCH_S3C64XX || ARCH_S5PC100 || ARCH_S5PV210 || ARCH_EXYNOS4
  ./net/ethernet/ti/Kconfig:      depends on PCI || EISA || AR7 || (ARM && (ARCH_DAVINCI || ARCH_OMAP3 || SOC_AM33XX))
  ./net/ethernet/ibm/Kconfig:     depends on MCA || PPC_PSERIES || PPC_PSERIES || PPC_DCR || ...
  ./net/ethernet/smsc/Kconfig:    depends on (ARM || M32R || SUPERH || MIPS || BLACKFIN || ...
  ./net/ethernet/smsc/Kconfig:    depends on (ARM || SUPERH || BLACKFIN || MIPS || MN10300)
  ./rtc/Kconfig:  depends on X86 || ALPHA || ARM || M32R || ATARI || PPC || MIPS || SPARC64
  ./rtc/Kconfig:  depends on ARCH_OMAP15XX || ARCH_OMAP16XX || ARCH_OMAP730 || ARCH_DAVINCI_DA8XX || SOC_AM33XX
  ./isdn/hisax/Kconfig:   depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN)))
  ./isdn/hisax/Kconfig:   depends on PCI && (BROKEN || !(PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN)))
  ./isdn/hisax/Kconfig:   depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN)))
  ./isdn/hisax/Kconfig:   depends on HISAX_NETJET && PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN)))
  ./input/serio/Kconfig:  depends on !PARISC && (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST) && ...
  ./char/Kconfig: depends on RTC!=y && !IA64 && !ARM && !M32R && !MIPS && !SPARC && !FRV && !S390 && !SUPERH && !AVR32 && !BLACKFIN && !UML
  ./video/console/Kconfig:        depends on !4xx && !8xx && !SPARC && !M68K && !PARISC && !FRV && !SUPERH && !BLACKFIN && !AVR32 && !MN10300 && (!ARM || ARCH_FOOTBRIDGE || ARCH_INTEGRATOR || ARCH_NETWINDER)
  ./video/Kconfig:        depends on FB && (CPU_S3C2416 || ARCH_S3C64XX || ARCH_S5P64X0 || ...
  ...



> 
> Oh, really it is, it is for PC, it seems except x86, no one else will
> use it. And for x86, it will be less and less used, in the future.
> 
> It seems it is a better candidate than VGA_CONSOLE. I will define
> CONFIG_HAVE_PARPORT_PC for it.  :-)
> 
> Thanks.
> 


-- 
Chen Gang

Asianux Corporation
