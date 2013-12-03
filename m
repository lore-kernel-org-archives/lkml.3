Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab3LCPlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:41:07 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:61725 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3LCPlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:41:04 -0500
From: Julien Grall <julien.grall@linaro.org>
To: xen-devel@lists.xenproject.org
Cc: patches@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Julien Grall <julien.grall@linaro.org>,
        Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v2] xen/block: Correctly define structures in public headers on ARM32 and ARM64
Date: Tue,  3 Dec 2013 15:40:37 +0000
Message-Id: <1386085237-8334-1-git-send-email-julien.grall@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ARM (32 bits and 64 bits), the double-word is 8-bytes aligned. This will
result on different structure from Xen and Linux repositories.

As Linux is using __packed__ attribute, it must have a 4-bytes padding before
each "id" field.

This change breaks guest block support with older kernel. IMHO, it's acceptable
because Xen on ARM is still on Tech Preview and the hypercall ABI is not yet
freezed.

Only one architecture (x86_32) doesn't have 64-bit ABI for the block interface.
Don't add padding if Linux is compiled for this architecture.

Signed-off-by: Julien Grall <julien.grall@linaro.org>
Cc: Roger Pau Monne <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Ian Campbell <ian.campbell@citrix.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

---

Changes in v2:
    - Reverse define

Changes in v1:
    - This patch is the rework of "xen-block: correctly define structures in
    public headers" sent by Roger (see https://lkml.org/lkml/2013/12/3/155).
---
 include/xen/interface/io/blkif.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/xen/interface/io/blkif.h b/include/xen/interface/io/blkif.h
index 65e1209..ae665ac 100644
--- a/include/xen/interface/io/blkif.h
+++ b/include/xen/interface/io/blkif.h
@@ -146,7 +146,7 @@ struct blkif_request_segment_aligned {
 struct blkif_request_rw {
 	uint8_t        nr_segments;  /* number of segments                   */
 	blkif_vdev_t   handle;       /* only for read/write requests         */
-#ifdef CONFIG_X86_64
+#ifndef CONFIG_X86_32
 	uint32_t       _pad1;	     /* offsetof(blkif_request,u.rw.id) == 8 */
 #endif
 	uint64_t       id;           /* private guest value, echoed in resp  */
@@ -163,7 +163,7 @@ struct blkif_request_discard {
 	uint8_t        flag;         /* BLKIF_DISCARD_SECURE or zero.        */
 #define BLKIF_DISCARD_SECURE (1<<0)  /* ignored if discard-secure=0          */
 	blkif_vdev_t   _pad1;        /* only for read/write requests         */
-#ifdef CONFIG_X86_64
+#ifndef CONFIG_X86_32
 	uint32_t       _pad2;        /* offsetof(blkif_req..,u.discard.id)==8*/
 #endif
 	uint64_t       id;           /* private guest value, echoed in resp  */
@@ -175,7 +175,7 @@ struct blkif_request_discard {
 struct blkif_request_other {
 	uint8_t      _pad1;
 	blkif_vdev_t _pad2;        /* only for read/write requests         */
-#ifdef CONFIG_X86_64
+#ifndef CONFIG_X86_32
 	uint32_t     _pad3;        /* offsetof(blkif_req..,u.other.id)==8*/
 #endif
 	uint64_t     id;           /* private guest value, echoed in resp  */
@@ -184,7 +184,7 @@ struct blkif_request_other {
 struct blkif_request_indirect {
 	uint8_t        indirect_op;
 	uint16_t       nr_segments;
-#ifdef CONFIG_X86_64
+#ifndef CONFIG_X86_32
 	uint32_t       _pad1;        /* offsetof(blkif_...,u.indirect.id) == 8 */
 #endif
 	uint64_t       id;
@@ -192,7 +192,7 @@ struct blkif_request_indirect {
 	blkif_vdev_t   handle;
 	uint16_t       _pad2;
 	grant_ref_t    indirect_grefs[BLKIF_MAX_INDIRECT_PAGES_PER_REQUEST];
-#ifdef CONFIG_X86_64
+#ifndef CONFIG_X86_32
 	uint32_t      _pad3;         /* make it 64 byte aligned */
 #else
 	uint64_t      _pad3;         /* make it 64 byte aligned */
-- 
1.7.10.4

