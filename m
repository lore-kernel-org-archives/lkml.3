Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934475Ab3CHSaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 13:30:08 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:41173 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759867Ab3CHSaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 13:30:06 -0500
MIME-Version: 1.0
In-Reply-To: <20130308145306.GA24085@redhat.com>
References: <CA+55aFwDYocNRjSCJk1PYw0MFy7dpKf1yMMEiePP--=ewQcX6A@mail.gmail.com>
	<20130307213819.GB19543@redhat.com>
	<CA+55aFx424SX6S1zFegVaMZ_BkeZctDKCN6eYCLFfaJDKRVG9g@mail.gmail.com>
	<20130307220333.GA31039@redhat.com>
	<20130307223610.GA2494@redhat.com>
	<CA+55aFzdPaFQROzFhz-v1Qn=3aDP=4uGTiOJxR26cR91uJHxyg@mail.gmail.com>
	<20130308145306.GA24085@redhat.com>
Date: Fri, 8 Mar 2013 10:30:01 -0800
X-Google-Sender-Auth: Ee3praTkOs24t49RiFVieAZyrPc
Message-ID: <CA+55aFzwOnRnp2B09fKjt8hd9tOCv44H482z1QpCnYc2mywnpA@mail.gmail.com>
Subject: Re: pipe_release oops.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: multipart/mixed; boundary=089e0160c9f2e5e2b804d76e02c1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0160c9f2e5e2b804d76e02c1
Content-Type: text/plain; charset=UTF-8

On Fri, Mar 8, 2013 at 6:53 AM, Dave Jones <davej@redhat.com> wrote:
>
> Yeah, that does the trick.
> I changed your other diff a little to use a goto, which reduces a level of indentation..

Hmm. So I've been trying to figure this out, and I really don't see
it. Every single pipe open routine *should* make sure that the inode
has an inode->i_pipe field. So if the open() has succeeded and you
have a valid file descriptor, the inode->i_pipe thing should be there.

I must be missing something, and I wonder if the thing I'm missing is
that with OPEN_PATH we may now have open calls that don't actually
have FMODE_READ or FMODE_WRITE set at all.

So suddenly we end up with these pipe openers that don't update the
counts, and I could imagine that really confusing us...

So I'm wondering if you could apply this patch, and see if that
triggers. In fact, please un-apply the other changes to fs/pipe.c too,
to see if it also obviates the need for checking i_pipe for NULL. You
should get the new warning (once), but you should not get any oopses..

Anyway, this would explain why the actual read/write paths don't need
to check for i_pipe - if FMODE_READ/WRITE aren't set, we'll never get
that far. But the release() and the fasync functions do get called
even for non-readable and non-writable files...

And Al, please get your email fixed. Is somebody usually on irc with
him or something?

                  Linus

--089e0160c9f2e5e2b804d76e02c1
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_he1oid9z0

IGZzL3BpcGUuYyB8IDQgKysrKwogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKQoKZGlm
ZiAtLWdpdCBhL2ZzL3BpcGUuYyBiL2ZzL3BpcGUuYwppbmRleCA2NGE0OTRjZWYwYTAuLmI3ODg5
YzJlYmFmNCAxMDA2NDQKLS0tIGEvZnMvcGlwZS5jCisrKyBiL2ZzL3BpcGUuYwpAQCAtODYzLDYg
Kzg2MywxMCBAQCBwaXBlX3Jkd3Jfb3BlbihzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmls
ZSAqZmlscCkKIHsKIAlpbnQgcmV0ID0gLUVOT0VOVDsKIAorCS8qIFdlIHJlbHkgb24gdGhlIHBp
cGUgcmVhZGVyL3dyaXRlciBjb3VudHMgdG8ga2VlcCB0cmFjayBvZiB0aGUgcGlwZSAqLworCWlm
IChXQVJOX09OX09OQ0UoIShmaWxwLT5mX21vZGUgJiAoRk1PREVfUkVBRHxGTU9ERV9XUklURSkp
KSkKKwkJcmV0dXJuIC1FSU5WQUw7CisKIAltdXRleF9sb2NrKCZpbm9kZS0+aV9tdXRleCk7CiAK
IAlpZiAoaW5vZGUtPmlfcGlwZSkgewo=
--089e0160c9f2e5e2b804d76e02c1--
