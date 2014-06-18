Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbaFRBE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 21:04:29 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:51448 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbaFRBE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 21:04:28 -0400
Date: Tue, 17 Jun 2014 18:04:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, Christoph Lameter <cl@linux.com>,
        peterz@infradead.org
Subject: Re: [bisected] pre-3.16 regression on open() scalability
Message-ID: <20140618010423.GW4669@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <539B594C.8070004@intel.com>
 <20140613224519.GV4581@linux.vnet.ibm.com>
 <53A0CAE5.9000702@intel.com>
 <20140618001517.GL8178@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618001517.GL8178@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061801-1542-0000-0000-000002A5354E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 05:15:17PM -0700, Andi Kleen wrote:
> > It also ends up eating a new cacheline in a bunch of pretty hot paths.
> > It would be nice to be able to keep the fast path part of this as at
> > least read-only.
> > 
> > Could we do something (functionally) like the attached patch?  Instead
> > of counting cond_resched() calls, we could just specify some future time
> > by which we want have a quiescent state.  We could even push the time to
> > be something _just_ before we would have declared a stall.
> 
> I still think it's totally the wrong place. cond_resched() is in so
> many fast paths (every lock, every allocation). It just doesn't
> make sense to add non essential things like this to it.
> 
> I would be rather to just revert the original patch.

OK.  What would you suggest instead?  If all we do is to revert the
original patch, we once again end up with long-running in-kernel code
paths stalling the RCU grace period.  The cond_resched() calls sprinkled
through them once again won't help with this.

Or are you suggesting leveraging the now-deprecated set_need_resched()
so that the checks happen deeper in the scheduler?  Looks like grabbing
the offending CPU's task and doing set_tsk_need_resched() on that task
is the replacement.

CCing Peter Zijlstra for his thoughts on this.

							Thanx, Paul

