Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934218Ab3CHOxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 09:53:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933058Ab3CHOxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 09:53:13 -0500
Date: Fri, 8 Mar 2013 09:53:07 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: pipe_release oops.
Message-ID: <20130308145306.GA24085@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <CA+55aFwDYocNRjSCJk1PYw0MFy7dpKf1yMMEiePP--=ewQcX6A@mail.gmail.com>
 <20130307213819.GB19543@redhat.com>
 <CA+55aFx424SX6S1zFegVaMZ_BkeZctDKCN6eYCLFfaJDKRVG9g@mail.gmail.com>
 <20130307220333.GA31039@redhat.com>
 <20130307223610.GA2494@redhat.com>
 <CA+55aFzdPaFQROzFhz-v1Qn=3aDP=4uGTiOJxR26cR91uJHxyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzdPaFQROzFhz-v1Qn=3aDP=4uGTiOJxR26cR91uJHxyg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 04:21:13PM -0800, Linus Torvalds wrote:
 > On Thu, Mar 7, 2013 at 2:36 PM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > The hits keep on coming..
 > >
 > > [  255.609172] BUG: unable to handle kernel NULL pointer dereference at 0000000000000064
 > > [  255.610393] IP: [<ffffffff811bad62>] pipe_release+0x42/0xd0
 > 
 > Ok, I think this is the same issue as your fasync thing.
 > 
 > So add a "if (pipe) { }" in pipe_release() too.

Yeah, that does the trick.
I changed your other diff a little to use a goto, which reduces a level of indentation..

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/fs/pipe.c b/fs/pipe.c
index 64a494c..49ba9cc 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -740,6 +740,9 @@ pipe_release(struct inode *inode, int decr, int decw)
 
 	mutex_lock(&inode->i_mutex);
 	pipe = inode->i_pipe;
+	if (!pipe)
+		goto out_unlock;
+
 	pipe->readers -= decr;
 	pipe->writers -= decw;
 
@@ -750,6 +753,8 @@ pipe_release(struct inode *inode, int decr, int decw)
 		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 		kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
 	}
+
+out_unlock:
 	mutex_unlock(&inode->i_mutex);
 
 	return 0;
@@ -759,10 +764,11 @@ static int
 pipe_read_fasync(int fd, struct file *filp, int on)
 {
 	struct inode *inode = file_inode(filp);
-	int retval;
+	int retval = 0;
 
 	mutex_lock(&inode->i_mutex);
-	retval = fasync_helper(fd, filp, on, &inode->i_pipe->fasync_readers);
+	if (inode->i_pipe)
+		retval = fasync_helper(fd, filp, on, &inode->i_pipe->fasync_readers);
 	mutex_unlock(&inode->i_mutex);
 
 	return retval;
@@ -773,10 +779,11 @@ static int
 pipe_write_fasync(int fd, struct file *filp, int on)
 {
 	struct inode *inode = file_inode(filp);
-	int retval;
+	int retval = 0;
 
 	mutex_lock(&inode->i_mutex);
-	retval = fasync_helper(fd, filp, on, &inode->i_pipe->fasync_writers);
+	if (inode->i_pipe)
+		retval = fasync_helper(fd, filp, on, &inode->i_pipe->fasync_writers);
 	mutex_unlock(&inode->i_mutex);
 
 	return retval;
@@ -787,16 +794,22 @@ static int
 pipe_rdwr_fasync(int fd, struct file *filp, int on)
 {
 	struct inode *inode = file_inode(filp);
-	struct pipe_inode_info *pipe = inode->i_pipe;
-	int retval;
+	struct pipe_inode_info *pipe;
+	int retval = 0;
 
 	mutex_lock(&inode->i_mutex);
+	pipe = inode->i_pipe;
+	if (!pipe)
+		goto out_unlock;
+
 	retval = fasync_helper(fd, filp, on, &pipe->fasync_readers);
 	if (retval >= 0) {
 		retval = fasync_helper(fd, filp, on, &pipe->fasync_writers);
 		if (retval < 0) /* this can happen only if on == T */
 			fasync_helper(-1, filp, 0, &pipe->fasync_readers);
 	}
+
+out_unlock:
 	mutex_unlock(&inode->i_mutex);
 	return retval;
 }
