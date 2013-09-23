Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab3IWTw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 15:52:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55267 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3IWTw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 15:52:58 -0400
Date: Mon, 23 Sep 2013 12:52:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: P J P <ppandit@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Export initial ramdisk compression config
Message-Id: <20130923125256.e53b51a137a19a972c6026a2@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.03.1309151434580.7830@erqung.pbz>
References: <alpine.LFD.2.03.1309151434580.7830@erqung.pbz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Sep 2013 14:49:05 +0530 (IST) P J P <ppandit@redhat.com> wrote:

> Make menuconfig allows one to choose compression format of an
> initial ramdisk image. But this choice does not result in duly
> compressed ramdisk image. Because - $ make install - does not
> pass on the selected compression choice to the dracut(8) tool,
> which creates the initramfs file. dracut(8) generates the image
> with the default compression, ie. gzip(1).
> 
> This patch exports the selected compression option to a sub-shell
> environment, so that it could be used by dracut(8) tool to generate
> appropriately compressed initramfs images.
> 
> There isn't a straight forward way to pass on options to dracut(8)
> via positional parameters. Because it is indirectly invoked at the
> end of a $ make install sequence.
> 
>  # make install
>    -> arch/$arch/boot/Makefile
>     -> arch/$arch/boot/install.sh
>      -> /sbing/installkernel ...
>       -> /sbin/new-kernel-pkg ...
>        -> /sbin/dracut ...
> 

It's a bit confusing whether all this appiles to initrd, to initramfs
or to both.  Can you please clarify all this and be sure that it's all
consistent?

> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -11,6 +11,23 @@ else
>          KBUILD_DEFCONFIG := $(ARCH)_defconfig
>  endif
>  
> +# Select initial ramdisk compression format, default is gzip(1).
> +# This shall be used by the dracut(8) tool while creating an initramfs image.
> +#
> +INITRD_COMPRESS=gzip
> +ifeq ($(CONFIG_RD_BZIP2), y)
> +        INITRD_COMPRESS=bzip2
> +else ifeq ($(CONFIG_RD_LZMA), y)
> +        INITRD_COMPRESS=lzma
> +else ifeq ($(CONFIG_RD_XZ), y)
> +        INITRD_COMPRESS=xz
> +else ifeq ($(CONFIG_RD_LZO), y)
> +        INITRD_COMPRESS=lzo
> +else ifeq ($(CONFIG_RD_LZ4), y)
> +        INITRD_COMPRESS=lz4
> +endif
> +export INITRD_COMPRESS

A few things...

- Why is it specific to x86?  Other architcetures use initramfs?

- People add new compression schemes fairly regularly.  We should add
  a code comment somewhere in a place where such people are sure to
  find it.  That comment should explain what's going on, remind them to
  update this environment varlaible and should explain to them the
  process by which they get dracut(8) updated if needed.

- Can we avoid having to update dracut each time a new compression
  scheme is added?  I assume your dracut changes will just exec
  "$INITRD_COMPRESS -d", so as long as any new decompression
  application uses the expected -d argument in the expected way, it
  should work seamlessly?
