Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730AbbASUnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 15:43:55 -0500
Received: from mail.fireflyinternet.com ([87.106.93.118]:60682 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751317AbbASUny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 15:43:54 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Date: Mon, 19 Jan 2015 20:43:34 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Matt Roper <matthew.d.roper@intel.com>
Cc: Daniel Vetter <daniel.vetter@intel.com>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        Jeremiah Mahler <jmmahler@gmail.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        Ander Conselvan de Oliveira <conselvan2@gmail.com>,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [BUG, bisect] drm/i915: mouse pointer lags and
 overshoots
Message-ID: <20150119204334.GI26577@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Matt Roper <matthew.d.roper@intel.com>,
	Daniel Vetter <daniel.vetter@intel.com>,
	Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
	Jeremiah Mahler <jmmahler@gmail.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	David Airlie <airlied@linux.ie>,
	Alex Deucher <alexander.deucher@amd.com>,
	Dave Airlie <airlied@redhat.com>,
	Ander Conselvan de Oliveira <conselvan2@gmail.com>,
	linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org
References: <20150117100635.GA1281@hudson.localdomain>
 <20150119090847.GQ10649@intel.com>
 <54BCE1BF.5050808@intel.com>
 <20150119110404.GA26577@nuc-i3427.alporthouse.com>
 <20150119164024.GI22549@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150119164024.GI22549@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 08:40:24AM -0800, Matt Roper wrote:
> On Mon, Jan 19, 2015 at 11:04:04AM +0000, Chris Wilson wrote:
> > On Mon, Jan 19, 2015 at 11:51:43AM +0100, Daniel Vetter wrote:
> > > There's also an issue in (most) X drivers which exaberates this
> > > issues: When changing the cursor buffer the X cursor code does a a)
> > > disable cursor b) update cursor image c) enable cursor cycle.
> > 
> > Notably not -intel on which the bug has been observed. And more
> > importantly, the slow downs don't seem to correlate with cursor change,
> > just cursor movement.
> > -Chris
> > 
> > -- 
> > Chris Wilson, Intel Open Source Technology Centre
> 
> It seems that the simple fix for this case (movement only) is to just
> skip the prepare_fb/cleanup_fb calls (and the associated vblank wait) in
> the transitional plane helper when newfb == oldfb.  I just posted a
> small patch that makes that change (and solves the cursor lag for me).
> 
> This won't solve the case if userspace uses a different framebuffer for
> each update (while trying to update faster than the refresh rate).  Is
> there any existing userspace that behaves this way that we can test
> with?

-modesetting and say moving the cursor in/out of an xterm very fast. or
similarly with

diff --git a/src/sna/sna_display.c b/src/sna/sna_display.c
index 5b45618..3873893 100644
--- a/src/sna/sna_display.c
+++ b/src/sna/sna_display.c
@@ -5182,7 +5182,6 @@ sna_cursors_init(ScreenPtr screen, struct sna *sna)
        cursor_info->MaxWidth = sna->cursor.max_size;
        cursor_info->MaxHeight = sna->cursor.max_size;
        cursor_info->Flags = (HARDWARE_CURSOR_TRUECOLOR_AT_8BPP |
-                             HARDWARE_CURSOR_UPDATE_UNHIDDEN |
                              HARDWARE_CURSOR_ARGB);
 
        cursor_info->RealizeCursor = sna_realize_cursor;


-- 
Chris Wilson, Intel Open Source Technology Centre
