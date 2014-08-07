Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151AbaHGQww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:52:52 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23671 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbaHGQws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:52:48 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-44-53e3aede1c64
Subject: [PATCH 2/3] Smack: handle zero-length security labels without panic
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Date: Thu, 07 Aug 2014 20:52:43 +0400
Message-id: <20140807165243.13463.74200.stgit@buzz>
In-reply-to: <20140807165233.13463.55258.stgit@buzz>
References: <20140807165233.13463.55258.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t/xK7r31j0ONng4Vc7i3rZfbBZ9j4Ms
	fuzsZbW4vGsOm8WHnkdsFucvnGN3YPO4tjvS4+PTWywefVtWMXoc3b+IzePzJrkA1igum5TU
	nMyy1CJ9uwSujI27ygrmqlds2zWRvYFxu0IXIyeHhICJRNffY8wQtpjEhXvr2boYuTiEBJYy
	Skx+sYARwmlkkrhw9ApYlbCAj8T6yx9ZQWw2ATOJbftuM4LYIgI6Evv2PGcHaWAWmMkosXX9
	KSaQBIuAqsT+az/BmnkFjCWOtr1k6WLk4OAEWn1yXiFIWAgovPDBORYQW1RATmLl5RZWiHJB
	iR+T74GVMwuoS0yZkgsSZhaQl9i85i3zBEaBWUiqZiFUzUJStYCReRWjaGppckFxUnqukV5x
	Ym5xaV66XnJ+7iZGSEh/3cG49JjVIUYBDkYlHl6FvXeDhVgTy4orcw8xSnAwK4nw6nY/Dhbi
	TUmsrEotyo8vKs1JLT7EyMTBKdXAyF743ltOyWtR0U2FAIFJMzerVSftPs6Y//tE0K1ZF+WT
	duWHtMelaKSH9Wm+i/mrvO3m35lP1ZYnN6xnXyh9pCBHQHIPl0vRlL4Pq64/X/JqTZVfrPOH
	56YPGlewuR4xlwnNMbLf9WVbyJ+DUnJLbdWMZ1bHRF36vb32aOw2/buTuWPPdZz7qsRSnJFo
	qMVcVJwIAHH1wddHAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zero-length security labels are invalid but kernel should handle them.

This patch fixes kernel panic after setting zero-length security labels:
# attr -S -s "SMACK64" -V "" file

And after writing zero-length string into smackfs files syslog and onlycp:
# python -c 'import os; os.write(1, "")' > /smack/syslog

The problem is caused by brain-damaged logic in function smk_parse_smack()
which takes pointer to buffer and its length but if length below or equal zero
it thinks that the buffer is zero-terminated. Unfortunately callers of this
function are widely used and proper fix requires serious refactoring.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>

---

Example:

