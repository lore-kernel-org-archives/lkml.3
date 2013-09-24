Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab3IXIUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:20:54 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:34883 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab3IXIUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:20:51 -0400
Date: Tue, 24 Sep 2013 10:20:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ben Skeggs <bskeggs@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [RFC PATCH] drm/nouveau: fix nested locking in mmap handler
Message-ID: <20130924082047.GB3715@gmail.com>
References: <52323734.4070908@canonical.com>
 <5232B44C.9010408@vmware.com>
 <5232BBE1.5030509@canonical.com>
 <5232C2BB.9070303@vmware.com>
 <20130913082933.GH31370@twins.programming.kicks-ass.net>
 <CAKMK7uHh_pKh1JpQ_nA7gvWMUsvQoTKAcBXpdcwpVGSddHE9mQ@mail.gmail.com>
 <20130913090000.GJ31370@twins.programming.kicks-ass.net>
 <52405F3E.4000609@canonical.com>
 <52413DA9.4050000@vmware.com>
 <5241409B.6010102@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5241409B.6010102@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maarten Lankhorst <maarten.lankhorst@canonical.com> wrote:

> > I think the Nouveau guys need to comment further on this, but 
> > returning -EFAULT might break existing user-space, and that's not 
> > allowed, but IIRC the return value of "presumed" is only a hint, and 
> > if it's incorrect will only trigger future command stream patching.
> >
> > Otherwise reviewing mostly the TTM stuff. FWIW, from wat I can tell 
> > the vmwgfx driver doesn't need any fixups.
>
> Well because we read the list of buffer objects the presumed offsets are 
> at least read-mapped. Although I guess in the worst case the mapping 
> might disappear before the syscall copies back the data. So if -EFAULT 
> happens here then userspace messed up in some way, either by forgetting 
> to map the offsets read-write, which cannot happen with libdrm or 
> free'ing the bo list before the syscall returns, which would probably 
> result in libdrm crashing shortly afterwards anyway.
> 
> So I don't know whether to swallow that -EFAULT or not, which is what I 
> asked.

In such a case returning -EFAULT is very strongly preferred.

If there's a user-space bug, such as a context life time race between 
graphics context creation/destruction and user threads making use of the 
graphics context, then getting the -EFAULT would be very helpful to 
user-space debugging as well.

Thanks,

	Ingo
