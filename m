Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab3LUCJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 21:09:00 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:44117 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab3LUCI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 21:08:57 -0500
Message-ID: <52B4F837.1010403@gmail.com>
Date: Sat, 21 Dec 2013 10:08:55 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: nab@linux-iscsi.org
CC: James Hogan <james.hogan@imgtec.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers: target: target_core_mod: use div64_u64_rem() instead
 of operator '%' for u64
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kernel, need use div64_u64_rem() instead of operator '%' for u64, or
can not pass compiling (with allmodconfig under metag):

    MODPOST 2909 modules
  ERROR: "__umoddi3" [drivers/target/target_core_mod.ko] undefined!

Also need u64 type cast for u32 variable multiply u32 variable, or will
cause type overflow issue.


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/target/target_core_alua.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index dc0d399..ff2aadc 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -489,7 +489,8 @@ static inline int core_alua_state_lba_dependent(
 			u64 first_lba = map->lba_map_first_lba;
 
 			if (segment_mult) {
-				start_lba = lba % (segment_size * segment_mult);
+				u64 tmp = (u64)segment_size * segment_mult;
+				div64_u64_rem(lba, tmp, &start_lba);
 				last_lba = first_lba + segment_size - 1;
 				if (start_lba >= first_lba &&
 				    start_lba <= last_lba) {
-- 
1.7.11.7
