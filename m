Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbaFDSMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 14:12:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbaFDSMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 14:12:38 -0400
Date: Wed, 4 Jun 2014 21:12:57 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PULL 2/2] vhost: replace rcu with mutex
Message-ID: <20140604181257.GA11756@redhat.com>
References: <1401744482-17764-1-git-send-email-mst@redhat.com>
 <1401744482-17764-3-git-send-email-mst@redhat.com>
 <1401746280.3645.187.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401746280.3645.187.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 02:58:00PM -0700, Eric Dumazet wrote:
> On Tue, 2014-06-03 at 00:30 +0300, Michael S. Tsirkin wrote:
> > All memory accesses are done under some VQ mutex.
> > So lock/unlock all VQs is a faster equivalent of synchronize_rcu()
> > for memory access changes.
> > Some guests cause a lot of these changes, so it's helpful
> > to make them faster.
> > 
> > Reported-by: "Gonglei (Arei)" <arei.gonglei@huawei.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  drivers/vhost/vhost.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index 78987e4..1c05e60 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -593,6 +593,7 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
> >  {
> >  	struct vhost_memory mem, *newmem, *oldmem;
> >  	unsigned long size = offsetof(struct vhost_memory, regions);
> > +	int i;
> >  
> >  	if (copy_from_user(&mem, m, size))
> >  		return -EFAULT;
> > @@ -619,7 +620,14 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
> >  	oldmem = rcu_dereference_protected(d->memory,
> >  					   lockdep_is_held(&d->mutex));
> >  	rcu_assign_pointer(d->memory, newmem);
> > -	synchronize_rcu();
> > +
> > +	/* All memory accesses are done under some VQ mutex.
> > +	 * So below is a faster equivalent of synchronize_rcu()
> > +	 */
> > +	for (i = 0; i < d->nvqs; ++i) {
> > +		mutex_lock(&d->vqs[i]->mutex);
> > +		mutex_unlock(&d->vqs[i]->mutex);
> > +	}
> >  	kfree(oldmem);
> >  	return 0;
> >  }
> 
> This looks dubious
> 
> What about using kfree_rcu() instead ?

Unfortunately userspace relies on the fact that no one
uses the old mappings by the time ioctl returns.
The issue isn't freeing the memory.

> translate_desc() still uses rcu_read_lock(), its not clear if the mutex
> is really held.
> 

Thanks, good point, we can drop that rcu_read_lock now, but I think this could be a
patch on top.

-- 
MST
