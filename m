Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab3B1DET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 22:04:19 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:39234 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab3B1DEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 22:04:15 -0500
MIME-Version: 1.0
In-Reply-To: <512EBD80.8070101@linaro.org>
References: <512EBD80.8070101@linaro.org>
From: Erik Gilling <konkers@android.com>
Date: Wed, 27 Feb 2013 19:03:55 -0800
X-Google-Sender-Auth: F93f2KErGlwfqtEPwopV--O2T4M
Message-ID: <CACSP8Sh85qhiUgBTVdbj2gdVRPkcM6Wtusp+9tkbXG9Aq0y1aQ@mail.gmail.com>
Subject: Re: [RFD] Proposal for merging Android sync driver in staging
To: John Stultz <john.stultz@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>, linaro-mm-sig@lists.linaro.org,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 6:14 PM, John Stultz <john.stultz@linaro.org> wrote:
> Also note: I've done this so far without any feedback from the Android devs
> (despite my reaching out to Erik a few times recently), so if they object to
> pushing it to staging, in deference to it being their code I'll back off,
> even though I do think it would be good to have the code get more visibility
> upstream in staging. I don't mean to step on anyone's toes. :)

Yeah, sorry about that.  I kept meaning to get back to you but kept
getting distracted.  A little background on the patches:

In Honeycomb where we introduced the Hardware Composer HAL.  This is a
userspace layer that allows composition acceleration on a per platform
basis.  Different SoC vendors have implemented this using overlays, 2d
blitters, a combinations of both, or other clever/disgusting means.
Along with the HWC we consolidated a lot of our camera and media
pipeline to allow their input to be fed into the GPU or
display(overlay.)  In order to exploit parallelism the the graphics
pipeline, this introduced lots of implicit synchronization
dependancies.  After a couple years of working with many different SoC
vendors, we found that it was really difficult to communicate our
system's expectations of the implicit contract and it was difficult
for the SoC vendors to properly implement the implicit contract in
each of their IP blocks (display, gpu, camera, video codecs).  It was
also incredibly difficult to debug when problems/deadlocks arose.

In an effort to clean up the situation we decided to create set of
simple synchronization primitives and have our compositor
(SurfaceFlinger) manage the synchronization contract explicitly.  We
designed these primitives so that they can be passed across processes
(much like ion/dma_buf handles), can be backed by hardware
synchronization primitives, and can be combined with other sync
dependancies in a heterogeneous manner.  We also added enough
debugging information to make pinpointing a synchronization deadlock
bug easier.  There are also OpenGL extensions added (which I believe
have been ratified by Khronos) to convert a "native" sync object to a
gl fence object and vise versa.

So far shipped this system on two products (the Nexus 10 and 4) with
two different SoCs (Samsung Exynos5250 and Qualcomm MSM8064.)  These
two projects were much easier to work out the kinks in the
graphics/compositing pipelines.  In addition we were able to use the
telemetry and tracing features to track down the causes of dropped
frames aka "jank."

As for the implementation, I started with having the main driver op
primitive be a wait() op.  I quickly noticed that most of the tricky
race condition prone code was ending up in the drivers wait() op.  It
also made handling asynchronous waits of more than one type of sync_pt
difficult to manage.  In the end I opted for something roughly like
poll() where all the heavy lifting is done at the high level and the
drivers only need to implement a simple check function.

Happy to hear feedback and (especially) bug reports/fixes.

Cheers,
    Erik
