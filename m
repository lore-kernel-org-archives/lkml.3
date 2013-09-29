Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab3I2TEj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:04:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52035 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab3I2TEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:04:36 -0400
Date: Sun, 29 Sep 2013 20:04:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Subject: Re: [rfc][possible solution] RCU vfsmounts
Message-ID: <20130929190434.GO13318@ZenIV.linux.org.uk>
References: <20130928202728.GK13318@ZenIV.linux.org.uk>
 <CA+55aFzrjiM6bgqNgdckJGAZks2fR8ZD+R_5AqxvrnS64DD3ow@mail.gmail.com>
 <20130929060601.GL13318@ZenIV.linux.org.uk>
 <CA+55aFyGY7hZTDhWiyWBe+oSkxd2GzoYWGhvXtGTyZKL-3PZ1w@mail.gmail.com>
 <20130929181047.GM13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130929181047.GM13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 07:10:47PM +0100, Al Viro wrote:

> FWIW, right now I'm reviewing the subset of fs code that can be hit in
> RCU mode.  Not a pretty sight, that... ;-/  First catch: in
[snip]

and another, this one completely unrelated to RCU:
                unsigned long gen = (unsigned long) dentry->d_fsdata;
                unsigned long pgen =
                        OCFS2_I(dentry->d_parent->d_inode)->ip_dir_lock_gen;
in ocfs2_dentry_revalidate() needs dentry->d_lock around fetching pgen, as
in the diff below.  I can put it into the next vfs.git pull request
tonight, or pass the buck to ocfs2 folks.  Folks, which tree would
you prefer that to go through?  I'm fine with either variant.  Strictly
speaking, that's -stable fodder, but the race window is quite narrow,
so it's not something earth-shattering...

diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index ef99972..0d3a97d 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -70,9 +70,10 @@ static int ocfs2_dentry_revalidate(struct dentry *dentry, unsigned int flags)
 	 */
 	if (inode == NULL) {
 		unsigned long gen = (unsigned long) dentry->d_fsdata;
-		unsigned long pgen =
-			OCFS2_I(dentry->d_parent->d_inode)->ip_dir_lock_gen;
-
+		unsigned long pgen;
+		spin_lock(&dentry->d_lock);
+		pgen = OCFS2_I(dentry->d_parent->d_inode)->ip_dir_lock_gen;
+		spin_unlock(&dentry->d_lock);
 		trace_ocfs2_dentry_revalidate_negative(dentry->d_name.len,
 						       dentry->d_name.name,
 						       pgen, gen);
