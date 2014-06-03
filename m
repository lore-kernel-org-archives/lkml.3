Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbaFCI3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 04:29:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:58742 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932171AbaFCI3N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 04:29:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,963,1392192000"; 
   d="scan'208";a="440193740"
From: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
To: NeilBrown <neilb@suse.de>
CC: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
Subject: RE: [PATCH 1/1] md: Do only necessary operations when adding device
 to RO array
Thread-Topic: [PATCH 1/1] md: Do only necessary operations when adding
 device to RO array
Thread-Index: Ac98CRsveY1xahZjQxqPA7TvjN5fzQB+aXOAAD/dyeA=
Date: Tue, 3 Jun 2014 08:29:10 +0000
Message-ID: <84A53BEA6EAC69439B7E311E9B17A76F0791C04E@IRSMSX105.ger.corp.intel.com>
References: <84A53BEA6EAC69439B7E311E9B17A76F07918BF9@IRSMSX105.ger.corp.intel.com>
 <20140602123411.4becb274@notabene.brown>
In-Reply-To: <20140602123411.4becb274@notabene.brown>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.182]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On Monday, June 02, 2014 4:34 AM NeilBrown Wrote:
> To: Baldysiak, Pawel
> Cc: linux-raid@vger.kernel.org; linux-kernel@vger.kernel.org; Paszkiewicz,
> Artur
> Subject: Re: [PATCH 1/1] md: Do only necessary operations when adding
> device to RO array
> 
> On Fri, 30 May 2014 13:17:14 +0000 "Baldysiak, Pawel"
> <pawel.baldysiak@intel.com> wrote:
> 
> > Commit 8313b8e57f55b15e5b7f7fc5d1630bbf686a9a97 changed way of
> adding
> > device to read-only array. Used routine
> > md_reap_sync_thread() which also trigger finish_reshape(), can break
> > reshape process, if it was restarted.
> 
> Exactly how can it break?
> 
> This is probably fixed by a couple of patches in my for-next branch which I will
> be sending to Linus shortly.
> 
> NeilBrown
> 
 
Hi Neil, 
I have checked your patches from "for-next", and this issue is fixed.
Reshape process is continued correctly after restart.
Thanks!

Pawel Baldysiak

> > This part of function should do only necessary operations, that is:
> > 1) call ->spare_active
> > 2) clear saved_raid_disk if array is no longer degraded
> >
> > Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> > Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> >
> > ---
> > drivers/md/md.c | 10 ++++++----
> > 1 file changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c index 237b7e0..cf073de2
> > 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -7820,11 +7820,13 @@ void md_check_recovery(struct mddev
> *mddev)
> >                                                 * As we only add devices that are already in-sync,
> >                                                 * we can activate the spares immediately.
> >                                                 */
> > +                                             struct md_rdev *rdev;
> >                                                remove_and_add_spares(mddev, NULL);
> > -                                              /* There is no thread, but we need to call
> > -                                              * ->spare_active and clear saved_raid_disk
> > -                                              */
> > -                                              md_reap_sync_thread(mddev);
> > +                                             mddev->pers->spare_active(mddev);
> > +                                             rdev_for_each(rdev, mddev)
> > +                                                             if (!mddev->degraded ||
> > +                                                                 test_bit(In_sync, &rdev->flags))
> > +
> > + rdev->saved_raid_disk = -1;
> >                                                clear_bit(MD_RECOVERY_NEEDED, &mddev-
> >recovery);
> >                                                goto unlock;
> >                                }
> > --
> > 1.9.0

