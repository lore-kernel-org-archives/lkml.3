Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760894AbaCUP05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 11:26:57 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:41673 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbaCUP0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 11:26:54 -0400
Message-ID: <532C5A3B.9020005@bjorling.me>
Date: Fri, 21 Mar 2014 08:26:51 -0700
From: Matias Bjorling <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: agk@redhat.com, dm-devel@redhat.com, neilb@suse.de,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v1 01/01] dm-lightnvm: An open FTL for open firmware
 SSDs
References: <1395383538-18019-1-git-send-email-m@bjorling.me> <1395383538-18019-2-git-send-email-m@bjorling.me> <20140321150942.GA29731@redhat.com>
In-Reply-To: <20140321150942.GA29731@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 08:09 AM, Mike Snitzer wrote:
> On Fri, Mar 21 2014 at  2:32am -0400,
> Matias Bjørling <m@bjorling.me> wrote:
> 
>> LightNVM implements the internal logic of an SSD within the host system.
>> This includes logic such as translation tables for logical to physical
>> address translation, garbage collection and wear-leveling.
>>
>> It is designed to be used either standalone or with a LightNVM
>> compatible firmware. If used standalone, NVM memory can be simulated
>> by passing timings to the dm target table. If used with a LightNVM
>> compatible device, the device will be queued upon initialized for the
>> relevant values.
>>
>> The last part is still in progress and a fully working prototype will be
>> presented in upcoming patches.
>>
>> Contributions to make this possible by the following people:
>>
>> Aviad Zuck <aviadzuc@tau.ac.il>
>> Jesper Madsen <jmad@itu.dk>
>>
>> Signed-off-by: Matias Bjorling <m@bjorling.me>
> ...
>> diff --git a/drivers/md/lightnvm/core.c b/drivers/md/lightnvm/core.c
>> new file mode 100644
>> index 0000000..113fde9
>> --- /dev/null
>> +++ b/drivers/md/lightnvm/core.c
>> @@ -0,0 +1,705 @@
>> +#include "lightnvm.h"
>> +
>> +/* alloc pbd, but also decorate it with bio */
>> +static struct per_bio_data *alloc_init_pbd(struct nvmd *nvmd, struct bio *bio)
>> +{
>> +	struct per_bio_data *pb = mempool_alloc(nvmd->per_bio_pool, GFP_NOIO);
>> +
>> +	if (!pb) {
>> +		DMERR("Couldn't allocate per_bio_data");
>> +		return NULL;
>> +	}
>> +
>> +	pb->bi_end_io = bio->bi_end_io;
>> +	pb->bi_private = bio->bi_private;
>> +
>> +	bio->bi_private = pb;
>> +
>> +	return pb;
>> +}
>> +
>> +static void free_pbd(struct nvmd *nvmd, struct per_bio_data *pb)
>> +{
>> +	mempool_free(pb, nvmd->per_bio_pool);
>> +}
>> +
>> +/* bio to be stripped from the pbd structure */
>> +static void exit_pbd(struct per_bio_data *pb, struct bio *bio)
>> +{
>> +	bio->bi_private = pb->bi_private;
>> +	bio->bi_end_io = pb->bi_end_io;
>> +}
>> +
> 
> Hi Matias,
> 
> This looks like it'll be very interesting!  But I won't have time to do
> a proper review of this code for ~1.5 weeks (traveling early next week
> and then need to finish some high priority work on dm-thin once I'm
> back).

That's great.

> 
> But a couple quick things I noticed:
> 
> 1) you don't need to roll your own per-bio-data allocation code any
> more.  The core block layer provides per_bio_data now.
> 
> And the DM targets have been converted to make use of it.  See callers
> of dm_per_bio_data() and how the associated targets set
> ti->per_bio_data_size
> 
> 2) Also, if you're chaining bi_end_io (like it appears you're doing)
> you'll definitely need to call atomic_inc(&bio->bi_remaining); after you
> restore bio->bi_end_io.  This is a new requirement of the 3.14 kernel
> (due to the block core's immutable biovec changes).
> 
> Please sort these issues out, re-test on 3.14, and post v2, thanks!
> Mike
> 

Thanks. I'll get it fixed and rebasedk/tested on 3.14.

Matias

