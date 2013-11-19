Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab3KSDOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 22:14:09 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:35933 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab3KSDOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 22:14:06 -0500
Date: Mon, 18 Nov 2013 19:13:54 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
cc: "Charley (Hao Chuan) Chu" <charley.chu@broadcom.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] FS: Fixed buffer overflow issue in seq_read()
In-Reply-To: <20131119012042.GA10323@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.10.1311181912090.7995@i7.linux-foundation.org>
References: <FB8A4655DFD2B34DB16AE06DDDD6C0E21BDB93D2@SJEXCHMB12.corp.ad.broadcom.com> <20131119012042.GA10323@ZenIV.linux.org.uk>
User-Agent: Alpine 2.10 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 Nov 2013, Al Viro wrote:
> 
> seq_file: always clear m->count when we free m->buf

Ok, applied.

What do you think about then just abstracing out that now common sequence 
of re-allocating a larger buffer, while clearing m->count?

IOW, something like the appended..

              Linus

---
 fs/seq_file.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 1d641bb108d2..f513e1efa49d 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -82,6 +82,14 @@ int seq_open(struct file *file, const struct seq_operations *op)
 }
 EXPORT_SYMBOL(seq_open);
 
+static int grow_seq_buf(struct seq_file *m)
+{
+	kfree(m->buf);
+	m->count = 0;
+	m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
+	return m->buf != NULL;
+}
+
 static int traverse(struct seq_file *m, loff_t offset)
 {
 	loff_t pos = 0, index;
@@ -135,10 +143,7 @@ static int traverse(struct seq_file *m, loff_t offset)
 
 Eoverflow:
 	m->op->stop(m, p);
-	kfree(m->buf);
-	m->count = 0;
-	m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
-	return !m->buf ? -ENOMEM : -EAGAIN;
+	return grow_seq_buf(m) ? -EAGAIN : -ENOMEM;
 }
 
 /**
@@ -232,10 +237,7 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 		if (m->count < m->size)
 			goto Fill;
 		m->op->stop(m, p);
-		kfree(m->buf);
-		m->count = 0;
-		m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
-		if (!m->buf)
+		if (!grow_seq_buf(m))
 			goto Enomem;
 		m->version = 0;
 		pos = m->index;
