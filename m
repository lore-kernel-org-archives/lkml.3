Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760557Ab3ICQkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:40:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46383 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab3ICQYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:24:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andreas Schwab <schwab@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 18/58] m68k: Truncate base in do_div()
Date: Tue,  3 Sep 2013 09:23:22 -0700
Message-Id: <1378225442-20654-19-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Schwab <schwab@linux-m68k.org>

commit ea077b1b96e073eac5c3c5590529e964767fc5f7 upstream.

Explicitly truncate the second operand of do_div() to 32 bits to guard
against bogus code calling it with a 64-bit divisor.

[Thorsten]

After upgrading from 3.2 to 3.10, mounting a btrfs volume fails with:

btrfs: setting nodatacow, compression disabled
btrfs: enabling auto recovery
btrfs: disk space caching is enabled
*** ZERO DIVIDE ***   FORMAT=2
Current process id is 722
BAD KERNEL TRAP: 00000000
Modules linked in: evdev mac_hid ext4 crc16 jbd2 mbcache btrfs xor lzo_compress zlib_deflate raid6_pq crc32c libcrc32c
PC: [<319535b2>] __btrfs_map_block+0x11c/0x119a [btrfs]
SR: 2000  SP: 30c1fab4  a2: 30f0faf0
d0: 00000000    d1: 00001000    d2: 00000000    d3: 00000000
d4: 00010000    d5: 00000000    a0: 3085c72c    a1: 3085c72c
Process mount (pid: 722, task=30f0faf0)
Frame format=2 instr addr=319535ae
Stack from 30c1faec:
        00000000 00000020 00000000 00001000 00000000 01401000 30253928 300ffc00
        00a843ac 3026f640 00000000 00010000 0009e250 00d106c0 00011220 00000000
        00001000 301c6830 0009e32a 000000ff 00000009 3085c72c 00000000 00000000
        30c1fd14 00000000 00000020 00000000 30c1fd14 0009e26c 00000020 00000003
        00000000 0009dd8a 300b0b6c 30253928 00a843ac 00001000 00000000 00000000
        0000a008 3194e76a 30253928 00a843ac 00001000 00000000 00000000 00000002
Call Trace: [<00001000>] kernel_pg_dir+0x0/0x1000

    [...]

Code: 222e ff74 2a2e ff5c 2c2e ff60 4c45 1402 <2d40> ff64 2d41 ff68 2205 4c2e 1800 ff68 4c04 0800 2041 d1c0 2206 4c2e 1400 ff68

[Geert]

As diagnosed by Andreas, fs/btrfs/volumes.c:__btrfs_map_block()
calls

    do_div(stripe_nr, stripe_len);

with stripe_len u64, while do_div() assumes the divisor is a 32-bit number.

Due to the lack of truncation in the m68k-specific implementation of
do_div(), the division is performed using the upper 32-bit word of
stripe_len, which is zero.

This was introduced by commit 53b381b3abeb86f12787a6c40fee9b2f71edc23b
("Btrfs: RAID5 and RAID6"), which changed the divisor from
map->stripe_len (struct map_lookup.stripe_len is int) to a 64-bit temporary.

Reported-by: Thorsten Glaser <tg@debian.org>
Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
Tested-by: Thorsten Glaser <tg@debian.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/m68k/include/asm/div64.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/m68k/include/asm/div64.h b/arch/m68k/include/asm/div64.h
index 444ea8a..ef881cf 100644
--- a/arch/m68k/include/asm/div64.h
+++ b/arch/m68k/include/asm/div64.h
@@ -15,16 +15,17 @@
 		unsigned long long n64;				\
 	} __n;							\
 	unsigned long __rem, __upper;				\
+	unsigned long __base = (base);				\
 								\
 	__n.n64 = (n);						\
 	if ((__upper = __n.n32[0])) {				\
 		asm ("divul.l %2,%1:%0"				\
-			: "=d" (__n.n32[0]), "=d" (__upper)	\
-			: "d" (base), "0" (__n.n32[0]));	\
+		     : "=d" (__n.n32[0]), "=d" (__upper)	\
+		     : "d" (__base), "0" (__n.n32[0]));		\
 	}							\
 	asm ("divu.l %2,%1:%0"					\
-		: "=d" (__n.n32[1]), "=d" (__rem)		\
-		: "d" (base), "1" (__upper), "0" (__n.n32[1]));	\
+	     : "=d" (__n.n32[1]), "=d" (__rem)			\
+	     : "d" (__base), "1" (__upper), "0" (__n.n32[1]));	\
 	(n) = __n.n64;						\
 	__rem;							\
 })
-- 
1.8.1.2

