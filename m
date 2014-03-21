Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760337AbaCUPJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 11:09:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbaCUPJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 11:09:48 -0400
Date: Fri, 21 Mar 2014 11:09:42 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Matias =?iso-8859-1?Q?Bj=F8rling?= <m@bjorling.me>
Cc: agk@redhat.com, dm-devel@redhat.com, neilb@suse.de,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v1 01/01] dm-lightnvm: An open FTL for open firmware
 SSDs
Message-ID: <20140321150942.GA29731@redhat.com>
References: <1395383538-18019-1-git-send-email-m@bjorling.me>
 <1395383538-18019-2-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395383538-18019-2-git-send-email-m@bjorling.me>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21 2014 at  2:32am -0400,
Matias Bjørling <m@bjorling.me> wrote:

> LightNVM implements the internal logic of an SSD within the host system.
> This includes logic such as translation tables for logical to physical
> address translation, garbage collection and wear-leveling.
> 
> It is designed to be used either standalone or with a LightNVM
> compatible firmware. If used standalone, NVM memory can be simulated
> by passing timings to the dm target table. If used with a LightNVM
> compatible device, the device will be queued upon initialized for the
> relevant values.
> 
> The last part is still in progress and a fully working prototype will be
> presented in upcoming patches.
> 
> Contributions to make this possible by the following people:
> 
> Aviad Zuck <aviadzuc@tau.ac.il>
> Jesper Madsen <jmad@itu.dk>
> 
> Signed-off-by: Matias Bjorling <m@bjorling.me>
...
> diff --git a/drivers/md/lightnvm/core.c b/drivers/md/lightnvm/core.c
> new file mode 100644
> index 0000000..113fde9
> --- /dev/null
> +++ b/drivers/md/lightnvm/core.c
> @@ -0,0 +1,705 @@
> +#include "lightnvm.h"
> +
> +/* alloc pbd, but also decorate it with bio */
> +static struct per_bio_data *alloc_init_pbd(struct nvmd *nvmd, struct bio *bio)
> +{
> +	struct per_bio_data *pb = mempool_alloc(nvmd->per_bio_pool, GFP_NOIO);
> +
> +	if (!pb) {
> +		DMERR("Couldn't allocate per_bio_data");
> +		return NULL;
> +	}
> +
> +	pb->bi_end_io = bio->bi_end_io;
> +	pb->bi_private = bio->bi_private;
> +
> +	bio->bi_private = pb;
> +
> +	return pb;
> +}
> +
> +static void free_pbd(struct nvmd *nvmd, struct per_bio_data *pb)
> +{
> +	mempool_free(pb, nvmd->per_bio_pool);
> +}
> +
> +/* bio to be stripped from the pbd structure */
> +static void exit_pbd(struct per_bio_data *pb, struct bio *bio)
> +{
> +	bio->bi_private = pb->bi_private;
> +	bio->bi_end_io = pb->bi_end_io;
> +}
> +

Hi Matias,

This looks like it'll be very interesting!  But I won't have time to do
a proper review of this code for ~1.5 weeks (traveling early next week
and then need to finish some high priority work on dm-thin once I'm
back).

But a couple quick things I noticed:

1) you don't need to roll your own per-bio-data allocation code any
more.  The core block layer provides per_bio_data now.

And the DM targets have been converted to make use of it.  See callers
of dm_per_bio_data() and how the associated targets set
ti->per_bio_data_size

2) Also, if you're chaining bi_end_io (like it appears you're doing)
you'll definitely need to call atomic_inc(&bio->bi_remaining); after you
restore bio->bi_end_io.  This is a new requirement of the 3.14 kernel
(due to the block core's immutable biovec changes).

Please sort these issues out, re-test on 3.14, and post v2, thanks!
Mike
