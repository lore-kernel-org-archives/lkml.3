Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab3BESDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 13:03:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755283Ab3BESDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 13:03:05 -0500
Date: Tue, 5 Feb 2013 13:03:00 -0500
From: Peter Jones <pjones@redhat.com>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] initramfs with digital signature protection
Message-ID: <20130205180300.GE2335@fenchurch.internal.datastacks.com>
References: <cover.1360067333.git.dmitry.kasatkin@intel.com>
 <cc87f1242960fad1a9fb44bcec331915e14c832b.1360067333.git.dmitry.kasatkin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cc87f1242960fad1a9fb44bcec331915e14c832b.1360067333.git.dmitry.kasatkin@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 02:34:50PM +0200, Dmitry Kasatkin wrote:
> Often initramfs is (re)fabricated on the machine on which it runs.
> In such cases it is impossible to sign initramfs image, because
> private key is not supposed to be available.

This doesn't address that problem at all.

> This patch adds support for additional digitaly signed initramfs images.
> Digitaly signed initramfs image can be loaded from conventional initramfs
> image or from rootfs and '/pre-init' is executed prior 'init' from initramfs
> or root file system. If 'pre-init' fails, kernel panics. Signed initramfs
> image must be located in '/initramfs-sig.img'.

So with this patch, you've effectively combined an unchecked initramfs with
a checked one that loads before it, and called the answer "secure".  This is
like S&P traunching a AAA mortgage with a DDD mortgage and calling it a
AAA CDO - the result isn't as good as what's claimed.

> Digitally signed initramfs can be used to provide protected user-space
> environment for initialization purpose. For example, LSM, IMA/EVM can be
> securely initialized using such approach.
> 
> Signing is done using scripts/sign-file from kernel source code and uses module
> signature format and module verification API. Important to note again that
> signing of such images should be done on the build machine.
> 
> Bellow is an example, how to sign compressed initrd (cpio) image:
> 
> scripts/sign-file -v signing_key.priv signing_key.x509 initrd.gz initramfs-sig.img

This means that if you've got multiple initramfs images, there's a signature
interleaved between them in the in-memory representation. We've used separate
images to separate invariant bits from e.g. plymouth from the initramfs that's
generated for each new kernel installed.  In general, it'd be nice to
keep multiple initramfs images working.

It's not clear to me why we need this encapsulation - wouldn't it be
better to add another [pointer,size] pair to the bootloader protocol
with a structure like:

struct {
	void *initramfs_area;
	size_t initramfs_area_len;
	void *signature;
	size_t signature_len;
};

And make that a list (all fields zero signifying the end).  That way we
can a) continue to easily support multiple initramfs images, b) allow
for /the whole initramfs to be checked/, which would be useful for e.g.
distro media?  If we really need a "parts of this are checked and parts
aren't" system, you could still allow policy to support that, but it's
not clear to me why that's a useful thing to have.

> @@ -895,6 +897,8 @@ static void __init kernel_init_freeable(void)
>  		prepare_namespace();
>  	}
>  
> +	initramfs_sig_load();
> +
>  	/*
>  	 * Ok, we have completed the initial bootup, and
>  	 * we're essentially up and running. Get rid of the

At the very least, this call should go in kernel_init() so that it's
logically after the comment you trimmed here about how we're about to
start userland running.

-- 
        Peter
