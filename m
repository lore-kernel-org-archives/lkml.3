Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbaFEALy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:11:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40304 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbaFDXWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Ron <ron@debian.org>
Subject: [PATCH 3.14 173/228] sysfs: make sure read buffer is zeroed
Date: Wed,  4 Jun 2014 16:23:22 -0700
Message-Id: <20140604232353.580003687@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit f5c16f29bf5e57ba4051fc7785ba7f035f798c71 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/sysfs/file.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -47,12 +47,13 @@ static int sysfs_kf_seq_show(struct seq_
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


