Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934007AbaFSRF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 13:05:56 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:45171 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933127AbaFSRFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:05:55 -0400
Date: Thu, 19 Jun 2014 10:05:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, cl@linux-foundation.org,
        kmo@daterainc.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] percpu-refcount: implement percpu_ref_reinit() and
 percpu_ref_is_zero()
Message-ID: <20140619170549.GC4904@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1403053685-28240-1-git-send-email-tj@kernel.org>
 <1403053685-28240-7-git-send-email-tj@kernel.org>
 <53A1097F.3060400@cn.fujitsu.com>
 <20140618153222.GA11042@htj.dyndns.org>
 <53A243B8.4010501@cn.fujitsu.com>
 <20140619020727.GC20100@mtj.dyndns.org>
 <20140619022708.GB4669@linux.vnet.ibm.com>
 <20140619133624.GI11042@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619133624.GI11042@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061917-9332-0000-0000-00000124AA2E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 09:36:24AM -0400, Tejun Heo wrote:
> Hey, Paul.
> 
> On Wed, Jun 18, 2014 at 07:27:08PM -0700, Paul E. McKenney wrote:
> > Yep, smp_load_acquire() orders its load against later loads and stores,
> > so it really does need a memory barrier on weakly ordered systems.
> 
> Yeap.
> 
> > This is the "publish" operation for dynamically allocated per-CPU
> > references?  If so, agreed, you should be able to rely on dependency
> > ordering.  Make sure to comment the smp_read_barrier_depends().  ;-)
> 
> Definitely, there aren't many things which are more frustrating than
> barriers w/o comments explaining their pairing.  I'm pairing
> store_release with read_barrier_depends as that's what RCU is doing.
> Is this the preferred way now?  I like the new store_release and
> load_acquire as they document what's being barriered better but as Lai
> suggested in another reply it does seem a bit unbalanced.  I wonder
> whether load_acquire_depends would make sense.

If you mean what I think you mean by load_acquire_depends(), it is spelled
"rcu_dereference()" or, in this case, where you are never removing anything
that has been added, "rcu_dereference_raw()".  Because you are never
removing anything, you don't need rcu_read_lock() or rcu_read_unlock(),
thus you don't want lockdep yelling at you about not having RCU read-side
critical sections, thus rcu_dereference_raw().

							Thanx, Paul

