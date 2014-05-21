Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbaEUUOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 16:14:51 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55569 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbaEUUOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 16:14:50 -0400
Date: Wed, 21 May 2014 16:14:48 -0400 (EDT)
Message-Id: <20140521.161448.716446182526388511.davem@davemloft.net>
To: davidn@davidnewall.com
Cc: Valdis.Kletnieks@vt.edu, fw@strlen.de, stephen@networkplumber.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: Revert 462fb2af9788a82a534f8184abfde31574e1cfa0 (bridge :
 Sanitize skb before it enters the IP stack)
From: David Miller <davem@davemloft.net>
In-Reply-To: <537C5F71.6000204@davidnewall.com>
References: <537A12EA.4060604@davidnewall.com>
	<14456.1400561749@turing-police.cc.vt.edu>
	<537C5F71.6000204@davidnewall.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 21 May 2014 13:14:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Newall <davidn@davidnewall.com>
Date: Wed, 21 May 2014 17:40:25 +0930

> On 20/05/14 14:25, Valdis.Kletnieks@vt.edu wrote:
>> So yes, we*do* need to do something sensible there - either frag the
>> packet
>> on the way out, or something.
> 
> I think the problem is that a bridge cannot be used across
> incompatible media.  That's the job of a router.
> 
> A bridge should act like a bridge, not a router.  Fragmenting the
> packet is wrong; that's IP's job.  Dropping the packet is also
> arguably wrong; that's the real device-driver's job.  What seems right
> to me is to act like a bridge and forward packets by looking inside of
> them *no more than is necessary*.  Looking beyond MAC address is
> perhaps too much.
> 
> We can finish the job of processing IP options, or at least in this
> scenario, but that seems wrong-headed and invites more work as more
> problems are discovered; or we could remove the half-hearted attempt
> it currently does and leave the bridge as a simple bridge.
> 
> This problem wouldn't occur if all devices in a bridge were required
> to be compatible media; particularly identical MTU.

I completely agree with you.

I also just want to state for the record, and I know some people will
disagree with me, that I think the bridging netfilter layer should
never have been integrated into the tree.

And I've been saying this for more than a decade.

It takes layering violations to a whole new level, and it's why we see
problems like this.

Besides this IP options issue, it also creates fake ipv4 routes, so
every time someone tries to do anything non-trivial with the ipv4
routing code the bridging netfilter fake route code had to be adjusted
or else we'd get crashes.

It has also held back many potential improvements to iptables in
general over the years because it does so many things differently
than the rest of the iptables modules.

It stinks, we never should have added it, and now since we have people
have been perversely convinced that doing stuff like this is actually
sane.  It's not.
