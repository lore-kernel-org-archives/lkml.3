Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750961AbaKSFEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 00:04:49 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:38940 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750710AbaKSFEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 00:04:48 -0500
Date: Wed, 19 Nov 2014 00:04:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: Re: [RFC][PATCH 1/3] seq_buf: Move the seq_buf code to lib/
Message-ID: <20141119000445.4b58b1a0@gandalf.local.home>
In-Reply-To: <20141119045555.769701022@goodmis.org>
References: <20141119043917.578498291@goodmis.org>
	<20141119045555.769701022@goodmis.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the changes are based on my branch, the linux/seq_buf.h file was
already existing. Thus it's not in this patch set. It may be important
for you to be able to review that too, so I'm including the file here.

-- Steve

------
#ifndef _LINUX_SEQ_BUF_H
#define _LINUX_SEQ_BUF_H

#include <linux/fs.h>

/*
 * Trace sequences are used to allow a function to call several other functions
 * to create a string of data to use.
 */

/**
 * seq_buf - seq buffer structure
 * @buffer:	pointer to the buffer
 * @size:	size of the buffer
 * @len:	the amount of data inside the buffer
 * @readpos:	The next position to read in the buffer.
 */
struct seq_buf {
	char			*buffer;
	size_t			size;
	size_t			len;
	loff_t			readpos;
};

static inline void seq_buf_clear(struct seq_buf *s)
{
	s->len = 0;
	s->readpos = 0;
}

static inline void
seq_buf_init(struct seq_buf *s, unsigned char *buf, unsigned int size)
{
	s->buffer = buf;
	s->size = size;
	seq_buf_clear(s);
}

/*
 * seq_buf have a buffer that might overflow. When this happens
 * the len and size are set to be equal.
 */
static inline bool
seq_buf_has_overflowed(struct seq_buf *s)
{
	return s->len > s->size;
}

static inline void
seq_buf_set_overflow(struct seq_buf *s)
{
	s->len = s->size + 1;
}

/*
 * How much buffer is left on the seq_buf?
 */
static inline unsigned int
seq_buf_buffer_left(struct seq_buf *s)
{
	if (seq_buf_has_overflowed(s))
		return 0;

	return s->size - s->len;
}

/* How much buffer was written? */
static inline unsigned int seq_buf_used(struct seq_buf *s)
{
	return min(s->len, s->size);
}

/**
 * seq_buf_get_buf - get buffer to write arbitrary data to
 * @s: the seq_buf handle
 * @bufp: the beginning of the buffer is stored here
 *
 * Return the number of bytes available in the buffer, or zero if
 * there's no space.
 */
static inline size_t seq_buf_get_buf(struct seq_buf *s, char **bufp)
{
	WARN_ON(s->len > s->size + 1);

	if (s->len < s->size) {
		*bufp = s->buffer + s->len;
		return s->size - s->len;
	}

	*bufp = NULL;
	return 0;
}

/**
 * seq_buf_commit - commit data to the buffer
 * @s: the seq_buf handle
 * @num: the number of bytes to commit
 *
 * Commit @num bytes of data written to a buffer previously acquired
 * by seq_buf_get.  To signal an error condition, or that the data
 * didn't fit in the available space, pass a negative @num value.
 */
static inline void seq_buf_commit(struct seq_buf *s, int num)
{
	if (num < 0) {
		seq_buf_set_overflow(s);
	} else {
		/* num must be negative on overflow */
		BUG_ON(s->len + num > s->size);
		s->len += num;
	}
}

extern __printf(2, 3)
int seq_buf_printf(struct seq_buf *s, const char *fmt, ...);
extern __printf(2, 0)
int seq_buf_vprintf(struct seq_buf *s, const char *fmt, va_list args);
extern int seq_buf_print_seq(struct seq_file *m, struct seq_buf *s);
extern int seq_buf_to_user(struct seq_buf *s, char __user *ubuf,
			   int cnt);
extern int seq_buf_puts(struct seq_buf *s, const char *str);
extern int seq_buf_putc(struct seq_buf *s, unsigned char c);
extern int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len);
extern int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
			      unsigned int len);
extern int seq_buf_path(struct seq_buf *s, const struct path *path, const char *esc);

extern int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
			   int nmaskbits);

#ifdef CONFIG_BINARY_PRINTF
extern int
seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary);
#endif

#endif /* _LINUX_SEQ_BUF_H */

