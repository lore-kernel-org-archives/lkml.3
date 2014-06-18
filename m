Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbaFRGeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 02:34:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:45782 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756390AbaFRGeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 02:34:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,499,1400050800"; 
   d="scan'208";a="559382460"
Message-ID: <53A132D4.60408@intel.com>
Date: Tue, 17 Jun 2014 23:33:56 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: LKML <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
References: <539B594C.8070004@intel.com> <20140613224519.GV4581@linux.vnet.ibm.com> <53A0CAE5.9000702@intel.com> <20140618001836.GV4669@linux.vnet.ibm.com>
In-Reply-To: <20140618001836.GV4669@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 05:18 PM, Paul E. McKenney wrote:
> So if I understand correctly, a goodly part of the regression is due not
> to the overhead added to cond_resched(), but rather because grace periods
> are now happening faster, thus incurring more overhead.  Is that correct?

Yes, that's the theory at least.

> If this is the case, could you please let me know roughly how sensitive is
> the performance to the time delay in RCU_COND_RESCHED_EVERY_THIS_JIFFIES?

This is the previous kernel, plus RCU tracing, so it's not 100%
apples-to-apples (and it peaks a bit lower than the other kernel).  But
here's the will-it-scale open1 throughput on the y axis vs
RCU_COND_RESCHED_EVERY_THIS_JIFFIES on x:

	http://sr71.net/~dave/intel/jiffies-vs-openops.png

This was a quick and dirty single run with very little averaging, so I
expect there to be a good amount of noise.  I ran it from 1->100, but it
seemed to peak at about 30.

> The patch looks promising.  I will probably drive the time-setup deeper
> into the guts of RCU, which should allow moving the access to jiffies
> and the comparison off of the fast path as well, but this appears to
> me to be good and sufficient for others encountering this same problem
> in the meantime.

Yeah, the more overhead we can push out of cond_resched(), the better.
I had no idea how much we call it!
