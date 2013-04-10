Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab3DJEZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 00:25:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707Ab3DJEZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 00:25:05 -0400
Date: Wed, 10 Apr 2013 06:24:49 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Michael R. Hines" <mrhines@linux.vnet.ibm.com>
Cc: Roland Dreier <roland@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Yishai Hadas <yishaih@mellanox.com>, Christoph Lameter <cl@linux.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, qemu-devel@nongnu.org
Subject: Re: [PATCHv2] rdma: add a new IB_ACCESS_GIFT flag
Message-ID: <20130410032449.GA12777@redhat.com>
References: <20130324155153.GA8597@redhat.com>
 <515F3160.4020007@linux.vnet.ibm.com>
 <CAL1RGDU2jtrRrxi6srsH_ADiYGvJbCpCT3UvoLGTX3cvQ=s0kQ@mail.gmail.com>
 <515F3948.40205@linux.vnet.ibm.com>
 <CAG4TOxPNHZadLjq6-HuOExf1XXLO6AYyvRQ1L09i6qVeA5dbLQ@mail.gmail.com>
 <515F42EE.8060203@linux.vnet.ibm.com>
 <20130409190350.GB8212@redhat.com>
 <5164BFE3.4040204@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5164BFE3.4040204@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, Apr 09, 2013 at 09:26:59PM -0400, Michael R. Hines wrote:
> With respect, I'm going to offload testing this patch back to the author =)
> because I'm trying to address all of Paolo's other minor issues
> with the RDMA patch before we can merge.

Fair enough, this likely means it won't happen anytime soon though.

> Since dynamic page registration (as you requested) is now fully
> implemented, this patch is less urgent since we now have a
> mechanism in place to avoid page pinning on both sides of the migration.
> 
> - Michael
> 

Which mechanism do you refer to? You patches still seem to pin
each page in guest memory at some point, which will break all
COW. In particular any pagemap tricks to detect duplicates
on source that I suggested won't work.

> On 04/09/2013 03:03 PM, Michael S. Tsirkin wrote:
> >presumably is_dup_page reads the page, so should not break COW ...
> >
> >I'm not sure about the cgroups swap limit - you might have
> >too many non COW pages so attempting to fault them all in
> >makes you exceed the limit. You really should look at
> >what is going on in the pagemap, to see if there's
> >measureable gain from the patch.
> >
> >
> >On Fri, Apr 05, 2013 at 05:32:30PM -0400, Michael R. Hines wrote:
> >>Well, I have the "is_dup_page()" commented out.......when RDMA is
> >>activated.....
> >>
> >>Is there something else in QEMU that could be touching the page that
> >>I don't know about?
> >>
> >>- Michael
> >>
> >>
> >>On 04/05/2013 05:03 PM, Roland Dreier wrote:
> >>>On Fri, Apr 5, 2013 at 1:51 PM, Michael R. Hines
> >>><mrhines@linux.vnet.ibm.com> wrote:
> >>>>Sorry, I was wrong. ignore the comments about cgroups. That's still broken.
> >>>>(i.e. trying to register RDMA memory while using a cgroup swap limit cause
> >>>>the process get killed).
> >>>>
> >>>>But the GIFT flag patch works (my understanding is that GIFT flag allows the
> >>>>adapter to transmit stale memory information, it does not have anything to
> >>>>do with cgroups specifically).
> >>>The point of the GIFT patch is to avoid triggering copy-on-write so
> >>>that memory doesn't blow up during migration.  If that doesn't work
> >>>then there's no point to the patch.
> >>>
> >>>  - R.
> >>>
