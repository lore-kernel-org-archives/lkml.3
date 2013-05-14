Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab3ENMXC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 08:23:02 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47733
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594Ab3ENMXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 08:23:00 -0400
Date: Tue, 14 May 2013 14:20:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 6/7] rcu: Drive quiescent-state-forcing
 delay from HZ
Message-ID: <20130514122049.GH15942@dyad.programming.kicks-ass.net>
References: <20130412231846.GA20038@linux.vnet.ibm.com>
 <1365808754-20762-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1365808754-20762-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130412235401.GA8140@jtriplet-mobl1>
 <20130413063804.GV29861@linux.vnet.ibm.com>
 <20130413181800.GA12096@leaf>
 <20130413193425.GY29861@linux.vnet.ibm.com>
 <20130413195336.GA14799@leaf>
 <20130413220943.GB29861@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130413220943.GB29861@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 13, 2013 at 03:09:43PM -0700, Paul E. McKenney wrote:
> > How are those CPUs going idle without first telling RCU that they're
> > quiesced?  Seems like, during boot at least, you want RCU to use its
> > idle==quiesced logic to proactively note continuously-quiescent states.
> > Ideally, you should not hit the FQS code at all during boot.
> 
> FQS is RCU's idle==quiesced logic.  ;-)
> 
> In theory, RCU could add logic at idle entry to report a quiescent state,
> in fact CONFIG_RCU_FAST_NO_HZ used to do exactly that.  In practice,
> this is not good for energy efficiency at runtime for a goodly number
> of workloads, which is why CONFIG_RCU_FAST_NO_HZ now relies on callback
> numbering and FQS.

OK, so bear with me.. I've missed a few months of RCU so I might not be as
up-to-date as I'd like to be.

So going by the above; FAST_NO_HZ used to kick RCU into quiescence on entering
NO_HZ. This made some ARM people happy but made the rest of the world sad
because of immense idle-entry times.

The above implies you've changed this about to allow CPUs to go idle without
reporting home but instead rely on Forced Quiescent States to push the remote
idle cpus into quiescence.

Now I understand that advancing the RCU state machine and processing callbacks
takes time; however at boot (and possibly thereafter) we have the special case
where we have no pending RCU state.

Could we not, under those circumstances, quickly remove the CPU from the RCU
state machine so that FQS aren't required to prod quite as much remote state?
