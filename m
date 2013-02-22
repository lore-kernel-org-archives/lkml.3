Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab3BVHvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 02:51:00 -0500
Received: from mail.servus.at ([193.170.194.20]:46092 "EHLO mail.servus.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219Ab3BVHul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 02:50:41 -0500
Message-ID: <51272257.7050907@oberhumer.com>
Date: Fri, 22 Feb 2013 08:46:31 +0100
From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Organization: oberhumer.com
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Bojan Smojver <bojan@rexursive.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] PM: align buffers for LZO compression
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

for performance reasons I'd strongly suggest that you explicitly align all
buffers passed to the LZO compress and decompress functions.

Below is a small (and completely untested!) patch, but I think you
get the idea.

BTW, it might be even more beneficial (esp. for NUMA systems) to align *all*
individual unc/cmp/wrk pointers to a multiple of the PAGE_SIZE, but this would
require some code restructuring.

Cheers,
Markus

completely untested patch:

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 7c33ed2..7af4293 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -532,9 +532,9 @@ struct cmp_data {
        wait_queue_head_t done;                   /* compression done */
        size_t unc_len;                           /* uncompressed length */
        size_t cmp_len;                           /* compressed length */
-       unsigned char unc[LZO_UNC_SIZE];          /* uncompressed buffer */
-       unsigned char cmp[LZO_CMP_SIZE];          /* compressed buffer */
-       unsigned char wrk[LZO1X_1_MEM_COMPRESS];  /* compression workspace */
+       unsigned char unc[LZO_UNC_SIZE]         ____cacheline_aligned; /* uncompressed buffer */
+       unsigned char cmp[LZO_CMP_SIZE]         ____cacheline_aligned; /* compressed buffer */
+       unsigned char wrk[LZO1X_1_MEM_COMPRESS] ____cacheline_aligned; /* compression workspace */
 };

 /**
@@ -1021,8 +1021,8 @@ struct dec_data {
        wait_queue_head_t done;                   /* decompression done */
        size_t unc_len;                           /* uncompressed length */
        size_t cmp_len;                           /* compressed length */
-       unsigned char unc[LZO_UNC_SIZE];          /* uncompressed buffer */
-       unsigned char cmp[LZO_CMP_SIZE];          /* compressed buffer */
+       unsigned char unc[LZO_UNC_SIZE]         ____cacheline_aligned; /* uncompressed buffer */
+       unsigned char cmp[LZO_CMP_SIZE]         ____cacheline_aligned; /* compressed buffer */
 };

 /**


Signed-off-by: Markus F.X.J. Oberhumer <markus@oberhumer.com>

-- 
Markus Oberhumer, <markus@oberhumer.com>, http://www.oberhumer.com/
