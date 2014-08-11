Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbaHKQgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 12:36:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37936 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbaHKQgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 12:36:54 -0400
Message-ID: <53E8F120.8070209@infradead.org>
Date: Mon, 11 Aug 2014 09:36:48 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: HuKeping <hukeping@huawei.com>, vgoyal@redhat.com, hbabu@us.ibm.com
CC: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, peifeiyue@huawei.com
Subject: Re: [PATCH V2] Add arm description to Documentation/kdump/kdump.txt
References: <1407730479-20800-1-git-send-email-hukeping@huawei.com>
In-Reply-To: <1407730479-20800-1-git-send-email-hukeping@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/14 21:14, HuKeping wrote:
> ----------------------------------------
> 
> Add arm specific parts to kdump kernel documentation.
> 
> It seem that we prefer to use nr_cpus=1 instead of maxcpus=1. but nr_cpus
> does not work fine on arm.
> There will be a warning when dump-caputre kernel booting if use nr_cpus:
> 
> "[    0.000000] DT/cpu 2nodes greater than max cores 1, capping them"
> 
> This is from arch/arm/kernel/devtree.c, in function
> void __init arm_dt_init_cpu_maps(void)
> 
> 145    if (WARN(cpuidx > nr_cpu_ids, "DT /cpu %u nodes greater than "
> 146                "max cores %u, capping them\n",
> 147                cpuidx, nr_cpu_ids)) {
> 148        cpuidx = nr_cpu_ids;
> 149        break;
> 150    }
> 
> Since we have already using nr_cpus to specify the number of cpus we
> want to be online, kdump should not to make the comparison with dtb
> (which is strongly recommended on arm-32bit ) again, but it does, so the
> warning out.
> Meanwhile the maxcpus works fine.
> 
> v1 -> v2:
> - Add description about dump-capture kernel config options(Arch Dependent, arm).
> 
> - Add description about the defference between arm and the others.
>   on extended crashkernel syntax
> 
> Signed-off-by: Hu Keping <hukeping@huawei.com>
> ---
>  Documentation/kdump/kdump.txt | 37 ++++++++++++++++++++++++++++++++++---
>  1 file changed, 34 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
> index 88d5a86..d07b902 100644
> --- a/Documentation/kdump/kdump.txt
> +++ b/Documentation/kdump/kdump.txt
> @@ -18,7 +18,7 @@ memory image to a dump file on the local disk, or across the network to
>  a remote system.
>  
>  Kdump and kexec are currently supported on the x86, x86_64, ppc64, ia64,
> -and s390x architectures.
> +s390x and arm architectures.
>  
>  When the system kernel boots, it reserves a small section of memory for
>  the dump-capture kernel. This ensures that ongoing Direct Memory Access
> @@ -112,7 +112,7 @@ There are two possible methods of using Kdump.
>  2) Or use the system kernel binary itself as dump-capture kernel and there is
>     no need to build a separate dump-capture kernel. This is possible
>     only with the architectures which support a relocatable kernel. As
> -   of today, i386, x86_64, ppc64 and ia64 architectures support relocatable
> +   of today, i386, x86_64, ppc64, ia64 and arm architectures support relocatable
>     kernel.
>  
>  Building a relocatable kernel is advantageous from the point of view that
> @@ -241,6 +241,14 @@ Dump-capture kernel config options (Arch Dependent, ia64)
>    kernel will be aligned to 64Mb, so if the start address is not then
>    any space below the alignment point will be wasted.
>  
> +Dump-capture kernel config options (Arch Dependent, arm)
> +----------------------------------------------------------
> +
> +-   To use a relocatable kernel,
> +    Enable "AUTO_ZRELADDR" support under "Boot" options:
> +
> +    AUTO_ZRELADDR=y
> +
>  
>  Extended crashkernel syntax
>  ===========================
> @@ -256,6 +264,10 @@ The syntax is:
>      crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
>      range=start-[end]
>  
> +Plesse note, on arm, the offset is required.

   Please

> +    crashkernel=<range1>:<size1>[,<range2>:<size2>,...]@offset
> +    range=start-[end]
> +
>      'start' is inclusive and 'end' is exclusive.
>  
>  For example:
> @@ -296,6 +308,12 @@ Boot into System Kernel
>     on the memory consumption of the kdump system. In general this is not
>     dependent on the memory size of the production system.
>  
> +   On arm, use "crashkernel=Y@X". Note that the start address of the kernel
> +   will be aligned to 128MiB (0x08000000), so if the start address is not then
> +   any space blow the alignment point may be overwrited by the dump-caputre kernel,

                below                           overwritten       dump-capture

> +   which means it is possible that the vmcore is not that precise as expected.
> +
> +
>  Load the Dump-capture Kernel
>  ============================
>  
> @@ -315,7 +333,8 @@ For ia64:
>  	- Use vmlinux or vmlinuz.gz
>  For s390x:
>  	- Use image or bzImage
> -
> +For arm:
> +	- Use zImage
>  
>  If you are using a uncompressed vmlinux image then use following command
>  to load dump-capture kernel.
> @@ -331,6 +350,15 @@ to load dump-capture kernel.
>     --initrd=<initrd-for-dump-capture-kernel> \
>     --append="root=<root-dev> <arch-specific-options>"
>  
> +If you are using a compressed zImage, then use following command
> +to load dump-capture kernel.
> +
> +   kexec --type zImage -p <dump-capture-kernel-bzImage> \
> +   --initrd=<initrd-for-dump-capture-kernel> \
> +   --dtb=<dtb-for-dump-capture-kernel> \
> +   --append="root=<root-dev> <arch-specific-options>"
> +
> +
>  Please note, that --args-linux does not need to be specified for ia64.
>  It is planned to make this a no-op on that architecture, but for now
>  it should be omitted
> @@ -347,6 +375,9 @@ For ppc64:
>  For s390x:
>  	"1 maxcpus=1 cgroup_disable=memory"
>  
> +For arm:
> +	"1 maxcpus=1 reset_devices"
> +
>  Notes on loading the dump-capture kernel:
>  
>  * By default, the ELF headers are stored in ELF64 format to support
> 

The kdump maintainers should merge this patch when it is ready.  Thanks.

-- 
~Randy
