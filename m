Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab3BFF6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 00:58:14 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:51561 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752054Ab3BFF6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 00:58:11 -0500
X-Sasl-enc: gVnY92LhrDGopu+D9D+rJgZF3iMbXl4myNmDwltfXsJK 1360130289
Message-ID: <1360130286.4186.0.camel@perseus.themaw.net>
Subject: Re: [PATCH] unbreak automounter support on 64-bit kernel with
 32-bit userspace (v2)
From: Ian Kent <raven@themaw.net>
To: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        John David Anglin <dave.anglin@bell.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>, autofs@vger.kernel.org
Date: Wed, 06 Feb 2013 13:58:06 +0800
In-Reply-To: <20130204193952.GA5785@p100.box>
References: <20130204193952.GA5785@p100.box>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-04 at 20:39 +0100, Helge Deller wrote:
> automount-support is broken on the parisc architecture, because the existing
> #if list does not include a check for defined(__hppa__). The HPPA (parisc)
> architecture is similiar to other 64bit Linux targets where we have to define
> autofs_wqt_t (which is passed back and forth to user space) as int type which
> has a size of 32bit across 32 and 64bit kernels.
> 
> During the discussion on the mailing list, H. Peter Anvin suggested to invert
> the #if list since only specific platforms (specifically those who do not have
> a 32bit userspace, like IA64 and Alpha) should have autofs_wqt_t as unsigned
> long type.
> 
> This suggestion is probably the best way to go, since Arm64 (and maybe others?)
> seems to have a non-working automounter. So in the long run even for other new
> upcoming architectures this inverted check seem to be the best solution, since
> it will not require them to change this #if again (unless they are 64bit only).
> 
> Signed-off-by: Helge Deller <deller@gmx.de>
> CC: James Bottomley <James.Bottomley@HansenPartnership.com>
> CC: Catalin Marinas <catalin.marinas@arm.com>
> CC: Rolf Eike Beer <eike-kernel@sf-tec.de>
> CC: H. Peter Anvin <hpa@zytor.com>
> CC: Ian Kent <raven@themaw.net>
> 
> 
> diff --git a/include/uapi/linux/auto_fs.h b/include/uapi/linux/auto_fs.h
> index 77cdba9..bb991df 100644
> --- a/include/uapi/linux/auto_fs.h
> +++ b/include/uapi/linux/auto_fs.h
> @@ -28,25 +28,16 @@
>  #define AUTOFS_MIN_PROTO_VERSION	AUTOFS_PROTO_VERSION
>  
>  /*
> - * Architectures where both 32- and 64-bit binaries can be executed
> - * on 64-bit kernels need this.  This keeps the structure format
> - * uniform, and makes sure the wait_queue_token isn't too big to be
> - * passed back down to the kernel.
> - *
> - * This assumes that on these architectures:
> - * mode     32 bit    64 bit
> - * -------------------------
> - * int      32 bit    32 bit
> - * long     32 bit    64 bit
> - *
> - * If so, 32-bit user-space code should be backwards compatible.
> + * The wait_queue_token (autofs_wqt_t) is part of a structure which is passed
> + * back to the kernel via ioctl from userspace. On architectures where 32- and
> + * 64-bit userspace binaries can be executed it's important that the size of
> + * autofs_wqt_t stays constant between 32- and 64-bit Linux kernels so that we
> + * do not break the binary ABI interface by changing the structure size.
>   */
> -
> -#if defined(__sparc__) || defined(__mips__) || defined(__x86_64__) \
> - || defined(__powerpc__) || defined(__s390__)
> -typedef unsigned int autofs_wqt_t;
> -#else
> +#if defined(__ia64__) || defined(__alpha__) /* pure 64bit architectures */
>  typedef unsigned long autofs_wqt_t;
> +#else
> +typedef unsigned int autofs_wqt_t;
>  #endif
>  
>  /* Packet types */

Acked-by: Ian Kent <raven@themaw.net>


