Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab3CAAnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:43:42 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:51856 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3CAAnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:43:39 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Erik Gilling <konkers@android.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org,
        Android Kernel Team <kernel-team@android.com>
Subject: [RFC][PATCH 00/30] staging: Android sync driver
Date: Thu, 28 Feb 2013 16:42:56 -0800
Message-Id: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As proposed yesterday, here's the Android sync driver patches for
staging.

I've preserved the commit history, but moved all the changes over
to be against the staging directory (instead of drivers/base).


The goal of submitting this driver to staging is to try to get
more collaberation, as there are some similar efforts going on
in the community with dmabuf-fences. My email from yesterday with
more details for how I hope this goes is here:
	http://comments.gmane.org/gmane.linux.kernel/1448420

Erik also provided a nice background on the patch set in his
reply yesterday, which I'll quote here:

"In Honeycomb where we introduced the Hardware Composer HAL.  This is a
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
drivers only need to implement a simple check function."


Anyway, let me know what you think of the patches, and hopefully
this is something that could be considered for staging for 3.10

thanks
-john



Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Erik Gilling <konkers@android.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Rob Clark <robclark@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
Cc: Android Kernel Team <kernel-team@android.com>


Erik Gilling (26):
  staging: sync: Add synchronization framework
  staging: sw_sync: Add cpu based sync driver
  staging: sync: Add timestamps to sync_pts
  staging: sync: Add debugfs support
  staging: sw_sync: Add debug support
  staging: sync: Add ioctl to get fence data
  staging: sw_sync: Add fill_driver_data support
  staging: sync: Add poll support
  staging: sync: Allow async waits to be canceled
  staging: sync: Export sync API symbols
  staging: sw_sync: Export sw_sync API
  staging: sync: Reorder sync_fence_release
  staging: sync: Optimize fence merges
  staging: sync: Add internal refcounting to fences
  staging: sync: Add reference counting to timelines
  staging: sync: Change wait timeout to mirror poll semantics
  staging: sync: Dump sync state to console on timeout
  staging: sync: Improve timeout dump messages
  staging: sync: Dump sync state on fence errors
  staging: sync: Protect unlocked access to fence status
  staging: sync: Update new fence status with sync_fence_signal_pt
  staging: sync: Use proper barriers when waiting indefinitely
  staging: sync: Refactor sync debug printing
  staging: sw_sync: Convert to use new value_str debug ops
  staging: sync: Add tracepoint support
  staging: sync: Don't log wait timeouts when timeout = 0

Jamie Gennis (1):
  staging: sync: Fix timeout = 0 wait behavior

Rebecca Schultz Zavin (2):
  staging: sync: Fix error paths
  staging: sw_sync: Fix error paths

Ørjan Eide (1):
  staging: sync: Fix race condition between merge and signal

 drivers/staging/android/Kconfig      |   27 +
 drivers/staging/android/Makefile     |    2 +
 drivers/staging/android/sw_sync.c    |  263 +++++++++
 drivers/staging/android/sw_sync.h    |   58 ++
 drivers/staging/android/sync.c       | 1016 ++++++++++++++++++++++++++++++++++
 drivers/staging/android/sync.h       |  426 ++++++++++++++
 drivers/staging/android/trace/sync.h |   82 +++
 7 files changed, 1874 insertions(+)
 create mode 100644 drivers/staging/android/sw_sync.c
 create mode 100644 drivers/staging/android/sw_sync.h
 create mode 100644 drivers/staging/android/sync.c
 create mode 100644 drivers/staging/android/sync.h
 create mode 100644 drivers/staging/android/trace/sync.h

-- 
1.7.10.4

