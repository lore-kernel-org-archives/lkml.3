Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab3COXtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 19:49:50 -0400
Received: from 209-20-75-48.static.cloud-ips.com ([209.20.75.48]:43887 "EHLO
	shiva.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753235Ab3COXtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 19:49:49 -0400
Date: Fri, 15 Mar 2013 16:49:42 -0700
From: Ben Widawsky <ben@bwidawsk.net>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Tommi Rantala <tt.rantala@gmail.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Dave Jones <davej@redhat.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Sanity check incoming ioctl data
 for a NULL pointer
Message-ID: <20130315234942.GB715@bwidawsk.net>
References: <CA+ydwtpuBvbwxbt-tdgPUvj1EU7itmCHo_2B3w13HkD5+jWKow@mail.gmail.com>
 <1363265997-29023-1-git-send-email-chris@chris-wilson.co.uk>
 <20130315045004.GA14747@bwidawsk.net>
 <20130315082403.GA29916@cantiga.alporthouse.com>
 <20130315163606.GA17773@bwidawsk.net>
 <20130315220619.GA17405@cantiga.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130315220619.GA17405@cantiga.alporthouse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 10:06:19PM +0000, Chris Wilson wrote:
> On Fri, Mar 15, 2013 at 09:36:07AM -0700, Ben Widawsky wrote:
> > On Fri, Mar 15, 2013 at 08:24:03AM +0000, Chris Wilson wrote:
> > > That's what I thought too. Looking at the stack trace, the empirical
> > > evidence is that we need the check.
> > > -Chris
> > 
> > I think we need to investigate the issue more then, or put a BUG_ON() in
> > the drm code and run it through trinity. We have other places where arg
> > can't/shouldn't be NULL and we don't check.
> 
> Actually we are both wrong. drm_ioctl() does not validate that the
> user struct matches the expected size, just ensures that if that user
> cmd specifies that the arg is to be used that it only up to the known
> size is copied.
> 
> A hostile userspace can bludgen a NULL pointer through drm_ioctl() into
> the driver->ioctl->func().

> > > +   if (args == NULL)
> > > +           return -EINVAL;
> > > +

I must be failing to see the obvious, but I'm still not getting how args
can ever be NULL. kdata which is passed to us as "data" and cast to
"args' is either always some stack variable, or some kmalloc'd memory. I
see how the arguments themselves can be crap which is really only when
user size != drv_size.

So tell me, which case can result in a NULL arg?
1. user size == drv_size // better not be this one
2. user size < driver size
3. user size > driver size

It seems to me we still must [simply] be missing something in our
parameter validation.

> 
> If we used driver->ioctl->cmd instead of the user supplied cmd, we would
> have a whole other can of worms to deal with (as we suddenly get a
> struct of zeroes). However, those worms should already be treated as
> invalid. Choose your poison.
> -Chris
> 
> -- 
> Chris Wilson, Intel Open Source Technology Centre


-- 
Ben Widawsky, Intel Open Source Technology Center
