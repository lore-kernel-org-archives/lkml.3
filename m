Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbaFKEWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 00:22:44 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:57678 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaFKEWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 00:22:43 -0400
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jun 2014 00:22:43 EDT
Date: Wed, 11 Jun 2014 00:12:43 -0400
From: Rich Felker <dalias@libc.org>
To: linux-kernel@vger.kernel.org
Subject: recvmmsg/sendmmsg result types inconsistent, integer overflows?
Message-ID: <20140611041243.GA1475@brightrain.aerifal.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While looking to add support for the recvmmsg and sendmmsg syscalls in
musl libc, I ran into some disturbing findings on the kernel side. In
the struct mmsghdr, the field where the result for each message is
stored has type int, which is inconsistent with the return type
ssize_t of recvmsg/sendmsg. So I tried to track down what happens when
the result is or would be larger than 2GB, and quickly found an
explanation for why the type in the structure was defined wrong:
internally, the kernel uses int as the return type for revcmsg and
sendmsg. Oops.

A bit more RTFS'ing brought me to tcp_sendmsg in net/ipv4/tcp.c (I
figured let's look at a stream-based protocol, since datagrams can
likely never be that big for any existing protocol), and as far as I
can tell, it's haphazardly mixing int and size_t with no checks for
overflows. I looked for anywhere the kernel might try to verify before
starting that the sum of the lengths of all the iovec components
doesn't overflow INT_MAX or even SIZE_MAX, but didn't find any such
checks.

Is there some magic that makes this all safe, or is this a big mess of
possibly-security-relevant bugs?

Rich
