Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab3HYLrE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 07:47:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247Ab3HYLrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 07:47:02 -0400
Date: Sun, 25 Aug 2013 14:48:52 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] vhost_net: use vhost_add_used_and_signal_n() in
 vhost_zerocopy_signal_used()
Message-ID: <20130825114852.GA1829@redhat.com>
References: <1376630190-5912-1-git-send-email-jasowang@redhat.com>
 <1376630190-5912-3-git-send-email-jasowang@redhat.com>
 <20130816095426.GA21821@redhat.com>
 <5212D564.80200@redhat.com>
 <5217225E.2060006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5217225E.2060006@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 04:50:38PM +0800, Jason Wang wrote:
> On 08/20/2013 10:33 AM, Jason Wang wrote:
> > On 08/16/2013 05:54 PM, Michael S. Tsirkin wrote:
> >> On Fri, Aug 16, 2013 at 01:16:26PM +0800, Jason Wang wrote:
> >>>> Switch to use vhost_add_used_and_signal_n() to avoid multiple calls to
> >>>> vhost_add_used_and_signal(). With the patch we will call at most 2 times
> >>>> (consider done_idx warp around) compared to N times w/o this patch.
> >>>>
> >>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> >> So? Does this help performance then?
> >>
> > Looks like it can especially when guest does support event index. When
> > guest enable tx interrupt, this can saves us some unnecessary signal to
> > guest. I will do some test.
> 
> Have done some test. I can see 2% - 3% increasing in both aggregate
> transaction rate and per cpu transaction rate in TCP_RR and UDP_RR test.
> 
> I'm using ixgbe. W/o this patch, I can see more than 100 calls of
> vhost_add_used_signal() in one vhost_zerocopy_signaled_used(). This is
> because ixgbe (and other modern ethernet driver) tends to free old tx
> skbs in a loop during tx interrupt, and vhost tend to batch the adding
> used and signal in vhost_zerocopy_callback(). Switching to use
> vhost_add_use_and_signal_n() means saving 100 times of used idx updating
> and memory barriers.

Well it's only smp_wmb so a nop on most architectures, so
a 2% gain is surprising.
I'm guessing the cache miss on the write is what's
giving us a speedup here.

I'll review the code, thanks.


-- 
MST
