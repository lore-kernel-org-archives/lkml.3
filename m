Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab3KARRG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 13:17:06 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:39054 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab3KARQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 13:16:57 -0400
Date: Fri, 1 Nov 2013 13:16:53 -0400
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Kay Sievers <kay@vrfy.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH driver-core-next] sysfs: use generic_file_llseek() for
 sysfs_file_operations
Message-ID: <20131101171653.GA3669@htj.dyndns.org>
References: <20131031114358.GA5551@osiris>
 <20131031172506.GE11698@mtj.dyndns.org>
 <20131101141348.GA5411@osiris>
 <20131101143542.GC20005@htj.dyndns.org>
 <20131101150448.GB18600@kroah.com>
 <20131101150800.GE20005@htj.dyndns.org>
 <20131101161443.GA4593@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101161443.GA4593@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Greg.

Here's proper patch with description and SOB.  I'll be traveling from
tomorrow so I might not be responsive for some days.  Can you please
apply it once Heiko confirms it fixes the issue?

Thanks!

------- 8< -------
13c589d5b0ac6 ("sysfs: use seq_file when reading regular files")
converted regular sysfs files to use seq_file.  The commit substituted
generic_file_llseek() with seq_lseek() for llseek implementation.

Before the change, all regular sysfs files were allowed to seek to any
position in [0, PAGE_SIZE] as the file size is always PAGE_SIZE and
generic_file_llseek() allows any seeking inside the range under file
size; however, seq_lseek()'s behavior is different.  It traverses the
output by repeatedly invoking ->show() until it reaches the target
offset or traversal indicates EOF.  As seq_files are fully dynamic and
may not end at all, it doesn't support seeking from the end
(SEEK_END).

Apparently, there are userland tools which uses SEEK_END to discover
the buffer size to use and the switch to seq_lseek() disturbs them as
SEEK_END fails with -EINVAL.

The only benefits of using seq_lseek() instead of
generic_file_llseek() are

* Early failure.  If traversing to certain file position should fail,
  seq_lseek() will report such failures on lseek(2) instead of the
  following read/write operations.

* EOF detection.  While SEEK_END is not supported, SEEK_SET/CUR +
  large offset can be used to detect eof - eof at the time of the seek
  anyway as the file size may change dynamically.

Both aren't necessary for sysfs or prospect kernfs users.  Revert to
genefic_file_llseek() and preserve the original behavior.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Link: https://lkml.kernel.org/r/20131031114358.GA5551@osiris
---
 fs/sysfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -800,7 +800,7 @@ EXPORT_SYMBOL_GPL(sysfs_notify);
 const struct file_operations sysfs_file_operations = {
 	.read		= seq_read,
 	.write		= sysfs_write_file,
-	.llseek		= seq_lseek,
+	.llseek		= generic_file_llseek,
 	.open		= sysfs_open_file,
 	.release	= sysfs_release,
 	.poll		= sysfs_poll,
