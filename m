Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab3HXSgB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 14:36:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249Ab3HXSf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 14:35:59 -0400
Date: Sat, 24 Aug 2013 20:29:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Subject: /proc/pid/fd && anon_inode_fops
Message-ID: <20130824182939.GA23630@redhat.com>
References: <b121a1082bf3365fda22a131782147c169c969f5.1377112282.git.luto@amacapital.net> <CA+55aFzXNU-eJ7KeZyv5YYKKtm8iorG-o3QtD7NXx0GTzuH+Bw@mail.gmail.com> <20130822185317.GI31117@1wt.eu> <CALCETrWYeNXhEDY7S9XLD6L0wOZu8iPVO6LN3A_797hLHfBzAw@mail.gmail.com> <CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com> <CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com> <20130822201530.GL31117@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130822201530.GL31117@1wt.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for off-topic, I am just curios.

On 08/22, Willy Tarreau wrote:
>
> It's not only that, it also supports sockets and pipes that you can access
> via /proc/pid/fd and not via a real symlink which would try to open eg
> "pipe:[23456]" instead of the real file.

But sock_no_open() disallows this, and for good reason I guess.

I am wondering, perhaps anon_inode should do the same? I do not
see any problem, but it looks pointless and misleading to allow
to open a file you can do nothing with.

Or is there any reason why, say, open("anon_inode:[perf_event]")
should succeed?

Thanks,

Oleg.

--- x/fs/anon_inodes.c
+++ x/fs/anon_inodes.c
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

