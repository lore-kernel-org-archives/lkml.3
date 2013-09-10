Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab3IJTBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 15:01:25 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:53684 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3IJTBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 15:01:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130910184324.GY13318@ZenIV.linux.org.uk>
References: <CA+5PVA4k9tTPs9vtTbMuG7pzw4kb3KFK-CLaqDDG4dm=0twyCQ@mail.gmail.com>
	<CA+55aFzg_r2c09TkGwmsMV3HbNAkSFJLGAFWweLNzofqs4o4Ug@mail.gmail.com>
	<CA+5PVA6EDV3zuDEyCvcGNvEAPtgY_Oy9xVbaM03ggRBPtq5Mmg@mail.gmail.com>
	<CA+55aFympAk-hnekaew8po5wLJdiY+DC_b4h=pa-y5i9=s303Q@mail.gmail.com>
	<CA+55aFygRtwwknO4Jb+nna046VhdNCXh2S0ybRBPf=b1GH9FPg@mail.gmail.com>
	<20130910184324.GY13318@ZenIV.linux.org.uk>
Date: Tue, 10 Sep 2013 12:01:22 -0700
X-Google-Sender-Auth: x07dxMuy0rBnqyYhjDIf8Wb9D-E
Message-ID: <CA+55aFwFQei-j47xZU06MZZ+S2ki2-dyi=7b7+U+QX_3FAYevQ@mail.gmail.com>
Subject: Re: kernel BUG at fs/dcache.c:648! with v3.11-7890-ge5c832d
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Josh Boyer <jwboyer@gmail.com>, Waiman Long <Waiman.Long@hp.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Mace Moneta <moneta.mace@gmail.com>
Content-Type: multipart/mixed; boundary=047d7b6d8cc882fb5604e60c2165
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b6d8cc882fb5604e60c2165
Content-Type: text/plain; charset=UTF-8

On Tue, Sep 10, 2013 at 11:43 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> !LOOKUP_ROOT: we set nd->root the first time we need / (in the very
> beginning if it's an absolute pathname, on the first absolute symlink
> otherwise).  In non-RCU mode we hold a reference to it; in RCU mode
> we do not.  As the result, leaving RCU mode should either grab
> a reference to the damn thing (if we intend to go on) or zero it out.

Yeah, that was what I was thinking. But in particular, I was wondering
if we could simplify unlazy_walk() to _not_ take that root reference
at all, and just always zero it out even if we succeed.

IOW, doing the attached patch (_instead_ of the one I sent out).

Or is there something in path lookup retrying that might get uphappy
if we go back to a NULL root.mnt, and doesn't check it?

Because this patch actually simplifies that nasty/complex
unlazy_walk() a lot, and makes it much more understnadable, I think.
It always looked really odd to me how it used to do "if LOOKUP_ROOT is
_not_ set, let's take a reference count to the root"). With this patch
in place, I really like how straightforward unlazy_walk() is. That
used to be just about _the_ most subtle part of the whole
rcu-to-refcount thing (as demonstrated by the number of bugs it has
exposed in the patches), and now it looks almost trivial.

Mace - ignore this newer patch for now, the one I want you to test is
the minimal one you already have, not this cleanup one. But since you
clearly saw the problem I never did, if you get bored _after_ testing
the first patch, feel free to give this one a whirl too. But notice
that this patch is a replacement for - not in addition to - the first
one.

             Linus

--047d7b6d8cc882fb5604e60c2165
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hlfhhwcl0