[   28.063935] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   28.064623] IP: [<ffffffff812ea780>] strlen+0x0/0x30
[   28.064623] PGD 29a77067 PUD 2972d067 PMD 0
[   28.064623] Oops: 0000 [#1] SMP
[   28.064623] Modules linked in:
[   28.064623] CPU: 0 PID: 824 Comm: attr Not tainted 3.16.0+ #6
[   28.064623] task: ffff880029bd88c0 ti: ffff8800297d0000 task.ti: ffff8800297d0000
[   28.064623] RIP: 0010:[<ffffffff812ea780>]  [<ffffffff812ea780>] strlen+0x0/0x30
[   28.064623] RSP: 0018:ffff8800297d3ca8  EFLAGS: 00010246
[   28.064623] RAX: 0000000000000001 RBX: ffff880029c096c0 RCX: 0000000000000001
[   28.064623] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[   28.064623] RBP: ffff8800297d3cd0 R08: ffffffff81e3d940 R09: ffff88002a3e8588
[   28.064623] R10: 8080808080808080 R11: 0000000000000000 R12: 0000000000000000
[   28.064623] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[   28.064623] FS:  00007effe391a700(0000) GS:ffff88002a400000(0000) knlGS:0000000000000000
[   28.064623] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   28.064623] CR2: 0000000000000000 CR3: 00000000297a1000 CR4: 00000000001406b0
[   28.064623] Stack:
[   28.064623]  ffffffff812a6fa5 ffff880029c096c0 0000000000000001 0000000000000000
[   28.064623]  0000000000000000 ffff8800297d3cf8 ffffffff812a70ae ffff880029c096c0
[   28.064623]  0000000000000001 0000000000000000 ffff8800297d3d88 ffffffff812a64dc
[   28.064623] Call Trace:
[   28.064623]  [<ffffffff812a6fa5>] ? smk_parse_smack+0xe5/0x110
[   28.064623]  [<ffffffff812a70ae>] smk_import_entry+0xe/0x130
[   28.064623]  [<ffffffff812a64dc>] smack_inode_setxattr+0x11c/0x280
[   28.064623]  [<ffffffff8116a767>] ? lookup_fast+0x177/0x2e0
[   28.064623]  [<ffffffff81177001>] ? dput+0x21/0x1a0
[   28.064623]  [<ffffffff812a0eeb>] security_inode_setxattr+0x1b/0x30
[   28.064623]  [<ffffffff8118488f>] vfs_setxattr+0x6f/0xb0
[   28.064623]  [<ffffffff81184a76>] setxattr+0x1a6/0x1f0
[   28.064623]  [<ffffffff8116af6d>] ? final_putname+0x1d/0x40
[   28.064623]  [<ffffffff8116b1c4>] ? putname+0x24/0x40
[   28.064623]  [<ffffffff8117144a>] ? user_path_at_empty+0x5a/0xa0
[   28.064623]  [<ffffffff81162b84>] ? __sb_start_write+0x44/0xe0
[   28.064623]  [<ffffffff8113cd21>] ? do_brk+0x241/0x320
[   28.064623]  [<ffffffff81184d97>] SyS_lsetxattr+0x87/0xe0
[   28.064623]  [<ffffffff81806f69>] system_call_fastpath+0x16/0x1b
[   28.064623] Code: 89 f8 48 89 e5 f6 82 40 3e a6 81 20 74 15 0f 1f 44 00 00 48 83 c0 01 0f b6 10 f6 82 40 3e a6 81 20 75 f0 5d c3 66 0f 1f 44 00 00 <80> 3f 00 55 48 89 e5 74 15 48 89 f8 0f 1f 40 00 48 83 c0 01 80
[   28.064623] RIP  [<ffffffff812ea780>] strlen+0x0/0x30
[   28.064623]  RSP <ffff8800297d3ca8>
[   28.064623] CR2: 0000000000000000
[   28.093561] ---[ end trace de1055429a98a5be ]---
---
 security/smack/smack_lsm.c |    2 +-
 security/smack/smackfs.c   |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index b11ab23..afa5ad0 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -923,7 +923,7 @@ static int smack_inode_setxattr(struct dentry *dentry, const char *name,
 		rc = -EPERM;
 
 	if (rc == 0 && check_import) {
-		skp = smk_import_entry(value, size);
+		skp = size ? smk_import_entry(value, size) : NULL;
 		if (skp == NULL || (check_star &&
 		    (skp == &smack_known_star || skp == &smack_known_web)))
 			rc = -EINVAL;
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 3c720ff..56a1439 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -1677,7 +1677,7 @@ static ssize_t smk_write_onlycap(struct file *file, const char __user *buf,
 	if (smack_onlycap != NULL && smack_onlycap != skp)
 		return -EPERM;
 
-	data = kzalloc(count, GFP_KERNEL);
+	data = kzalloc(count + 1, GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 
@@ -2228,7 +2228,7 @@ static ssize_t smk_write_syslog(struct file *file, const char __user *buf,
 	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
-	data = kzalloc(count, GFP_KERNEL);
+	data = kzalloc(count + 1, GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 

