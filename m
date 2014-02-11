Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaBKO4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 09:56:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:37131 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbaBKO4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 09:56:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,826,1384329600"; 
   d="scan'208";a="473419927"
Date: Tue, 11 Feb 2014 16:56:15 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Sagar Arun Kamble <sagar.a.kamble@intel.com>
Cc: intel-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH v5 11/11] drm/i915: Calling rotate and
 inverse rotate transformations after clipping
Message-ID: <20140211145615.GT3891@intel.com>
References: <1392017478-4945-1-git-send-email-sagar.a.kamble@intel.com>
 <1392017478-4945-12-git-send-email-sagar.a.kamble@intel.com>
 <20140210133257.GK3891@intel.com>
 <1392118351.28501.21.camel@sagar-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392118351.28501.21.camel@sagar-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 05:02:31PM +0530, Sagar Arun Kamble wrote:
> On Mon, 2014-02-10 at 15:32 +0200, Ville Syrjälä wrote:
> > On Mon, Feb 10, 2014 at 01:01:18PM +0530, sagar.a.kamble@intel.com wrote:
> > > From: Sagar Kamble <sagar.a.kamble@intel.com>
> > > 
> > > With clipped sprites these transformations are not working. these
> > > functions transform complete sprite irrespective of clipping present.
> > > This leads to invisible portion of sprite show up when rotate 180 if
> > > it was out of visible area before.
> > > 
> > > v4: Moved rotate transform for source rectangle after clipping.
> > > Added rotate and inverse rotate transform for destination rect.
> > 
> > Still NAK.
> > 
> > I just pushed rotation support to my glplane test app [1], and with
> > with that my rotated clipping code works exactly as intended.
> > 
> > [1] git://gitorious.org/vsyrjala/glplane.git
> I tried this app. I think I am considering 180 degree rotation of
> clipped sprite plane differently. I have captured output with these
> rotate transforms moved before(clip-rotated) and after(rotate-clipped)
> clipping code.
> 
> Which is valid? Rotating entire sprite and then clipping or Rotating
> clipped portion?
> 
> Reference and Rotated output is attached FYI.
> 
> If rotating entire sprite is correct then this patch 11/11 is not needed
> and can be abandoned.

The way I think of these things is roughly this:

You have the user specified source rectangle, where the coordinates specify
the viewport into the framebuffer. This coordinate space is oriented the
same was as the framebuffer itself, ie. the first pixel of the
framebuffer is at coordinates 0,0. So plane rotation doesn't affect this
at all.

Then you have the user specified destination/crtc rectangle, where the
coordinates specify the position of the plane within the crtc coordinate
space. So the first visible pixel the pipe will push out is at
coordinates 0,0. So again plane rotation doesn't affect this.

Then you have the rotation which simply specifies the transformation to
be applied to the pixels when they "move" from the source rectangle to
the destination rectangle. So w/ 0 degree rotation the pixel at
src_x,src_y in the framebuffer will appear at position crtc_x,crtc_y
on the crtc output. With 180 degree rotation the pixel at src_x,src_y
will appear at crtc_x+crtc_w-1,crtc_y+crtc_h-1.

As clipping happens in the crtc coordinate space, we need to orient
the source coordindates the same way to get the correct clipping result.
So for example with 0 degrees rotation clipping the left side of the
destination rectangle must result in clipping the left side of the source
rectangle as well. And with 180 degree rotation clipping the destination
rectangle on the left side must result in clipping the source rectangle
on the right side. Left and right in each case referring to the original
unrotate coordinates.

So let's say we have the following situation w/ 180 degree rotation.
The letters inside the rects represented specific named pixels,
the FB rectangle represents the FB as specified by addfb2 ioctl,
the CRTC rectangle represents the pipe output (0,0 -> PIPESRC.w,h):

FB:                 CRTC:
0,0 ___________     0.0 __________
    |  abcd   |         |         |
    |  efgh   |         |         |
    |_________|         |hgfe     |
                        |dcba_____|
unclipped coordinates specified by user:
src_x=2,src_y=0     crtc_x=0,crtc_y=2
src_w=4.src_h=2     crtc_w=4,crtc_h=2

clipped coordinates:
src_x=2,src_y=0     crtc_x=0,crtc_y=2
src_w=4.src_h=2     crtc_w=4,crtc_h=2


Then the user moves the sprite one pixel to the left resulting on some
clipping (the X pixels). Note that the unclipped source coordinates do
not change here at all, in fact crtc_x is the only thing changed by the
user:

FB:                 CRTC:
0,0 ___________     0.0 __________
    |  abcX   |         |         |
    |  efgX   |         |         |
    |_________|         Xgfe      |
                        Xcba______|
unclipped coordinates specified by user:
src_x=2,src_y=0     crtc_x=-1,crtc_y=2
src_w=4.src_h=2     crtc_w= 4,crtc_h=2

clipped coordinates:
src_x=2,src_y=0     crtc_x=0,crtc_y=2
src_w=3.src_h=2     crtc_w=3,crtc_h=2

-- 
Ville Syrjälä
Intel OTC
