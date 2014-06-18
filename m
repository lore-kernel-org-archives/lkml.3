Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966475AbaFRM6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 08:58:38 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:53532 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966138AbaFRM6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 08:58:36 -0400
Date: Wed, 18 Jun 2014 05:58:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
Message-ID: <20140618125831.GB4669@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <539B594C.8070004@intel.com>
 <20140613224519.GV4581@linux.vnet.ibm.com>
 <53A0CAE5.9000702@intel.com>
 <20140618001836.GV4669@linux.vnet.ibm.com>
 <53A132D4.60408@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A132D4.60408@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061812-8236-0000-0000-00000330CB4E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 11:33:56PM -0700, Dave Hansen wrote:
> On 06/17/2014 05:18 PM, Paul E. McKenney wrote:
> > So if I understand correctly, a goodly part of the regression is due not
> > to the overhead added to cond_resched(), but rather because grace periods
> > are now happening faster, thus incurring more overhead.  Is that correct?
> 
> Yes, that's the theory at least.
> 
> > If this is the case, could you please let me know roughly how sensitive is
> > the performance to the time delay in RCU_COND_RESCHED_EVERY_THIS_JIFFIES?
> 
> This is the previous kernel, plus RCU tracing, so it's not 100%
> apples-to-apples (and it peaks a bit lower than the other kernel).  But
> here's the will-it-scale open1 throughput on the y axis vs
> RCU_COND_RESCHED_EVERY_THIS_JIFFIES on x:
> 
> 	http://sr71.net/~dave/intel/jiffies-vs-openops.png
> 
> This was a quick and dirty single run with very little averaging, so I
> expect there to be a good amount of noise.  I ran it from 1->100, but it
> seemed to peak at about 30.

OK, so a default setting on the order of 20-30 jiffies looks promising.

> > The patch looks promising.  I will probably drive the time-setup deeper
> > into the guts of RCU, which should allow moving the access to jiffies
> > and the comparison off of the fast path as well, but this appears to
> > me to be good and sufficient for others encountering this same problem
> > in the meantime.
> 
> Yeah, the more overhead we can push out of cond_resched(), the better.
> I had no idea how much we call it!

Me neither!

							Thanx, Paul

