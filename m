Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbaIZSh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 14:37:26 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:15396 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754361AbaIZShY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 14:37:24 -0400
Date: Fri, 26 Sep 2014 14:37:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Petr Mladek <pmladek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] seq_file: Fix seq_putc() to be consistent with seq_puts()
Message-ID: <20140926143721.52206f95@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that seq_putc() is not consistent with the way seq_puts() is
when it comes to filling the buffer.

Lets look at the two functions doing basically the same thing:

	seq_putc('A');

and

	seq_puts("A");

Now if m->count is 1 less than m->size, the two do different things.
The seq_putc() will write the character, return success, but if a
seq_overflow() is called on the seq_file *m, it will return true.

For seq_puts(), the character is not written, count is set to size, it
returns failure (-1), and like seq_putc(), seq_overflow() will
also return true.

Note, technically, both should act the exact same way, because
seq_puts() does not add the ending null character:

int seq_puts(struct seq_file *m, const char *s)
{
        int len = strlen(s);
        if (m->count + len < m->size) {
                memcpy(m->buf + m->count, s, len);
                m->count += len;
                return 0;
        }
        seq_set_overflow(m);
        return -1;
}

len is just the number of characters in "A" and does not include the
nul terminator. The memcpy, would only copy one character for the
example above. But if m->count is 1 less than m->size, it would not do
the copy and would set the overflow and return failure.

Looking at seq_putc():

int seq_putc(struct seq_file *m, char c)
{
        if (m->count < m->size) {
                m->buf[m->count++] = c;
                return 0;
        }
        return -1;
}

If m->count is one less than m->size, the if condition will succeed,
the buffer will be updated, and success would be returned. But as
overflow is determined by m->count == m->size, that would be true.

Note, I also noticed that seq_puts() behaves slightly different than
other seq_*() functions, in that it does not fill the buffer when it
overflows, but just sets the m->count to size. I'm not sure if this is
incorrect or not as there's bogus data within the buffer that is
encompassed by m->count. This isn't that important as the seq_file()
which uses this code, on overflow, simply frees the entire contents of
m->buf, and updates the size by a power of two the next go around, and
it doesn't care if there's bogus data in an overflowed buffer or not.

But, I'm trying to write code that both the seq_file and trace_seq can
share and these issues will come to the surface and make a difference.

Anyway, this patch is just to make seq_putc() match the behavior of
seq_puts() which does have visibility to the other subsystems.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
diff --git a/fs/seq_file.c b/fs/seq_file.c
index 3857b720cb1b..4cdd900c6a0c 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -686,10 +686,11 @@ EXPORT_SYMBOL(seq_open_private);
 
 int seq_putc(struct seq_file *m, char c)
 {
-	if (m->count < m->size) {
+	if (m->count + 1 < m->size) {
 		m->buf[m->count++] = c;
 		return 0;
 	}
+	seq_set_overflow(m);
 	return -1;
 }
 EXPORT_SYMBOL(seq_putc);
