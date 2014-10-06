Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaJFLd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 07:33:27 -0400
Received: from smtp.eu.citrix.com ([185.25.65.24]:52159 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaJFLdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 07:33:25 -0400
X-IronPort-AV: E=Sophos;i="5.04,663,1406592000"; 
   d="scan'208";a="25717072"
From: Thanos Makatos <thanos.makatos@citrix.com>
To: Thanos Makatos <thanos.makatos@citrix.com>, "'Jan Kara'" <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>
CC: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "jlayton@poochiereds.net" <jlayton@poochiereds.net>,
        "bfields@fieldses.org" <bfields@fieldses.org>
Subject: RE: [PATCH RFC] introduce ioctl to completely invalidate page cache
Thread-Topic: [PATCH RFC] introduce ioctl to completely invalidate page cache
Thread-Index: AQHP3ltJMeutIaA2t0eKb6z3ckY5/ZwdGI8AgAWCNICAADKhoIAAKHWw
Date: Mon, 6 Oct 2014 11:33:23 +0000
Message-ID: <2368A3FCF9F7214298E53C823B0A48EC0424106C@AMSPEX01CL02.citrite.net>
References: <1412266184-23776-1-git-send-email-thanos.makatos@citrix.com>
 <542DAEAC.8010203@kernel.dk> <20141006080659.GA7526@quack.suse.cz>
 <2368A3FCF9F7214298E53C823B0A48EC042405BC@AMSPEX01CL02.citrite.net>
In-Reply-To: <2368A3FCF9F7214298E53C823B0A48EC042405BC@AMSPEX01CL02.citrite.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-DLP: AMS1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Trond also had a comment that if we extended the ioctl to work for all
> > inodes (not just blkdev) and allowed some additional flags of what
> > needs to be invalidated, the new ioctl would be also useful to NFS
> > userspace - see Trond's email at
> >
> > http://www.spinics.net/lists/linux-fsdevel/msg78917.html
> >
> > and the following thread. I would prefer to cover that usecase when we
> > are introducing new invalidation ioctl. Have you considered that Thanos?
> 
> Sure, though I don't really know how to do it. I'll start by looking at the code
> flow when someone does " echo 3 > /proc/sys/vm/drop_caches", unless you
> already have a rough idea how to do that.

I realise I haven't clearly understood what the semantics of this new ioctl
should be.

My initial goal was to implement an ioctl that would _completely_ invalidate
the buffer cache of a block device when there is no file-system involved.
Unless I'm mistaken the patch I posted achieves this goal.

We now want to extend this patch to take care of cached metadata, which seems
to be of particular importance for NFS, and I suspect that this piece of
functionality will still be applicable to any kind of file-system, correct?

Do we want this new ioctl to do what "echo 3 > /proc/sys/vm/drop_caches" does
but on a more selective basis, which IIUC drops whatever can be dropped, but
may not drop everything? If so, then we should more precisely define this ioctl
as "drop *all* cached data and as much metadata you can, which may not be all
of them". If this is the case, would adding a call to drop_pagecache_sb() on
all super blocks whose .s_bdev equals the block device we're interested in
suffice?
