Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbaLPQQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:16:18 -0500
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:56213 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaLPQQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:16:16 -0500
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Tue, 16 Dec 2014 11:16:14 -0500
To: Lokesh Vutla <lokeshvutla@ti.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, "Kristo, Tero" <t-kristo@ti.com>,
        Nishanth Menon <nm@ti.com>, Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH 2/2] ARM: omap5/dra7xx: Fix counter frequency drift for
 AM572x errata i856.
Message-ID: <20141216161614.GK24110@csclub.uwaterloo.ca>
References: <cover.1418421100.git.lsorense@csclub.uwaterloo.ca>
 <358281a880ccd89873efeea75edaa6c953eac2bd.1418421100.git.lsorense@csclub.uwaterloo.ca>
 <20141214044517.GD24110@csclub.uwaterloo.ca>
 <549018EC.8020207@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <549018EC.8020207@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 05:05:08PM +0530, Lokesh Vutla wrote:
> Is this applicable for OMAP5 also?
> If not can you drop omap5 from $subject?

DRA7xx = OMAP57xx, which to me is an omap5.  Isn't it?

And I haven't been able to get a manual for the omap54xx to confirm it,
although it seems it does not apply to the omap54xx from what I have
been able to gather indirectly.

arch_timer_freq = (rate / den) * num;

If I do this with the workaround I get:

20000000 / 75 * 244 = 6147525

where as

20000000 * 244 / 75 = 6147540

best value would be 6147541 with proper rounding.

In the normal case the worst case is:

26000000 * 384 = 9984000000

That is too big for 32 bits.

Now what could be done is prescale by 4 to make the worst case still
fit in 32 bits while doing the multiplication before the division,
so like this:

arch_timer_freq = ((rate / 4) * num / den ) * 4;

That gives the same result in all cases including the errata case for
the dra7xx at 20MHz and 27MHz.  It is off by 3 in the 19.2MHz case though
which isn't so nice.

Would that be more acceptable?  I think having the arch_timer_freq
calculated for the errata case seperately from the normal case is
cleaner looking compared to that mess and gives a better result for the
19.2MHz case.

-- 
Len Sorensen
