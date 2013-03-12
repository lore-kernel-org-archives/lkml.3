Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab3CLJqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 05:46:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946Ab3CLJq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 05:46:29 -0400
Subject: Re: rcu: fix hlist_bl_set_first_rcu annotation
From: Steven Whitehouse <swhiteho@redhat.com>
To: paulmck@linux.vnet.ibm.com
Cc: Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        adas@redhat.com, hch@lst.de, npiggin@gmail.com
In-Reply-To: <20130203183958.GO2632@linux.vnet.ibm.com>
References: <1359572877.2719.50.camel@menhir>
	 <20130203183958.GO2632@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 12 Mar 2013 09:44:29 +0000
Message-ID: <1363081470.2732.1.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 2013-02-03 at 10:39 -0800, Paul E. McKenney wrote:
> On Wed, Jan 30, 2013 at 07:07:57PM +0000, Steven Whitehouse wrote:
> > 
> > Abhi noticed that we were getting a complaint from the RCU subsystem
> > about access of an RCU protected list under the write side bit lock.
> > This patch adds additional annotation to check both the RCU read
> > lock and the write side bit lock before printing a message.
> > 
> > Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
> > Reported-by: Abhijith Das <adas@redhat.com>
> > Tested-by: Abhijith Das <adas@redhat.com>
> 
> Looks plausible to me on first glance, copying Nick Piggin and Christoph
> Hellwig.  If they have no objections, I will queue this.
> 
> 							Thanx, Paul
> 

Just a quick query to see what happened to this patch... it doesn't
appear to have landed in Linus' tree yet, and I can't spot it in your
git trees at korg either,

Steve.


> > diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
> > index 31f9d75..2eb8855 100644
> > --- a/include/linux/list_bl.h
> > +++ b/include/linux/list_bl.h
> > @@ -125,6 +125,11 @@ static inline void hlist_bl_unlock(struct hlist_bl_head *b)
> >  	__bit_spin_unlock(0, (unsigned long *)b);
> >  }
> > 
> > +static inline bool hlist_bl_is_locked(struct hlist_bl_head *b)
> > +{
> > +	return bit_spin_is_locked(0, (unsigned long *)b);
> > +}
> > +
> >  /**
> >   * hlist_bl_for_each_entry	- iterate over list of given type
> >   * @tpos:	the type * to use as a loop cursor.
> > diff --git a/include/linux/rculist_bl.h b/include/linux/rculist_bl.h
> > index cf1244f..4f216c5 100644
> > --- a/include/linux/rculist_bl.h
> > +++ b/include/linux/rculist_bl.h
> > @@ -20,7 +20,7 @@ static inline void hlist_bl_set_first_rcu(struct hlist_bl_head *h,
> >  static inline struct hlist_bl_node *hlist_bl_first_rcu(struct hlist_bl_head *h)
> >  {
> >  	return (struct hlist_bl_node *)
> > -		((unsigned long)rcu_dereference(h->first) & ~LIST_BL_LOCKMASK);
> > +		((unsigned long)rcu_dereference_check(h->first, hlist_bl_is_locked(h)) & ~LIST_BL_LOCKMASK);
> >  }
> > 
> >  /**
> > 
> > 
> 


