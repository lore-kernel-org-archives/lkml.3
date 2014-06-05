Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaFEKoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 06:44:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbaFEKop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 06:44:45 -0400
Date: Thu, 5 Jun 2014 13:45:06 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Miller <davem@davemloft.net>
Subject: Re: [PULL 2/2] vhost: replace rcu with mutex
Message-ID: <20140605104506.GA15379@redhat.com>
References: <1401744482-17764-1-git-send-email-mst@redhat.com>
 <1401744482-17764-3-git-send-email-mst@redhat.com>
 <1401746280.3645.187.camel@edumazet-glaptop2.roam.corp.google.com>
 <538DC422.1050303@redhat.com>
 <1401803863.3645.208.camel@edumazet-glaptop2.roam.corp.google.com>
 <20140604195112.GB10676@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604195112.GB10676@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 10:51:12PM +0300, Michael S. Tsirkin wrote:
> On Tue, Jun 03, 2014 at 06:57:43AM -0700, Eric Dumazet wrote:
> > On Tue, 2014-06-03 at 14:48 +0200, Paolo Bonzini wrote:
> > > Il 02/06/2014 23:58, Eric Dumazet ha scritto:
> > > > This looks dubious
> > > >
> > > > What about using kfree_rcu() instead ?
> > > 
> > > It would lead to unbound allocation from userspace.
> > 
> > Look at how we did this in commit
> > c3059477fce2d956a0bb3e04357324780c5d8eeb
> > 
> > > 
> > > > translate_desc() still uses rcu_read_lock(), its not clear if the mutex
> > > > is really held.
> > > 
> > > Yes, vhost_get_vq_desc must be called with the vq mutex held.
> > > 
> > > The rcu_read_lock/unlock in translate_desc is unnecessary.
> > 
> > Yep, this is what I pointed out. This is not only necessary, but
> > confusing and might be incorrectly copy/pasted in the future.
> > 
> > This patch is a partial one and leaves confusion.
> > 
> > Some places uses the proper 
> > 
> > mp = rcu_dereference_protected(dev->memory,
> > 		 lockdep_is_held(&dev->mutex));
> > 
> > others use the now incorrect :
> > 
> > rcu_read_lock();
> > mp = rcu_dereference(dev->memory);
> > ...
> > 
> 
> I agree, working on a cleanup patch on top now.

OK I just posted two cleanups as patches on top that address this.
Eric, could you please confirm that you are fine with
cleanups being patches on top?
Bisect will be fine since this hack is ugly but technically correct.

Thanks a lot for pointing out the issues!

> -- 
> MST
