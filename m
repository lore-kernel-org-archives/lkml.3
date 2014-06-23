Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbaFWPXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 11:23:54 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:8791 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753882AbaFWPXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 11:23:53 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqgPAN9FqFNbskjJ/2dsb2JhbABZgw2DSKgiAQEBAQEBBQGZMQICAYEMF3WEAwEBBAE6HCMFCwgDGC4hGB4GE4guAwkMAb95DYZLF4VjhnSCJQeEQwEDhGMCiw2IYIF5AYs1giiGBoNEOw
Date: Mon, 23 Jun 2014 17:22:36 +0200
From: Fabian Frederick <fabf@skynet.be>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Damien Wyart <damien.wyart@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] Revert "block: add __init to blkcg_policy_register"
Message-Id: <20140623172236.27a28d7c184e16670c4a011e@skynet.be>
In-Reply-To: <alpine.DEB.2.02.1406230234170.8821@chino.kir.corp.google.com>
References: <1403352321-6353-1-git-send-email-fabf@skynet.be>
	<alpine.DEB.2.02.1406230234170.8821@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2014 02:35:09 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Sat, 21 Jun 2014, Fabian Frederick wrote:
> 
> > This reverts commit a2d445d44000
> > 
> > Adding __init to blkcg_policy_register makes it unreliable when
> > loading cfq at runtime.
> > 
> > (Similar problem to b5097e956a4d "block: add __init to elv_register"
> >  reported by Damien Wyart).
> > 
> > Cc: Jens Axboe <axboe@kernel.dk>
> > Cc: Damien Wyart <damien.wyart@gmail.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > ---
> >  block/blk-cgroup.c | 2 +-
> >  block/blk-cgroup.h | 4 ++--
> >  2 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> > index 069bc20..9f5bce3 100644
> > --- a/block/blk-cgroup.c
> > +++ b/block/blk-cgroup.c
> > @@ -1093,7 +1093,7 @@ EXPORT_SYMBOL_GPL(blkcg_deactivate_policy);
> >   * Register @pol with blkcg core.  Might sleep and @pol may be modified on
> >   * successful registration.  Returns 0 on success and -errno on failure.
> >   */
> > -int __init blkcg_policy_register(struct blkcg_policy *pol)
> > +int blkcg_policy_register(struct blkcg_policy *pol)
> >  {
> >  	int i, ret;
> >  
> 
> This is the second such revert from you for __init annotations, have you 
> double checked all the other patches you've sent?

I received a bug report for elv_register and after looking at my
recent __init patches I found this one with the same problem.


> 
> > diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
> > index cbb7f94..d692b29 100644
> > --- a/block/blk-cgroup.h
> > +++ b/block/blk-cgroup.h
> > @@ -145,7 +145,7 @@ void blkcg_drain_queue(struct request_queue *q);
> >  void blkcg_exit_queue(struct request_queue *q);
> >  
> >  /* Blkio controller policy registration */
> > -int __init blkcg_policy_register(struct blkcg_policy *pol);
> > +int blkcg_policy_register(struct blkcg_policy *pol);
> >  void blkcg_policy_unregister(struct blkcg_policy *pol);
> >  int blkcg_activate_policy(struct request_queue *q,
> >  			  const struct blkcg_policy *pol);
> > @@ -580,7 +580,7 @@ static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg, void *key) { ret
> >  static inline int blkcg_init_queue(struct request_queue *q) { return 0; }
> >  static inline void blkcg_drain_queue(struct request_queue *q) { }
> >  static inline void blkcg_exit_queue(struct request_queue *q) { }
> > -static inline int __init blkcg_policy_register(struct blkcg_policy *pol) { return 0; }
> > +static inline int blkcg_policy_register(struct blkcg_policy *pol) { return 0; }
> 
> Why would you have marked an inline function as __init in the first place?

__init was initially added to mark function in case we remove inline someday as it's only called by __init functions. Problem in this case being it would break external modules.

Fabian
> 
> >  static inline void blkcg_policy_unregister(struct blkcg_policy *pol) { }
> >  static inline int blkcg_activate_policy(struct request_queue *q,
> >  					const struct blkcg_policy *pol) { return 0; }
