Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab3KMAb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 19:31:26 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:50270 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab3KMAbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 19:31:19 -0500
Date: Wed, 13 Nov 2013 08:28:51 +0800
From: Shaohua Li <shli@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: fengguang.wu@intel.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [raid5] kernel BUG at drivers/md/raid5.c:701!
Message-ID: <20131113002851.GA8051@kernel.org>
References: <20131111144757.GA20255@localhost>
 <20131112115556.6ee0e2e3@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112115556.6ee0e2e3@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 11:55:56AM +1100, NeilBrown wrote:
> On Mon, 11 Nov 2013 22:47:57 +0800 fengguang.wu@intel.com wrote:
> 
> > 28cc2127527dcba2a0817afa8fd5a33c9e023090 is the first bad commit
> > commit 28cc2127527dcba2a0817afa8fd5a33c9e023090
> > Author: Shaohua Li <shli@kernel.org>
> > Date:   Tue Sep 10 15:37:56 2013 +0800
> > 
> >     raid5: relieve lock contention in get_active_stripe()
> >     
> >     get_active_stripe() is the last place we have lock contention. It has two
> >     paths. One is stripe isn't found and new stripe is allocated, the other is
> >     stripe is found.
> >     
> >     The first path basically calls __find_stripe and init_stripe. It accesses
> >     conf->generation, conf->previous_raid_disks, conf->raid_disks,
> >     conf->prev_chunk_sectors, conf->chunk_sectors, conf->max_degraded,
> >     conf->prev_algo, conf->algorithm, the stripe_hashtbl and inactive_list. Except
> >     stripe_hashtbl and inactive_list, other fields are changed very rarely.
> >     
> >     With this patch, we split inactive_list and add new hash locks. Each free
> >     stripe belongs to a specific inactive list. Which inactive list is determined
> >     by stripe's lock_hash. Note, even a stripe hasn't a sector assigned, it has a
> >     lock_hash assigned. Stripe's inactive list is protected by a hash lock, which
> >     is determined by it's lock_hash too. The lock_hash is derivied from current
> >     stripe_hashtbl hash, which guarantees any stripe_hashtbl list will be assigned
> >     to a specific lock_hash, so we can use new hash lock to protect stripe_hashtbl
> >     list too. The goal of the new hash locks introduced is we can only use the new
> >     locks in the first path of get_active_stripe(). Since we have several hash
> >     locks, lock contention is relieved significantly.
> >     
> >     The first path of get_active_stripe() accesses other fields, since they are
> >     changed rarely, changing them now need take conf->device_lock and all hash
> >     locks. For a slow path, this isn't a problem.
> >     
> >     If we need lock device_lock and hash lock, we always lock hash lock first. The
> >     tricky part is release_stripe and friends. We need take device_lock first.
> >     Neil's suggestion is we put inactive stripes to a temporary list and readd it
> >     to inactive_list after device_lock is released. In this way, we add stripes to
> >     temporary list with device_lock hold and remove stripes from the list with hash
> >     lock hold. So we don't allow concurrent access to the temporary list, which
> >     means we need allocate temporary list for all participants of release_stripe.
> >     
> >     One downside is free stripes are maintained in their inactive list, they can't
> >     across between the lists. By default, we have total 256 stripes and 8 lists, so
> >     each list will have 32 stripes. It's possible one list has free stripe but
> >     other list hasn't. The chance should be rare because stripes allocation are
> >     even distributed. And we can always allocate more stripes for cache, several
> >     mega bytes memory isn't a big deal.
> >     
> >     This completely removes the lock contention of the first path of
> >     get_active_stripe(). It slows down the second code path a little bit though
> >     because we now need takes two locks, but since the hash lock isn't contended,
> >     the overhead should be quite small (several atomic instructions). The second
> >     path of get_active_stripe() (basically sequential write or big request size
> >     randwrite) still has lock contentions.
> >     
> >     Signed-off-by: Shaohua Li <shli@fusionio.com>
> >     Signed-off-by: NeilBrown <neilb@suse.de>
> > 
> > :040000 040000 84ab47136c389751c7c08ded47b1761b1bee7184 351047cfe3ac66013fc5c77f23d9bb04f869081d M	drivers
> > bisect run success
> > 
> > # bad: [86737931c2be292ec985df48f2e7fbafb4467f0e] Merge 'md/master' into devel-hourly-2013111107
> > # good: [5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52] Linux 3.12
> > git bisect start '86737931c2be292ec985df48f2e7fbafb4467f0e' '5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52' '--'
> > # good: [21136946c495b0e1e0f7e25a8de6f170efbdeadf] drm/vmwgfx: fix warning if config intel iommu is off.
> > git bisect good 21136946c495b0e1e0f7e25a8de6f170efbdeadf
> > # good: [ee360d688c8e37f81c92039f76bebaddbe36befe] Merge branch 'acpi-assorted'
> > git bisect good ee360d688c8e37f81c92039f76bebaddbe36befe
> > # good: [cf0613d242805797f252535fcf7bb019512beb46] Merge branch 'gma500-next' of git://github.com/patjak/drm-gma500 into drm-next
> > git bisect good cf0613d242805797f252535fcf7bb019512beb46
> > # good: [feba070dbac6f7b477570e590a7dc960b7b0f784] Merge branch 'pm-sleep'
> > git bisect good feba070dbac6f7b477570e590a7dc960b7b0f784
> > # good: [6f092343855a71e03b8d209815d8c45bf3a27fcd] net: flow_dissector: fail on evil iph->ihl
> > git bisect good 6f092343855a71e03b8d209815d8c45bf3a27fcd
> > # good: [7d963128c95a790b40ae5bac6af23646ceffcb54] Merge 'drm/drm-next' into devel-hourly-2013111107
> > git bisect good 7d963128c95a790b40ae5bac6af23646ceffcb54
> > # bad: [917bb50339fbbea9c5f47d257ea42f9652129c3f] raid1: Replace raise_barrier/lower_barrier with freeze_array/unfreeze_array when reconfiguring the array.
> > git bisect bad 917bb50339fbbea9c5f47d257ea42f9652129c3f
> > # bad: [28cc2127527dcba2a0817afa8fd5a33c9e023090] raid5: relieve lock contention in get_active_stripe()
> > git bisect bad 28cc2127527dcba2a0817afa8fd5a33c9e023090
> > # good: [09b06d70464536cb3cce7cf1c52f23a321604f62] md: fix calculation of stacking limits on level change.
> > git bisect good 09b06d70464536cb3cce7cf1c52f23a321604f62
> > # good: [c0f773604d33616b07d61841463a056a780f5ae7] wait: add wait_event_cmd()
> > git bisect good c0f773604d33616b07d61841463a056a780f5ae7
> > # first bad commit: [28cc2127527dcba2a0817afa8fd5a33c9e023090] raid5: relieve lock contention in get_active_stripe()
> > 
> 
> I think I've fixed this by merging in the follow.
> 
> Shaohua: could you please review and confirm if you  agree?
> 
> Thanks,
> NeilBrown
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index c37ffca1b13c..93090b2afab4 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -697,6 +697,7 @@ get_active_stripe(struct r5conf *conf, sector_t sector,
>  				if (!test_bit(STRIPE_HANDLE, &sh->state))
>  					atomic_inc(&conf->active_stripes);
>  				if (list_empty(&sh->lru) &&
> +				    !test_bit(STRIPE_ON_RELEASE_LIST, &sh->state) &&
>  				    !test_bit(STRIPE_EXPANDING, &sh->state))
>  					BUG();
>  				list_del_init(&sh->lru);

Yes, makes a lot of sense. Thanks!
