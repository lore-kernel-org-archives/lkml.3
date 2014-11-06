Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaKFV2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:28:16 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59084 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaKFV2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:28:12 -0500
Date: Thu, 06 Nov 2014 16:28:08 -0500 (EST)
Message-Id: <20141106.162808.1546139916210194279.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: viro@ZenIV.linux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcrl@kvack.org, nakam@linux-ipv6.org,
        yoshfuji@linux-ipv6.org
Subject: Re: ipv4: Use standard iovec primitive in raw_probe_proto_opt
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141106064629.GA29321@gondor.apana.org.au>
References: <20141106055023.GA28865@gondor.apana.org.au>
	<20141106064318.GW7996@ZenIV.linux.org.uk>
	<20141106064629.GA29321@gondor.apana.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Nov 2014 13:28:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Thu, 6 Nov 2014 14:46:29 +0800

> On Thu, Nov 06, 2014 at 06:43:18AM +0000, Al Viro wrote:
>> On Thu, Nov 06, 2014 at 01:50:23PM +0800, Herbert Xu wrote:
>> > +	/* We only need the first two bytes. */
>> > +	err = memcpy_fromiovecend((void *)&icmph, msg->msg_iov, 0, 2);
>> > +	if (err)
>> > +		return err;
>> > +
>> > +	fl4->fl4_icmp_type = icmph.type;
>> > +	fl4->fl4_icmp_code = icmph.code;
>> 
>> That's more readable, but that exposes another problem in there - we read
>> the same piece of userland data twice, with no promise whatsoever that we'll
>> get the same value both times...
> 
> Sure, but you have to be root anyway to write to raw sockets.
> 
> Patches are welcome :)

I'd agree with this root-only argument maybe 15 years ago, but with
containers and stuff like that we want to prevent root X from messing
up the machine for root Y.

This is a recurring topic, and I'd strongly like to avoid adding new
ways that these kinds of problems can happen.

For example, I'm still on the hook to address the AF_NETLINK mmap TX
code, which has a similarly abusable issue.
