Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901AbaEEO3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:29:39 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:60575 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713AbaEEO3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:29:38 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <s5htx94fkfi.wl%tiwai@suse.de>
References: <s5htx94fkfi.wl%tiwai@suse.de>
Date: Mon, 5 May 2014 16:29:37 +0200
X-Google-Sender-Auth: Uy_j8ts5Y2h-Px88vcKzk392k04
Message-ID: <CAKMK7uHcYvuViEeyxLc75+kMVPPaKMr8svJQysk124--cjGL+g@mail.gmail.com>
Subject: Re: Atomicity in KMS panic notifier
From: Daniel Vetter <daniel@ffwll.ch>
To: Takashi Iwai <tiwai@suse.de>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Herrmann <dh.herrmann@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2014 at 3:02 PM, Takashi Iwai <tiwai@suse.de> wrote:
> Hi,
>
> while debugging a few reported bugs, I noticed that
> drm_fb_helper_force_kernel_mode() that is called in the KMS panic
> notifier isn't really atomic-safe.  It invokes crtc's set_config(),
> and all implementations seem to involve with page allocations (kmalloc
> with GFP_KERNEL, via some ttm ops, etc).  I've actually seen the Oops
> with cirrus KMS during panic due to this.
>
> Does anyone have an idea to fix this?  I thought of re-using
> drm_fb_helper_debug_enter(), but this won't work with many drivers
> that don't have crtc->mode_set_base_atomic(), either (yeah, this is
> another bug).

David Herrmann has a long-term plan to address this, using a much more
minimal panic console (so that we can avoid all the fbcon madness) and
adding a new driver callback to deliver a pointer to whatever
framebuffers are currently displayed. If it's possible to obtain such
a pointer in atomic contexts. Then we'd rip out all the existing panic
notifier and handler stuff in fbcon. We'd also need to disable the
panic notifier fbcon registers itself (since that ends up calling down
into our ->set_par which again ends up in ->set_config).

That should leave us with some very minimal panic code to audit.

Imo trying to fix the current mess and making ->set_config work in
atomic contexts is pointless. drm_can_sleep is trying to make that
possible in some ways, and it's horrible since using it means
busy-loops in atomic contexts outside of panic handlers won't get
reported any more. Also the interactions with the console_lock (which
due to some bonghits is protecting almost everything in fbcon/fbdev
nowadays) would also be almost completely removed.

Unfortunately doing all this is a lot of work.
-Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
