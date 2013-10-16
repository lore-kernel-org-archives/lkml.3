Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760213Ab3JPHnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 03:43:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:48432 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755152Ab3JPHnu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 03:43:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,505,1378882800"; 
   d="scan'208";a="308403702"
From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
To: NeilBrown <neilb@suse.de>
CC: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "Baldysiak, Pawel" <pawel.baldysiak@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] md: Fix skipping recovery for read-only arrays.
Thread-Topic: [PATCH] md: Fix skipping recovery for read-only arrays.
Thread-Index: AQHOyiLTBYMF63C3Rka310QD8JjSw5n28kLw
Date: Wed, 16 Oct 2013 07:43:16 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB1A664D26@IRSMSX105.ger.corp.intel.com>
References: <20131007142551.14867.36809.stgit@gklab-154-244.igk.intel.com>
 <20131016144954.5eb8a689@notabene.brown>
In-Reply-To: <20131016144954.5eb8a689@notabene.brown>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.181]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 16, 2013 5:50 AM NeilBrown <neilb@suse.de> wrote:
> On Mon, 07 Oct 2013 16:25:51 +0200 Lukasz Dorau <lukasz.dorau@intel.com>
> wrote:
> 
> > Since:
> >         commit 7ceb17e87bde79d285a8b988cfed9eaeebe60b86
> >         md: Allow devices to be re-added to a read-only array.
> >
> > spares are activated on a read-only array. In case of raid1 and raid10
> > personalities it causes that not-in-sync devices are marked in-sync
> > without checking if recovery has been finished.
> >
> > If a read-only array is degraded and one of its devices is not in-sync
> > (because the array has been only partially recovered) recovery will be skipped.
> >
> > This patch adds checking if recovery has been finished before marking
> > a device in-sync for raid1 and raid10 personalities. In case of raid5
> > personality such condition is already present (at raid5.c:6029).
> >
> > Bug was introduced in 3.10 and causes data corruption.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> > Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> > ---
> >  drivers/md/raid1.c  |    1 +
> >  drivers/md/raid10.c |    1 +
> >  2 files changed, 2 insertions(+)
> >
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c index
> > d60412c..aacf6bf 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -1479,6 +1479,7 @@ static int raid1_spare_active(struct mddev *mddev)
> >  			}
> >  		}
> >  		if (rdev
> > +		    && rdev->recovery_offset == MaxSector
> >  		    && !test_bit(Faulty, &rdev->flags)
> >  		    && !test_and_set_bit(In_sync, &rdev->flags)) {
> >  			count++;
> > diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c index
> > df7b0a0..73dc8a3 100644
> > --- a/drivers/md/raid10.c
> > +++ b/drivers/md/raid10.c
> > @@ -1782,6 +1782,7 @@ static int raid10_spare_active(struct mddev
> *mddev)
> >  			}
> >  			sysfs_notify_dirent_safe(tmp->replacement-
> >sysfs_state);
> >  		} else if (tmp->rdev
> > +			   && tmp->rdev->recovery_offset == MaxSector
> >  			   && !test_bit(Faulty, &tmp->rdev->flags)
> >  			   && !test_and_set_bit(In_sync, &tmp->rdev->flags)) {
> >  			count++;
> 
> Applied - thanks.
> 
> I'll forward it to Linus and -stable shortly.
> 
> NeilBrown

Thanks!

Lukasz

