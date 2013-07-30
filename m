Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab3G3Jc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:32:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52963 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab3G3Jc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:32:26 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <gmazyland@gmail.com>,
        Alasdair G Kergon <agk@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 013/106] dm verity: fix inability to use a few specific devices sizes
Date: Tue, 30 Jul 2013 10:30:32 +0100
Message-Id: <1375176725-5825-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit b1bf2de07271932326af847a3c6a01fdfd29d4be upstream.

Fix a boundary condition that caused failure for certain device sizes.

The problem is reported at
  http://code.google.com/p/cryptsetup/issues/detail?id=160

For certain device sizes the number of hashes at a specific level was
calculated incorrectly.

It happens for example for a device with data and metadata block size 4096
that has 16385 blocks and algorithm sha256.

The user can test if he is affected by this bug by running the
"veritysetup verify" command and also by activating the dm-verity kernel
driver and reading the whole block device. If it passes without an error,
then the user is not affected.

The condition for the bug is:

Split the total number of data blocks (data_block_bits) into bit strings,
each string has hash_per_block_bits bits. hash_per_block_bits is
rounddown(log2(metadata_block_size/hash_digest_size)). Equivalently, you
can say that you convert data_blocks_bits to 2^hash_per_block_bits base.

If there some zero bit string below the most significant bit string and at
least one bit below this zero bit string is set, then the bug happens.

The same bug exists in the userspace veritysetup tool, so you must use
fixed veritysetup too if you want to use devices that are affected by
this boundary condition.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Milan Broz <gmazyland@gmail.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-verity.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index adb32e7..157007d 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -842,9 +842,8 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	for (i = v->levels - 1; i >= 0; i--) {
 		sector_t s;
 		v->hash_level_block[i] = hash_position;
-		s = verity_position_at_level(v, v->data_blocks, i);
-		s = (s >> v->hash_per_block_bits) +
-		    !!(s & ((1 << v->hash_per_block_bits) - 1));
+		s = (v->data_blocks + ((sector_t)1 << ((i + 1) * v->hash_per_block_bits)) - 1)
+					>> ((i + 1) * v->hash_per_block_bits);
 		if (hash_position + s < hash_position) {
 			ti->error = "Hash device offset overflow";
 			r = -E2BIG;
-- 
1.8.3.2

