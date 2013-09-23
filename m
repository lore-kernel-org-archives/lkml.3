Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab3IWTlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 15:41:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55231 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab3IWTlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 15:41:12 -0400
Date: Mon, 23 Sep 2013 12:41:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: P J P <ppandit@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Fix NULL pointer dereference while loading
 initramfs
Message-Id: <20130923124110.9b8aebd78c2b602255f1dc1f@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.03.1309151431180.7830@erqung.pbz>
References: <alpine.LFD.2.03.1309151431180.7830@erqung.pbz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Sep 2013 14:33:53 +0530 (IST) P J P <ppandit@redhat.com> wrote:

> Make menuconfig allows one to choose compression format of an
> initial ramdisk image. But this choice does not result in duly
> compressed initial ramdisk image. Because - $ make install - does
> not pass on the selected compression choice to the dracut(8) tool,
> which creates the initramfs file. dracut(8) generates the image
> with the default compression, ie. gzip(1).
> 
> If a user chose any other compression instead of gzip(1), it leads
> to a crash due to NULL pointer dereference in crd_load(), caused by
> a NULL function pointer returned by the 'decompress_method()' routine.
> Because the initramfs image is gzip(1) compressed, whereas the kernel
> knows how decompress the chosen format and not gzip(1).
> 
> This patch replaces the crash by an explicit panic() call with an
> appropriate error message. This shall prevent the kernel from
> eventually panicking in: init/do_mounts.c: mount_block_root() with
>   -> panic("VFS: Unable to mount root fs on %s", b);
> 
> Signed-off-by: P J P <prasad@redhat.com>
> 
> diff --git a/init/do_mounts_rd.c b/init/do_mounts_rd.c
> index 6be2879..76faec1 100644
> --- a/init/do_mounts_rd.c
> +++ b/init/do_mounts_rd.c
> @@ -342,6 +342,13 @@ static int __init crd_load(int in_fd, int out_fd, decompress_fn deco)
>  	int result;
>  	crd_infd = in_fd;
>  	crd_outfd = out_fd;
> +
> +    if (!deco)
> +    {
> +        printk(KERN_EMERG "Invalid decompression routine address: %p\n", deco);
> +        panic("Could not decompress initial ramdisk image.");
> +    }

A few things here.

- the coding style is very unconventional.  We'd do it like this:

static int __init crd_load(int in_fd, int out_fd, decompress_fn deco)
{
	int result;
	crd_infd = in_fd;
	crd_outfd = out_fd;

	if (!deco) {
		pr_emerg("Invalid decompression routine address: %p\n", deco);
		panic("Could not decompress initial ramdisk image.");
	}

	result = deco(NULL, 0, compr_fill, compr_flush, NULL, NULL, error);
	if (decompress_error)
		result = 1;
	return result;
}

- Note the use of the pr_emerg() shorthand, which prevents the
  statement from overflowing 80 columns.

- There isn't much point in printing the value of `deco' - we already
  know it's NULL.  Isn't there some more useful message we can display
  which will tell the user what he/she did wrong, and which explains
  how to fix it?

- Is anyone working on fixing up Kconfig/dracut(8) so the correct
  decompression method is used?

