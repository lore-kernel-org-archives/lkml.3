Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbaBUA0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:26:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767AbaBTXwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:52:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mika Kuoppala <mika.kuoppala@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.12 33/82] drm/i915: Pair va_copy with va_end in i915_error_vprintf
Date: Thu, 20 Feb 2014 15:52:16 -0800
Message-Id: <20140220235020.464667467@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235019.483734207@linuxfoundation.org>
References: <20140220235019.483734207@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Kuoppala <mika.kuoppala@linux.intel.com>

commit 1d2cb9a54abc6e1d239f28f07661366d5662a94a upstream.

Each invocation of va_copy() must be matched by a corresponding
invocation of va_end() in the same function.

This regression has been introduced in

commit e29bb4ebbf000ff9ac081d29784a3331618f012e
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Fri Sep 20 10:20:59 2013 +0100

    drm/i915: Use a temporary va_list for two-pass string handling

Signed-off-by: Mika Kuoppala <mika.kuoppala@intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gpu_error.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_gpu_error.c
+++ b/drivers/gpu/drm/i915/i915_gpu_error.c
@@ -146,7 +146,10 @@ static void i915_error_vprintf(struct dr
 		va_list tmp;
 
 		va_copy(tmp, args);
-		if (!__i915_error_seek(e, vsnprintf(NULL, 0, f, tmp)))
+		len = vsnprintf(NULL, 0, f, tmp);
+		va_end(tmp);
+
+		if (!__i915_error_seek(e, len))
 			return;
 	}
 


