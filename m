Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbaGHI7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:59:19 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:55129 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751842AbaGHI7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:59:15 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Date: Tue, 8 Jul 2014 09:59:01 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Thomas Meyer <thomas@m3y3r.de>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Intel-gfx] Linux 3.16-rc2
Message-ID: <20140708085901.GI26405@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Jiri Kosina <jkosina@suse.cz>, Thomas Meyer <thomas@m3y3r.de>,
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Pavel Machek <pavel@ucw.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <871tuea7nz.fsf@intel.com>
 <20140624115753.GD17674@nuc-i3427.alporthouse.com>
 <1403612670.3091.10.camel@localhost.localdomain>
 <20140624122737.GF17674@nuc-i3427.alporthouse.com>
 <20140630100220.GA4934@xo-6d-61-c0.localdomain>
 <20140630100925.GA18836@nuc-i3427.alporthouse.com>
 <1404317921.3910.3.camel@localhost.localdomain>
 <20140707151613.GG5821@phenom.ffwll.local>
 <20140707160402.GA26405@nuc-i3427.alporthouse.com>
 <alpine.LNX.2.00.1407080013030.1655@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1407080013030.1655@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 12:15:31AM +0200, Jiri Kosina wrote:
> On Mon, 7 Jul 2014, Chris Wilson wrote:
> 
> > > > this patch on top of v3.16-rc3-62-gd92a333 makes the resume from ram
> > > > regression go away on my machine:
> > > 
> > > Hm, we could conditionalize this hack on IS_G4X ... Chris, thoughts?
> > 
> > As different machines favour different w/a, I think the issue is mostly
> > timing related. It could be sequence of register writes, but we tried
> > different orders early on. The next experiment I guess would be to
> > insert small delays between each write to see if that helps. Or to write
> > each register twice.
> 
> I actually tried to introduce rather large delays between individual 
> I915_WRITE() calls in the ring initialization sequence a couple weeks ago 
> already, but it resulted in complete machine lockup (which is worse than 
> my usual symptoms) during resume. Therefore I probably lack the knowledge 
> of internal workings of the HW that would allow me to guess what the 
> reasonable timeout value should be.
> 
> Willing to test any patches.

Are you using the extra patches on bug 76554? If not, try

diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index e18ed05dc0d5..48326f9628d4 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -526,6 +526,9 @@ static int init_ring_common(struct intel_engine_cs *ring)
                        ((ringbuf->size - PAGE_SIZE) & RING_NR_PAGES)
                        | RING_VALID);
 
+       I915_WRITE_HEAD(ring, 0);
+       (void)I915_READ_HEAD(ring);
+
        /* If the head is still not zero, the ring is dead */
        if (wait_for((I915_READ_CTL(ring) & RING_VALID) != 0 &&
                     I915_READ_START(ring) == i915_gem_obj_ggtt_offset(obj) &&

-- 
Chris Wilson, Intel Open Source Technology Centre
