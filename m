Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab3FYXJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 19:09:43 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:59885 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3FYXJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 19:09:42 -0400
Date: Tue, 25 Jun 2013 16:09:38 -0700
From: Tejun Heo <tj@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "David S. Miller" <davem@davemloft.net>, Li Zefan <lizefan@huawei.com>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rculist: list_first_or_null_rcu() should use
 list_entry_rcu()
Message-ID: <20130625230938.GB30407@mtj.dyndns.org>
References: <20130621003244.GD11837@mtj.dyndns.org>
 <20130625225759.GI3828@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625225759.GI3828@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Paul.

On Tue, Jun 25, 2013 at 03:57:59PM -0700, Paul E. McKenney wrote:
> >  #define list_first_or_null_rcu(ptr, type, member) \
> >  	({struct list_head *__ptr = (ptr); \
> > -	  struct list_head __rcu *__next = list_next_rcu(__ptr); \
> > -	  likely(__ptr != __next) ? container_of(__next, type, member) : NULL; \
> > +	  struct list_head *__next = __ptr->next; \
> > +	  likely(__ptr != __next) ? \
> > +		list_entry_rcu(__next, type, member) : NULL; \
> 
> I am a bit uneasy with this, and would feel better if the volatile
> cast was on the very first fetch of the ->next pointer.
> 
> Is there some reason why my unease is ill-founded?

Do you mean something like the following?

	  struct list_head *__next = ACCESS_ONCE(__ptr->next); \
	  likely(__ptr != __next) ? \
		list_entry_rcu(__next, type, member) : NULL; \

Yeah, that looks right to me.

Thanks.

-- 
tejun
