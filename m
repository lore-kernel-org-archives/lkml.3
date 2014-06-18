Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbaFRVsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 17:48:17 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:43515 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaFRVsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 17:48:05 -0400
Date: Wed, 18 Jun 2014 14:48:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
Message-ID: <20140618214800.GA7445@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <539B594C.8070004@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539B594C.8070004@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061821-0928-0000-0000-000002BEFABF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 01:04:28PM -0700, Dave Hansen wrote:
> Hi Paul,
> 
> I'm seeing a regression when comparing 3.15 to Linus's current tree.
> I'm using Anton Blanchard's will-it-scale "open1" test which creates a
> bunch of processes and does open()/close() in a tight loop:
> 
> > https://github.com/antonblanchard/will-it-scale/blob/master/tests/open1.c
> 
> At about 50 cores worth of processes, 3.15 and the pre-3.16 code start
> to diverge, with 3.15 scaling better:
> 
> 	http://sr71.net/~dave/intel/3.16-open1regression-0.png
> 
> Some profiles point to a big increase in contention inside slub.c's
> get_partial_node() (the allocation side of the slub code) causing the
> regression.  That particular open() test is known to do a lot of slab
> operations.  But, the odd part is that the slub code hasn't been touched
> much.

Coming back to this...  If the original was stalling RCU grace periods
for the duration of the test, then it would also be deferring any
freeing until after the end of the test.  This is of course similar
to the usual Java benchmarking trick of making sure that the garbage
collector never runs.  It would also mean that if a change caused RCU
grace periods to complete during the test, that change might appear to
reduce throughput when in fact it was simply causing the throughput to
be more accurately represented.

The reason I bring this possibility up is that it would account for the
increase in contention in slub -- by causing free operations to occur
concurrently.

							Thanx, Paul

