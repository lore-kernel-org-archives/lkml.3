Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab3CLMre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 08:47:34 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:59136 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab3CLMrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 08:47:32 -0400
Date: Tue, 12 Mar 2013 05:46:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        adas@redhat.com, hch@lst.de, npiggin@gmail.com
Subject: Re: rcu: fix hlist_bl_set_first_rcu annotation
Message-ID: <20130312124648.GC3725@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1359572877.2719.50.camel@menhir>
 <20130203183958.GO2632@linux.vnet.ibm.com>
 <1363081470.2732.1.camel@menhir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363081470.2732.1.camel@menhir>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031212-7408-0000-0000-00000DB785C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 09:44:29AM +0000, Steven Whitehouse wrote:
> Hi,
> 
> On Sun, 2013-02-03 at 10:39 -0800, Paul E. McKenney wrote:
> > On Wed, Jan 30, 2013 at 07:07:57PM +0000, Steven Whitehouse wrote:
> > > 
> > > Abhi noticed that we were getting a complaint from the RCU subsystem
> > > about access of an RCU protected list under the write side bit lock.
> > > This patch adds additional annotation to check both the RCU read
> > > lock and the write side bit lock before printing a message.
> > > 
> > > Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
> > > Reported-by: Abhijith Das <adas@redhat.com>
> > > Tested-by: Abhijith Das <adas@redhat.com>
> > 
> > Looks plausible to me on first glance, copying Nick Piggin and Christoph
> > Hellwig.  If they have no objections, I will queue this.
> > 
> > 							Thanx, Paul
> > 
> 
> Just a quick query to see what happened to this patch... it doesn't
> appear to have landed in Linus' tree yet, and I can't spot it in your
> git trees at korg either,

Hello, Steve,

I have queued it for 3.10, and will push it to -rcu shortly.

							Thanx, Paul

> Steve.
> 
> 
> > > diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
> > > index 31f9d75..2eb8855 100644
> > > --- a/include/linux/list_bl.h
> > > +++ b/include/linux/list_bl.h
> > > @@ -125,6 +125,11 @@ static inline void hlist_bl_unlock(struct hlist_bl_head *b)
> > >  	__bit_spin_unlock(0, (unsigned long *)b);
> > >  }
> > > 
> > > +static inline bool hlist_bl_is_locked(struct hlist_bl_head *b)
> > > +{
> > > +	return bit_spin_is_locked(0, (unsigned long *)b);
> > > +}
> > > +
> > >  /**
> > >   * hlist_bl_for_each_entry	- iterate over list of given type
> > >   * @tpos:	the type * to use as a loop cursor.
> > > diff --git a/include/linux/rculist_bl.h b/include/linux/rculist_bl.h
> > > index cf1244f..4f216c5 100644
> > > --- a/include/linux/rculist_bl.h
> > > +++ b/include/linux/rculist_bl.h
> > > @@ -20,7 +20,7 @@ static inline void hlist_bl_set_first_rcu(struct hlist_bl_head *h,
> > >  static inline struct hlist_bl_node *hlist_bl_first_rcu(struct hlist_bl_head *h)
> > >  {
> > >  	return (struct hlist_bl_node *)
> > > -		((unsigned long)rcu_dereference(h->first) & ~LIST_BL_LOCKMASK);
> > > +		((unsigned long)rcu_dereference_check(h->first, hlist_bl_is_locked(h)) & ~LIST_BL_LOCKMASK);
> > >  }
> > > 
> > >  /**
> > > 
> > > 
> > 
> 
> 

