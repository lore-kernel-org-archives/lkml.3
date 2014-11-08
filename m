Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbaKHOsM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 09:48:12 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:55156 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbaKHOsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 09:48:08 -0500
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Casey Schaufler <casey@schaufler-ca.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [PATCH] security: smack: fix out-of-bounds access in smk_parse_smack()
Date: Sat,  8 Nov 2014 17:48:05 +0300
Message-Id: <1415458085-12485-1-git-send-email-ryabinin.a.a@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Ryabinin <a.ryabinin@samsung.com>

Setting smack label on file (e.g. 'attr -S -s SMACK64 -V "test" test')
triggered following spew on the kernel with KASan applied:
    ==================================================================
    BUG: AddressSanitizer: out of bounds access in strncpy+0x28/0x60 at addr ffff8800059ad064
    =============================================================================
    BUG kmalloc-8 (Not tainted): kasan error
    -----------------------------------------------------------------------------

    Disabling lock debugging due to kernel taint
    INFO: Slab 0xffffea0000166b40 objects=128 used=7 fp=0xffff8800059ad080 flags=0x4000000000000080
    INFO: Object 0xffff8800059ad060 @offset=96 fp=0xffff8800059ad080

    Bytes b4 ffff8800059ad050: a0 df 9a 05 00 88 ff ff 5a 5a 5a 5a 5a 5a 5a 5a  ........ZZZZZZZZ
    Object ffff8800059ad060: 74 65 73 74 6b 6b 6b a5                          testkkk.
    Redzone ffff8800059ad068: cc cc cc cc cc cc cc cc                          ........
    Padding ffff8800059ad078: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
    CPU: 0 PID: 528 Comm: attr Tainted: G    B          3.18.0-rc1-mm1+ #5
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
     0000000000000000 ffff8800059ad064 ffffffff81534cf2 ffff880005a5bc40
     ffffffff8112fe1a 0000000100800006 0000000f059ad060 ffff880006000f90
     0000000000000296 ffffea0000166b40 ffffffff8107ca97 ffff880005891060
    Call Trace:
    ? dump_stack (lib/dump_stack.c:52)
    ? kasan_report_error (mm/kasan/report.c:102 mm/kasan/report.c:178)
    ? preempt_count_sub (kernel/sched/core.c:2651)
    ? __asan_load1 (mm/kasan/kasan.h:50 mm/kasan/kasan.c:248 mm/kasan/kasan.c:358)
    ? strncpy (lib/string.c:121)
    ? strncpy (lib/string.c:121)
    ? smk_parse_smack (security/smack/smack_access.c:457)
    ? setxattr (fs/xattr.c:343)
    ? smk_import_entry (security/smack/smack_access.c:514)
    ? smack_inode_setxattr (security/smack/smack_lsm.c:1093 (discriminator 1))
    ? security_inode_setxattr (security/security.c:602)
    ? vfs_setxattr (fs/xattr.c:134)
    ? setxattr (fs/xattr.c:343)
    ? setxattr (fs/xattr.c:360)
    ? get_parent_ip (kernel/sched/core.c:2606)
    ? preempt_count_sub (kernel/sched/core.c:2651)
    ? __percpu_counter_add (arch/x86/include/asm/preempt.h:98 lib/percpu_counter.c:90)
    ? get_parent_ip (kernel/sched/core.c:2606)
    ? preempt_count_sub (kernel/sched/core.c:2651)
    ? __mnt_want_write (arch/x86/include/asm/preempt.h:98 fs/namespace.c:359)
    ? path_setxattr (fs/xattr.c:380)
    ? SyS_lsetxattr (fs/xattr.c:397)
    ? system_call_fastpath (arch/x86/kernel/entry_64.S:423)
    Read of size 1 by task attr:
    Memory state around the buggy address:
     ffff8800059ace80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
     ffff8800059acf00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
     ffff8800059acf80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    >ffff8800059ad000: 00 fc fc fc 00 fc fc fc 05 fc fc fc 04 fc fc fc
                                                           ^
     ffff8800059ad080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
     ffff8800059ad100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
     ffff8800059ad180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
    ==================================================================

strncpy() copies one byte more than the source string has.
Fix this by passing the correct length to strncpy().

Now we can remove initialization of the last byte in 'smack' string
because kzalloc() already did this for us.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 security/smack/smack_access.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index 5b970ff..ad75ddf 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -452,10 +452,9 @@ char *smk_parse_smack(const char *string, int len)
 		return NULL;
 
 	smack = kzalloc(i + 1, GFP_KERNEL);
-	if (smack != NULL) {
-		strncpy(smack, string, i + 1);
-		smack[i] = '\0';
-	}
+	if (smack != NULL)
+		strncpy(smack, string, i);
+
 	return smack;
 }
 
-- 
1.8.5.5

