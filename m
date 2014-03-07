Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbaCGXM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 18:12:27 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:49555 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaCGXMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 18:12:24 -0500
MIME-Version: 1.0
In-Reply-To: <20140307215808.3755f855@alan.etchedpixels.co.uk>
References: <1394131242-29567-1-git-send-email-dh.herrmann@gmail.com>
	<20140307215808.3755f855@alan.etchedpixels.co.uk>
Date: Sat, 8 Mar 2014 00:12:24 +0100
Message-ID: <CANq1E4Q07SYZVEZ4Xfbc=wwTO2aNqahLU4Bo-0Awj7TUKwESYw@mail.gmail.com>
Subject: Re: [RFC] drm: add kernel-log renderer
From: David Herrmann <dh.herrmann@gmail.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Mar 7, 2014 at 10:58 PM, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
>>  - The renderer supports *any* RGB target, from 8bit to 32bit with
>>    big-endian and little-endian support. The related pixel-renderer will
>>    probably never win a beauty-contest, but it works.. Again, who cares
>>    for debug-log rendering speed?
>
> Debug log writing performance is extremely important when you are using
> the log for debugging work rather than for panic display. I don't think
> that is a show stopper because having a logger makes sense and someone
> can write a better render engine if they care.

I don't do damage-based rendering (useless if you don't do
hw-scrolling), therefore you can easily configure the higher-level API
to render in a 50ms (or even 500ms) interval if anything changed. This
should be suitable for other use-cases and avoids hogging the CPU like
VTs do. Furthermore, you can just avoid rendering until something
useful happened that you *want* to see. Last but not least, when
something goes wrong, the panic-handler will always print the latest
log, so that should contain all useful information.
Anyhow, I need specific use-cases to comment on that.

> Supporting any target is also going to be useful but you do need to
> support non linear framebuffers. A GMA500 with something like an X
> display in use for example does not have a linear mapping of the
> framebuffer memory. I don't believe its exactly unique in this.

Should be fairly easy to do. But as long as you can atomically flip to
a linear FB, that's not needed as you can use a separate FB for the
render-log (which is also what we currently do for fbdev-fallbacks).
But imho most drivers allow you to easily map it linearly via the GTT,
so I haven't bothered supported tiled setups. If drivers need that,
they can tell me what formats exactly to support and I can add that.

> What I am more dubious about is tying it to DRM. Yes it uses DRM
> constants but it doesn't appear functionally to have a single tie to
> either DRM or even framebuffer.
>
> It's potentially useful in cases where neither framebuffer or DRM are
> compiled into the system.

Using the four-cc constants makes sense, imho. Apart from that,
drm_log.c will stay generic as it is now. There is nothing
DRM-specific in there. All the higher-level helpers are separate in
drm_log_helpers.c (which is not posted here). However, I've spent
enough time trying to get the attention of core maintainers for simple
fixes, I really don't want to waste my time pinging on feature-patches
every 5 days to get any attention. If someone outside of DRM wants to
use it, I'd be happy to discuss any code-sharing. Until then, I'd like
to keep it here as people are willing to take it through their tree.

Cheers
David
