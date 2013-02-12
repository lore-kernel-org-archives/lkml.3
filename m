Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab3BLVzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:55:42 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:46116 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab3BLVzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 16:55:41 -0500
Message-ID: <511ABA59.9050604@suse.cz>
Date: Tue, 12 Feb 2013 22:55:37 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>
Subject: compositing broken in -next (idr bug)
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this commit in -next causes my KDE to get stuck while starting. I see
only the splash screen. If I disable effects by alt-shift-f12, it continues.

I bisected it to this commit:
commit 430440fce7da4ad52c2af06a04a5132e5d19faaf
Author: Tejun Heo <tj@kernel.org>
Date:   Thu Feb 7 12:31:37 2013 +1100

    drm: convert to idr_alloc()


More concretely to the change in drm_gem_flink_ioctl. If I revert solely
that one, it works again. Maybe I'm blind, but I do not see why...

Well I see a bug in there, but that is not the root cause -- there is a
missing call to idr_preload_end. Of course, that one only leaves
preemption disabled forever.

What I tried with no effect is this:
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -453,7 +453,8 @@ drm_gem_flink_ioctl(struct drm_device *dev, void *data,
        spin_lock(&dev->object_name_lock);
        if (!obj->name) {
                ret = idr_alloc(&dev->object_name_idr, obj, 1, 0,
GFP_NOWAIT);
-               obj->name = ret;
+               if (ret >= 0)
+                       obj->name = ret;
                args->name = (uint64_t) obj->name;
                spin_unlock(&dev->object_name_lock);

@@ -469,6 +470,7 @@ drm_gem_flink_ioctl(struct drm_device *dev, void *data,
        }

 err:
+       idr_preload_end();
        drm_gem_object_unreference_unlocked(obj);
        return ret;
 }

thanks,
-- 
js
suse labs
