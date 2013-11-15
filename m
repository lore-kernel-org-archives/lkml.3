Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab3KOFzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 00:55:33 -0500
Received: from kiruna.synopsys.com ([198.182.44.80]:52800 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab3KOFzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 00:55:25 -0500
Message-ID: <5285B739.9060000@synopsys.com>
Date: Fri, 15 Nov 2013 11:25:05 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
Newsgroups: gmane.linux.ports.openrisc,gmane.linux.kbuild.devel,gmane.linux.kernel
To: Geert Uytterhoeven <geert@linux-m68k.org>, Jonas Bonn <jonas@southpole.se>,
        <linux-kbuild@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux@openrisc.net>
Subject: Re: [PATCH] [RFC] initramfs: Prefix simple paths with $(srctree)
References: <1384467283-14806-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1384467283-14806-1-git-send-email-geert@linux-m68k.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2013 03:44 AM, Geert Uytterhoeven wrote:
> If CONFIG_INITRAMFS_SOURCE contains relative paths inside the source tree
> (e.g. in a defconfig pointing to arch-specific files), the corresponding
> file system entries are not found when building outside the source tree.
> 
> Prefix all simple paths (paths not starting with "/", "../", or "./") with
> $(srctree) to fix this.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> This issue happens when building an OpenRISC defconfig from
> git://openrisc.net/jonas/linux. Mainline doesn't have the OpenRISC
> initramfs.

+1.
This applies to ARC defconfig too.

> 
> Questions:
>   1. Is this an acceptable solution for mainline?
>   2. My make-foo is limited. is there a better way to accomplish this, than
>      by prefixing all paths and removing the prefixes again where they're
>      not wanted?
>    
>  usr/Makefile |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/usr/Makefile b/usr/Makefile
> index e767f019accf..2170c38936ce 100644
> --- a/usr/Makefile
> +++ b/usr/Makefile
> @@ -41,6 +41,12 @@ hostprogs-y := gen_init_cpio
>  initramfs   := $(CONFIG_SHELL) $(srctree)/scripts/gen_initramfs_list.sh
>  ramfs-input := $(if $(filter-out "",$(CONFIG_INITRAMFS_SOURCE)), \
>  			$(shell echo $(CONFIG_INITRAMFS_SOURCE)),-d)
> +ifneq ("$(ramfs-input)", "-d")
> +ramfs-input := $(patsubst %, $(srctree)/%, $(ramfs-input))
> +ramfs-input := $(patsubst $(srctree)//%, /%, $(ramfs-input))
> +ramfs-input := $(patsubst $(srctree)/../%, ../%, $(ramfs-input))
> +ramfs-input := $(patsubst $(srctree)/./%, ./%, $(ramfs-input))
> +endif
>  ramfs-args  := \
>          $(if $(CONFIG_INITRAMFS_ROOT_UID), -u $(CONFIG_INITRAMFS_ROOT_UID)) \
>          $(if $(CONFIG_INITRAMFS_ROOT_GID), -g $(CONFIG_INITRAMFS_ROOT_GID))
> 

