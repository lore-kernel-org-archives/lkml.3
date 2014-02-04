Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbaBDMfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 07:35:43 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:38966 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaBDMfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 07:35:40 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.11.1402040425020.23694@eggly.anvils>
References: <alpine.LSU.2.11.1401121909160.1239@eggly.anvils>
	<20140114023346.GN9037@kmo>
	<yq161pnmcl2.fsf@sermon.lab.mkp.net>
	<20140114044841.GO9037@kmo>
	<yq1ob3el3mr.fsf@sermon.lab.mkp.net>
	<20140114222424.GA7333@moria.home.lan>
	<alpine.LSU.2.11.1401161129380.1321@eggly.anvils>
	<20140117012105.GS9037@kmo>
	<alpine.LSU.2.11.1401310852000.987@eggly.anvils>
	<20140204101748.GA12440@kmo-pixel>
	<alpine.LSU.2.11.1402040425020.23694@eggly.anvils>
Date: Tue, 4 Feb 2014 04:35:39 -0800
Message-ID: <CALJ65znU+84G2vuc-xJN7eV-k=tsCCRBf4zqZbyzCCk0qYA4KQ@mail.gmail.com>
Subject: Re: [PATCH] block: Explicitly handle discard/write same segments
From: Kent Overstreet <kmo@daterainc.com>
To: Hugh Dickins <hughd@google.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks!

