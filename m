Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab3IXTaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 15:30:15 -0400
Received: from relay1.sgi.com ([192.48.179.29]:34013 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155Ab3IXTaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 15:30:13 -0400
Date: Tue, 24 Sep 2013 14:30:12 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: Jason Baron <jbaron@akamai.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC] eventpoll: Move a kmem_cache_alloc and kmem_cache_free
Message-ID: <20130924193012.GA70073@asylum.americas.sgi.com>
References: <1379087642-131349-1-git-send-email-nzimmer@sgi.com> <5239FA69.8030202@akamai.com> <523B2867.7000209@sgi.com> <52405B93.2010206@akamai.com> <20130923164740.GA43736@asylum.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130923164740.GA43736@asylum.americas.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 11:47:41AM -0500, Nathan Zimmer wrote:
> On Mon, Sep 23, 2013 at 11:17:39AM -0400, Jason Baron wrote:
> > On 09/19/2013 12:37 PM, Nathan Zimmer wrote:
> > > On 09/18/2013 02:09 PM, Jason Baron wrote:
> > >> On 09/13/2013 11:54 AM, Nathan Zimmer wrote:
> > >>> We noticed some scaling issue in the SPECjbb benchmark.  Running perf
> > >>> we found that the it was spending lots of time in SYS_epoll_ctl.
> > >>> In particular it is holding the epmutex.
> > >>> This patch helps by moving out the kmem_cache_alloc and kmem_cache_free out
> > >>> from under the lock.  It improves throughput by around 15% on 16 sockets.
> > >>>
> > >>> While this patch should be fine as it is there are probably is more things
> > >>> that can be done out side the lock, like wakeup_source_unregister, but I am
> > >>> not familar with the area and I don't know of many tests.  I did find the
> > >>> one posted by Jason Baron at https://lkml.org/lkml/2011/2/25/297.
> > >>>
> > >>> Any thoughts?
> > >>>
> > >> Hi,
> > >>
> > >> Intersting - I think its also possible to completely drop taking the
> > >> 'epmutex' for EPOLL_CTL_DEL by using rcu, and restricting it on add
> > >> to more 'complex' topologies. That is when we have an epoll descriptor
> > >> that doesn't nest with other epoll descriptors, we don't need the
> > >> global 'epmutex' either. Any chance you can re-run with this? Its a bit
> > >> hacky, but we can clean it up if it makes sense.
> > >>
> > >> Thanks,
> > >>
> > >> -Jason
> > >>
> > > That is working GREAT.  It is scaling to 16 jobs quite well.
> > > I will have to grab a larger machine( to see what the new scaling curve 
> > > will be.
> > > 
> > 
> > Cool. Any specific numbers would be helpful for the changelog in support of these
> > changes. Also, I think the move the alloc/free out of from under the locks still
> > might be nice, since we are still taking the per-ep lock in most cases. If you
> > want I can roll those too into a patch series for this when I resubmit.
> > 
> > Also, if you're still testing I have a small additional optimization on top of the
> > prior patch:
> > 
> > diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> > index d98105d..d967fd7 100644
> > --- a/fs/eventpoll.c
> > +++ b/fs/eventpoll.c
> > @@ -857,7 +857,7 @@ static unsigned int ep_eventpoll_poll(struct file *file, poll_table *wait)
> >  	struct eventpoll *ep = file->private_data;
> >  	struct readyevents_params params;
> >  
> > -	params.locked = ((wait->_qproc == ep_ptable_queue_proc) ? 1 : 0);
> > +	params.locked = ((wait && (wait->_qproc == ep_ptable_queue_proc)) ? 1 : 0);
> >  	params.ep = ep;
> >  
> >  	/* Insert inside our poll wait queue */
> > @@ -1907,7 +1907,6 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
> >  			} else
> >  				list_add(&tf.file->f_tfile_llink, &tfile_check_list);
> >  			mutex_lock_nested(&ep->mtx, 0);
> > -			ep->type = EVENTPOLL_COMPLEX;
> >  			if (is_file_epoll(tf.file)) {
> >  				mutex_lock_nested(&(((struct eventpoll *)tf.file->private_data)->mtx), 1);
> >  				((struct eventpoll *)tf.file->private_data)->type = EVENTPOLL_COMPLEX;
> > 
> > 
> > Thanks,
> > 
> > -Jason
> > 
> > 
> > 
> 
> I just finished up run some tests over the weekend.
> The specjbb benchmark went from only scaling 10-12 sockets to scaling to over
> 32 sockets.  I don't have an exact point where it stops scaling but it is under
> 64 sockets, the size of the machine I had handy.  perf seems to indicate the
> problems are elsewhere, but I will have to rerun and grap some more data.
> 
> Nate
> 

Some more details.

On the 16 socket run the performance went from 35k jOPS to 125k jOPS.
In addition the benchmark when from scaling well on 10 sockets to scaling well
on just over 40 sockets.

I should also note there system responsiveness of various commands was quite
improved when under the full load of the benchmark.

Also I haven't tried your second optimization.  Once I applied your first patch
the scaling in this area improved so much I am not seeing an issue in this area
at all.  Moving the alloc/free out of the lock might be nice but at this point
it would't be noticable.

Currently the benchmark stops scaling at around 40-44 sockets but it seems like
I found a second unrelated bottleneck.

Feel free to toss on my tested-by.

Nate

