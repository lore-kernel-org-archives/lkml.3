Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbaA2TJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 14:09:25 -0500
Received: from mail-vb0-f53.google.com ([209.85.212.53]:39196 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaA2TJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 14:09:21 -0500
MIME-Version: 1.0
In-Reply-To: <1391013467-7598-1-git-send-email-ilya.dryomov@inktank.com>
References: <CALFYKtDCNWK+9m5m3P01dcxOOV7iHFeNaOH=Q=6Pffuo8gmrMQ@mail.gmail.com>
	<1391013467-7598-1-git-send-email-ilya.dryomov@inktank.com>
Date: Wed, 29 Jan 2014 11:09:18 -0800
X-Google-Sender-Auth: wt6UdAG_aPgYQbUbjg49lSQ5MH8
Message-ID: <CA+55aFwTuBDHgQoTymr8OtE-+k=+pX0T_eb+fff0K+Pa3C-g-Q@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix posix ACL hooks
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ilya Dryomov <ilya.dryomov@inktank.com>
Cc: Sage Weil <sage@inktank.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Guangliang Zhao <lucienchao@gmail.com>,
        Li Wang <li.wang@ubuntykylin.com>, zheng.z.yan@intel.com
Content-Type: multipart/mixed; boundary=047d7b3a946a7d6a1404f120ad72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b3a946a7d6a1404f120ad72
Content-Type: text/plain; charset=UTF-8

On Wed, Jan 29, 2014 at 8:37 AM, Ilya Dryomov <ilya.dryomov@inktank.com> wrote:
> From: Sage Weil <sage@inktank.com>
>
> The merge of 7221fe4c2 raced with upstream changes in the generic POSIX
> ACL code (2aeccbe95).  Update Ceph to use the new helpers as well by
> dropping the now-generic functions and setting the set_acl inode op.
>
> Signed-off-by: Sage Weil <sage@inktank.com>

Ok, I already committed my untested (and broken) patch yesterday,
because even a broken tree is better than a non-*compiling* tree for
testing.

I created a diff from my current tree to this, and will happily apply
it, but the sign-off chain is now broken (Ilya didn't sign off on his
changes to Sage's patch. Not that it really matters for what is really
a one-liner change, but I thought I'd mention it, since another issue
came up with this patch..

Ceph now does

        struct dentry *dentry = d_find_alias(inode);

in its ceph_set_acl() function, and that's because the VFS layer
doesn't pass down the dentry to the acl code any more.

Christoph - that sounds like a misfeature in the new interfaces. I
realize that for traditional unix filesystems, the path is irrelevant
for an inode operation, but the thing is, from a Linux VFS standpoint
and a conceptual standpoint, the dentry really is the more important
and unique one, and some filesystems want the dentry because they are
*correctly* designed to be about pathnames.

Network filesystems that are pass file descriptors around (ie NFS etc)
are not the "RightWay(tm)" of doing things, so I think that it is
quite reasonable for ceph to want the *path* to the inode and not just
the inode.

So attached is the incremental diff of the patch by Sage and Ilya, and
I'll apply it (delayed a bit to see if I can get the sign-off from
Ilya), but I also think we should fix the (non-cached) ACL functions
that call down to the filesystem layer to also get the dentry.

We already do that for the xattr functions, just not for
get_acl()/set_acl()/acl_chmod().

Christoph, Al? Yes, most filesystems will ignore the dentry pointer, but still..

               Linus

--047d7b3a946a7d6a1404f120ad72
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hr0yo2m00

IGZzL2NlcGgvYWNsLmMgICB8IDkgKysrKy0tLS0tCiBmcy9jZXBoL2Rpci5jICAgfCAxICsKIGZz
L2NlcGgvaW5vZGUuYyB8IDIgKysKIGZzL2NlcGgvc3VwZXIuaCB8IDMgKysrCiA0IGZpbGVzIGNo
YW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMv
Y2VwaC9hY2wuYyBiL2ZzL2NlcGgvYWNsLmMKaW5kZXggZjY5MTEyODRjOWJkLi42NmQzNzdhMTJm
N2MgMTAwNjQ0Ci0tLSBhL2ZzL2NlcGgvYWNsLmMKKysrIGIvZnMvY2VwaC9hY2wuYwpAQCAtMTA3
LDE0ICsxMDcsMTQgQEAgc3RydWN0IHBvc2l4X2FjbCAqY2VwaF9nZXRfYWNsKHN0cnVjdCBpbm9k
ZSAqaW5vZGUsIGludCB0eXBlKQogCXJldHVybiBhY2w7CiB9CiAKLXN0YXRpYyBpbnQgY2VwaF9z
ZXRfYWNsKHN0cnVjdCBkZW50cnkgKmRlbnRyeSwgc3RydWN0IGlub2RlICppbm9kZSwKLQkJCQlz
dHJ1Y3QgcG9zaXhfYWNsICphY2wsIGludCB0eXBlKQoraW50IGNlcGhfc2V0X2FjbChzdHJ1Y3Qg
aW5vZGUgKmlub2RlLCBzdHJ1Y3QgcG9zaXhfYWNsICphY2wsIGludCB0eXBlKQogewogCWludCBy
ZXQgPSAwLCBzaXplID0gMDsKIAljb25zdCBjaGFyICpuYW1lID0gTlVMTDsKIAljaGFyICp2YWx1
ZSA9IE5VTEw7CiAJc3RydWN0IGlhdHRyIG5ld2F0dHJzOwogCXVtb2RlX3QgbmV3X21vZGUgPSBp
bm9kZS0+aV9tb2RlLCBvbGRfbW9kZSA9IGlub2RlLT5pX21vZGU7CisJc3RydWN0IGRlbnRyeSAq
ZGVudHJ5ID0gZF9maW5kX2FsaWFzKGlub2RlKTsKIAogCWlmIChhY2wpIHsKIAkJcmV0ID0gcG9z
aXhfYWNsX3ZhbGlkKGFjbCk7CkBAIC0yMDgsOCArMjA4LDcgQEAgaW50IGNlcGhfaW5pdF9hY2wo
c3RydWN0IGRlbnRyeSAqZGVudHJ5LCBzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgaW5vZGUg
KmRpcikKIAogCWlmIChJU19QT1NJWEFDTChkaXIpICYmIGFjbCkgewogCQlpZiAoU19JU0RJUihp
bm9kZS0+aV9tb2RlKSkgewotCQkJcmV0ID0gY2VwaF9zZXRfYWNsKGRlbnRyeSwgaW5vZGUsIGFj
bCwKLQkJCQkJCUFDTF9UWVBFX0RFRkFVTFQpOworCQkJcmV0ID0gY2VwaF9zZXRfYWNsKGlub2Rl
LCBhY2wsIEFDTF9UWVBFX0RFRkFVTFQpOwogCQkJaWYgKHJldCkKIAkJCQlnb3RvIG91dF9yZWxl
YXNlOwogCQl9CkBAIC0yMTcsNyArMjE2LDcgQEAgaW50IGNlcGhfaW5pdF9hY2woc3RydWN0IGRl
bnRyeSAqZGVudHJ5LCBzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgaW5vZGUgKmRpcikKIAkJ
aWYgKHJldCA8IDApCiAJCQlnb3RvIG91dDsKIAkJZWxzZSBpZiAocmV0ID4gMCkKLQkJCXJldCA9
IGNlcGhfc2V0X2FjbChkZW50cnksIGlub2RlLCBhY2wsIEFDTF9UWVBFX0FDQ0VTUyk7CisJCQly
ZXQgPSBjZXBoX3NldF9hY2woaW5vZGUsIGFjbCwgQUNMX1RZUEVfQUNDRVNTKTsKIAkJZWxzZQog
CQkJY2FjaGVfbm9fYWNsKGlub2RlKTsKIAl9IGVsc2UgewpkaWZmIC0tZ2l0IGEvZnMvY2VwaC9k
aXIuYyBiL2ZzL2NlcGgvZGlyLmMKaW5kZXggNjE5NjE2ZDU4NWIwLi42ZGE0ZGY4NGJhMzAgMTAw
NjQ0Ci0tLSBhL2ZzL2NlcGgvZGlyLmMKKysrIGIvZnMvY2VwaC9kaXIuYwpAQCAtMTMwMyw2ICsx
MzAzLDcgQEAgY29uc3Qgc3RydWN0IGlub2RlX29wZXJhdGlvbnMgY2VwaF9kaXJfaW9wcyA9IHsK
IAkubGlzdHhhdHRyID0gY2VwaF9saXN0eGF0dHIsCiAJLnJlbW92ZXhhdHRyID0gY2VwaF9yZW1v
dmV4YXR0ciwKIAkuZ2V0X2FjbCA9IGNlcGhfZ2V0X2FjbCwKKwkuc2V0X2FjbCA9IGNlcGhfc2V0
X2FjbCwKIAkubWtub2QgPSBjZXBoX21rbm9kLAogCS5zeW1saW5rID0gY2VwaF9zeW1saW5rLAog
CS5ta2RpciA9IGNlcGhfbWtkaXIsCmRpZmYgLS1naXQgYS9mcy9jZXBoL2lub2RlLmMgYi9mcy9j
ZXBoL2lub2RlLmMKaW5kZXggOGI4YjUwNjYzNmNjLi4zMmQ1MTlkOGEyZTIgMTAwNjQ0Ci0tLSBh
L2ZzL2NlcGgvaW5vZGUuYworKysgYi9mcy9jZXBoL2lub2RlLmMKQEAgLTk3LDYgKzk3LDcgQEAg
Y29uc3Qgc3RydWN0IGlub2RlX29wZXJhdGlvbnMgY2VwaF9maWxlX2lvcHMgPSB7CiAJLmxpc3R4
YXR0ciA9IGNlcGhfbGlzdHhhdHRyLAogCS5yZW1vdmV4YXR0ciA9IGNlcGhfcmVtb3ZleGF0dHIs
CiAJLmdldF9hY2wgPSBjZXBoX2dldF9hY2wsCisJLnNldF9hY2wgPSBjZXBoX3NldF9hY2wsCiB9
OwogCiAKQEAgLTE2MTYsNiArMTYxNyw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgaW5vZGVfb3Bl
cmF0aW9ucyBjZXBoX3N5bWxpbmtfaW9wcyA9IHsKIAkubGlzdHhhdHRyID0gY2VwaF9saXN0eGF0
dHIsCiAJLnJlbW92ZXhhdHRyID0gY2VwaF9yZW1vdmV4YXR0ciwKIAkuZ2V0X2FjbCA9IGNlcGhf
Z2V0X2FjbCwKKwkuc2V0X2FjbCA9IGNlcGhfc2V0X2FjbCwKIH07CiAKIC8qCmRpZmYgLS1naXQg
YS9mcy9jZXBoL3N1cGVyLmggYi9mcy9jZXBoL3N1cGVyLmgKaW5kZXggMzQ1OTMzOTQ4YjZlLi5h
YTI2MDU5MGY2MTUgMTAwNjQ0Ci0tLSBhL2ZzL2NlcGgvc3VwZXIuaAorKysgYi9mcy9jZXBoL3N1
cGVyLmgKQEAgLTcxOCw2ICs3MTgsNyBAQCBleHRlcm4gdm9pZCBjZXBoX3F1ZXVlX3dyaXRlYmFj
ayhzdHJ1Y3QgaW5vZGUgKmlub2RlKTsKIGV4dGVybiBpbnQgY2VwaF9kb19nZXRhdHRyKHN0cnVj
dCBpbm9kZSAqaW5vZGUsIGludCBtYXNrKTsKIGV4dGVybiBpbnQgY2VwaF9wZXJtaXNzaW9uKHN0
cnVjdCBpbm9kZSAqaW5vZGUsIGludCBtYXNrKTsKIGV4dGVybiBpbnQgY2VwaF9zZXRhdHRyKHN0
cnVjdCBkZW50cnkgKmRlbnRyeSwgc3RydWN0IGlhdHRyICphdHRyKTsKK2V4dGVybiBpbnQgY2Vw
aF9zZXRhdHRyKHN0cnVjdCBkZW50cnkgKmRlbnRyeSwgc3RydWN0IGlhdHRyICphdHRyKTsKIGV4
dGVybiBpbnQgY2VwaF9nZXRhdHRyKHN0cnVjdCB2ZnNtb3VudCAqbW50LCBzdHJ1Y3QgZGVudHJ5
ICpkZW50cnksCiAJCQlzdHJ1Y3Qga3N0YXQgKnN0YXQpOwogCkBAIC03NDEsMTIgKzc0MiwxNCBA
QCBleHRlcm4gY29uc3Qgc3RydWN0IHhhdHRyX2hhbmRsZXIgKmNlcGhfeGF0dHJfaGFuZGxlcnNb
XTsKICNpZmRlZiBDT05GSUdfQ0VQSF9GU19QT1NJWF9BQ0wKIAogc3RydWN0IHBvc2l4X2FjbCAq
Y2VwaF9nZXRfYWNsKHN0cnVjdCBpbm9kZSAqLCBpbnQpOworaW50IGNlcGhfc2V0X2FjbChzdHJ1
Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgcG9zaXhfYWNsICphY2wsIGludCB0eXBlKTsKIGludCBj
ZXBoX2luaXRfYWNsKHN0cnVjdCBkZW50cnkgKiwgc3RydWN0IGlub2RlICosIHN0cnVjdCBpbm9k
ZSAqKTsKIHZvaWQgY2VwaF9mb3JnZXRfYWxsX2NhY2hlZF9hY2xzKHN0cnVjdCBpbm9kZSAqaW5v
ZGUpOwogCiAjZWxzZQogCiAjZGVmaW5lIGNlcGhfZ2V0X2FjbCBOVUxMCisjZGVmaW5lIGNlcGhf
c2V0X2FjbCBOVUxMCiAKIHN0YXRpYyBpbmxpbmUgaW50IGNlcGhfaW5pdF9hY2woc3RydWN0IGRl
bnRyeSAqZGVudHJ5LCBzdHJ1Y3QgaW5vZGUgKmlub2RlLAogCQkJCXN0cnVjdCBpbm9kZSAqZGly
KQo=
--047d7b3a946a7d6a1404f120ad72--
