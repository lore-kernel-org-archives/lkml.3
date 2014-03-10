Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbaCJSBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 14:01:43 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:64893 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaCJSBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 14:01:41 -0400
Message-ID: <1394474492.31499.177.camel@bobble.lax.corp.google.com>
Subject: [PATCH] block:  Force sector and nr_sects to device alignment and
 granularity.
From: Frank Mayhar <fmayhar@google.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 10 Mar 2014 11:01:32 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

block:  Force sector and nr_sects to device alignment and granularity.

In blkdev_issue_discard(), rather than sending an improperly-
aligned discard to the device (where it may get an error),
adjust the start and length to the block device alignment and
granularity.  Don't fail if this leaves nothing to discard.

Without this change, certain flash drivers can report invalid
trim parameters (and will fail the command).  Per tytso, "given
that discards are advisory, any part of the storage stack is
free to drop discard requests silently."

Signed-off-by: Frank Mayhar <fmayhar@google.com>
Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>

 block/blk-lib.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 97a733c..a4472cd 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -61,6 +61,21 @@ int blkdev_issue_discard(struct block_device *bdev,
sector_t sector,
 	alignment = (bdev_discard_alignment(bdev) >> 9) % granularity;
 
 	/*
+	 * Force sector and nr_sects to block device alignment and
+	 * granularity.
+	 */
+	if (alignment && (sector % alignment)) {
+		sector_t adj = alignment - (sector % alignment);
+
+		sector += adj;
+		nr_sects -= adj;
+	}
+	if (nr_sects % granularity)
+		nr_sects -= nr_sects % granularity;
+	if (!nr_sects)
+		return ret;
+
+	/*
 	 * Ensure that max_discard_sectors is of the proper
 	 * granularity, so that requests stay aligned after a split.
 	 */


