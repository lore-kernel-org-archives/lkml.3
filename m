Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121AbaIDGoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 02:44:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:44511 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545AbaIDGoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 02:44:19 -0400
Date: Thu, 4 Sep 2014 08:32:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Kautuk Consul <consul.kautuk@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        Ionut Alexa <ionut.m.alexa@gmail.com>,
        Guillaume Morin <guillaume@morinfr.org>, linux-kernel@vger.kernel.org,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH 1/1] do_exit(): Solve possibility of BUG() due to race
 with try_to_wake_up()
Message-ID: <20140904063200.GE3190@worktop.ger.corp.intel.com>
References: <20140825155738.GA5944@redhat.com>
 <20140901153935.GQ27892@worktop.ger.corp.intel.com>
 <20140901175851.GA15210@redhat.com>
 <20140901190931.GD5806@worktop.ger.corp.intel.com>
 <20140902155208.GA28668@redhat.com>
 <20140902164714.GA17033@redhat.com>
 <20140902173910.GF27892@worktop.ger.corp.intel.com>
 <20140903133640.GA25439@redhat.com>
 <20140903144450.GB7083@twins.programming.kicks-ass.net>
 <20140904050424.GA26756@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140904050424.GA26756@gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 07:04:24AM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > > Ah, I simply do not know what is cheaper, even on x86. Well, 
> > > we need to enable/disable irqs, but again I do not really 
> > > know how much does this cost.
> > 
> > Ah good point about that IRQ thing, yes that's horribly 
> > expensive.
> 
> Enabling/disabling local IRQs is not really expensive (it's a 
> flat cost essentially - below 10 cycles on modern x86 CPUs) - 
> especially if we consider the 100x-1000x frequency difference 
> between schedule() and exit(), on typical systems:
> 
>   $ grep -E 'ctxt|processes' /proc/stat 
>   ctxt 47166536
>   processes 91876
> 
> And that's from a system that emphatically does not schedule 
> much. On others the difference is much larger.
> 
> So please don't push complexity into the scheduler from 
> lower-freq areas of the kernel!

We were very much not going to make schedule() more expensive, just
figuring out other ways.

And while its good to know modern x86 has cheap INT flag poking, this is
very much not true for other archs and not even older x86 (remember P4?
:-).
