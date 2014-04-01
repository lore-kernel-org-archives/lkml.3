Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaDANQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:16:11 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:56180 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaDANQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:16:06 -0400
Date: Tue, 1 Apr 2014 15:15:59 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "zab@redhat.com" <zab@redhat.com>
Subject: Re: splicing pages to the same file
Message-ID: <20140401131559.GB10187@tucsk.piliscsaba.szeredi.hu>
References: <20140325150017.GA2336@tucsk.piliscsaba.szeredi.hu>
 <CA+55aFw+xsZYME=L6pwfTQGX20ZNmMiqn5P-W90Y62quqa_qpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw+xsZYME=L6pwfTQGX20ZNmMiqn5P-W90Y62quqa_qpA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2014 at 10:17:35AM -0700, Linus Torvalds wrote:
> On Tue, Mar 25, 2014 at 8:00 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > In pipe_to_file() I noticed the "if (buf->page != page)" and started
> > thinking about this.  What should be the correct behavior?
> 
> I don't think we can have "correct" behavior, because no such behavior exists.
> 
> It's very much like memcpy() with the destination and source
> overlapping. And as you noticed, doing it as a "memmove()" in
> pipe_to_file() wouldn't help, because since we block this up by pages,
> there will still be a potential overlap across subsequent page
> fragments.
> 
> So I think the only reasonable option is to document the fact that
> splicing from a file to itself falls under the "you're insane, it may
> or may not do what you want". And since it depends on page size and on
> which order we move pages around in etc, the rule should simply be
> that you cannot sanely expect a splice from a file to itself to work.
> Regardless of any actual byte range overlap details. "Don't do it".

Returning EINVAL is a good way to start documenting.  I don't like the way it
does something silly without any indication that it's a "Don't do it" category.

> Now, we *could* make it work when there isn't any overlap. Right now,
> if you splice from a file to itself within the same page, we'll always
> just say "screw you", but we could look at the offset too. That
> wouldn't make a true overlap work (you could still have overlap that
> we'd miss because within one part of a page it wouldn't look like
> overlap to us since we only see this one page fragment at a time), but
> we could try to make the case where there is no true overlap always
> work reliably.

Yes, and we could even make the overlapping write work reliably, as long as the
destination offset is smaller than the source offset, since we are always
iterating the pages in the forward direction.

The problem is that there's no easy way to detect if what we do is sane or not.

So I propose leaving it as it is, but returning EINVAL for the same page case.
That is very unlikely to break anything that isn't already broken.

Thanks,
Miklos
----

diff --git a/fs/splice.c b/fs/splice.c
index 12028fa41def..8ab9f9cf8a8d 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -750,10 +750,10 @@ int pipe_to_file(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 {
 	struct file *file = sd->u.file;
 	struct address_space *mapping = file->f_mapping;
-	unsigned int offset, this_len;
+	unsigned int offset, this_len, copied;
 	struct page *page;
 	void *fsdata;
-	int ret;
+	int ret, error = 0;
 
 	offset = sd->pos & ~PAGE_CACHE_MASK;
 
@@ -774,10 +774,23 @@ int pipe_to_file(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 		flush_dcache_page(page);
 		kunmap_atomic(dst);
 		buf->ops->unmap(pipe, buf, src);
+		copied = this_len;
+	} else {
+		/*
+		 * Source and destination page is the same.
+		 *
+		 * Historically this page was just silently skipped.  Return
+		 * EINVAL instead, to let the caller know that we don't support
+		 * this.
+		 */
+		copied = 0;
+		error = -EINVAL;
 	}
-	ret = pagecache_write_end(file, mapping, sd->pos, this_len, this_len,
+	ret = pagecache_write_end(file, mapping, sd->pos, this_len, copied,
 				page, fsdata);
 out:
+	if (!ret && error)
+		return error;
 	return ret;
 }
 EXPORT_SYMBOL(pipe_to_file);
