Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaJMJcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 05:32:18 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:62174 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbaJMJcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 05:32:15 -0400
Date: Mon, 13 Oct 2014 11:32:16 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [RFC 1/4] dma-buf: Add constraints sharing
 information
Message-ID: <20141013093216.GK26941@phenom.ffwll.local>
Mail-Followup-To: Laura Abbott <lauraa@codeaurora.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org
References: <1412971678-4457-1-git-send-email-sumit.semwal@linaro.org>
 <1412971678-4457-2-git-send-email-sumit.semwal@linaro.org>
 <20141011185502.GH26941@phenom.ffwll.local>
 <543B8A02.5050106@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543B8A02.5050106@codeaurora.org>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 01:14:58AM -0700, Laura Abbott wrote:
> On 10/11/2014 11:55 AM, Daniel Vetter wrote:
> >On Sat, Oct 11, 2014 at 01:37:55AM +0530, Sumit Semwal wrote:
> >>At present, struct device lacks a mechanism of exposing memory
> >>access constraints for the device.
> >>
> >>Consequently, there is also no mechanism to share these constraints
> >>while sharing buffers using dma-buf.
> >>
> >>If we add support for sharing such constraints, we could use that
> >>to try to collect requirements of different buffer-sharing devices
> >>to allocate buffers from a pool that satisfies requirements of all
> >>such devices.
> >>
> >>This is an attempt to add this support; at the moment, only a bitmask
> >>is added, but if post discussion, we realise we need more information,
> >>we could always extend the definition of constraint.
> >>
> >>A new dma-buf op is also added, to allow exporters to interpret or decide
> >>on constraint-masks on their own. A default implementation is provided to
> >>just AND (&) all the constraint-masks.
> >>
> >>What constitutes a constraint-mask could be left for interpretation on a
> >>per-platform basis, while defining some common masks.
> >>
> >>Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
> >>Cc: linux-kernel@vger.kernel.org
> >>Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >>Cc: linux-media@vger.kernel.org
> >>Cc: dri-devel@lists.freedesktop.org
> >>Cc: linaro-mm-sig@lists.linaro.org
> >
> >Just a few high-level comments, I'm between conference travel but
> >hopefully I can discuss this a bit at plumbers next week.
> >
> >- I agree that for the insane specific cases we need something opaque like
> >   the access constraints mask you propose here. But for the normal case I
> >   think the existing dma constraints in dma_params would go a long way,
> >   and I think we should look at Rob's RFC from aeons ago to solve those:
> >
> >   https://lkml.org/lkml/2012/7/19/285
> >
> >   With this we should be able to cover the allocation constraints of 90%
> >   of all cases hopefully.
> >
> >- I'm not sure whether an opaque bitmask is good enough really, I suspect
> >   that we also need various priorities between different allocators. With
> >   the option that some allocators are flat-out incompatible.
> >
> 
> From my experience with Ion, the bitmask is okay if you have only a few
> types but as soon as there are multiple regions it gets complicated and
> when you start adding in priority via id it really gets unwieldy.

My idea is to just have a priority field for all devices which have
special requirements (i.e. beyond dma masks/alignement/segment limits).
Same priority on different devices would indicate an incompatibility, but
higher priority on a parent device would indicate a possible allocator.
That way you could have a root allocator if there's a way to unify
everything. Not sure though whether this will work, since on intel devices
we just don't have these kinds of special constraints.

Overall my idea is to reuse the existing dma allocation code in upstream
linux as much as possible. So having a completely separate hirarchy of
memory allocators for shared buffers should imo be avoided.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
