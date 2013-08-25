Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab3HYSBp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 14:01:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756569Ab3HYSBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 14:01:43 -0400
Date: Sun, 25 Aug 2013 19:55:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Brad Spengler <spender@grsecurity.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] anon_inodefs: forbid open via /proc
Message-ID: <20130825175524.GB31703@redhat.com>
References: <CALCETrWYeNXhEDY7S9XLD6L0wOZu8iPVO6LN3A_797hLHfBzAw@mail.gmail.com> <CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com> <CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com> <20130822201530.GL31117@1wt.eu> <20130824182939.GA23630@redhat.com> <20130825051044.GY27005@ZenIV.linux.org.uk> <20130825155348.GB25922@redhat.com> <CALCETrXrtP2C+g=QeNWK4EMctmonW91kWoO1xmy7rDmEj__1Dw@mail.gmail.com> <20130825174936.GA30957@redhat.com> <20130825175502.GA31703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130825175502.GA31703@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

open("/proc/pid/$anon-fd") should fail, we can't create the new
file with correct f_op/etc correctly. Currently this creates the
bogus file with the empty anon_inode_fops, this is harmless but
still wrong and misleading.

Add anon_inode_fops->anon_open() which simply returns ENXIO like
sock_no_open() does in this case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/anon_inodes.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 47a65df..af25036 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -24,7 +24,15 @@
 
 static struct vfsmount *anon_inode_mnt __read_mostly;
 static struct inode *anon_inode_inode;
-static const struct file_operations anon_inode_fops;
+
+static int anon_open(struct inode *inode, struct file *file)
+{
+	return -ENXIO;
+}
+
+static const struct file_operations anon_inode_fops = {
+	.open = anon_open,
+};
 
 /*
  * anon_inodefs_dname() is called from d_path().
-- 
1.5.5.1


