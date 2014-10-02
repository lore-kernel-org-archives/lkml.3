Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbaJBNwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:52:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbaJBNwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:52:39 -0400
Date: Thu, 2 Oct 2014 09:52:32 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: NeilBrown <neilb@suse.de>
Cc: Heinz Mauelshagen <heinzm@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        Shaohua Li <shli@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: dm-raid: add RAID discard support
Message-ID: <20141002135232.GA25298@redhat.com>
References: <yq1zjdpsqry.fsf@sermon.lab.mkp.net>
 <7C39EB56-623A-4318-A558-258ABA32FF12@redhat.com>
 <20140924142157.33475baa@notabene.brown>
 <5422A4C4.4020707@redhat.com>
 <20141001125625.1e0d356a@notabene.brown>
 <20141001133237.GB16521@redhat.com>
 <20141002093403.25cc832f@notabene.brown>
 <20141002013135.GA21091@redhat.com>
 <20141002120049.58dba551@notabene.brown>
 <20141002140410.1b379f74@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141002140410.1b379f74@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02 2014 at 12:04am -0400,
NeilBrown <neilb@suse.de> wrote:

> 
> I plan to submit this to Linus tomorrow, hopefully for 3.7, unless there are
> complaints. It is in my for-next branch now.
> 
> Thanks,
> NeilBrown
> 
> 
> From aec6f821ed92fac5ae4f1db50279a3999de5872a Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Thu, 2 Oct 2014 13:45:00 +1000
> Subject: [PATCH] md/raid5: disable 'DISCARD' by default due to safety
>  concerns.
> 
> It has come to my attention (thanks Martin) that 'discard_zeroes_data'
> is only a hint.  Some devices in some cases don't do what it
> says on the label.
> 
> The use of DISCARD in RAID5 depends on reads from discarded regions
> being predictably zero.  If a write to a previously discarded region
> performs a read-modify-write cycle it assumes that the parity block
> was consistent with the data blocks.  If all were zero, this would
> be the case.  If some are and some aren't this would not be the case.
> This could lead to data corruption after a device failure when
> data needs to be reconstructed from the parity.
> 
> As we cannot trust 'discard_zeroes_data', ignore it by default
> and so disallow DISCARD on all raid4/5/6 arrays.
> 
> As many devices are trustworthy, and as there are benefits to using
> DISCARD, add a module parameter to over-ride this caution and cause
> DISCARD to work if discard_zeroes_data is set.
> 
> If a site want to enable DISCARD on some arrays but not on others they
> should select DISCARD support at the filesystem level, and set the
> raid456 module parameter.
>     raid456.devices_handle_discard_safely=Y
> 
> As this is a data-safety issue, I believe this patch is suitable for
> -stable.
> DISCARD support for RAID456 was added in 3.7
> 
> Cc: Shaohua Li <shli@kernel.org>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Heinz Mauelshagen <heinzm@redhat.com>
> Cc: stable@vger.kernel.org (3.7+)
> Fixes: 620125f2bf8ff0c4969b79653b54d7bcc9d40637
> Signed-off-by: NeilBrown <neilb@suse.de>

Acked-by: Mike Snitzer <snitzer@redhat.com>

Thanks Neil, I'll get something comparable staged for dm-raid for 3.18
(less urgency given that dm-raid doesn't yet support discards).
