Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaAMPsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:48:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbaAMPss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:48:48 -0500
Date: Mon, 13 Jan 2014 16:49:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Dipankar Sarma <dipankar@in.ibm.com>, Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] fs: __fget_light() can use __fget() in slow path
Message-ID: <20140113154906.GD6496@redhat.com>
References: <20140107181258.GA29288@redhat.com> <20140108132852.GF10038@linux.vnet.ibm.com> <20140108151918.GA5156@redhat.com> <20140109011650.GI10038@linux.vnet.ibm.com> <20140110153459.GA31491@redhat.com> <20140111063438.GY10038@linux.vnet.ibm.com> <20140111181908.GA7358@redhat.com> <20140111222737.GE10038@linux.vnet.ibm.com> <20140113154748.GA6496@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113154748.GA6496@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The slow path in __fget_light() can use __fget() to avoid the
code duplication. Saves 232 bytes.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/file.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 50c1208..771578b 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -694,17 +694,9 @@ struct file *__fget_light(unsigned int fd, fmode_t mask, int *fput_needed)
 		if (file && (file->f_mode & mask))
 			file = NULL;
 	} else {
-		rcu_read_lock();
-		file = fcheck_files(files, fd);
-		if (file) {
-			if (!(file->f_mode & mask) &&
-			    atomic_long_inc_not_zero(&file->f_count))
-				*fput_needed = 1;
-			else
-				/* Didn't get the reference, someone's freed */
-				file = NULL;
-		}
-		rcu_read_unlock();
+		file = __fget(fd, mask);
+		if (file)
+			*fput_needed = 1;
 	}
 
 	return file;
-- 
1.5.5.1


