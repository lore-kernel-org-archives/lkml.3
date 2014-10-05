Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbaJEKsJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 06:48:09 -0400
Received: from mail-oi0-f41.google.com ([209.85.218.41]:45099 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbaJEKsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 06:48:04 -0400
Date: Sun, 5 Oct 2014 05:47:58 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Peter Hurley <peter@hurleysoftware.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
        iommu@lists.linux-foundation.org, Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH] cma: make default CMA area size zero for x86
Message-ID: <20141005054758.0f9c06bd@as>
In-Reply-To: <1412488976-3885-1-git-send-email-akinobu.mita@gmail.com>
References: <1412488976-3885-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  5 Oct 2014 15:02:56 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> This makes CMA memory area size zero for x86 in default configuration
> (doesn't change on the other architectures).  If default CMA size is
> zero, DMA_CMA is disabled.  It can be enabled by passing cma= to the
> kernel.
> 
> This makes less impact on x86.  Because there is no mainline driver that
> requires it for x86, and Peter Hurley reported the performance
> regression, as this is trying to drive _all_ dma mapping allocations
> through a _very_ small window.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Reported-by: Peter Hurley <peter@hurleysoftware.com>
> Cc: Peter Hurley <peter@hurleysoftware.com>
> Cc: Chuck Ebbert <cebbert.lkml@gmail.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Don Dutile <ddutile@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: x86@kernel.org
> Cc: iommu@lists.linux-foundation.org
> ---
>  drivers/base/Kconfig | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index 4e7f0ff..92a5987e 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -240,6 +240,7 @@ comment "Default contiguous memory area size:"
>  config CMA_SIZE_MBYTES
>  	int "Size in Mega Bytes"
>  	depends on !CMA_SIZE_SEL_PERCENTAGE
> +	default 0 if X86
>  	default 16
>  	help
>  	  Defines the size (in MiB) of the default memory area for Contiguous
> @@ -248,6 +249,7 @@ config CMA_SIZE_MBYTES
>  config CMA_SIZE_PERCENTAGE
>  	int "Percentage of total memory"
>  	depends on !CMA_SIZE_SEL_MBYTES
> +	default 0 if X86
>  	default 10
>  	help
>  	  Defines the size of the default memory area for Contiguous Memory

You probably need to add some documentation too. Jean Delvare proposed
the below, before your change. If the default is going to be zero on
x86, that information and some further help should be added to this.

------------------------

From: Jean Delvare <jdelvare@suse.de>
Subject: [PATCH] CMA: Document cma=0

It isn't obvious that CMA can be disabled on the kernel's command
line, so document it.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/kernel-parameters.txt |    3 ++-
 drivers/base/Kconfig                |    3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

--- linux-3.17-rc7.orig/Documentation/kernel-parameters.txt	2014-09-23 13:19:06.644838292 +0200
+++ linux-3.17-rc7/Documentation/kernel-parameters.txt	2014-10-04 14:10:03.257579721 +0200
@@ -656,7 +656,8 @@ bytes respectively. Such letter suffixes
 			Sets the size of kernel global memory area for
 			contiguous memory allocations and optionally the
 			placement constraint by the physical address range of
-			memory allocations. For more information, see
+			memory allocations. A value of 0 disables CMA
+			altogether. For more information, see
 			include/linux/dma-contiguous.h
 
 	cmo_free_hint=	[PPC] Format: { yes | no }
--- linux-3.17-rc7.orig/drivers/base/Kconfig	2014-09-12 16:23:14.911353676 +0200
+++ linux-3.17-rc7/drivers/base/Kconfig	2014-10-04 13:41:37.672347240 +0200
@@ -231,6 +231,9 @@ config DMA_CMA
 	  to allocate big physically-contiguous blocks of memory for use with
 	  hardware components that do not support I/O map nor scatter-gather.
 
+	  You can disable CMA by specifying "cma=0" on the kernel's command
+	  line.
+
 	  For more information see <include/linux/dma-contiguous.h>.
 	  If unsure, say "n".
 