IGZzL25hbWVpLmMgfCAxNyArKy0tLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5z
ZXJ0aW9ucygrKSwgMTUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvbmFtZWkuYyBiL2Zz
L25hbWVpLmMKaW5kZXggNTZlNGY0ZDUzN2QwLi44YzZjOTRhYmE4ODAgMTAwNjQ0Ci0tLSBhL2Zz
L25hbWVpLmMKKysrIGIvZnMvbmFtZWkuYwpAQCAtNTA2LDcgKzUwNiw2IEBAIHN0YXRpYyBpbmxp
bmUgdm9pZCB1bmxvY2tfcmN1X3dhbGsodm9pZCkKICAqLwogc3RhdGljIGludCB1bmxhenlfd2Fs
ayhzdHJ1Y3QgbmFtZWlkYXRhICpuZCwgc3RydWN0IGRlbnRyeSAqZGVudHJ5KQogewotCXN0cnVj
dCBmc19zdHJ1Y3QgKmZzID0gY3VycmVudC0+ZnM7CiAJc3RydWN0IGRlbnRyeSAqcGFyZW50ID0g
bmQtPnBhdGguZGVudHJ5OwogCiAJQlVHX09OKCEobmQtPmZsYWdzICYgTE9PS1VQX1JDVSkpOwpA
QCAtNTMxLDYgKzUzMCw4IEBAIHN0YXRpYyBpbnQgdW5sYXp5X3dhbGsoc3RydWN0IG5hbWVpZGF0
YSAqbmQsIHN0cnVjdCBkZW50cnkgKmRlbnRyeSkKIAkgKi8KIAltbnRnZXQobmQtPnBhdGgubW50
KTsKIAluZC0+ZmxhZ3MgJj0gfkxPT0tVUF9SQ1U7CisJaWYgKCEobmQtPmZsYWdzICYgTE9PS1VQ
X1JPT1QpKQorCQluZC0+cm9vdC5tbnQgPSBOVUxMOwogCiAJLyoKIAkgKiBGb3IgYSBuZWdhdGl2
ZSBsb29rdXAsIHRoZSBsb29rdXAgc2VxdWVuY2UgcG9pbnQgaXMgdGhlIHBhcmVudHMKQEAgLTU1
NCwyMyArNTU1LDkgQEAgc3RhdGljIGludCB1bmxhenlfd2FsayhzdHJ1Y3QgbmFtZWlkYXRhICpu
ZCwgc3RydWN0IGRlbnRyeSAqZGVudHJ5KQogCQkJZ290byBkcm9wX2RlbnRyeTsKIAl9CiAKLQkv
KgotCSAqIFNlcXVlbmNlIGNvdW50cyBtYXRjaGVkLiBOb3cgbWFrZSBzdXJlIHRoYXQgdGhlIHJv
b3QgaXMKLQkgKiBzdGlsbCB2YWxpZCBhbmQgZ2V0IGl0IGlmIHJlcXVpcmVkLgotCSAqLwotCWlm
IChuZC0+cm9vdC5tbnQgJiYgIShuZC0+ZmxhZ3MgJiBMT09LVVBfUk9PVCkpIHsKLQkJc3Bpbl9s
b2NrKCZmcy0+bG9jayk7Ci0JCWlmIChuZC0+cm9vdC5tbnQgIT0gZnMtPnJvb3QubW50IHx8IG5k
LT5yb290LmRlbnRyeSAhPSBmcy0+cm9vdC5kZW50cnkpCi0JCQlnb3RvIHVubG9ja19hbmRfZHJv
cF9kZW50cnk7Ci0JCXBhdGhfZ2V0KCZuZC0+cm9vdCk7Ci0JCXNwaW5fdW5sb2NrKCZmcy0+bG9j
ayk7Ci0JfQotCiAJdW5sb2NrX3JjdV93YWxrKCk7CiAJcmV0dXJuIDA7CiAKLXVubG9ja19hbmRf
ZHJvcF9kZW50cnk6Ci0Jc3Bpbl91bmxvY2soJmZzLT5sb2NrKTsKIGRyb3BfZGVudHJ5OgogCXVu
bG9ja19yY3Vfd2FsaygpOwogCWRwdXQoZGVudHJ5KTsK
--047d7b6d8cc882fb5604e60c2165--
