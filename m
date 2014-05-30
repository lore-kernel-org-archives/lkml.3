Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934585AbaE3UTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:19:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47631 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755035AbaE3UTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:19:38 -0400
Message-ID: <5388E7A5.90308@zytor.com>
Date: Fri, 30 May 2014 13:18:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
CC: linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC 02/32] uapi: add struct __kernel_timespec{32,64}
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <1401480116-1973111-3-git-send-email-arnd@arndb.de>
In-Reply-To: <1401480116-1973111-3-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 01:01 PM, Arnd Bergmann wrote:
> We cannot use time_t or any derived structures beyond the year
> 2038 in interfaces between kernel and user space, on 32-bit
> machines.
> 
> This is my suggestion for how to migrate syscall and ioctl
> interfaces: We completely phase out time_t, timeval and timespec
> from the uapi header files and replace them with types that are
> either explicitly safe (__kernel_timespec64), or explicitly
> unsafe (e.g. __kernel_timespec32). For each unsafe interface,
> there needs to be a safe replacement interface.
> 

This gets really messy for structures where this is ABI-dependent.  I'm
not sure this is a net win.

> +/*
> + * __kernel_timespec64 is the general type to be used for
> + * new user space interfaces passing a time argument.
> + * 64-bit nanoseconds is a bit silly, but the advantage is
> + * that it is compatible with the native 'struct timespec'
> + * on 64-bit user space. This simplifies the compat code.
> + */
> +struct __kernel_timespec64 {
> +	long long tv_sec;
> +	long long tv_nsec;
> +};

So it seems that it is not just POSIX that is drain bramaged with this,
but the "long" type for tv_nsec idiocy has made it into the C11
standard.  This unfortunately means that now there are two standards
bodies involved, at least one of which moves very slowly.

This makes me wonder if we don't need to deal with the problem in the
case of 32-bit ABIs with 64-bit time_t.  The logical thing seems to be
to EITHER:

a. ALWAYS ignore the upper 32 bits of tv_nsec when read from user space,
   but always set them to zero, or
b. Only ignore the upper 32 bits of tv_nsec when we are known to come
   from a 32-bit ABI context, but still always return zero.  These bits
   are already only used for validity checking.

   This most likely introduces a whole lot of new tests in deep paths,
   although we probably can centralize this in a single function, which
   otherwise ends up looking a lot like compat_get_timespec().

Getting rid of struct timespec on the kernel/user boundary is probably
not really feasible.

	-hpa


