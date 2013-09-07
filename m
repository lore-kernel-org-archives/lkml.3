Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750902Ab3IGXea (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 19:34:30 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:56768 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab3IGXe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 19:34:28 -0400
MIME-Version: 1.0
Date: Sat, 7 Sep 2013 16:34:27 -0700
X-Google-Sender-Auth: yErl1dWhG-HXVm1QX10ATbXbJ9k
Message-ID: <CA+55aFwwvxHnJTFrqMGjjR_uXLOzPs0zucEL=x4D9TapWRyGfA@mail.gmail.com>
Subject: Adding concept of "dead" references to lockref
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>, Waiman Long <Waiman.Long@hp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: multipart/mixed; boundary=047d7bd6adfe95a9f404e5d398bd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7bd6adfe95a9f404e5d398bd
Content-Type: text/plain; charset=UTF-8

Ok, I added the notion of having a dead entry to lockref, because it
simplifies the dcache code a bit. I committed and pushed out the
actual lockref infrastructure, but the actual dcache *use* of that
infrastructure is probably too late for 3.12, or at least it needs
some discussion.

I'm attaching the patch here (but it needs _current_ git as of not
very long ago for the new "dead lockref" support). It simplifies both
the actual killing of dentries (we used to pass this "ref" thing
around to show whether we held the last ref to the dentry or not, this
makes it pointless because we'll just overwrite the refcount anyway)
and it particularly simplifies the getting the reference for the RCU
case, because the whole "it's valid but we couldn't tell" case is
gone.

Comments? It doesn't matter for my insane test-case, since that one
was either looking at a directory with non-zero refcount to begin
with, and even if you looked up a regular file, all the other people
looking it up would guarantee that non-zero refcount. But it basically
makes the (common) special case of "we got the dentry d_lock because
we're looking up a file that nobody else had actively open yet", and
now that's just a reference count operation too.

Simpler code and one less special case sounds like a good thing to me.

                 Linus

--047d7bd6adfe95a9f404e5d398bd
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hlbgqig00

IGZzL2RjYWNoZS5jIHwgMTcgKysrKysrKysrKy0tLS0tLS0KIGZzL25hbWVpLmMgIHwgMjMgKysr
KystLS0tLS0tLS0tLS0tLS0tLS0KIDIgZmlsZXMgY2hhbmdlZCwgMTUgaW5zZXJ0aW9ucygrKSwg
MjUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvZGNhY2hlLmMgYi9mcy9kY2FjaGUuYwpp
bmRleCA3NjFlMzFiYWNiYzIuLmFiMzRiZmM0ZDE5OSAxMDA2NDQKLS0tIGEvZnMvZGNhY2hlLmMK
KysrIGIvZnMvZGNhY2hlLmMKQEAgLTIyOSw3ICsyMjksNyBAQCBzdGF0aWMgdm9pZCBfX2RfZnJl
ZShzdHJ1Y3QgcmN1X2hlYWQgKmhlYWQpCiAgKi8KIHN0YXRpYyB2b2lkIGRfZnJlZShzdHJ1Y3Qg
ZGVudHJ5ICpkZW50cnkpCiB7Ci0JQlVHX09OKGRlbnRyeS0+ZF9sb2NrcmVmLmNvdW50KTsKKwlC
VUdfT04oKGludClkZW50cnktPmRfbG9ja3JlZi5jb3VudCA+IDApOwogCXRoaXNfY3B1X2RlYyhu
cl9kZW50cnkpOwogCWlmIChkZW50cnktPmRfb3AgJiYgZGVudHJ5LT5kX29wLT5kX3JlbGVhc2Up
CiAJCWRlbnRyeS0+ZF9vcC0+ZF9yZWxlYXNlKGRlbnRyeSk7CkBAIC00NDMsNyArNDQzLDcgQEAg
RVhQT1JUX1NZTUJPTChkX2Ryb3ApOwogICogSWYgcmVmIGlzIG5vbi16ZXJvLCB0aGVuIGRlY3Jl
bWVudCB0aGUgcmVmY291bnQgdG9vLgogICogUmV0dXJucyBkZW50cnkgcmVxdWlyaW5nIHJlZmNv
dW50IGRyb3AsIG9yIE5VTEwgaWYgd2UncmUgZG9uZS4KICAqLwotc3RhdGljIGlubGluZSBzdHJ1
Y3QgZGVudHJ5ICpkZW50cnlfa2lsbChzdHJ1Y3QgZGVudHJ5ICpkZW50cnksIGludCByZWYpCitz
dGF0aWMgaW5saW5lIHN0cnVjdCBkZW50cnkgKmRlbnRyeV9raWxsKHN0cnVjdCBkZW50cnkgKmRl
bnRyeSkKIAlfX3JlbGVhc2VzKGRlbnRyeS0+ZF9sb2NrKQogewogCXN0cnVjdCBpbm9kZSAqaW5v
ZGU7CkBAIC00NjYsOCArNDY2LDExIEBAIHJlbG9jazoKIAkJZ290byByZWxvY2s7CiAJfQogCi0J
aWYgKHJlZikKLQkJZGVudHJ5LT5kX2xvY2tyZWYuY291bnQtLTsKKwkvKgorCSAqIFRoZSBkZW50
cnkgaXMgbm93IHVucmVjb3ZlcmFibHkgZGVhZCB0byB0aGUgd29ybGQuCisJICovCisJbG9ja3Jl
Zl9tYXJrX2RlYWQoJmRlbnRyeS0+ZF9sb2NrcmVmKTsKKwogCS8qCiAJICogaW5mb3JtIHRoZSBm
cyB2aWEgZF9wcnVuZSB0aGF0IHRoaXMgZGVudHJ5IGlzIGFib3V0IHRvIGJlCiAJICogdW5oYXNo
ZWQgYW5kIGRlc3Ryb3llZC4KQEAgLTUzNSw3ICs1MzgsNyBAQCByZXBlYXQ6CiAJcmV0dXJuOwog
CiBraWxsX2l0OgotCWRlbnRyeSA9IGRlbnRyeV9raWxsKGRlbnRyeSwgMSk7CisJZGVudHJ5ID0g
ZGVudHJ5X2tpbGwoZGVudHJ5KTsKIAlpZiAoZGVudHJ5KQogCQlnb3RvIHJlcGVhdDsKIH0KQEAg
LTc2MCw3ICs3NjMsNyBAQCBzdGF0aWMgdm9pZCB0cnlfcHJ1bmVfb25lX2RlbnRyeShzdHJ1Y3Qg
ZGVudHJ5ICpkZW50cnkpCiB7CiAJc3RydWN0IGRlbnRyeSAqcGFyZW50OwogCi0JcGFyZW50ID0g
ZGVudHJ5X2tpbGwoZGVudHJ5LCAwKTsKKwlwYXJlbnQgPSBkZW50cnlfa2lsbChkZW50cnkpOwog
CS8qCiAJICogSWYgZGVudHJ5X2tpbGwgcmV0dXJucyBOVUxMLCB3ZSBoYXZlIG5vdGhpbmcgbW9y
ZSB0byBkby4KIAkgKiBpZiBpdCByZXR1cm5zIHRoZSBzYW1lIGRlbnRyeSwgdHJ5bG9ja3MgZmFp
bGVkLiBJbiBlaXRoZXIKQEAgLTc4MSw3ICs3ODQsNyBAQCBzdGF0aWMgdm9pZCB0cnlfcHJ1bmVf
b25lX2RlbnRyeShzdHJ1Y3QgZGVudHJ5ICpkZW50cnkpCiAJd2hpbGUgKGRlbnRyeSkgewogCQlp
ZiAobG9ja3JlZl9wdXRfb3JfbG9jaygmZGVudHJ5LT5kX2xvY2tyZWYpKQogCQkJcmV0dXJuOwot
CQlkZW50cnkgPSBkZW50cnlfa2lsbChkZW50cnksIDEpOworCQlkZW50cnkgPSBkZW50cnlfa2ls
bChkZW50cnkpOwogCX0KIH0KIApkaWZmIC0tZ2l0IGEvZnMvbmFtZWkuYyBiL2ZzL25hbWVpLmMK
aW5kZXggZjQxNWM2NjgzYTgzLi5jYzRiY2ZhYTg2MjQgMTAwNjQ0Ci0tLSBhL2ZzL25hbWVpLmMK
KysrIGIvZnMvbmFtZWkuYwpAQCAtNTE3LDI1ICs1MTcsMTIgQEAgc3RhdGljIGlubGluZSB2b2lk
IHVubG9ja19yY3Vfd2Fsayh2b2lkKQogICovCiBzdGF0aWMgaW5saW5lIGludCBkX3JjdV90b19y
ZWZjb3VudChzdHJ1Y3QgZGVudHJ5ICpkZW50cnksIHNlcWNvdW50X3QgKnZhbGlkYXRlLCB1bnNp
Z25lZCBzZXEpCiB7Ci0JaW50IGdvdHJlZjsKLQotCWdvdHJlZiA9IGxvY2tyZWZfZ2V0X29yX2xv
Y2soJmRlbnRyeS0+ZF9sb2NrcmVmKTsKLQotCS8qIERvZXMgdGhlIHNlcXVlbmNlIG51bWJlciBz
dGlsbCBtYXRjaD8gKi8KLQlpZiAocmVhZF9zZXFjb3VudF9yZXRyeSh2YWxpZGF0ZSwgc2VxKSkg
ewotCQlpZiAoZ290cmVmKQotCQkJZHB1dChkZW50cnkpOwotCQllbHNlCi0JCQlzcGluX3VubG9j
aygmZGVudHJ5LT5kX2xvY2spOwotCQlyZXR1cm4gLUVDSElMRDsKLQl9Ci0KLQkvKiBHZXQgdGhl
IHJlZiBub3csIGlmIHdlIGNvdWxkbid0IGdldCBpdCBvcmlnaW5hbGx5ICovCi0JaWYgKCFnb3Ry
ZWYpIHsKLQkJZGVudHJ5LT5kX2xvY2tyZWYuY291bnQrKzsKLQkJc3Bpbl91bmxvY2soJmRlbnRy
eS0+ZF9sb2NrKTsKKwlpZiAobGlrZWx5KGxvY2tyZWZfZ2V0X25vdF9kZWFkKCZkZW50cnktPmRf
bG9ja3JlZikpKSB7CisJCWlmICghcmVhZF9zZXFjb3VudF9yZXRyeSh2YWxpZGF0ZSwgc2VxKSkK
KwkJCQlyZXR1cm4gMDsKKwkJZHB1dChkZW50cnkpOwogCX0KLQlyZXR1cm4gMDsKKwlyZXR1cm4g
LUVDSElMRDsKIH0KIAogLyoqCg==
--047d7bd6adfe95a9f404e5d398bd--
