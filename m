Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab3BVMfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 07:35:46 -0500
Received: from mout.gmx.net ([212.227.15.18]:64171 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756467Ab3BVMfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 07:35:45 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18KHk4s9iwKUlsSUeXDRkffv8CzSFYM0Rv0IBNESe
	8wImYoRbZS0V7l
Message-ID: <1361536534.1340.12.camel@marge.simpson.net>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Fri, 22 Feb 2013 13:35:34 +0100
In-Reply-To: <20130222121123.GA6473@gmail.com>
References: <51079178.3070002@linux.vnet.ibm.com>
	 <20130220104958.GA9152@gmail.com> <5125A7C8.8020308@linux.vnet.ibm.com>
	 <1361442055.26780.3.camel@laptop> <5126D9E0.7040108@linux.vnet.ibm.com>
	 <1361522197.26780.39.camel@laptop>
	 <1361526022.5817.115.camel@marge.simpson.net>
	 <20130222095416.GA4450@gmail.com>
	 <1361527288.5817.121.camel@marge.simpson.net>
	 <20130222121123.GA6473@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-22 at 13:11 +0100, Ingo Molnar wrote: 
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Fri, 2013-02-22 at 10:54 +0100, Ingo Molnar wrote: 
> > > * Mike Galbraith <efault@gmx.de> wrote:
> > > 
> > > > On Fri, 2013-02-22 at 09:36 +0100, Peter Zijlstra wrote: 
> > > > > On Fri, 2013-02-22 at 10:37 +0800, Michael Wang wrote:
> > > > > > But that's really some benefit hardly to be estimate, especially when
> > > > > > the workload is heavy, the cost of wake_affine() is very high to
> > > > > > calculated se one by one, is that worth for some benefit we could not
> > > > > > promise?
> > > > > 
> > > > > Look at something like pipe-test.. wake_affine() used to 
> > > > > ensure both client/server ran on the same cpu, but then I 
> > > > > think we added select_idle_sibling() and wrecked it again :/
> > > > 
> > > > Yeah, that's the absolute worst case for 
> > > > select_idle_sibling(), 100% synchronous, absolutely nothing to 
> > > > be gained by cross cpu scheduling. Fortunately, most tasks do 
> > > > more than that, but nonetheless, select_idle_sibling() 
> > > > definitely is a two faced little b*tch.  I'd like to see the 
> > > > evil b*tch die, but something needs to replace it's pretty 
> > > > face.  One thing that you can do is simply don't call it when 
> > > > the context switch rate is incredible.. its job is to recover 
> > > > overlap, if you're scheduling near your max, there's no win 
> > > > worth the cost.
> > > 
> > > Couldn't we make the cutoff dependent on sched_migration_cost? 
> > > If the wakeup comes in faster than that then don't spread.
> > 
> > No, that's too high, you loose too much of the pretty face. 
> > [...]
> 
> Then a logical proportion of it - such as half of it?

Hm.  Better would maybe be a quick boot time benchmark, and use some
multiple of your cross core pipe ping-pong time?  That we know is a
complete waste of cycles, because almost all cycles are scheduler cycles
with no other work to be done, making firing up another scheduler rather
pointless.  If we're approaching that rate, we're approaching bad idea.

-Mike

