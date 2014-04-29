Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbaD2Xjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 19:39:53 -0400
Received: from one.firstfloor.org ([193.170.194.197]:53314 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaD2Xjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 19:39:52 -0400
Date: Wed, 30 Apr 2014 01:39:50 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/7] x86: Add support for rd/wr fs/gs base
Message-ID: <20140429233950.GE2382@two.firstfloor.org>
References: <1398723161-21968-1-git-send-email-andi@firstfloor.org>
 <1398723161-21968-5-git-send-email-andi@firstfloor.org>
 <535FED4D.5000703@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535FED4D.5000703@amacapital.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Case 3 is annoying.  If nothing tries to change the user gs base, then
> everything is okay because the user gs base and the kernel gs bases are
> equal.  But if something does try to change the user gs base, then it
> will accidentally change the kernel gs base instead.

It doesn't really matter, as they are the same.
They would just switch identities.

Besides I don't think anyone does that.

> 
> For the IST entries, this should be fine -- cpu migration, scheduling,
> and such are impossible anyway.  For the non-IST entries, I'm less
> convinced.  The entry_64.S code suggests that the problematic entries are:
> 
> double_fault
> stack_segment
> machine_check

I don't think any of them can schedule.

> 
> Of course, all of those entries really do use IST, so I wonder why they
> are paranoid*entry instead of paranoid*entry_ist.  Is it because they're
> supposedly non-recursive?

Yes, only the DEBUG stack is big enough to recurse.

> 
> In any case, wouldn't this all be much simpler and less magical if the
> paranoid entries just saved the old gsbase to the rbx and loaded the new
> ones?  The exits could do the inverse.  This should be really fast:

I had it originally in a similar scheme, but it was significantly
more complicated, with changed exit path So I switched to this "only a 
single hook needed" variant, which mirrors the existing code
closely.

> I don't know the actual latencies, but I suspect that this would be
> faster, too -- it removes some branches, and wrgsbase and rdgsbase
> deserve to be faster than swapgs.  It's probably no good for
> non-rd/wrgsbase-capable cpus, though, since I suspect that three MSR
> accesses are much worse than one MSR access and two swapgs calls.

Probably doesn't matter much, it's MUCH faster than the old
code in any case.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
