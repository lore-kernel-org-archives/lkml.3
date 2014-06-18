Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaFRUbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:31:16 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:41295 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbaFRUa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:30:56 -0400
Date: Wed, 18 Jun 2014 13:30:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
Message-ID: <20140618203052.GT4669@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <539B594C.8070004@intel.com>
 <20140613224519.GV4581@linux.vnet.ibm.com>
 <53A0CAE5.9000702@intel.com>
 <20140618001836.GV4669@linux.vnet.ibm.com>
 <53A132D4.60408@intel.com>
 <20140618125831.GB4669@linux.vnet.ibm.com>
 <53A1CE19.7040103@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A1CE19.7040103@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061820-0928-0000-0000-000002BE85BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 10:36:25AM -0700, Dave Hansen wrote:
> On 06/18/2014 05:58 AM, Paul E. McKenney wrote:
> >> > This is the previous kernel, plus RCU tracing, so it's not 100%
> >> > apples-to-apples (and it peaks a bit lower than the other kernel).  But
> >> > here's the will-it-scale open1 throughput on the y axis vs
> >> > RCU_COND_RESCHED_EVERY_THIS_JIFFIES on x:
> >> > 
> >> > 	http://sr71.net/~dave/intel/jiffies-vs-openops.png
> >> > 
> >> > This was a quick and dirty single run with very little averaging, so I
> >> > expect there to be a good amount of noise.  I ran it from 1->100, but it
> >> > seemed to peak at about 30.
> > OK, so a default setting on the order of 20-30 jiffies looks promising.
> 
> For the biggest machine I have today, yeah.  But, we need to be a bit
> careful here.  The CPUs I'm running it on were released 3 years ago and
> I think we need to be planning at _least_ for today's large systems.  I
> would guess that by raising ...EVERY_THIS_JIFFIES, we're shifting this
> curve out to the right:
> 
> 	http://sr71.net/~dave/intel/3.16-open1regression-0.png
> 
> so that we're _just_ before the regression hits us.  But that just
> guarantees I'll hit this again when I get new CPUs. :)

Understood.  One approach would be to scale this in a manner similar
to the scaling of the delay from the beginning of the grace period
to the start of quiescent-state forcing, which is about three jiffies
on small systems scaling up to about 20 jiffies on large systems.

> If we go this route, I think we should probably take it up in to the
> 100-200 range, or even scale it to something on the order of what the
> rcu stall timeout is.  Other than the stall detector, is there some
> other reason to be forcing frequent quiescent states?

Yep.  CONFIG_NO_HZ_FULL+nohz_full kernels running in kernel mode don't
progress RCU grace periods.  But they should not need to be all that
frequent.

							Thanx, Paul

