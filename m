Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaJYTDE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 15:03:04 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60658 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbaJYTDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 15:03:02 -0400
Date: Sat, 25 Oct 2014 06:48:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Daniel J Blueman <daniel@numascale.com>
Cc: Steffen Persvold <sp@numascale.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: RCU fanout leaf balancing
Message-ID: <20141025134835.GD28247@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <544B4A4C.5070807@numascale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544B4A4C.5070807@numascale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102513-0029-0000-0000-000000E4B2EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2014 at 02:59:24PM +0800, Daniel J Blueman wrote:
> Hi Paul,
> 
> Finding earlier reference to increasing RCU fanout leaf for the
> purpose of "decrease[ing] cache-miss overhead for large systems",
> would your suggestion be to increase the value to the next hierarchy
> core-count above 16?
> 
> If we have say 32 interconnected 48-core servers; 3 sockets of
> dual-node 8-core Opteron 6300s, so 1536 cores in all. Latency across
> the coherent interconnect is O(100x) higher than the internal
> Hypertransport interconnect, so if we set RCU_FANOUT_LEAF to 48 to
> keep leaf-checking local to one Hypertransport fabric, what wisdom
> would one use for RCU_FANOUT? 4x leaf?
> 
> Or, would it be more cache-friendly to set RCU_FANOUT_LEAF to 8 and
> RCU_FANOUT to 48?

The easiest approach would be to use the default of 16.  Assuming
consecutive CPU numbering within each 48-core server, this would mean that
you would have three rcu_node structures per 48-core server.  The next
level up would of course span servers, but that level is accessed much
less frequently than is the root level, so this should still work.

If you also have hyperthreading, so that there are 96 hardware threads
per server, and if you are using the same "interesting" numbering scheme
that Intel uses, then this still works.  You have three leaf rcu_node
structure for the first set of hardware threads and another set of three
for the second set of hardware threads.

Or are you seeing some problem with the default?  If so, please tell me
what that problem is.

You can of course increase RCU_FANOUT to 24 or 48 (this latter assuming
a 64-bit kernel), at least if you are using a recent kernel.  However,
the penalty for too large a value for RCU_FANOUT is lock contention at
scheduling-clock-interrupt time.  So if you are setting RCU_FANOUT to 48,
you probably also want to boot with skew_tick set.

But the best approach is to try it.  I bet that the default will work
just fine for you.  ;-)

							Thanx, Paul

