Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbaE3AKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 20:10:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47685 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbaE3AKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 20:10:34 -0400
Date: Thu, 29 May 2014 17:10:30 -0700 (PDT)
Message-Id: <20140529.171030.2160766520049624641.davem@davemloft.net>
To: will.deacon@arm.com
Cc: sam@ravnborg.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, monstr@monstr.eu, dhowells@redhat.com,
        broonie@linaro.org, benh@kernel.crashing.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH v2 14/18] sparc: io: implement dummy relaxed accessor
 macros for writes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140523143810.GE21319@arm.com>
References: <1400777250-17335-15-git-send-email-will.deacon@arm.com>
	<20140522181838.GA30632@ravnborg.org>
	<20140523143810.GE21319@arm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 29 May 2014 17:10:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>
Date: Fri, 23 May 2014 15:38:10 +0100

> On Thu, May 22, 2014 at 07:18:38PM +0100, Sam Ravnborg wrote:
>> On Thu, May 22, 2014 at 05:47:26PM +0100, Will Deacon wrote:
>> > write{b,w,l,q}_relaxed are implemented by some architectures in order to
>> > permit memory-mapped I/O accesses with weaker barrier semantics than the
>> > non-relaxed variants.
>> > 
>> > This patch adds dummy macros for the write accessors to sparc, in the
>> > same vein as the dummy definitions for the relaxed read accessors. The
>> > existing relaxed read{b,w,l} accessors are moved into asm/io.h, since
>> > they are identical between 32-bit and 64-bit machines.
>> > 
>> > Cc: "David S. Miller" <davem@davemloft.net>
>> > Signed-off-by: Will Deacon <will.deacon@arm.com>
>> Look good:
>> Acked-by: Sam Ravnborg <sam@ravnborg.org>
> 
> Thanks, Sam.
> 
>> But you should wait for David's ack too.
> 
> Yeah, I still need to get buy-in on the semantics from the PPC folks
> anyway.

I'm fine with these changes so:

Acked-by: David S. Miller <davem@davemloft.net>

Unfortunately, whilst sparc64 could support the relaxed variants, there is
no easy way to implement this.

I/O addrs are simply physical addresses on sparc64, and we therefore do
loads and stores via the ASY_PHYS_BYPASS_EC_E* address spaces.  What
this address space means is "physical address", "bypass caches", "side
effect".

To do a relaxed variant we'd need something without the "side effect"
part, but no such ASI exists.

These are all page protection bits, so we could move to using virtual
mappings on I/O things, but that's so much overkill just for this I
think.

Besides there are bigger fish to fry on sparc64 :-)

