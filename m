Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab3CRVPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:15:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab3CRVKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:10:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mika Kuoppala <mika.kuoppala@intel.com>,
        Dmitry Rogozhkin <dmitry.v.rogozhkin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 27/40] drm/i915: EBUSY status handling added to i915_gem_fault().
Date: Mon, 18 Mar 2013 14:11:05 -0700
Message-Id: <20130318211018.197259507@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318211016.254453918@linuxfoundation.org>
References: <20130318211016.254453918@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Rogozhkin <dmitry.v.rogozhkin@intel.com>

commit e79e0fe380847493266fba557217e2773c61bd1b upstream.

Subsequent threads returning EBUSY from vm_insert_pfn() was not handled
correctly. As a result concurrent access from new threads to
mmapped data caused SIGBUS.

Note that this fixes i-g-t/tests/gem_threaded_tiled_access.

Tested-by: Mika Kuoppala <mika.kuoppala@intel.com>
Signed-off-by: Dmitry Rogozhkin <dmitry.v.rogozhkin@intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1256,6 +1256,11 @@ out:
 	case 0:
 	case -ERESTARTSYS:
 	case -EINTR:
+	case -EBUSY:
+		/*
+		 * EBUSY is ok: this just means that another thread
+		 * already did the job.
+		 */
 		return VM_FAULT_NOPAGE;
 	case -ENOMEM:
 		return VM_FAULT_OOM;


