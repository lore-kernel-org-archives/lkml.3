Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaHRB5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 21:57:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59544 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbaHRB5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 21:57:19 -0400
Date: Sun, 17 Aug 2014 18:56:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Philippe Reynes <tremyfr@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        andrzej.p@samsung.com
Subject: Re: [PATCH] usb: gadget: remove $(PWD) in ccflags-y
Message-ID: <20140818015643.GA14301@kroah.com>
References: <1408313287-4999-1-git-send-email-tremyfr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408313287-4999-1-git-send-email-tremyfr@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 12:08:07AM +0200, Philippe Reynes wrote:
> The variable $(PWD) is useless, and it may break the compilation.
> For example, it breaks the kernel compilation when it's done with
> buildroot :
> 
>   /home/trem/Codes/armadeus/armadeus/buildroot/output/host/usr/bin/ccache
> /home/trem/Codes/armadeus/armadeus/buildroot/output/host/usr/bin/arm-buildroot-linux-uclibcgnueabi-gcc
> -Wp,-MD,drivers/usb/gadget/legacy/.hid.o.d  -nostdinc -isystem
> /home/trem/Codes/armadeus/armadeus/buildroot/output/host/usr/lib/gcc/arm-buildroot-linux-uclibcgnueabi/4.7.3/include
> -I./arch/arm/include -Iarch/arm/include/generated  -Iinclude
> -I./arch/arm/include/uapi -Iarch/arm/include/generated/uapi
> -I./include/uapi -Iinclude/generated/uapi -include
> ./include/linux/kconfig.h -D__KERNEL__ -mlittle-endian -Wall -Wundef
> -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common
> -Werror-implicit-function-declaration -Wno-format-security
> -fno-dwarf2-cfi-asm -mabi=aapcs-linux -mno-thumb-interwork -mfpu=vfp
> -funwind-tables -marm -D__LINUX_ARM_ARCH__=5 -march=armv5te
> -mtune=arm9tdmi -msoft-float -Uarm -fno-delete-null-pointer-checks -O2
> --param=allow-store-data-races=0 -Wframe-larger-than=1024
> -fno-stack-protector -Wno-unused-but-set-variable -fomit-frame-pointer
> -fno-var-tracking-assignments -g -Wdeclaration-after-statement
> -Wno-pointer-sign -fno-strict-overflow -fconserve-stack
> -Werror=implicit-int -Werror=strict-prototypes -DCC_HAVE_ASM_GOTO
> -I/home/trem/Codes/armadeus/armadeus/buildroot/drivers/usb/gadget/
> -I/home/trem/Codes/armadeus/armadeus/buildroot/drivers/usb/gadget/udc/
> -I/home/trem/Codes/armadeus/armadeus/buildroot/drivers/usb/gadget/function/
> -DMODULE  -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(hid)"
> -D"KBUILD_MODNAME=KBUILD_STR(g_hid)" -c -o
> drivers/usb/gadget/legacy/hid.o drivers/usb/gadget/legacy/hid.c
> drivers/usb/gadget/epautoconf.c:23:26: erreur fatale: gadget_chips.h :
> Aucun fichier ou dossier de ce type
> 
> This compilation line include :
> ..../buildroot/driver/usb/gadget
> but the real path is :
> ..../buildroot/output/build/linux-3.17-rc1/driver/usb/gadget
> 
> Signed-off-by: Philippe Reynes <tremyfr@gmail.com>
> ---
>  drivers/usb/gadget/Makefile          |    2 +-
>  drivers/usb/gadget/function/Makefile |    4 ++--
>  drivers/usb/gadget/legacy/Makefile   |    6 +++---
>  3 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/usb/gadget/Makefile b/drivers/usb/gadget/Makefile
> index a186afe..9add915 100644
> --- a/drivers/usb/gadget/Makefile
> +++ b/drivers/usb/gadget/Makefile
> @@ -3,7 +3,7 @@
>  #
>  subdir-ccflags-$(CONFIG_USB_GADGET_DEBUG)	:= -DDEBUG
>  subdir-ccflags-$(CONFIG_USB_GADGET_VERBOSE)	+= -DVERBOSE_DEBUG
> -ccflags-y				+= -I$(PWD)/drivers/usb/gadget/udc
> +ccflags-y				+= -Idrivers/usb/gadget/udc

Ick, why are these here at all, shouldn't you just use the proper
relative paths in the .c files for the include files?  That way just
building a .o file individually will work properly, otherwise, it will
not.

And getting rid of those other ccflags would be good to do as well, no
need for them to be in a Makefile.

thanks,

greg k-h
