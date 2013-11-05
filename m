Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab3KEOZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 09:25:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:62426 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754833Ab3KEOZW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 09:25:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="403927851"
From: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
To: NeilBrown <neilb@suse.de>
CC: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "shli@kernel.org" <shli@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] raid0: Set discard_granularity to correct value after
 reshape.
Thread-Topic: [PATCH] raid0: Set discard_granularity to correct value after
 reshape.
Thread-Index: AQHO1WqCdPPrmNsXQkSnG63rT6wyZpoN8foAgAjIBxA=
Date: Tue, 5 Nov 2013 14:25:19 +0000
Message-ID: <84A53BEA6EAC69439B7E311E9B17A76F01783D0B@IRSMSX105.ger.corp.intel.com>
References: <20131030122022.20862.97997.stgit@gklab-154-222.igk.intel.com>
 <20131031111612.2735d0c1@notabene.brown>
In-Reply-To: <20131031111612.2735d0c1@notabene.brown>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.182]
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 31, 2013 1:16 AM NeilBrown <neilb@suse.de> wrote:
> On Wed, 30 Oct 2013 13:20:22 +0100 Pawel Baldysiak
> <pawel.baldysiak@intel.com> wrote:
> 
> > In case of reshape of raid0 through raid4 a value of
> > discard_granularity will be set to stripe size. MD driver should
> > re-set this value to correct one when migration will be finished.
> > Otherwise array will be left with wrong value and discard operations will not
> work properly.
> >
> > Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> > Cc: Shaohua Li <shli@kernel.org>
> > ---
> >  drivers/md/raid0.c |    2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c index
> > c4d420b..807ca3a 100644
> > --- a/drivers/md/raid0.c
> > +++ b/drivers/md/raid0.c
> > @@ -266,6 +266,8 @@ static int create_strip_zones(struct mddev *mddev,
> struct r0conf **private_conf)
> >  	}
> >  	mddev->queue->backing_dev_info.congested_fn = raid0_congested;
> >  	mddev->queue->backing_dev_info.congested_data = mddev;
> > +	mddev->queue->limits.discard_granularity =
> > +			queue_logical_block_size(mddev->queue);
> >
> >  	/*
> >  	 * now since we have the hard sector sizes, we can make sure
> 
> Thanks, but this doesn't seem like the right sort of fix.  It is to specific to the
> symptom rather than trying to address the underlying problem.
> 
> Maybe something like this?  Can you review and test?
> 
> Thanks,
> NeilBrown
> 
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c index
> 628cd529343f..740b6340f980 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3620,6 +3620,7 @@ level_store(struct mddev *mddev, const char
> *buf, size_t len)
>  		mddev->in_sync = 1;
>  		del_timer_sync(&mddev->safemode_timer);
>  	}
> +	blk_set_stacking_limit(&mddev->queue->limits);
>  	pers->run(mddev);
>  	set_bit(MD_CHANGE_DEVS, &mddev->flags);
>  	mddev_resume(mddev);
Hi Neil,
I have tested Yours patch, and everything works well.
TRIM operation are made correctly.
Could You apply it to upstream? 

BTW. Correct name of this function is blk_set_stacking_limits();

Thanks,
Pawe³ Baldysiak
