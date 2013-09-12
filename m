Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab3ILQj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 12:39:28 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:36295 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753871Ab3ILQj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 12:39:26 -0400
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Sep 2013 12:39:26 EDT
Message-ID: <5231ECDD.2050108@vmware.com>
Date: Thu, 12 Sep 2013 18:33:33 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: Peter Zijlstra <peterz@infradead.org>, Dave Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] completely bonkers use of set_need_resched + VM_FAULT_NOPAGE
References: <20130912150645.GZ31370@twins.programming.kicks-ass.net> <CAKMK7uFF2GkYapa2_DLv4WYAd0t+POaT+Vy9HG=HQhzMmtH9nA@mail.gmail.com> <20130912154329.GB31370@twins.programming.kicks-ass.net> <CAKMK7uFTYB-E5ksVNEBqGJusJ5TKJv5X4hiPv1mno9tJKuUAdA@mail.gmail.com>
In-Reply-To: <CAKMK7uFTYB-E5ksVNEBqGJusJ5TKJv5X4hiPv1mno9tJKuUAdA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 05:58 PM, Daniel Vetter wrote:
> On Thu, Sep 12, 2013 at 5:43 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>>> The one in ttm is just bonghits to shut up lockdep: ttm can recurse
>>> into it's own pagefault handler and then deadlock, the trylock just
>>> keeps lockdep quiet.

Could you describe how it could recurse into it's own pagefault handler?
IIRC the VM flags of the TTM VMAs makes get_user_pages() refrain from 
touching these VMAs,
hence I don't think this code can deadlock, but admittedly it's far from 
the optimal solution.

Never mind, more on the set_need_resched() below.


>>>   We've had that bug arise in drm/i915 due to some
>>> fun userspace did and now have testcases for them. The right solution
>>> to fix this is to use copy_to|from_user_atomic in ttm everywhere it
>>> holds locks and have slowpaths which drops locks, copies stuff into a
>>> temp allocation and then continues. At least that's how we've fixed
>>> all those inversions in i915-gem. I'm not volunteering to fix this ;-)
>> Yikes.. so how common is it? If I simply rip the set_need_resched() out
>> it will 'spin' on the fault a little longer until a 'natural' preemption
>> point -- if such a thing is every going to happen.

A typical case is if a process is throwing out a buffer from the GPU or 
system memory while another
process pagefaults while writing to it. It's not a common situation, and 
it's by no means a fastpath situation.
For correctness purposes, I think set_need_resched() can be safely removed.

> It's a case of "our userspace doesn't do this", so as long as you're
> not evil and frob the drm device nodes of ttm drivers directly the
> deadlock will never happen. No idea how much contention actually
> happens on e.g. shared buffer objects - in i915 we have just one lock
> and so suffer quite a bit more from contention. So no idea how much
> removing the yield would hurt.
> -Daniel

/Thomas
