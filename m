Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210AbaCGHwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 02:52:24 -0500
Received: from smtprelay.restena.lu ([158.64.1.62]:47508 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaCGHwX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 02:52:23 -0500
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Mar 2014 02:52:22 EST
Date: Fri, 7 Mar 2014 08:44:20 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: dri-devel@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] drm: add kernel-log renderer
Message-ID: <20140307084420.20eda4b9@pluto>
In-Reply-To: <CANq1E4QZXjfJp7gdDS_2stC0UrzMVvdTj_C05PUmML6cF4v22A@mail.gmail.com>
References: <1394131242-29567-1-git-send-email-dh.herrmann@gmail.com>
	<20140306225631.0eb29cf3@neptune.home>
	<CANq1E4QZXjfJp7gdDS_2stC0UrzMVvdTj_C05PUmML6cF4v22A@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Fri, 7 Mar 2014 00:41:05 +0100 David Herrmann wrote:
> On Thu, Mar 6, 2014 at 10:56 PM, Bruno Prémont wrote:
> > On Thu, 06 March 2014 David Herrmann wrote:
> >> On modern linux user-space, the VT subsystem is no longer needed for
> >> system consoles. Although most DEs will fail if VTs are disabled, there
> >> are several gfx-systems that support this mode. Especially the lower
> >> system stack has been extended to work without VTs.
> >>
> >> However, there is one major drawback if VTs are disabled: You don't get
> >> oops/panic-screens nor early boot-debugging. The VT subsystem registers a
> >> console-driver, thus displays the kernel log and oops/panic screens in
> >> those situations. This patch introduces a fallback for CONFIG_VT=n.
> >>
> >> A new DRM-Log core is added. At its heart, DRM-Log maintains a log-buffer
> >> of kernel-log messages. It registers a console-driver and pushes new
> >> messages into this buffer whenever they appear. The size of the log-buffer
> >> can be changed via drm_log_ensure_size(). Initially, a suitable buffer is
> >> chosen, but whenever drivers register high-res CRTCs, they ought to
> >> increase that buffer to guarantee there's always enough data to render the
> >> whole screen.
> >> This log-buffer is managed at the character-level, not pixel-level. It is
> >> shared across all users, supports parallel, atomic readers and writers and
> >> supports seamless resizing.
> >
> > Does it make sense to express drm_log_ensure_size() with pixel arguments
> > and have the buffer below operated in characters? Shouldn't the pixel->char
> > calculation be done at a higher level? (see also below regarding high-DPI)
> 
> I don't want to expose "character" sizes. Any external API should be
> dealing with pixels and only pixels. There is no reason to let them
> deal with glyphs and text.. Regarding DPI, see below.
> 
> >> Additionally to the log-buffer handling, a generic software renderer is
> >> introduced. drm_log_draw() renders the current log-buffer into any
> >> memory-mapped framebuffer you want. Note that it supports splitting lines
> >> in case your framebuffer is smaller than the log-buffer, but also merging
> >> continuation lines in case your framebuffer is wider. This allows
> >> rendering an 80x25 log-buffer in full-width on high-res displays. On the
> >> other hand, 800x250 log-buffers can be rendered without information loss
> >> (apart from a shorter backlog) on low-res displays.
> >
> > Would it be possible to pass the dlog_font to drm_log_draw() so that
> > DRM driver or high-level code could choose a larger font on high-DPI
> > monitors (think retina-like)?
> >
> > Without that option kernel would need to be built specifically for a
> > given DPI range and not be able to provide readable debug output on
> > multiple CRTCs with (very) different DPIs.
> 
> First of all, I won't support any fancy high-DPI features, that's just
> wrong for debugging stuff. What I can do (and what we do in fallback
> consoles in user-space) is to add an "dpi" or "scale" argument to
> drm_log_draw() which does _integer_ scaling of glyphs. This allows you
> to render glyphs 2x or 3x .. as big as usual.

Integer scaling would do as well. Just some way to avoid tiny glyphs
on high-DPI monitors (so that it can be applied per-CRTC) is needed.

> I don't think it makes sense to modify drm_log_ensure_size(). I mean,
> the worst that can happen is that the *text*-backlog is twice as big
> as required. But if you have a high-dpi display, you already require
> like 10x as much space for each framebuffer than for the entire
> log-buffer. The log-buffer requires 1 byte per *char*. The frambuffer
> requires at least 8*16*4=512 bytes per char.

That's fair, especially as drm_log_ensure_size() is grow-only.

> Anyhow, integer-scaling should be fairly easy to get done.

I thought providing the font to drm_log_draw() and express
drm_log_ensure_size() in chars - or pass font to it as well - would be
easier than scaling.

Bruno

> Thanks
> David
