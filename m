Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab3BLV23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:28:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54486 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab3BLV22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 16:28:28 -0500
Date: Tue, 12 Feb 2013 13:28:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Imre Deak <imre.deak@intel.com>
Cc: linux-kernel@vger.kernel.org, Maxim Levitsky <maximlevitsky@gmail.com>,
        Tejun Heo <tj@kernel.org>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH v2] lib/scatterlist: add simple page iterator
Message-Id: <20130212132826.a35d6f1d.akpm@linux-foundation.org>
In-Reply-To: <1360688840.5578.75.camel@localhost>
References: <1353590706-1366-5-git-send-email-imre.deak@intel.com>
	<1360608604-3520-1-git-send-email-imre.deak@intel.com>
	<20130211125422.978c1e99.akpm@linux-foundation.org>
	<1360688840.5578.75.camel@localhost>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2013 19:07:20 +0200
Imre Deak <imre.deak@intel.com> wrote:

> > So, exactly how big is this thing, and how do we know it's better this
> > way than if we were to uninline some/all of the helpers?
> 
> I admit I only hoped compiler optimization would keep the inlined parts
> at a minimum, but now I actually checked (on Intel CPU). I applied the
> patchset from [1] and uninlined sg_page_iter_start as it's not
> significant for speed:
> 
>  size drivers/gpu/drm/i915/i915.ko
>  514855	  15996	    272	 531123	  81ab3	drivers/gpu/drm/i915/i915.ko
> 
> Then uninlined all helpers:
>  size drivers/gpu/drm/i915/i915.ko
>  513447	  15996	    272	 529715	  81533	drivers/gpu/drm/i915/i915.ko
> 
> Since there are 8 invocations of the macro, the overhead for a single
> invocation is about (531123 - 529715) / 8 = 191 bytes.
> 
> For speed, I benchmarked a simple loop which was basically:
> 
> page = vmalloc(sizeof(*page) * 1000, GFP_KERNEL);
> for_each_sg_page(sglist, iter, 0)
> 	*page++ = iter.page;
> 
> where each entry on the sglist contained 16 consecutive pages. This
> takes ~10% more time for the uninlined version to run. This is a rather
> artificial test and I couldn't come up with something more real-life
> using only the i915 driver's ioctl interface that would show a
> significant change in speed.

10% for the function call overhead sounds reasonable.  Of course, that
test is biased in one direction.  A test which was biased in the other
direction would exercise all eight of the macro's callsites and would
investigate the performance impact of a 1kbyte increase in L1 cache
utilisation.

And I must say, it would need to be a pretty damn carefully crafted
test case to be able to trigger enough cache thrashing to cause a 10%
hit.

> So at least for now I'm ok with just uninlining all the helpers.

OK.
