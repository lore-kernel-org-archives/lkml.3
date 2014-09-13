Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbaIMMjD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 08:39:03 -0400
Received: from mga14.intel.com ([192.55.52.115]:6572 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbaIMMjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 08:39:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,517,1406617200"; 
   d="scan'208";a="590826459"
Date: Sat, 13 Sep 2014 20:38:57 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux.com>, Shan Wei <davidshan@tencent.com>,
        Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, bobby.prani@gmail.com,
        Tejun Heo <htejun@gmail.com>
Subject: Re: [rcu] BUG: unable to handle kernel NULL pointer dereference at
 000000da
Message-ID: <20140913123857.GA20185@localhost>
References: <20140901084403.GA18808@localhost>
 <20140912190238.GJ4775@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409121413540.21514@gentwo.org>
 <20140912192659.GM4775@linux.vnet.ibm.com>
 <20140913002005.GA9550@localhost>
 <20140913003837.GO4775@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140913003837.GO4775@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 05:38:37PM -0700, Paul E. McKenney wrote:
> On Sat, Sep 13, 2014 at 08:20:05AM +0800, Fengguang Wu wrote:
> > On Fri, Sep 12, 2014 at 12:26:59PM -0700, Paul E. McKenney wrote:
> > > On Fri, Sep 12, 2014 at 02:19:57PM -0500, Christoph Lameter wrote:
> > > > On Fri, 12 Sep 2014, Paul E. McKenney wrote:
> > > > 
> > > > > So, I am not seeing this failure in my testing, but my best guess is
> > > > > that the problem is due to the fact that force_quiescent_state() is
> > > > > sometimes invoked with preemption enabled, which breaks __this_cpu_read()
> > > > > though perhaps with very low probability.  The common-case call (from
> > > > > __call_rcu_core()) -does- have preemption disabled, in fact, it has
> > > > > interrupts disabled.
> > > > 
> > > > How could __this_cpu_read() break in a way that would make a difference to
> > > > the code? There was no disabling/enabling of preemption before the patch
> > > > and there is nothing like that after the patch. If there was a race then
> > > > it still exists. The modification certainly cannot create a race.
> > > 
> > > Excellent question.  Yet Fengguang's tests show breakage.
> > > 
> > > Fengguang, any possibility of a false positive here?
> > 
> > Yes, it is possible. I find the first bad commit and its parent
> > commit's kernels are built in 2 different machines which might
> > cause subtle changes. I'll redo the bisect.
> 
> Thank you, Fengguang, and please let me know how it goes!

The new bisect finds the below commit. However, Christoph has fixed
this bug and it no longer shows up in current mainline and linux-next
trees. So please ignore this noise..

commit 188a81409ff7de1c5aae947a96356ddd8ff4aaa3
Author: Christoph Lameter <cl@linux.com>
Date:   Mon Apr 7 15:39:44 2014 -0700

    percpu: add preemption checks to __this_cpu ops

    We define a check function in order to avoid trouble with the include
    files.  Then the higher level __this_cpu macros are modified to invoke
    the preemption check.

    [akpm@linux-foundation.org: coding-style fixes]
    Signed-off-by: Christoph Lameter <cl@linux.com>
    Acked-by: Ingo Molnar <mingo@kernel.org>
    Cc: Tejun Heo <tj@kernel.org>
    Tested-by: Grygorii Strashko <grygorii.strashko@ti.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Thanks,
Fengguang
