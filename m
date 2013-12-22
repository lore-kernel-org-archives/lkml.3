Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab3LVDHq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 22:07:46 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:52478 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab3LVDHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 22:07:45 -0500
Message-ID: <1387681647.5412.25.camel@marge.simpson.net>
Subject: Re: [PATCH] rcu: Eliminate softirq processing from rcutree
From: Mike Galbraith <bitbucket@online.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Sun, 22 Dec 2013 04:07:27 +0100
In-Reply-To: <20131221193900.GA8427@linutronix.de>
References: <20131221193900.GA8427@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:6pDV8omx/Mz6yk04mMeUv6Famt9ARw4ckrrtQDPnk5S
 Vgtdf6JagtRsdAOYlxl/M3WCE6GEOuiYMIYq4QXzAH7734VnrA
 BYFgjgrJ7OKhNwT0ro7xbzDgKIKv8ZNmVBfmTRrZNBLeCBzRlF
 1Il9nvVRTF0WDSrUIdmFSW/v+XL/jKhT1AjpW/LjJKtTl+YvW3
 15aWs6e1s26UR/XDCiNXJD+AfCSFoLBIgXsE33XRDYeuX5x0Yd
 yYw+MdyAB5094+Tjdh9eZWb0NQEqEId27TE/6fL/aVU5MKldoV
 aDVpwRMYXB5gSKNQqqUFu9hXAfh07YMeujYlGYMy+QmbEZQy8M
 8QvV7hAhKL9fAeWT0qGA8vfwgc4EVPZE94W7uOH4FnShvaAcR/
 w7KYaW+n9mQ3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-12-21 at 20:39 +0100, Sebastian Andrzej Siewior wrote: 
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> Running RCU out of softirq is a problem for some workloads that would
> like to manage RCU core processing independently of other softirq work,
> for example, setting kthread priority.  This commit therefore moves the
> RCU core work from softirq to a per-CPU/per-flavor SCHED_OTHER kthread
> named rcuc.  The SCHED_OTHER approach avoids the scalability problems
> that appeared with the earlier attempt to move RCU core processing to
> from softirq to kthreads.  That said, kernels built with RCU_BOOST=y
> will run the rcuc kthreads at the RCU-boosting priority.

I'll take this for a spin on my 64 core test box.

I'm pretty sure I'll still end up having to split softirq threads again
though, as big box has been unable to meet jitter requirements without,
and last upstream rt kernel tested still couldn't.

-Mike

Hm.  Another thing I'll have to check again is btrfs locking fix, and
generic IO deadlocks if you don't pull your plug upon first rtmutex
block.  In 3.0, both were required for box to survive heavy fs pounding.
Oh yeah, and the pain of rt tasks playing idle balance for SCHED_OTHER
tasks, and nohz balancing crud, and cpupri cost when cores are isolated
and and.. sigh, big boxen _suck_ ;-)

