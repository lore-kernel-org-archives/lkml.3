Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab3ASBSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:18:09 -0500
Received: from mail.kernel.org ([198.145.19.201]:56393 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756114Ab3ASBR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:17:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Shuah Khan <shuah.khan@hp.com>, CAI Qian <caiqian@redhat.com>
Subject: [ 17/33] drm/radeon: fix a bogus kfree
Date: Fri, 18 Jan 2013 17:16:42 -0800
Message-Id: <20130119010351.903163884@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119010345.885772698@linuxfoundation.org>
References: <20130119010345.885772698@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilija Hadzic <ihadzic@research.bell-labs.com>

commit a6b7e1a02b77ab8fe8775d20a88c53d8ba55482e upstream.

parser->chunks[.].kpage[.] is not always kmalloc-ed
by the parser initialization, so parser_fini should
not try to kfree it if it didn't allocate it.

This patch fixes a kernel oops that can be provoked
in UMS mode.

Signed-off-by: Ilija Hadzic <ihadzic@research.bell-labs.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Shuah Khan <shuah.khan@hp.com>
Cc: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/r600_cs.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/r600_cs.c
+++ b/drivers/gpu/drm/radeon/r600_cs.c
@@ -2429,8 +2429,10 @@ static void r600_cs_parser_fini(struct r
 	kfree(parser->relocs);
 	for (i = 0; i < parser->nchunks; i++) {
 		kfree(parser->chunks[i].kdata);
-		kfree(parser->chunks[i].kpage[0]);
-		kfree(parser->chunks[i].kpage[1]);
+		if (parser->rdev && (parser->rdev->flags & RADEON_IS_AGP)) {
+			kfree(parser->chunks[i].kpage[0]);
+			kfree(parser->chunks[i].kpage[1]);
+		}
 	}
 	kfree(parser->chunks);
 	kfree(parser->chunks_array);


