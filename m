Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133AbaFSQMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:12:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40171 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757405AbaFSQMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:12:38 -0400
Message-ID: <53A30BF0.1060109@canonical.com>
Date: Thu, 19 Jun 2014 18:12:32 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Colin Cross <ccross@google.com>, Greg KH <gregkh@linuxfoundation.org>,
        "open list:GENERIC INCLUDE/A..." <linux-arch@vger.kernel.org>,
        thellstrom@vmware.com, lkml <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Rob Clark <robdclark@gmail.com>, thierry.reding@gmail.com,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "open list:DMA BUFFER SHARIN..." <linux-media@vger.kernel.org>
CC: daniel@ffwll.ch
Subject: Re: [REPOST PATCH 4/8] android: convert sync to fence api, v5
References: <20140618102957.15728.43525.stgit@patser>	<20140618103711.15728.97842.stgit@patser>	<20140619011556.GE10921@kroah.com>	<20140619063727.GL5821@phenom.ffwll.local> <CAMbhsRRZOHuDkW9GzWbBCQiBjdUFv7MtkB_qhx+pofT+38gugQ@mail.gmail.com>
In-Reply-To: <CAMbhsRRZOHuDkW9GzWbBCQiBjdUFv7MtkB_qhx+pofT+38gugQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 19-06-14 17:22, Colin Cross schreef:
> On Wed, Jun 18, 2014 at 11:37 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
>> On Wed, Jun 18, 2014 at 06:15:56PM -0700, Greg KH wrote:
>>> On Wed, Jun 18, 2014 at 12:37:11PM +0200, Maarten Lankhorst wrote:
>>>> Just to show it's easy.
>>>>
>>>> Android syncpoints can be mapped to a timeline. This removes the need
>>>> to maintain a separate api for synchronization. I've left the android
>>>> trace events in place, but the core fence events should already be
>>>> sufficient for debugging.
>>>>
>>>> v2:
>>>> - Call fence_remove_callback in sync_fence_free if not all fences have fired.
>>>> v3:
>>>> - Merge Colin Cross' bugfixes, and the android fence merge optimization.
>>>> v4:
>>>> - Merge with the upstream fixes.
>>>> v5:
>>>> - Fix small style issues pointed out by Thomas Hellstrom.
>>>>
>>>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>>>> Acked-by: John Stultz <john.stultz@linaro.org>
>>>> ---
>>>>  drivers/staging/android/Kconfig      |    1
>>>>  drivers/staging/android/Makefile     |    2
>>>>  drivers/staging/android/sw_sync.c    |    6
>>>>  drivers/staging/android/sync.c       |  913 +++++++++++-----------------------
>>>>  drivers/staging/android/sync.h       |   79 ++-
>>>>  drivers/staging/android/sync_debug.c |  247 +++++++++
>>>>  drivers/staging/android/trace/sync.h |   12
>>>>  7 files changed, 609 insertions(+), 651 deletions(-)
>>>>  create mode 100644 drivers/staging/android/sync_debug.c
>>> With these changes, can we pull the android sync logic out of
>>> drivers/staging/ now?
>> Afaik the google guys never really looked at this and acked it. So I'm not
>> sure whether they'll follow along. The other issue I have as the
>> maintainer of gfx driver is that I don't want to implement support for two
>> different sync object primitives (once for dma-buf and once for android
>> syncpts), and my impression thus far has been that even with this we're
>> not there.
> We have tested these patches to use dma fences to back the android
> sync driver and not found any major issues.  However, my understanding
> is that dma fences are designed for implicit sync, and explicit sync
> through the android sync driver is bolted on the side to share code.
> Android is not moving away from explicit sync, but we do wrap all of
> our userspace sync accesses through libsync
> (https://android.googlesource.com/platform/system/core/+/master/libsync/sync.c,
> ignore the sw_sync parts), so if the kernel supported a slightly
> different userspace explicit sync interface we could adapt to it
> fairly easily.  All we require is that individual kernel drivers need
> to be able to accept work alongisde an fd to wait on, and to return an
> fd that will signal when the work is done, and that userspace has some
> way to merge two of those fds, wait on an fd, and get some debugging
> info from an fd.  However, this patch set doesn't do that, it has no
> way to export a dma fence as an fd except through the android sync
> driver, so it is not yet ready to fully replace android sync.
>
Dma fences can be exported as android fences, just didn't see a need for it yet. :-)
To wait on all implicit fences attached to a dma-buf one could simply poll the dma-buf directly,
or use something like a android userspace fence.

sync_fence_create takes a sync_pt as function argument, but I kept that to keep source code
compatibility, not because it uses any sync_pt functions. Here's a patch to create a userspace
fd for dma-fence instead of a android fence, applied on top of "android: convert sync to fence api".

diff --git a/drivers/staging/android/sw_sync.c b/drivers/staging/android/sw_sync.c
index a76db3ff87cb..afc3c63b0438 100644
--- a/drivers/staging/android/sw_sync.c
+++ b/drivers/staging/android/sw_sync.c
@@ -184,7 +184,7 @@ static long sw_sync_ioctl_create_fence(struct sw_sync_timeline *obj,
 	}
 
 	data.name[sizeof(data.name) - 1] = '\0';
-	fence = sync_fence_create(data.name, pt);
+	fence = sync_fence_create(data.name, &pt->base);
 	if (fence == NULL) {
 		sync_pt_free(pt);
 		err = -ENOMEM;
diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index 70b09b5001ba..c89a6f954e41 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -188,7 +188,7 @@ static void fence_check_cb_func(struct fence *f, struct fence_cb *cb)
 }
 
 /* TODO: implement a create which takes more that one sync_pt */
-struct sync_fence *sync_fence_create(const char *name, struct sync_pt *pt)
+struct sync_fence *sync_fence_create(const char *name, struct fence *pt)
 {
 	struct sync_fence *fence;
 
@@ -199,10 +199,10 @@ struct sync_fence *sync_fence_create(const char *name, struct sync_pt *pt)
 	fence->num_fences = 1;
 	atomic_set(&fence->status, 1);
 
-	fence_get(&pt->base);
-	fence->cbs[0].sync_pt = &pt->base;
+	fence_get(pt);
+	fence->cbs[0].sync_pt = pt;
 	fence->cbs[0].fence = fence;
-	if (fence_add_callback(&pt->base, &fence->cbs[0].cb,
+	if (fence_add_callback(pt, &fence->cbs[0].cb,
 			       fence_check_cb_func))
 		atomic_dec(&fence->status);
 
diff --git a/drivers/staging/android/sync.h b/drivers/staging/android/sync.h
index 66b0f431f63e..3020751f3c5d 100644
--- a/drivers/staging/android/sync.h
+++ b/drivers/staging/android/sync.h
@@ -252,7 +252,7 @@ void sync_pt_free(struct sync_pt *pt);
  * Creates a fence containg @pt.  Once this is called, the fence takes
  * ownership of @pt.
  */
-struct sync_fence *sync_fence_create(const char *name, struct sync_pt *pt);
+struct sync_fence *sync_fence_create(const char *name, struct fence *fence);
 
 /*
  * API for sync_fence consumers

