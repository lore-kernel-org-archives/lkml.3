Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab3COQgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:36:13 -0400
Received: from 209-20-75-48.static.cloud-ips.com ([209.20.75.48]:43645 "EHLO
	shiva.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753001Ab3COQgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:36:12 -0400
Date: Fri, 15 Mar 2013 09:36:07 -0700
From: Ben Widawsky <ben@bwidawsk.net>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Tommi Rantala <tt.rantala@gmail.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Dave Jones <davej@redhat.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Sanity check incoming ioctl data
 for a NULL pointer
Message-ID: <20130315163606.GA17773@bwidawsk.net>
References: <CA+ydwtpuBvbwxbt-tdgPUvj1EU7itmCHo_2B3w13HkD5+jWKow@mail.gmail.com>
 <1363265997-29023-1-git-send-email-chris@chris-wilson.co.uk>
 <20130315045004.GA14747@bwidawsk.net>
 <20130315082403.GA29916@cantiga.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130315082403.GA29916@cantiga.alporthouse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 08:24:03AM +0000, Chris Wilson wrote:
> On Thu, Mar 14, 2013 at 09:50:04PM -0700, Ben Widawsky wrote:
> > On Thu, Mar 14, 2013 at 12:59:57PM +0000, Chris Wilson wrote:
> > > In order to prevent a potential NULL deference with hostile userspace,
> > > we need to check whether the ioctl was passed an invalid args pointer.
> > > 
> > > Reported-by: Tommi Rantala <tt.rantala@gmail.com>
> > > Link: http://lkml.kernel.org/r/CA+ydwtpuBvbwxbt-tdgPUvj1EU7itmCHo_2B3w13HkD5+jWKow@mail.gmail.com
> > > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > > ---
> > >  drivers/gpu/drm/i915/i915_gem_execbuffer.c |   11 +++++++++--
> > >  1 file changed, 9 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
> > > index 365e41a..9f5602e 100644
> > > --- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
> > > +++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
> > > @@ -1103,7 +1103,11 @@ i915_gem_execbuffer(struct drm_device *dev, void *data,
> > >  	struct drm_i915_gem_exec_object2 *exec2_list = NULL;
> > >  	int ret, i;
> > >  
> > > -	if (args->buffer_count < 1) {
> > > +	if (args == NULL)
> > > +		return -EINVAL;
> > > +
> > > +	if (args->buffer_count < 1 ||
> > > +	    args->buffer_count > INT_MAX / sizeof(*exec2_list)) {
> > >  		DRM_DEBUG("execbuf with %d buffers\n", args->buffer_count);
> > >  		return -EINVAL;
> > >  	}
> > > @@ -1182,8 +1186,11 @@ i915_gem_execbuffer2(struct drm_device *dev, void *data,
> > >  	struct drm_i915_gem_exec_object2 *exec2_list = NULL;
> > >  	int ret;
> > >  
> > > +	if (args == NULL)
> > > +		return -EINVAL;
> > > +
> > >  	if (args->buffer_count < 1 ||
> > > -	    args->buffer_count > UINT_MAX / sizeof(*exec2_list)) {
> > > +	    args->buffer_count > INT_MAX / sizeof(*exec2_list)) {
> > >  		DRM_DEBUG("execbuf2 with %d buffers\n", args->buffer_count);
> > >  		return -EINVAL;
> > >  	}
> > 
> > Why did you change UINT_MAX to INT_MAX?
> 
> Because we check later against INT_MAX, and I didn't like the confusion.
> If we are going to pick an arbitrary limit, lets at least be consistent.
> 
> > TBH, I'm confused what we're
> > trying to achieve, and why we need anything other than:
> > if (!args->buffer_count)
> 
> Because we then promptly do a u32 multiply and we need to be sure that
> userspace can't trigger an overflow there and cause us to read
> unallocated memory later.
> > 
> > I'm also not seeing how the NULL checks are needed since at least it
> > seems to be for execbuffer (IOW) we could never have NULL args.
> 
> That's what I thought too. Looking at the stack trace, the empirical
> evidence is that we need the check.
> -Chris

I think we need to investigate the issue more then, or put a BUG_ON() in
the drm code and run it through trinity. We have other places where arg
can't/shouldn't be NULL and we don't check.

-- 
Ben Widawsky, Intel Open Source Technology Center
