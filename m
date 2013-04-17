Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966559Ab3DQOFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:05:51 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37169 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966386Ab3DQOFu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:05:50 -0400
Date: Wed, 17 Apr 2013 10:05:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH v1 2/7] xen-blkback: use balloon pages for all mappings
Message-ID: <20130417140542.GD21378@phenom.dumpdata.com>
References: <1364382643-3711-1-git-send-email-roger.pau@citrix.com>
 <1364382643-3711-3-git-send-email-roger.pau@citrix.com>
 <20130409144733.GA3158@phenom.dumpdata.com>
 <516BC4F5.10307@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <516BC4F5.10307@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 11:14:29AM +0200, Roger Pau Monné wrote:
> On 09/04/13 16:47, Konrad Rzeszutek Wilk wrote:
> > On Wed, Mar 27, 2013 at 12:10:38PM +0100, Roger Pau Monne wrote:
> >> Using balloon pages for all granted pages allows us to simplify the
> >> logic in blkback, especially in the xen_blkbk_map function, since now
> >> we can decide if we want to map a grant persistently or not after we
> >> have actually mapped it. This could not be done before because
> >> persistent grants used ballooned pages, whereas non-persistent grants
> >> used pages from the kernel.
> >>
> >> This patch also introduces several changes, the first one is that the
> >> list of free pages is no longer global, now each blkback instance has
> >> it's own list of free pages that can be used to map grants. Also, a
> >> run time parameter (max_buffer_pages) has been added in order to tune
> >> the maximum number of free pages each blkback instance will keep in
> >> it's buffer.
> >>
> >> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> >> Cc: xen-devel@lists.xen.org
> >> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > 
> > Sorry for the late review. Some comments.
> >> ---
> >> Changes since RFC:
> >>  * Fix typos in commit message.
> >>  * Minor fixes in code.
> >> ---
> >>  Documentation/ABI/stable/sysfs-bus-xen-backend |    8 +
> >>  drivers/block/xen-blkback/blkback.c            |  265 +++++++++++++-----------
> >>  drivers/block/xen-blkback/common.h             |    5 +
> >>  drivers/block/xen-blkback/xenbus.c             |    3 +
> >>  4 files changed, 165 insertions(+), 116 deletions(-)
> >>
> >> diff --git a/Documentation/ABI/stable/sysfs-bus-xen-backend b/Documentation/ABI/stable/sysfs-bus-xen-backend
> >> index 3d5951c..e04afe0 100644
> >> --- a/Documentation/ABI/stable/sysfs-bus-xen-backend
> >> +++ b/Documentation/ABI/stable/sysfs-bus-xen-backend
> >> @@ -73,3 +73,11 @@ KernelVersion:     3.0
> >>  Contact:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >>  Description:
> >>                  Number of sectors written by the frontend.
> >> +
> >> +What:           /sys/module/xen_blkback/parameters/max_buffer_pages
> >> +Date:           March 2013
> >> +KernelVersion:  3.10
> >> +Contact:        Roger Pau Monné <roger.pau@citrix.com>
> >> +Description:
> >> +                Maximum number of free pages to keep in each block
> >> +                backend buffer.
> >> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> >> index f7526db..8a1892a 100644
> >> --- a/drivers/block/xen-blkback/blkback.c
> >> +++ b/drivers/block/xen-blkback/blkback.c
> >> @@ -63,6 +63,21 @@ static int xen_blkif_reqs = 64;
> >>  module_param_named(reqs, xen_blkif_reqs, int, 0);
> >>  MODULE_PARM_DESC(reqs, "Number of blkback requests to allocate");
> >>
> >> +/*
> >> + * Maximum number of unused free pages to keep in the internal buffer.
> >> + * Setting this to a value too low will reduce memory used in each backend,
> >> + * but can have a performance penalty.
> >> + *
> >> + * A sane value is xen_blkif_reqs * BLKIF_MAX_SEGMENTS_PER_REQUEST, but can
> >> + * be set to a lower value that might degrade performance on some intensive
> >> + * IO workloads.
> >> + */
> >> +
> >> +static int xen_blkif_max_buffer_pages = 704;
> >> +module_param_named(max_buffer_pages, xen_blkif_max_buffer_pages, int, 0644);
> >> +MODULE_PARM_DESC(max_buffer_pages,
> >> +"Maximum number of free pages to keep in each block backend buffer");
> >> +
> >>  /* Run-time switchable: /sys/module/blkback/parameters/ */
> >>  static unsigned int log_stats;
> >>  module_param(log_stats, int, 0644);
> >> @@ -82,10 +97,14 @@ struct pending_req {
> >>       int                     status;
> >>       struct list_head        free_list;
> >>       DECLARE_BITMAP(unmap_seg, BLKIF_MAX_SEGMENTS_PER_REQUEST);
> >> +     struct page             *pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
> >>  };
> >>
> >>  #define BLKBACK_INVALID_HANDLE (~0)
> >>
> >> +/* Number of free pages to remove on each call to free_xenballooned_pages */
> >> +#define NUM_BATCH_FREE_PAGES 10
> >> +
> >>  struct xen_blkbk {
> >>       struct pending_req      *pending_reqs;
> >>       /* List of all 'pending_req' available */
> >> @@ -93,8 +112,6 @@ struct xen_blkbk {
> >>       /* And its spinlock. */
> >>       spinlock_t              pending_free_lock;
> >>       wait_queue_head_t       pending_free_wq;
> >> -     /* The list of all pages that are available. */
> >> -     struct page             **pending_pages;
> >>       /* And the grant handles that are available. */
> >>       grant_handle_t          *pending_grant_handles;
> >>  };
> >> @@ -143,14 +160,66 @@ static inline int vaddr_pagenr(struct pending_req *req, int seg)
> >>               BLKIF_MAX_SEGMENTS_PER_REQUEST + seg;
> >>  }
> >>
> >> -#define pending_page(req, seg) pending_pages[vaddr_pagenr(req, seg)]
> >> +static inline int get_free_page(struct xen_blkif *blkif, struct page **page)
> >> +{
> >> +     unsigned long flags;
> >> +
> >> +     spin_lock_irqsave(&blkif->free_pages_lock, flags);
> > 
> > I am curious to why you need to use the irqsave variant one here, as
> >> +     if (list_empty(&blkif->free_pages)) {
> >> +             BUG_ON(blkif->free_pages_num != 0);
> >> +             spin_unlock_irqrestore(&blkif->free_pages_lock, flags);
> >> +             return alloc_xenballooned_pages(1, page, false);
> > 
> > This function is using an mutex.
> > 
> > which would imply it is OK to have an non-irq variant of spinlock?
> 
> Sorry, the previous response is wrong, I need to use irqsave in order to
> disable interrupts, since put_free_pages is called from interrupt
> context and it could create a race if for example, put_free_pages is
> called while we are inside shrink_free_pagepool.

OK, but you can mix the irq and non-irq spinlocks variants.
