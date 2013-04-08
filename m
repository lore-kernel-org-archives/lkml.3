Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935868Ab3DHNiI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 09:38:08 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:43205
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935827Ab3DHNiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 09:38:06 -0400
Message-ID: <1365428274.2609.160.camel@laptop>
Subject: Re: [PATCH] [PATCH] Gaurantee spinlocks implicit barrier for
 !PREEMPT_COUNT
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 08 Apr 2013 15:37:54 +0200
In-Reply-To: <CA+55aFyFWjpSVQM6M266tKrG_ZXJzZ-nYejpmXYQXbrr42mGPQ@mail.gmail.com>
References: <alpine.LFD.2.02.1304031433350.21884@ionos>
	 <1364998282-21437-1-git-send-email-vgupta@synopsys.com>
	 <20130404152808.GB15261@ab42.lan> <515E54BD.2090300@synopsys.com>
	 <51602459.3040105@synopsys.com>
	 <CA+55aFw=-oJxujka-emxyRcY54MSe3qEjZ6xgzoE-roe3EFk5g@mail.gmail.com>
	 <51624591.4010303@synopsys.com>
	 <CA+55aFyFWjpSVQM6M266tKrG_ZXJzZ-nYejpmXYQXbrr42mGPQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-04-07 at 21:48 -0700, Linus Torvalds wrote:
> That said, thinking about barriers and preemption made me realize that
> we do have a potential issue between: (a) non-preemption UP kernel
> (with no barriers in the preempt_enable/disable()) and (b)
> architectures that use inline asm without a memory clobber for
> get_user/put_user(). That includes x86.
> 
> The reason is that I could imagine code like
> 
>     if (get_user(val, addr))
>         return -EFAULT;
>     preempt_disable();
>     ... do something percpu ..
>     preempt_enable();
> 
> and it turns out that for non-preempt UP, we don't tell the compiler
> anywhere that it can't move the get_user past the preempt_disable. But
> the get_user() can cause a preemption point because of a page fault,
> obviously.
> 
> I suspect that the best way to fix this ends up relying on the gcc
> "asm volatile" rules, and make the rule be that:
>  - preempt_disable/enable have to generate an asm volatile() string
> (preferably just a ASM comment saying "preempt disable/enable")
>  - get_user/put_user doesn't need to add a memory clobber, but needs
> to be done with an asm volatile too.
> 
> Then the gcc "no reordering of volatile asms" should make the above be
> ok, without having to add an actual compiler memory barrier.
> 
> Ingo? Peter? I'm not sure anybody really uses UP+no-preempt on x86,
> but it does seem to be a bug.. Comments?

Right, stuff between preempt_disable() and preempt_enable() is supposed
to appear atomic wrt scheduling contexts, allowing any schedule to
happen in between would violate this.

I'm not seeing how this would be UP only though, I can see the same
thing happening on SMP+no-preempt.

Also, is {get,put}_user() the only construct that can do this? If so,
using the "asm volatile" rules as described might be the best way,
otherwise making the PREEMPT_COUNT=n operations be compiler barriers
seems like the safer option.

That said, I can't remember ever having seen a BUG like this, even
though !PREEMPT is (or at least was) the most popular distro setting.

