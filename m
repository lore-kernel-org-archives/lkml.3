Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaGKDFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 23:05:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbaGKDFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 23:05:18 -0400
Date: Thu, 10 Jul 2014 23:05:05 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: chris@chris-wilson.co.uk, daniel.vetter@ffwll.ch
Subject: i915: reduce noise from i915_gem_shrinker_oom when no memory freed.
Message-ID: <20140711030505.GA30830@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	chris@chris-wilson.co.uk, daniel.vetter@ffwll.ch
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the shrinker doesn't free any memory, don't spew over and over
into the logs.  My fuzz tester hits this quite easily, resulting
in dozens of instances of this printk when memory runs low, filling
dmesg, when there's not even any graphical stuff going on, so the
situation would never change.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index f36126383d26..9cbccdfedd74 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -5198,6 +5198,9 @@ i915_gem_shrinker_oom(struct notifier_block *nb, unsigned long event, void *ptr)
 	if (unlock)
 		mutex_unlock(&dev->struct_mutex);
 
+	if (freed == 0)
+		return NOTIFY_DONE;
+
 	pr_info("Purging GPU memory, %lu bytes freed, %lu bytes still pinned.\n",
 		freed, pinned);
 	if (unbound || bound)
