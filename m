Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaKCUF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 15:05:59 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49008 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbaKCUF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 15:05:56 -0500
Date: Mon, 03 Nov 2014 15:05:53 -0500 (EST)
Message-Id: <20141103.150553.633529234958324183.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: viro@ZenIV.linux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcrl@kvack.org
Subject: Re: [0/3] net: Kill skb_copy_datagram_const_iovec
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141103053751.GA27845@gondor.apana.org.au>
References: <20141103002207.GA26588@gondor.apana.org.au>
	<20141103004503.GX7996@ZenIV.linux.org.uk>
	<20141103053751.GA27845@gondor.apana.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Nov 2014 12:05:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Mon, 3 Nov 2014 13:37:51 +0800

> On Mon, Nov 03, 2014 at 12:45:03AM +0000, Al Viro wrote:
>>
>> Note, BTW, that there's a damn good reason to convert the socket side of
>> things to iov_iter - as it is, ->splice_write() there is basically done with
>> page-by-page mapping and doing kernel_sendmsg(); being able to deal with
>> "map and copy" stuff *inside* ->sendmsg() would not only reduce the overhead,
>> it would allow to get rid of ->sendpage() completely.  Basically, let
>> ->sendmsg() instances check the iov_iter type and play zerocopy games if
>> it's an "array of kernel pages" kind.  Compare ->sendpage() and ->sendmsg()
>> instances for the protocols that have nontrivial ->sendpage(); you'll see
>> that there's a lot of duplication.  Merging them looks very feasible, with
>> divergence happening only very deep in the call chain.
> 
> Honestly I don't really care which way we end up going as long as
> we pick one solution and stick with it.  Right now we have an
> abomination in the form of skb_copy_datagram_const_iovec which is
> the worst of both worlds, plus it duplicates tons of code.
> 
> So here's a few patches to kill this crap.

To pick one direction and go with it, I totally agree with.

But a patch set like this as an interim solution, I am not so happy
with.

If the method says const, we have a contract with the caller to not
modify the iovec.  That caller can assume that we have not done so.

So this patch set violated that contract and can result in real bugs
either now or in the future.

I'll see if I can make some progress converting the networking over
to iov_iter.  It can't be that difficult... albeit perhaps a little
time consuming.
