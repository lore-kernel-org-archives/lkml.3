Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbaESTwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:52:15 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:61383 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaESTwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:52:14 -0400
Date: Mon, 19 May 2014 15:52:10 -0400
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay@vrfy.org>, Ron <ron@debian.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH driver-core-linus] sysfs: make sure read buffer is zeroed
Message-ID: <20140519195210.GA27506@mtj.dyndns.org>
References: <20140519172334.GK20439@audi.shelbyville.oz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519172334.GK20439@audi.shelbyville.oz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

13c589d5b0ac ("sysfs: use seq_file when reading regular files")
switched sysfs from custom read implementation to seq_file to enable
later transition to kernfs.  After the change, the buffer passed to
->show() is acquired through seq_get_buf(); unfortunately, this
introduces a subtle behavior change.  Before the commit, the buffer
passed to ->show() was always zero as it was allocated using
get_zeroed_page().  Because seq_file doesn't clear buffers on
allocation and neither does seq_get_buf(), after the commit, depending
on the behavior of ->show(), we may end up exposing uninitialized data
to userland thus possibly altering userland visible behavior and
leaking information.

Fix it by explicitly clearing the buffer.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Ron <ron@debian.org> 
Fixes: 13c589d5b0ac ("sysfs: use seq_file when reading regular files")
---
 fs/sysfs/file.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 28cc1acd..e9ef59b 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -47,12 +47,13 @@ static int sysfs_kf_seq_show(struct seq_file *sf, void *v)
 	ssize_t count;
 	char *buf;
 
-	/* acquire buffer and ensure that it's >= PAGE_SIZE */
+	/* acquire buffer and ensure that it's >= PAGE_SIZE and clear */
 	count = seq_get_buf(sf, &buf);
 	if (count < PAGE_SIZE) {
 		seq_commit(sf, -1);
 		return 0;
 	}
+	memset(buf, 0, PAGE_SIZE);
 
 	/*
 	 * Invoke show().  Control may reach here via seq file lseek even
