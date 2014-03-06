Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbaCFV4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:56:37 -0500
Received: from hygieia.santi-shop.eu ([78.46.175.2]:38508 "EHLO
	hygieia.santi-shop.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbaCFV4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:56:35 -0500
Date: Thu, 6 Mar 2014 22:56:31 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: dri-devel@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] drm: add kernel-log renderer
Message-ID: <20140306225631.0eb29cf3@neptune.home>
In-Reply-To: <1394131242-29567-1-git-send-email-dh.herrmann@gmail.com>
References: <1394131242-29567-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.22; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Thu, 06 March 2014 David Herrmann <dh.herrmann@gmail.com> wrote:
> On modern linux user-space, the VT subsystem is no longer needed for
> system consoles. Although most DEs will fail if VTs are disabled, there
> are several gfx-systems that support this mode. Especially the lower
> system stack has been extended to work without VTs.
> 
> However, there is one major drawback if VTs are disabled: You don't get
> oops/panic-screens nor early boot-debugging. The VT subsystem registers a
> console-driver, thus displays the kernel log and oops/panic screens in
> those situations. This patch introduces a fallback for CONFIG_VT=n.
> 
> A new DRM-Log core is added. At its heart, DRM-Log maintains a log-buffer
> of kernel-log messages. It registers a console-driver and pushes new
> messages into this buffer whenever they appear. The size of the log-buffer
> can be changed via drm_log_ensure_size(). Initially, a suitable buffer is
> chosen, but whenever drivers register high-res CRTCs, they ought to
> increase that buffer to guarantee there's always enough data to render the
> whole screen.
> This log-buffer is managed at the character-level, not pixel-level. It is
> shared across all users, supports parallel, atomic readers and writers and
> supports seamless resizing.

Does it make sense to express drm_log_ensure_size() with pixel arguments
and have the buffer below operated in characters? Shouldn't the pixel->char
calculation be done at a higher level? (see also below regarding high-DPI)

> Additionally to the log-buffer handling, a generic software renderer is
> introduced. drm_log_draw() renders the current log-buffer into any
> memory-mapped framebuffer you want. Note that it supports splitting lines
> in case your framebuffer is smaller than the log-buffer, but also merging
> continuation lines in case your framebuffer is wider. This allows
> rendering an 80x25 log-buffer in full-width on high-res displays. On the
> other hand, 800x250 log-buffers can be rendered without information loss
> (apart from a shorter backlog) on low-res displays.

Would it be possible to pass the dlog_font to drm_log_draw() so that
DRM driver or high-level code could choose a larger font on high-DPI
monitors (think retina-like)?

Without that option kernel would need to be built specifically for a
given DPI range and not be able to provide readable debug output on
multiple CRTCs with (very) different DPIs.

Bruno


> No high-level API is introduced, yet. So for now drivers need to decide
> when and where to render on their own. A generic interface with
> panic-handlers, scheduled redrawing and automatic modesetting will be
> added in follow-ups.
> 
> A few more notes:
>  - This is for *debugging*, and for debugging only! You can use this
>    renderer to get a kernel-log onto your framebuffers. However, the
>    renderer is horribly slow! There is no intention to speed it up. No-one
>    cares whether it takes 500ms to render your panic-screen!
>  - If you enable the log-renderer for a continous boot-log, you're
>    supposed to redraw on vblanks. The renderer does not support
>    damage-tracking as each new-line causes a scroll-up, anyway.
>  - The renderer works bottom-up and right-to-left. This is required to
>    avoid pre-calculating log sizes.
>  - The renderer supports multiple columns. This is quite handy on high-res
>    screens where you can get bigger backlogs this way. Usually 80% of the
>    screen are black. Now you can reuse this for the next log-column.
>  - I have some wrappers to use this in user-space. I did several tests
>    with resizing and different buffer-sizes and valgrind didn't complain.
>    Results looked all fine.
>  - The renderer supports *any* RGB target, from 8bit to 32bit with
>    big-endian and little-endian support. The related pixel-renderer will
>    probably never win a beauty-contest, but it works.. Again, who cares
>    for debug-log rendering speed?
>  - If you want a normal boot-log, use a user-space log-renderer (like
>    experimential systemd-er (no merged, yet)). They can render with proper
>    speed, can do hw-scrolling and more.
>    Or: Enable VTs! Seriously, if you want all the VT features, use VTs! I
>    will not tell you to disable them.
> 
> On a last note:
>   With this (and the high-level integration) in place, you can easily
>   disable CONFIG_FB, CONFIG_VT and CONFIG_FRAMEBUFFER_CONSOLE. Combined
>   with a proper user-space system-console, you will end up with more
>   features, less bugs and definitely some happy kernel maintainers.
