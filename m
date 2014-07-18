Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422860AbaGRNuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:50:39 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:36708 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030526AbaGRNK1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:10:27 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] [RFC] initial getrandom wrapper to provide getentropy for LibreSSL
From: Brent Cook <busterb@gmail.com>
In-Reply-To: <1405666144-88053-1-git-send-email-busterb@gmail.com>
Date: Fri, 18 Jul 2014 08:09:52 -0500
Cc: tytso@mit.edu
Content-Transfer-Encoding: 8BIT
Message-Id: <1158B2FC-1289-4E10-8C99-F407123B0D01@gmail.com>
References: <1405666144-88053-1-git-send-email-busterb@gmail.com>
To: linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 18, 2014, at 1:49 AM, Brent Cook <busterb@gmail.com> wrote:

> From: Brent Cook <bcook@openbsd.org>
> 
> This is not a kernel patch, but rather an initial test of the API to see
> how it might mesh LibreSSL's expectations for how getentropy works.
> 
> It is a bit more code to carefully handle the extra return values, as
> not reading enough bytes, because there is an unhandled EINTR, might
> lead to an unseeded CSPRNG.
> 
> The syscall may return EAGAIN depending on the version of getrandom(2)
> (this will go away later), but this should give a good example of what
> its use would look like in practice.

While I think we can wrap the currently-proposed getrandom() interface to provide a safe emulation of getentropy()’s semantics, I would not be surprised to eventually find software that gets it wrong.

I am a little concerned that the interface is evolving into a Bradley Fighting Vehicle :)

https://www.youtube.com/watch?v=aXQ2lO3ieBA


> ---
> src/lib/libcrypto/crypto/getentropy_linux.c | 42 ++++++++++++++++++++++++++++-
> 1 file changed, 41 insertions(+), 1 deletion(-)
> 
> diff --git a/src/lib/libcrypto/crypto/getentropy_linux.c b/src/lib/libcrypto/crypto/getentropy_linux.c
> index c16b289..b717d91 100644
> --- a/src/lib/libcrypto/crypto/getentropy_linux.c
> +++ b/src/lib/libcrypto/crypto/getentropy_linux.c
> @@ -1,4 +1,4 @@
> -/*	$OpenBSD: getentropy_linux.c,v 1.24 2014/07/13 13:37:38 deraadt Exp $	*/
> +/*	$OpenBSD: getentropy_linux.c,v 1.25 2014/07/16 14:26:47 kettenis Exp $	*/
> 
> /*
>  * Copyright (c) 2014 Theo de Raadt <deraadt@openbsd.org>
> @@ -73,10 +73,21 @@
> 
> int	getentropy(void *buf, size_t len);
> 
> +#ifndef SYS__getrandom
> +#ifdef __LP64__
> +#define SYS__getrandom 317
> +#else
> +#define SYS__getrandom 354
> +#endif
> +#endif
> +
> #if 0
> extern int main(int, char *argv[]);
> #endif
> static int gotdata(char *buf, size_t len);
> +#ifdef SYS__getrandom
> +static int getentropy_getrandom(void *buf, size_t len);
> +#endif
> static int getentropy_urandom(void *buf, size_t len);
> #ifdef CTL_MAXNAME
> static int getentropy_sysctl(void *buf, size_t len);
> @@ -95,6 +106,13 @@ getentropy(void *buf, size_t len)
> 	}
> 
> 	/*
> +	 * Brand new system call in Linux.  Interface not yet settled.
> +	 */
> +	ret = getentropy_getrandom(buf, len);
> +	if (ret != -1)
> +		return (ret);
> +
> +	/*
> 	 * Try to get entropy with /dev/urandom
> 	 *
> 	 * This can fail if the process is inside a chroot or if file
> @@ -180,6 +198,28 @@ gotdata(char *buf, size_t len)
> }
> 
> static int
> +getentropy_getrandom(void *buf, size_t len)
> +{
> +	size_t i = 0;
> +
> +#ifdef SYS__getrandom
> +	ssize_t ret;
> +
> +	for (i = 0; i < len; ) {
> +		size_t wanted = len - i;
> +		ret = syscall(SYS__getrandom, (char *)buf + i, wanted, 0);
> +		if (ret == -1) {
> +			if (errno == EAGAIN || errno == EINTR)
> +				continue;
> +			return (-1);
> +		}
> +		i += ret;
> +	}
> +#endif
> +	return (i == len ? 0 : -1);
> +}
> +
> +static int
> getentropy_urandom(void *buf, size_t len)
> {
> 	struct stat st;
> -- 
> 2.0.1
> 

