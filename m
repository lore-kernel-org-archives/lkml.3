Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab3IKFXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:23:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab3IKE51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:27 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=uZBUTYWbnP4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=klAmjzfMPd4A:10 a=20KFwNOVAAAA:8 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=qZ8VYHB6UeH5i3Dy9scA:9 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OOrE2L2Zc4ewzulR:21 a=n5roPa3acQUmg7Qg:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042910.290751694@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <gmazyland@gmail.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [108/251] dm verity: fix inability to use a few specific devices sizes
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0108-dm-verity-fix-inability-to-use-a-few-specific-device.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit b1bf2de07271932326af847a3c6a01fdfd29d4be ]

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
Cc: stable@vger.kernel.org # 3.4+
Cc: Milan Broz <gmazyland@gmail.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/md/dm-verity.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index dd5ba3b..30b364c 100644
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
1.7.10.4


