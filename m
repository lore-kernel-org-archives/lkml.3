Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab3HEBCO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 21:02:14 -0400
Received: from outbound-mail03.westnet.com.au ([203.10.1.244]:2329 "EHLO
	outbound-mail03.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754066Ab3HEBCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 21:02:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApQBAPv2/lGVhxBY/2dsb2JhbAANTYcbvASBM4MYAQEBBCMPAUUBEAsSBgICBRYEBwICCQMCAQIBDygOBg0BBQIBAYd5AQOjcnSHdg2IXoEoi3+BKIFKB4JmgScDlXeMDIIFhwWBS4FW
X-IronPort-AV: E=Sophos;i="4.89,814,1367942400"; 
   d="scan'208";a="352142821"
X-WN-REMOTEIP: 149.135.16.88
X-WN-ENVELOPESENDER: gregungerer@westnet.com.au
X-WN-MID: 352142821
X-WN-SMTPAUTHID: gregungerer
Message-ID: <51FEF6D2.2090009@westnet.com.au>
Date: Mon, 05 Aug 2013 10:50:26 +1000
From: Greg Ungerer <gregungerer@westnet.com.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Michael Schmitz <schmitzmic@gmail.com>, Chen Gang <gang.chen@asianux.com>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        uClinux development list <uclinux-dev@uclinux.org>
Subject: Re: [PATCH] arch: m68k: include: asm: define 'VM_DATA_DEFAULT_FLAGS'
 no matter whether has 'NOMMU' or not.
References: <51C548E2.1060104@asianux.com> <51C54A9B.9060009@asianux.com> <51CE9442.2020105@gmail.com> <CAMuHMdVAQJWDem0=uMnH7iVrckxPJ9cPn=8pYOusNov+wW5VeA@mail.gmail.com>
In-Reply-To: <CAMuHMdVAQJWDem0=uMnH7iVrckxPJ9cPn=8pYOusNov+wW5VeA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On 29/06/13 18:26, Geert Uytterhoeven wrote:
> On Sat, Jun 29, 2013 at 10:01 AM, Michael Schmitz <schmitzmic@gmail.com> wrote:
>>> The same .config file, also report the compiling error below:
>>>
>>> drivers/i2c/busses/i2c-ocores.c:81:2: error: implicit declaration of
>>> function ‘iowrite8’ [-Werror=implicit-function-declaration]
>>> drivers/i2c/busses/i2c-ocores.c:86:2: error: implicit declaration of
>>> function ‘iowrite16’ [-Werror=implicit-function-declaration]
>>> drivers/i2c/busses/i2c-ocores.c:91:2: error: implicit declaration of
>>> function ‘iowrite32’ [-Werror=implicit-function-declaration]
>>> drivers/i2c/busses/i2c-ocores.c:96:2: error: implicit declaration of
>>> function ‘ioread8’ [-Werror=implicit-function-declaration]
>>> drivers/i2c/busses/i2c-ocores.c:101:2: error: implicit declaration of
>>> function ‘ioread16’ [-Werror=implicit-function-declaration]
>>> drivers/i2c/busses/i2c-ocores.c:106:2: error: implicit declaration of
>>> function ‘ioread32’ [-Werror=implicit-function-declaration]
>>>
>>> Excuse me, I am not quite familiar with the related hardware and m68k,
>>> I guess under m68k architecture, we need not this drivers, is it correct ?
> 
> Until someone synthesizes the OpenCores i2c core together with the
> OpenCores 68000 core (they seem to have one), and tries to run uClinux
> on it...
> 
>> That would be correct, yes. Perhaps add appropriate dependencies in
>> drivers/i2c/Kconfig to allow building I2C drivers
>> only on hardware that supports it?
> 
> We still want it for compile-coverage.
> 
> Now, the issue is that m68knommu doesn't implement ioread8() and
> friends, so I'm adding the uClinux list.

I think this is relatively strait forward to fix. And we end up
making m68knommu targets consistent with the MMU m68k targets in
the process.

Regards
Greg



[PATCH] m68knommu: user generic iomap to support ioread*/iowrite*

There is no reason we cannot use the generic iomap support to give us
the ioread* and iowrite* family of IO access functions. The m68k arch with
MMU enabled does, so this makes us consistent for all m68k now.

Some potentially valid drivers will fail to compile without these,
for example:

drivers/i2c/busses/i2c-ocores.c:81:2: error: implicit declaration of
function ‘iowrite8’ [-Werror=implicit-function-declaration]
drivers/i2c/busses/i2c-ocores.c:86:2: error: implicit declaration of
function ‘iowrite16’ [-Werror=implicit-function-declaration]
drivers/i2c/busses/i2c-ocores.c:91:2: error: implicit declaration of
function ‘iowrite32’ [-Werror=implicit-function-declaration]
drivers/i2c/busses/i2c-ocores.c:96:2: error: implicit declaration of
function ‘ioread8’ [-Werror=implicit-function-declaration]
drivers/i2c/busses/i2c-ocores.c:101:2: error: implicit declaration of
function ‘ioread16’ [-Werror=implicit-function-declaration]
drivers/i2c/busses/i2c-ocores.c:106:2: error: implicit declaration of
function ‘ioread32’ [-Werror=implicit-function-declaration]

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---
 arch/m68k/Kconfig             | 2 +-
 arch/m68k/include/asm/io_no.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 821170e..c3cda41 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -11,6 +11,7 @@ config M68K
 	select VIRT_TO_BUS
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
 	select GENERIC_CPU_DEVICES
+	select GENERIC_IOMAP
 	select GENERIC_STRNCPY_FROM_USER if MMU
 	select GENERIC_STRNLEN_USER if MMU
 	select FPU if MMU
@@ -72,7 +73,6 @@ source "kernel/Kconfig.freezer"
 config MMU
 	bool "MMU-based Paged Memory Management Support"
 	default y
-	select GENERIC_IOMAP
 	help
 	  Select if you want MMU-based virtualised addressing space
 	  support by paged memory management. If unsure, say 'Y'.
diff --git a/arch/m68k/include/asm/io_no.h b/arch/m68k/include/asm/io_no.h
index 353bf75..e153478 100644
--- a/arch/m68k/include/asm/io_no.h
+++ b/arch/m68k/include/asm/io_no.h
@@ -4,6 +4,7 @@
 #ifdef __KERNEL__
 
 #include <asm/virtconvert.h>
+#include <asm-generic/iomap.h>
 
 /*
  * These are for ISA/PCI shared memory _only_ and should never be used

