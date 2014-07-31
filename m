Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394AbaGaTYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 15:24:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49961 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaGaTYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 15:24:34 -0400
Date: Thu, 31 Jul 2014 12:24:32 -0700 (PDT)
Message-Id: <20140731.122432.358447367571730334.davem@davemloft.net>
To: sasha.levin@oracle.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ipv4: raw: don't agree to 0 sized headers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1406726468-19035-1-git-send-email-sasha.levin@oracle.com>
References: <1406726468-19035-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Jul 2014 12:24:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>
Date: Wed, 30 Jul 2014 09:21:08 -0400

> For raw sockets, we'd always assume that a header is supplied and will attempt
> to copy it into the ip header space using memcpy_fromiovecend():
> 
> 	if (memcpy_fromiovecend((void *)iph, from, 0, length))
> 		goto error_free;
> 
> The problem is that memcpy_fromiovecend() assumes that there are actual data
> to read from the iovec and doesn't deal with cases where there are none:
> 
> 	int memcpy_fromiovecend(unsigned char *kdata, const struct iovec *iov,
> 				int offset, int len)
> 	{
> 		/* Skip over the finished iovecs */
> 		while (offset >= iov->iov_len) {
> 			offset -= iov->iov_len;
> 			iov++;
> 		}
> 		[...]
> 
> So when offset == 0 and iov->iov_len == 0, we'll just run iov into random
> kernel memory until it hits something bad and dies in a BUG/panic - either
> killing the kernel or leaking memory and held locks.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

I sincerely think that memcpy_fromiovecend() is the part at fault here.

Defensively it should handle zero length copies, as memcpy_fromiovec()
right above it does.
