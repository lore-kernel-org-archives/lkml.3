Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab3LBQAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 11:00:41 -0500
Received: from mail-vb0-f41.google.com ([209.85.212.41]:40226 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab3LBQAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 11:00:39 -0500
MIME-Version: 1.0
Date: Mon, 2 Dec 2013 08:00:38 -0800
X-Google-Sender-Auth: uFNKcwonQ7NAFmJh5a0JK2fy3fk
Message-ID: <CA+55aFyez7uZ6LeXrBRCqJzgJ=w4Xv+CV6QSYp5NkOJ2R9Xang@mail.gmail.com>
Subject: Found it! (was Re: [3.10] Oopses in kmem_cache_allocate() via prepare_creds())
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Simon Kirby <sim@hostway.ca>
Cc: Ian Applegate <ia@cloudflare.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Lameter <cl@gentwo.org>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>
Content-Type: multipart/mixed; boundary=089e013a0b1afa806d04ec8f47e9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e013a0b1afa806d04ec8f47e9
Content-Type: text/plain; charset=UTF-8

On Sat, Nov 30, 2013 at 1:08 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I still don't see what could be wrong with the pipe_inode_info thing,
> but the fact that it's been so consistent in your traces does make me
> suspect it really is *that* particular slab.

I think I finally found it.

I've spent waaayy too much time looking at and thinking about that
code without seeing anything wrong, but this morning I woke up and
thought to myself "What if.."

And looking at the code again, I went "BINGO".

All our reference counting etc seems right, but we have one very
subtle bug: on the freeing path, we have a pattern like this:

        spin_lock(&inode->i_lock);
        if (!--pipe->files) {
                inode->i_pipe = NULL;
                kill = 1;
        }
        spin_unlock(&inode->i_lock);
        __pipe_unlock(pipe);
        if (kill)
                free_pipe_info(pipe);

which on the face of it is trying to be very careful in not accessing
the pipe-info after it is released by having that "kill" flag, and
doing the release last.

And it's complete garbage.

Why?

Because the thread that decrements "pipe->files" *without* releasing
it, will very much access it after it has been dropped: that
"__pipe_unlock(pipe)" happens *after* we've decremented the pipe
reference count and dropped the inode lock. So another CPU can come in
and free the structure concurrently with that __pipe_unlock(pipe).

This happens in two places, and we don't actually need or want the
pipe lock for the pipe->files accesses (since pipe->files is protected
by inode->i_lock, not the pipe lock), so the solution is to just do
the __pipe_unlock() before the whole dance about the pipe->files
reference count.

Patch appended. And no wonder nobody has ever seen it, because the
race is unlikely as hell to ever happen. Simon, I assume it will be
another few months before we can say "yeah, that fixed it", but I
really think this is it. It explains all the symptoms, including
"DEBUG_PAGEALLOC didn't catch it" (because the access happens just as
it is released, and DEBUG_PAGEALLOC takes too long to actually free
unmap the page etc).

                     Linus

--089e013a0b1afa806d04ec8f47e9
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hopwkp6k1

IGZzL3BpcGUuYyB8IDYgKysrKy0tCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAy
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3BpcGUuYyBiL2ZzL3BpcGUuYwppbmRleCBk
MmM0NWUxNGU2ZDguLjE4ZjFhNGIyZGJiYyAxMDA2NDQKLS0tIGEvZnMvcGlwZS5jCisrKyBiL2Zz
L3BpcGUuYwpAQCAtNzQzLDEzICs3NDMsMTQgQEAgcGlwZV9yZWxlYXNlKHN0cnVjdCBpbm9kZSAq
aW5vZGUsIHN0cnVjdCBmaWxlICpmaWxlKQogCQlraWxsX2Zhc3luYygmcGlwZS0+ZmFzeW5jX3Jl
YWRlcnMsIFNJR0lPLCBQT0xMX0lOKTsKIAkJa2lsbF9mYXN5bmMoJnBpcGUtPmZhc3luY193cml0
ZXJzLCBTSUdJTywgUE9MTF9PVVQpOwogCX0KKwlfX3BpcGVfdW5sb2NrKHBpcGUpOworCiAJc3Bp
bl9sb2NrKCZpbm9kZS0+aV9sb2NrKTsKIAlpZiAoIS0tcGlwZS0+ZmlsZXMpIHsKIAkJaW5vZGUt
PmlfcGlwZSA9IE5VTEw7CiAJCWtpbGwgPSAxOwogCX0KIAlzcGluX3VubG9jaygmaW5vZGUtPmlf
bG9jayk7Ci0JX19waXBlX3VubG9jayhwaXBlKTsKIAogCWlmIChraWxsKQogCQlmcmVlX3BpcGVf
aW5mbyhwaXBlKTsKQEAgLTExMzAsMTMgKzExMzEsMTQgQEAgZXJyX3dyOgogCWdvdG8gZXJyOwog
CiBlcnI6CisJX19waXBlX3VubG9jayhwaXBlKTsKKwogCXNwaW5fbG9jaygmaW5vZGUtPmlfbG9j
ayk7CiAJaWYgKCEtLXBpcGUtPmZpbGVzKSB7CiAJCWlub2RlLT5pX3BpcGUgPSBOVUxMOwogCQlr
aWxsID0gMTsKIAl9CiAJc3Bpbl91bmxvY2soJmlub2RlLT5pX2xvY2spOwotCV9fcGlwZV91bmxv
Y2socGlwZSk7CiAJaWYgKGtpbGwpCiAJCWZyZWVfcGlwZV9pbmZvKHBpcGUpOwogCXJldHVybiBy
ZXQ7Cg==
--089e013a0b1afa806d04ec8f47e9--
