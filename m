Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbaGGN2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:28:45 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:64799 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbaGGN2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:28:43 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <53A7E93B.4060007@canonical.com>
References: <20140618102957.15728.43525.stgit@patser>
	<20140618103711.15728.97842.stgit@patser>
	<20140619011556.GE10921@kroah.com>
	<20140619063727.GL5821@phenom.ffwll.local>
	<20140619114825.GB28111@ulmo>
	<CAKMK7uE_B3pCZB9orh5+BJGooNfyEa0APrZqRpXqYu5xfQ0PCQ@mail.gmail.com>
	<20140620205252.GC28814@mithrandir>
	<53A7E93B.4060007@canonical.com>
Date: Mon, 7 Jul 2014 15:28:42 +0200
X-Google-Sender-Auth: _u4RYlBjukK2cEFOLHNZHjgy4p8
Message-ID: <CAKMK7uE78SP74JGViNpTia=PeV6OnHiePn+0_aG5CVoFWFW4Fg@mail.gmail.com>
Subject: Re: [REPOST PATCH 4/8] android: convert sync to fence api, v5
From: Daniel Vetter <daniel@ffwll.ch>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "open list:GENERIC INCLUDE/A..." <linux-arch@vger.kernel.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "Clark, Rob" <robdclark@gmail.com>, Colin Cross <ccross@google.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 10:45 AM, Maarten Lankhorst
<maarten.lankhorst@canonical.com> wrote:
> But in drivers/drm I can encounter a similar issue, people expect to be able to
> overwrite the contents of the currently displayed buffer, so I 'solved' it by not adding
> a fence on the buffer, only by waiting for buffer idle before page flipping.
> The rationale is that the buffer is pinned internally, and the backing storage cannot
> go away until dma_buf_unmap_attachment is called. So when you render to the
> current front buffer without queuing a page flip you get exactly what you expect. ;-)

Yeah, scanout buffers are special and imo we should only uses fences
as barriers just around the flip, but _not_ to prevent frontbuffer in
general. Userspace is after all allowed to do that (e.g. with the dumb
bo ioctls). If we'd premanently lock scanout buffers that would indeed
result in hilarity all over the place, no surprises there. And all
current drivers with dynamic memory management solve this through
pinning, but not by restricting write access at all.

So I think we can shrug this scenario off as a non-issue of the "don't
do this" kind ;-) Thierry, is there anything else you've stumbled over
in the tegra k1 enabling work?

I still get the impression that there's an awful lot of
misunderstandings between the explicit and implicit syncing camps and
that we need to do a lot more talking for a better understanding ...

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
