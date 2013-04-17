Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966645Ab3DQO0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:26:06 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17553 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966437Ab3DQO0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:26:03 -0400
Date: Wed, 17 Apr 2013 10:25:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH v1 7/7] xen-block: implement indirect descriptors
Message-ID: <20130417142554.GG21378@phenom.dumpdata.com>
References: <1364382643-3711-1-git-send-email-roger.pau@citrix.com>
 <1364382643-3711-8-git-send-email-roger.pau@citrix.com>
 <20130409184923.GA4978@phenom.dumpdata.com>
 <516C3264.3050409@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516C3264.3050409@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +struct blkif_x86_32_request_indirect {
> >> +     uint8_t        indirect_op;
> >> +     uint16_t       nr_segments;
> > 
> > This needs to be documented. Is there are limit to what it can be? What if
> > the frontend sets it to 1231231?
> 
> This is checked in dispatch_rw_block_io:
> 
> if (unlikely(nseg == 0 && operation != WRITE_FLUSH) ||
>     unlikely((req->operation != BLKIF_OP_INDIRECT) &&
>              (nseg > BLKIF_MAX_SEGMENTS_PER_REQUEST)) ||
>     unlikely((req->operation == BLKIF_OP_INDIRECT) &&
>              (nseg > MAX_INDIRECT_SEGMENTS))) {
> 	pr_debug(DRV_PFX "Bad number of segments in request (%d)\n",
> 		 nseg);

I am wondering whether we should make that pr_err ..?

> 	/* Haven't submitted any bio's yet. */
> 	goto fail_response;
> }
> 
> And the value of MAX_INDIRECT_SEGMENTS is exported to the frontend in
> xenstore, so the frontend does:
> 
> max_indirect_segments = min(MAX_INDIRECT_SEGMENTS, front_max_segments);
> 
> To know how many segments it can safely use in an indirect op.

<nods>
> 
> > 
> >> +     uint64_t       id;
> >> +     blkif_sector_t sector_number;
> >> +     blkif_vdev_t   handle;
> >> +     uint16_t       _pad1;
> >> +     grant_ref_t    indirect_grefs[BLKIF_MAX_INDIRECT_GREFS_PER_REQUEST];
> > 
> > And how do we figure out whether we are going to use one indirect_grefs or many?
> > That should be described here. (if I understand it right it would be done
> > via the maximum-indirect-something' variable)
> 
> I've added the following comment:
> 
> /*
>  * The maximum number of indirect segments (and pages) that will
>  * be used is determined by MAX_INDIRECT_SEGMENTS, this value
>  * is also exported to the guest (via xenstore max-indirect-segments
.. feature-max-indirect-segments..
>  * entry), so the frontend knows how many indirect segments the
>  * backend supports.
>  */
> 
Great!
> > 
> > 
> >> +} __attribute__((__packed__));
> >> +
> > 
> > Per my calculation the size of this structure is 55 bytes. The 64-bit is 59 bytes.
> > 
> > It is a bit odd, but then 1 byte is for the 'operation' in the 'blkif_x*_request',
> > so it comes out to 56 and 60 bytes.
> > 
> > Is that still the right amount ? I thought we wanted to flesh it out to be a nice
> > 64 byte aligned so that the future patches which will make the requests be
> > more cache-aligned and won't have to play games?
> 
> Yes, I've added a uint32_t for 64bits and a uint64_t for 32bits, that
> makes it 64bytes aligned in both cases.

Thanks
> 
> > 
> >>  struct blkif_x86_32_request {
> >>       uint8_t        operation;    /* BLKIF_OP_???                         */
> >>       union {
> >>               struct blkif_x86_32_request_rw rw;
> >>               struct blkif_x86_32_request_discard discard;
> >>               struct blkif_x86_32_request_other other;
> >> +             struct blkif_x86_32_request_indirect indirect;
> >>       } u;
> >>  } __attribute__((__packed__));
> >>
> >> @@ -127,12 +149,24 @@ struct blkif_x86_64_request_other {
> >>       uint64_t       id;           /* private guest value, echoed in resp  */
> >>  } __attribute__((__packed__));
> >>
> >> +struct blkif_x86_64_request_indirect {
> >> +     uint8_t        indirect_op;
> >> +     uint16_t       nr_segments;
> >> +     uint32_t       _pad1; /* offsetof(blkif_..,u.indirect.id)==8   */
> > 
> > The comment is a bit off compared to the rest.
> > 
> >> +     uint64_t       id;
> >> +     blkif_sector_t sector_number;
> >> +     blkif_vdev_t   handle;
> >> +     uint16_t       _pad2;
> >> +     grant_ref_t    indirect_grefs[BLKIF_MAX_INDIRECT_GREFS_PER_REQUEST];
> >> +} __attribute__((__packed__));
> >> +
> >>  struct blkif_x86_64_request {
> >>       uint8_t        operation;    /* BLKIF_OP_???                         */
> >>       union {
> >>               struct blkif_x86_64_request_rw rw;
> >>               struct blkif_x86_64_request_discard discard;
> >>               struct blkif_x86_64_request_other other;
> >> +             struct blkif_x86_64_request_indirect indirect;
> >>       } u;
> >>  } __attribute__((__packed__));
> >>
> >> @@ -257,6 +291,11 @@ struct xen_blkif {
> >>       wait_queue_head_t       waiting_to_free;
> >>  };
> >>
> >> +struct seg_buf {
> >> +     unsigned long offset;
> >> +     unsigned int nsec;
> >> +};
> >> +
> >>  /*
> >>   * Each outstanding request that we've passed to the lower device layers has a
> >>   * 'pending_req' allocated to it. Each buffer_head that completes decrements
> >> @@ -271,9 +310,16 @@ struct pending_req {
> >>       unsigned short          operation;
> >>       int                     status;
> >>       struct list_head        free_list;
> >> -     struct page             *pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
> >> -     struct persistent_gnt   *persistent_gnts[BLKIF_MAX_SEGMENTS_PER_REQUEST];
> >> -     grant_handle_t          grant_handles[BLKIF_MAX_SEGMENTS_PER_REQUEST];
> >> +     struct page             *pages[MAX_INDIRECT_SEGMENTS];
> >> +     struct persistent_gnt   *persistent_gnts[MAX_INDIRECT_SEGMENTS];
> >> +     grant_handle_t          grant_handles[MAX_INDIRECT_SEGMENTS];
> >> +     grant_ref_t             grefs[MAX_INDIRECT_SEGMENTS];
> >> +     /* Indirect descriptors */
> >> +     struct persistent_gnt   *indirect_persistent_gnts[MAX_INDIRECT_GREFS];
> >> +     struct page             *indirect_pages[MAX_INDIRECT_GREFS];
> >> +     grant_handle_t          indirect_handles[MAX_INDIRECT_GREFS];
> >> +     struct seg_buf          seg[MAX_INDIRECT_SEGMENTS];
> >> +     struct bio              *biolist[MAX_INDIRECT_SEGMENTS];
> > 
> > Oh wow. That is a big structure. So 1536 for the BLKIF_MAX_SEGMENTS_PER_REQUEST
> > ones and 24 bytes for the ones that deail with MAX_INDIRECT_GREFS.
> > 
> > This could be made look nicer. For example you could do:
> > 
> >         struct indirect {
> >                 struct page;
> >                 grant_handle_t handle;
> >                 struct persistent_gnt *gnt;
> >         } desc[MAX_INDIRECT_GREFS];
> > 
> >         .. and the same treatment to the BLKIF_MAX_SEGMENTS_PER_REQUEST
> > one.
> > 
> > Thought perhaps it makes more sense to do that with a later patch as a cleanup.
> 
> This was similar to what Jan was suggesting, but I would prefer to leave
> that for a latter patch.

<nods>

.. snip..
> >> +/*
> >> + * Maximum number of segments in indirect requests, the actual value used by
> >> + * the frontend driver is the minimum of this value and the value provided
> >> + * by the backend driver.
> >> + */
> >> +
> >> +static int xen_blkif_max_segments = 32;
> >> +module_param_named(max_segments, xen_blkif_max_segments, int, 0);
> >> +MODULE_PARM_DESC(max_segments,
> >> +"Maximum number of segments in indirect requests");
> > 
> > This means a new entry in Documentation/ABI/sysfs/...
> 
> I think I should just not allow this to be exported, since we cannot
> change it at run-time, so if a user changes the 0 to something else, and
> changes the value... nothing will happen (because this is only used
> before the device is connected).

OK, lets then not make it a module_param_named.

> 
> > 
> > Perhaps the xen-blkfront part of the patch should be just split out to make
> > this easier?
> > 
> > Perhaps what we really should have is just the 'max' value of megabytes
> > we want to handle on the ring.
> > 
> > As right now 32 ring requests * 32 segments = 4MB.  But if the user wants
> > to se the max: 32 * 4096 = so 512MB (right? each request would handle now 16MB
> > and since we have 32 of them = 512MB).
> 
> I've just set that to something that brings a performance benefit
> without having to map an insane number of persistent grants in blkback.
> 
> Yes, the values are correct, but the device request queue (rq) is only
> able to provide read requests with 64 segments or write requests with
> 128 segments. I haven't been able to get larger requests, even when
> setting this to 512 or higer.

What are you using to drive the requests? 'fio'?

.. snip..
> >> @@ -588,13 +666,14 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size)
> >>  static void xlvbd_flush(struct blkfront_info *info)
> >>  {
> >>       blk_queue_flush(info->rq, info->feature_flush);
> >> -     printk(KERN_INFO "blkfront: %s: %s: %s %s\n",
> >> +     printk(KERN_INFO "blkfront: %s: %s: %s %s %s\n",
> >>              info->gd->disk_name,
> >>              info->flush_op == BLKIF_OP_WRITE_BARRIER ?
> >>               "barrier" : (info->flush_op == BLKIF_OP_FLUSH_DISKCACHE ?
> >>               "flush diskcache" : "barrier or flush"),
> >>              info->feature_flush ? "enabled" : "disabled",
> >> -            info->feature_persistent ? "using persistent grants" : "");
> >> +            info->feature_persistent ? "using persistent grants" : "",
> >> +            info->max_indirect_segments ? "using indirect descriptors" : "");
> > 
> > This is a bit of mess now:
> > 
> > 
> > [    0.968241] blkfront: xvda: barrier or flush: disabled using persistent grants using indirect descriptors
> > 
> > Should it just be:
> > 
> > 'persistent_grants: enabled; indirect descriptors: enabled'
> > 
> > ?
> 
> Agreed. If you don't mind I will change the wording for both persistent
> grants and indirect descriptors in this same patch.

That is OK.

.. snip..
> >>   * Invoked when the backend is finally 'ready' (and has told produced
> >>   * the details about the physical device - #sectors, size, etc).
> >> @@ -1414,8 +1735,9 @@ static void blkfront_connect(struct blkfront_info *info)
> >>               set_capacity(info->gd, sectors);
> >>               revalidate_disk(info->gd);
> >>
> >> -             /* fall through */
> >> +             return;
> > 
> > How come?
> 
> We cannot fall thought anymore, because now we call blkif_recover in
> order to recover after performing the suspension, in the past this was
> just a return so we could fall thought.
> 
> We need to perform the recover at this point because we need to know if
> the backend supports indirect descriptors, and how many. In the past we
> used to perform the recover before the backend announced it's features,
> but now we need to know if the backend supports indirect segments or not.

OK. Can you put that nice explanation as a comment in there please?
