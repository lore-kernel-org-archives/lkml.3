Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab3KSBUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 20:20:47 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:34913 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab3KSBUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 20:20:45 -0500
Date: Tue, 19 Nov 2013 01:20:43 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Charley (Hao Chuan) Chu" <charley.chu@broadcom.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] FS: Fixed buffer overflow issue in seq_read()
Message-ID: <20131119012042.GA10323@ZenIV.linux.org.uk>
References: <FB8A4655DFD2B34DB16AE06DDDD6C0E21BDB93D2@SJEXCHMB12.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FB8A4655DFD2B34DB16AE06DDDD6C0E21BDB93D2@SJEXCHMB12.corp.ad.broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 12:18:41AM +0000, Charley (Hao Chuan) Chu wrote:
> The buffer count is not initialized when a new buffer is allocated. 
> 
> It cause kernel crash with "Unable to handle kernel paging
> request..." error in __copy_to_user_std(). It happens when a 
> memory allocation failure in the while(1)-loop, which left the 
> buffer count (m->count) is larger than buffer size 
> (m->size).  
> 
> This patch is currently against a linux 3.12 kernel

The bug is real, but I don't like the fix.  First of all, m->from is
a red herring - it's not even looked at if m->count is 0.  The real
bug is that m->count is not cleared when m->buf is freed - at those
points we have zero bytes of valid contents reachable via m->buf.

What's more, one of those two points (in seq_read()) has cleaning of
->count right after successful kmalloc() following that kfree(), so
it just needs to be moved up a bit.  The other one (in traverse())
is missing.  So how about this:

seq_file: always clear m->count when we free m->buf

Once we'd freed m->buf, m->count should become zero - we have no
valid contents reachable via m->buf.

Reported-by: Charley (Hao Chuan) Chu <charley.chu@broadcom.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/seq_file.c b/fs/seq_file.c
index 1cd2388..1d641bb 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -136,6 +136,7 @@ static int traverse(struct seq_file *m, loff_t offset)
 Eoverflow:
 	m->op->stop(m, p);
 	kfree(m->buf);
+	m->count = 0;
 	m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
 	return !m->buf ? -ENOMEM : -EAGAIN;
 }
@@ -232,10 +233,10 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 			goto Fill;
 		m->op->stop(m, p);
 		kfree(m->buf);
+		m->count = 0;
 		m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
 		if (!m->buf)
 			goto Enomem;
-		m->count = 0;
 		m->version = 0;
 		pos = m->index;
 		p = m->op->start(m, &pos);
