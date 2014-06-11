Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbaFKFJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 01:09:06 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:50348 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaFKFJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 01:09:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140611041243.GA1475@brightrain.aerifal.cx>
References: <20140611041243.GA1475@brightrain.aerifal.cx>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Wed, 11 Jun 2014 07:08:43 +0200
X-Google-Sender-Auth: Gruw7OwVcp1q87KCa4wM4g9OPRM
Message-ID: <CAHO5Pa2WJJS0um6mVo-DaeR3rw7z_Ayc8ZYbyVdd-_dFc4zRgQ@mail.gmail.com>
Subject: Re: recvmmsg/sendmmsg result types inconsistent, integer overflows?
To: Rich Felker <dalias@libc.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, acme@kernel.org,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Anton Blanchard <anton@samba.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding developers of the two syscalls to CC; maybe they have some insights.]

On Wed, Jun 11, 2014 at 6:12 AM, Rich Felker <dalias@libc.org> wrote:
> While looking to add support for the recvmmsg and sendmmsg syscalls in
> musl libc, I ran into some disturbing findings on the kernel side. In
> the struct mmsghdr, the field where the result for each message is
> stored has type int, which is inconsistent with the return type
> ssize_t of recvmsg/sendmsg. So I tried to track down what happens when
> the result is or would be larger than 2GB, and quickly found an
> explanation for why the type in the structure was defined wrong:
> internally, the kernel uses int as the return type for revcmsg and
> sendmsg. Oops.
>
> A bit more RTFS'ing brought me to tcp_sendmsg in net/ipv4/tcp.c (I
> figured let's look at a stream-based protocol, since datagrams can
> likely never be that big for any existing protocol), and as far as I
> can tell, it's haphazardly mixing int and size_t with no checks for
> overflows. I looked for anywhere the kernel might try to verify before
> starting that the sum of the lengths of all the iovec components
> doesn't overflow INT_MAX or even SIZE_MAX, but didn't find any such
> checks.
>
> Is there some magic that makes this all safe, or is this a big mess of
> possibly-security-relevant bugs?
>
> Rich
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
