Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbaHAOJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:09:34 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:51878 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbaHAOJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:09:32 -0400
Date: Fri, 1 Aug 2014 10:09:28 -0400
From: Tejun Heo <tj@kernel.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: libahci: Make host flags unsigned long
Message-ID: <20140801140928.GE21624@htj.dyndns.org>
References: <1406893181-24764-1-git-send-email-thierry.reding@gmail.com>
 <20140801125206.GB21624@htj.dyndns.org>
 <20140801140121.GB373@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140801140121.GB373@ulmo.nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Aug 01, 2014 at 04:01:23PM +0200, Thierry Reding wrote:
> I think there's just one occurrence. Turning the flags into an unsigned
> long seems like a much more natural thing to do, though Besides it being
> what many other parts of the kernel use for flags it gives us natural
> alignment within struct ahci_host_priv. The structure currently looks
> like this:
> 
> 	struct ahci_host_priv {
> 		unsigned int flags;
> 		u32 force_port_map;
> 		u32 mask_port_map;
> 
> 		void __iomem *mmio;
> 		...
> 	};
> 
> On 64-bit that unsigned int will be 32-bit and cause additional padding
> to be inserted between mask_port_map and mmio to align the 64-bit
> pointer.
> 
> It's not like the alignment is that *hugely* important, but it's still,
> you know, pretty.

I don't get how that's pretty.  Sure, that space is consumed by
something on 64bit archs but the extra space consumed can't be
utilized unless we're gonna change how we use flags depending on the
bitness of the architecture.  You're saying that rather than leaving
unused space as unused it's better to commit that space to a variable
which can't make use of that extra space anyway.  What if we later
wanna add another int there?  Do we make that int a long too or modify
the complete unrelated ->flags back to int?

Prettiness is a good thing but code fundamentally should match what
the underlying requirement dictates it to.  We sure have to trade that
off too at times when the benefit gained is worthwhile, but I
completely fail to see how this feel-good packed prettiness is
anything worthwhile.

In general, please don't do things like this in the kernel.  Use ulong
for flags iff it's necessary (atomic bitops).

Thanks.

-- 
tejun
