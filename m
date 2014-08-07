Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbaHGMrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 08:47:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34523 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471AbaHGMrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 08:47:24 -0400
Date: Thu, 7 Aug 2014 14:47:21 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Pavel Machek <pavel@ucw.cz>
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux-pm mailing list <linux-pm@lists.osdl.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: 3.15-rc: regression in suspend
In-Reply-To: <20140711192629.GA20015@amd.pavel.ucw.cz>
Message-ID: <alpine.LNX.2.00.1408071445250.6219@pobox.suse.cz>
References: <alpine.LNX.2.00.1405151727380.16459@pobox.suse.cz> <CAKMK7uFEjDGSpdB0xDPL09GZ8N7aFrNA530HbRLyfTPx5SkLQw@mail.gmail.com> <20140607120614.GB5309@amd.pavel.ucw.cz> <20140607231124.GA3611@amd.pavel.ucw.cz> <CAKMK7uEALofLiEA3m-QKjygC=YZNjaEtUMfbpbXinMoim1ygkw@mail.gmail.com>
 <20140609102328.GA25332@amd.pavel.ucw.cz> <alpine.LNX.2.00.1406091302560.20782@pobox.suse.cz> <20140625223522.GA5923@xo-6d-61-c0.localdomain> <alpine.LNX.2.00.1406271537000.21386@pobox.suse.cz> <20140707083908.GE5821@phenom.ffwll.local>
 <20140711192629.GA20015@amd.pavel.ucw.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014, Pavel Machek wrote:

> > > > Ok, so I have set up machines for ktest / autobisect, and found out that 
> > > > 3.16-rc1 no longer has that problem. Oh well, bisect would not be fun, 
> > > > anyway...
> > > 
> > > I am still seeing the problem with 3.16-rc2.
> > 
> > I'm confused now. Is the bisect result
> > 
> > commit 773875bfb6737982903c42d1ee88cf60af80089c
> > Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> > Date:   Mon Jan 27 10:00:30 2014 +0100
> > 
> >     drm/i915: Don't set the 8to6 dither flag when not scaling
> > 
> > now the culprit or not? Or do we have 2 different bugs at hand here?
> 
> Three different issues, it seems. Two ring initialization problems,
> one went away in 3.16 (for me), second did not (suspend for jikos),
> third -- trivial issue with 8to6 dither.

The patch below seems to finally cure the problem at my system; I've just 
attached it to freedesktop bugzilla, but sending it to this thread as well 
to hopefully get as much testing coverage by affected people as possible.

I am going on with testing whether it really completely fixes the problem 
or just made it less likely.





From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] drm/i915: read HEAD register back in init_ring_common() to enforce ordering

Withtout this, ring initialization fails reliabily during resume with

	[drm:init_ring_common] *ERROR* render ring initialization failed ctl 0001f001 head ffffff8804 tail 00000000 start 000e4000

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/gpu/drm/i915/intel_ringbuffer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 279488a..7add7ee 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -517,6 +517,9 @@ static int init_ring_common(struct intel_engine_cs *ring)
 	else
 		ring_setup_phys_status_page(ring);
 
+	/* Enforce ordering by reading HEAD register back */
+	I915_READ_HEAD(ring);
+
 	/* Initialize the ring. This must happen _after_ we've cleared the ring
 	 * registers with the above sequence (the readback of the HEAD registers
 	 * also enforces ordering), otherwise the hw might lose the new ring

-- 
Jiri Kosina
SUSE Labs
