Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760323Ab3B0A7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:59:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760265Ab3BZX54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ben Widawsky <ben@bwidawsk.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 084/150] drm/i915: Fix RC6VIDS encode/decode
Date: Tue, 26 Feb 2013 15:55:41 -0800
Message-Id: <20130226235532.842977158@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Widawsky <ben@bwidawsk.net>

commit 7083e05072b88d503d257b6f012ce56367f3ac97 upstream.

The RC6 VIDS has a linear ramp starting at 250mv, which means any values
below 250 are invalid. The old buggy macros tried to adjust for this to
be more flexible, but there is no need. As Dan pointed out the ENCODE
only ever has one value. The only invalid value for decode is an input
of 0 which means something is really wonky, and the cases where DECODE
are used either don't matter (debug values), or would be implicitly
correct (the check for less than 450).

This patch makes simpler, easier to read macros which are actually
correct. Maybe this patch can actually fix some bugs now.

Thanks to Dan for catching this. /me hides

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ben Widawsky <ben@bwidawsk.net>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_reg.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -4282,8 +4282,8 @@
 #define   GEN6_PCODE_READ_MIN_FREQ_TABLE	0x9
 #define	  GEN6_PCODE_WRITE_RC6VIDS		0x4
 #define	  GEN6_PCODE_READ_RC6VIDS		0x5
-#define   GEN6_ENCODE_RC6_VID(mv)		(((mv) / 5) - 245) < 0 ?: 0
-#define   GEN6_DECODE_RC6_VID(vids)		(((vids) * 5) > 0 ? ((vids) * 5) + 245 : 0)
+#define   GEN6_ENCODE_RC6_VID(mv)		(((mv) - 245) / 5)
+#define   GEN6_DECODE_RC6_VID(vids)		(((vids) * 5) + 245)
 #define GEN6_PCODE_DATA				0x138128
 #define   GEN6_PCODE_FREQ_IA_RATIO_SHIFT	8
 