On Tue, Feb 4, 2014 at 4:25 AM, Hugh Dickins <hughd@google.com> wrote:
> On Tue, 4 Feb 2014, Kent Overstreet wrote:
>
>> Immutable biovecs changed the way biovecs are interpreted - drivers no
>> longer use bi_vcnt, they have to go by bi_iter.bi_size (to allow for
>> using part of an existing segment without modifying it).
>>
>> This breaks with discards and write_same bios, since for those bi_size
>> has nothing to do with segments in the biovec. So for now, we need a
>> fairly gross hack - we fortunately know that there will never be more
>> than one segment for the entire request, so we can special case
>> discard/write_same.
>>
>> Signed-off-by: Kent Overstreet <kmo@daterainc.com>
>> ---
>> On Fri, Jan 31, 2014 at 09:17:25AM -0800, Hugh Dickins wrote:
>> > On Thu, 16 Jan 2014, Kent Overstreet wrote:
>> > >
>> > > Ok, I reread the code and figured it out - the analagous change also has to be
>> > > made in __blk_segment_map_sg(). I'll mail out a patch for this tomorrow after
>> > > I've stared at the code more and had less beer.
>> >
>> > I'd been hoping for a patch to try, but now your changes have hit Linus's
>> > tree: so today we have discard broken there too, crashing as originally
>> > reported on the NULL struct page pointer in __blk_recalc_rq_segments()'s
>> > page_to_pfn(bv.bv_page).
>> >
>> > How to reproduce it?  I hope you'll find easier ways, but I get it with
>> > swapping to SSD (remember "swapon -d" to enable discard).  I'm just doing
>> > what I've done for years, running a pair of make -j20 kbuilds to tmpfs in
>> > limited RAM (I use mem=700M with 1.5G of swap: but that would be far too
>> > little RAM for a general config of current tree), to get plenty of fairly
>> > chaotic swapping but good forward progress nonetheless (if the sizes are
>> > too small, then it'll just thrash abysmally or be OOM-killed).
>> >
>> > But please do send me a patch and I'll give it a try - thanks.
>>
>> Hugh - can you give this patch a try? Passes my tests but I was never
>> able to reproduce your crash, unfortunately.
>
> Thanks a lot, Kent: I'm glad to report, this is working fine for me.
>
> Hugh
>
>>
>>  block/blk-merge.c | 91 +++++++++++++++++++++++++++++++++++++------------------
>>  1 file changed, 62 insertions(+), 29 deletions(-)
>>
>> diff --git a/block/blk-merge.c b/block/blk-merge.c
>> index 8f8adaa954..6c583f9c5b 100644
>> --- a/block/blk-merge.c
>> +++ b/block/blk-merge.c
>> @@ -21,6 +21,16 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
>>       if (!bio)
>>               return 0;
>>
>> +     /*
>> +      * This should probably be returning 0, but blk_add_request_payload()
>> +      * (Christoph!!!!)
>> +      */
>> +     if (bio->bi_rw & REQ_DISCARD)
>> +             return 1;
>> +
>> +     if (bio->bi_rw & REQ_WRITE_SAME)
>> +             return 1;
>> +
>>       fbio = bio;
>>       cluster = blk_queue_cluster(q);
>>       seg_size = 0;
>> @@ -161,30 +171,60 @@ new_segment:
>>       *bvprv = *bvec;
>>  }
>>
>> -/*
>> - * map a request to scatterlist, return number of sg entries setup. Caller
>> - * must make sure sg can hold rq->nr_phys_segments entries
>> - */
>> -int blk_rq_map_sg(struct request_queue *q, struct request *rq,
>> -               struct scatterlist *sglist)
>> +static int __blk_bios_map_sg(struct request_queue *q, struct bio *bio,
>> +                          struct scatterlist *sglist,
>> +                          struct scatterlist **sg)
>>  {
>>       struct bio_vec bvec, bvprv = { NULL };
>> -     struct req_iterator iter;
>> -     struct scatterlist *sg;
>> +     struct bvec_iter iter;
>>       int nsegs, cluster;
>>
>>       nsegs = 0;
>>       cluster = blk_queue_cluster(q);
>>
>> -     /*
>> -      * for each bio in rq
>> -      */
>> -     sg = NULL;
>> -     rq_for_each_segment(bvec, rq, iter) {
>> -             __blk_segment_map_sg(q, &bvec, sglist, &bvprv, &sg,
>> -                                  &nsegs, &cluster);
>> -     } /* segments in rq */
>> +     if (bio->bi_rw & REQ_DISCARD) {
>> +             /*
>> +              * This is a hack - drivers should be neither modifying the
>> +              * biovec, nor relying on bi_vcnt - but because of
>> +              * blk_add_request_payload(), a discard bio may or may not have
>> +              * a payload we need to set up here (thank you Christoph) and
>> +              * bi_vcnt is really the only way of telling if we need to.
>> +              */
>> +
>> +             if (bio->bi_vcnt)
>> +                     goto single_segment;
>> +
>> +             return 0;
>> +     }
>> +
>> +     if (bio->bi_rw & REQ_WRITE_SAME) {
>> +single_segment:
>> +             *sg = sglist;
>> +             bvec = bio_iovec(bio);
>> +             sg_set_page(*sg, bvec.bv_page, bvec.bv_len, bvec.bv_offset);
>> +             return 1;
>> +     }
>> +
>> +     for_each_bio(bio)
>> +             bio_for_each_segment(bvec, bio, iter)
>> +                     __blk_segment_map_sg(q, &bvec, sglist, &bvprv, sg,
>> +                                          &nsegs, &cluster);
>>
>> +     return nsegs;
>> +}
>> +
>> +/*
>> + * map a request to scatterlist, return number of sg entries setup. Caller
>> + * must make sure sg can hold rq->nr_phys_segments entries
>> + */
>> +int blk_rq_map_sg(struct request_queue *q, struct request *rq,
>> +               struct scatterlist *sglist)
>> +{
>> +     struct scatterlist *sg = NULL;
>> +     int nsegs = 0;
>> +
>> +     if (rq->bio)
>> +             nsegs = __blk_bios_map_sg(q, rq->bio, sglist, &sg);
>>
>>       if (unlikely(rq->cmd_flags & REQ_COPY_USER) &&
>>           (blk_rq_bytes(rq) & q->dma_pad_mask)) {
>> @@ -230,20 +270,13 @@ EXPORT_SYMBOL(blk_rq_map_sg);
>>  int blk_bio_map_sg(struct request_queue *q, struct bio *bio,
>>                  struct scatterlist *sglist)
>>  {
>> -     struct bio_vec bvec, bvprv = { NULL };
>> -     struct scatterlist *sg;
>> -     int nsegs, cluster;
>> -     struct bvec_iter iter;
>> -
>> -     nsegs = 0;
>> -     cluster = blk_queue_cluster(q);
>> -
>> -     sg = NULL;
>> -     bio_for_each_segment(bvec, bio, iter) {
>> -             __blk_segment_map_sg(q, &bvec, sglist, &bvprv, &sg,
>> -                                  &nsegs, &cluster);
>> -     } /* segments in bio */
>> +     struct scatterlist *sg = NULL;
>> +     int nsegs;
>> +     struct bio *next = bio->bi_next;
>> +     bio->bi_next = NULL;
>>
>> +     nsegs = __blk_bios_map_sg(q, bio, sglist, &sg);
>> +     bio->bi_next = next;
>>       if (sg)
>>               sg_mark_end(sg);
>>
>> --
>> 1.9.rc1
