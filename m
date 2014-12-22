Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbaLVLwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:52:25 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:40665 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbaLVLum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:50:42 -0500
From: Dongsu Park <dongsu.park@profitbricks.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Ming Lin <mlin@minggr.net>, Dongsu Park <dongsu.park@profitbricks.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [RFC PATCH 17/17] Documentation: update notes in biovecs about arbitrarily sized bios
Date: Mon, 22 Dec 2014 12:48:44 +0100
Message-Id: <a116a7da8f881f69dfcc2e40bda91533f1bb3c57.1419241597.git.dongsu.park@profitbricks.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <4287748e7d1a0fce1c951567a7688821f1a21e5e.1419241597.git.dongsu.park@profitbricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
 <d26a9a0fc9a7d1529c115785ee5935d5750782bd.1419241597.git.dongsu.park@profitbricks.com>
 <f67d71b4a375ab504c2fc02e94a9d2a651686cab.1419241597.git.dongsu.park@profitbricks.com>
 <fe96db02d805ca6191dd605d03dac0d04c926fc1.1419241597.git.dongsu.park@profitbricks.com>
 <bb0051ceb5805896089ded26c0f7f06758b25105.1419241597.git.dongsu.park@profitbricks.com>
 <e4b7b017eaa81784889ebb2a4e6a7d4366adf13a.1419241597.git.dongsu.park@profitbricks.com>
 <83a9ee8a309f8e08490c5dd715a608ea054f5c33.1419241597.git.dongsu.park@profitbricks.com>
 <fc859b23b383f6f4c1e81f4210aa62cb1bdc935f.1419241597.git.dongsu.park@profitbricks.com>
 <0b6ba533a64aec98e8447bfd30c6622d0729d12e.1419241597.git.dongsu.park@profitbricks.com>
 <d42dae3d2a64fa4c3a0893f1af963151b31869e3.1419241597.git.dongsu.park@profitbricks.com>
 <4334b90a56b96ad7a11e4ba7eb97c2cf4405950d.1419241597.git.dongsu.park@profitbricks.com>
 <abe647cf7cf272220227fad4dac9c43641192f01.1419241597.git.dongsu.park@profitbricks.com>
 <b7767767957ca758ac492e94dfb320bea4f52dd7.1419241597.git.dongsu.park@profitbricks.com>
 <e35d37b66d621c51f2eb24ff024291bd1d53422e.1419241597.git.dongsu.park@profitbricks.com>
 <a7118fb6a3353958a19f4d848472da2de76de238.1419241597.git.dongsu.park@profitbricks.com>
 <a0e8166c0c5455755b0cd2d79e8066636c22aa77.1419241597.git.dongsu.park@profitbricks.com>
 <4287748e7d1a0fce1c951567a7688821f1a21e5e.1419241597.git.dongsu.park@profitbricks.com>
In-Reply-To: <cover.1419241597.git.dongsu.park@profitbricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update block/biovecs.txt so that it includes a note on what kind of
effects arbitrarily sized bios would bring to the block layer.
Also fix a trivial typo, bio_iter_iovec.

Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
---
 Documentation/block/biovecs.txt | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/Documentation/block/biovecs.txt b/Documentation/block/biovecs.txt
index 74a32ad..339045d 100644
--- a/Documentation/block/biovecs.txt
+++ b/Documentation/block/biovecs.txt
@@ -24,7 +24,7 @@ particular, presenting the illusion of partially completed biovecs so that
 normal code doesn't have to deal with bi_bvec_done.
 
  * Driver code should no longer refer to biovecs directly; we now have
-   bio_iovec() and bio_iovec_iter() macros that return literal struct biovecs,
+   bio_iovec() and bio_iter_iovec() macros that return literal struct biovecs,
    constructed from the raw biovecs but taking into account bi_bvec_done and
    bi_size.
 
@@ -109,3 +109,18 @@ Other implications:
    over all the biovecs in the new bio - which is silly as it's not needed.
 
    So, don't use bi_vcnt anymore.
+
+ * As of 3.18, block layer is written based on merging biovecs. Its goal is
+   to avoid having to split bios; upper layer code such as bio_add_page()
+   checks what the underlying device can handle, and tries to always create
+   bios that don't need to be split. However, this approach has been actually
+   cumbersome and error-prone. It eventually breaks down with stacked devices
+   and devices with dynamic limits, which then adds a lot of complexity.
+
+   So its new interface allows the block layer to split bios as needed, so we
+   could eliminate a lot of complexity elsewhere - particularly in stacked
+   drivers. Code that creates bios can then create whatever size bios are
+   convenient, and more importantly stacked drivers don't have to deal with
+   both their own bio size limitations and the limitations of the underlying
+   devices. Thus there's no need to define ->merge_bvec_fn() callbacks for
+   individual block drivers.
-- 
2.1.0

