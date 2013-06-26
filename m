Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab3FZOSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:18:25 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:38414 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3FZOSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:18:23 -0400
Date: Wed, 26 Jun 2013 07:17:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Dipankar Sarma <dipankar@in.ibm.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "David S. Miller" <davem@davemloft.net>, Li Zefan <lizefan@huawei.com>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rculist: list_first_or_null_rcu() should use
 list_entry_rcu()
Message-ID: <20130626141752.GK3828@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130621003244.GD11837@mtj.dyndns.org>
 <20130625225759.GI3828@linux.vnet.ibm.com>
 <20130625230938.GB30407@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625230938.GB30407@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062614-5406-0000-0000-000009E0436A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 04:09:38PM -0700, Tejun Heo wrote:
> Hello, Paul.
> 
> On Tue, Jun 25, 2013 at 03:57:59PM -0700, Paul E. McKenney wrote:
> > >  #define list_first_or_null_rcu(ptr, type, member) \
> > >  	({struct list_head *__ptr = (ptr); \
> > > -	  struct list_head __rcu *__next = list_next_rcu(__ptr); \
> > > -	  likely(__ptr != __next) ? container_of(__next, type, member) : NULL; \
> > > +	  struct list_head *__next = __ptr->next; \
> > > +	  likely(__ptr != __next) ? \
> > > +		list_entry_rcu(__next, type, member) : NULL; \
> > 
> > I am a bit uneasy with this, and would feel better if the volatile
> > cast was on the very first fetch of the ->next pointer.
> > 
> > Is there some reason why my unease is ill-founded?
> 
> Do you mean something like the following?
> 
> 	  struct list_head *__next = ACCESS_ONCE(__ptr->next); \
> 	  likely(__ptr != __next) ? \
> 		list_entry_rcu(__next, type, member) : NULL; \
> 
> Yeah, that looks right to me.

I would feel much better about this!  Does it avoid warnings in your
use cases?

							Thanx, Paul

