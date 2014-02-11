Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbaBKTRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:17:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbaBKTI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:08:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Eric Paris <eparis@redhat.com>, Paul Moore <pmoore@redhat.com>
Subject: [PATCH 3.4 01/30] SELinux: Fix memory leak upon loading policy
Date: Tue, 11 Feb 2014 11:06:01 -0800
Message-Id: <20140211184647.194336408@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184647.149512538@linuxfoundation.org>
References: <20140211184647.149512538@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 8ed814602876bec9bad2649ca17f34b499357a1c upstream.

Hello.

I got below leak with linux-3.10.0-54.0.1.el7.x86_64 .

[  681.903890] kmemleak: 5538 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

Below is a patch, but I don't know whether we need special handing for undoing
ebitmap_set_bit() call.
----------
>>From fe97527a90fe95e2239dfbaa7558f0ed559c0992 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 6 Jan 2014 16:30:21 +0900
Subject: [PATCH 3.4 01/30] SELinux: Fix memory leak upon loading policy

Commit 2463c26d "SELinux: put name based create rules in a hashtable" did not
check return value from hashtab_insert() in filename_trans_read(). It leaks
memory if hashtab_insert() returns error.

  unreferenced object 0xffff88005c9160d0 (size 8):
    comm "systemd", pid 1, jiffies 4294688674 (age 235.265s)
    hex dump (first 8 bytes):
      57 0b 00 00 6b 6b 6b a5                          W...kkk.
    backtrace:
      [<ffffffff816604ae>] kmemleak_alloc+0x4e/0xb0
      [<ffffffff811cba5e>] kmem_cache_alloc_trace+0x12e/0x360
      [<ffffffff812aec5d>] policydb_read+0xd1d/0xf70
      [<ffffffff812b345c>] security_load_policy+0x6c/0x500
      [<ffffffff812a623c>] sel_write_load+0xac/0x750
      [<ffffffff811eb680>] vfs_write+0xc0/0x1f0
      [<ffffffff811ec08c>] SyS_write+0x4c/0xa0
      [<ffffffff81690419>] system_call_fastpath+0x16/0x1b
      [<ffffffffffffffff>] 0xffffffffffffffff

However, we should not return EEXIST error to the caller, or the systemd will
show below message and the boot sequence freezes.

  systemd[1]: Failed to load SELinux policy. Freezing.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/selinux/ss/policydb.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -1914,7 +1914,19 @@ static int filename_trans_read(struct po
 		if (rc)
 			goto out;
 
-		hashtab_insert(p->filename_trans, ft, otype);
+		rc = hashtab_insert(p->filename_trans, ft, otype);
+		if (rc) {
+			/*
+			 * Do not return -EEXIST to the caller, or the system
+			 * will not boot.
+			 */
+			if (rc != -EEXIST)
+				goto out;
+			/* But free memory to avoid memory leak. */
+			kfree(ft);
+			kfree(name);
+			kfree(otype);
+		}
 	}
 	hash_eval(p->filename_trans, "filenametr");
 	return 0;


