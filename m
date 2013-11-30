Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab3K3VI5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 16:08:57 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:39091 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab3K3VIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 16:08:54 -0500
MIME-Version: 1.0
In-Reply-To: <20131130094343.GA12573@hostway.ca>
References: <CAOJsxLGA+Aha8JcPsWyNd3BLQ6L0g7iznN0o2fG5yL5Xw0s8Lg@mail.gmail.com>
	<20130819201717.GA23608@hostway.ca>
	<0000014098447577-0d3e3f6b-f97b-4c73-946d-d70b697ce194-000000@email.amazonses.com>
	<CA+55aFxiYzxLDUnr+9BGQ+fsfmb1T8_zW4fOOC=SQ4rVzwbv4A@mail.gmail.com>
	<20130820040648.GG27005@ZenIV.linux.org.uk>
	<CAEcaRjip29P8TdMHF8zJ3zzsQj7o_B9chEz7Q6xH0Bqtw3A-jg@mail.gmail.com>
	<20130820072143.GJ27005@ZenIV.linux.org.uk>
	<CAEcaRjg7GJhEbQoduup6xQKea4Pn4+SOgv8GbbJUeU=xR74dVQ@mail.gmail.com>
	<20131126004456.GF19648@hostway.ca>
	<CA+55aFxmVteJApiC5e=d9NmYO6PSbNertq5ipLpunmVreCTYUQ@mail.gmail.com>
	<20131130094343.GA12573@hostway.ca>
Date: Sat, 30 Nov 2013 13:08:52 -0800
X-Google-Sender-Auth: ZNHB9_V4rwLN-UULVNOv8F5kZVs
Message-ID: <CA+55aFxrGaWRQTAWxCOtRSUxm4xO6fpv1pgPQyhHU0i3YFJY0w@mail.gmail.com>
Subject: Re: [3.10] Oopses in kmem_cache_allocate() via prepare_creds()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Simon Kirby <sim@hostway.ca>
Cc: Ian Applegate <ia@cloudflare.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Lameter <cl@gentwo.org>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>
Content-Type: multipart/mixed; boundary=047d7b33d0f4aa2d1904ec6b5a52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b33d0f4aa2d1904ec6b5a52
Content-Type: text/plain; charset=UTF-8

On Sat, Nov 30, 2013 at 1:43 AM, Simon Kirby <sim@hostway.ca> wrote:
>
> I turned on kmalloc-192 tracing to find what else is using it: struct
> nfs_fh, struct bio, and struct cred. Poking around those, struct bio has
> bi_cnt, but it is way down in the struct. struct cred has "usage", but it
> comes first.

You could also try to avoid the whole aliasing by using a separate
slab for just the pipe_inode_info.

Something like the attached patch (which also enables debugging just
for that slab).

I still don't see what could be wrong with the pipe_inode_info thing,
but the fact that it's been so consistent in your traces does make me
suspect it really is *that* particular slab. But I dunno, and this
would just confirm it.

                Linus

--047d7b33d0f4aa2d1904ec6b5a52
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_honcqbzv0

IGZzL3BpcGUuYyB8IDIxICsrKysrKysrKysrKysrKystLS0tLQogMSBmaWxlIGNoYW5nZWQsIDE2
IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvcGlwZS5jIGIv
ZnMvcGlwZS5jCmluZGV4IGQyYzQ1ZTE0ZTZkOC4uN2NmZDZjZGYwMTQ3IDEwMDY0NAotLS0gYS9m
cy9waXBlLmMKKysrIGIvZnMvcGlwZS5jCkBAIC03MjksNyArNzI5LDcgQEAgcGlwZV9wb2xsKHN0
cnVjdCBmaWxlICpmaWxwLCBwb2xsX3RhYmxlICp3YWl0KQogc3RhdGljIGludAogcGlwZV9yZWxl
YXNlKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxlKQogewotCXN0cnVjdCBw
aXBlX2lub2RlX2luZm8gKnBpcGUgPSBpbm9kZS0+aV9waXBlOworCXN0cnVjdCBwaXBlX2lub2Rl
X2luZm8gKnBpcGUgPSBmaWxlLT5wcml2YXRlX2RhdGE7CiAJaW50IGtpbGwgPSAwOwogCiAJX19w
aXBlX2xvY2socGlwZSk7CkBAIC03NzYsMTEgKzc3NiwxMyBAQCBwaXBlX2Zhc3luYyhpbnQgZmQs
IHN0cnVjdCBmaWxlICpmaWxwLCBpbnQgb24pCiAJcmV0dXJuIHJldHZhbDsKIH0KIAorc3RhdGlj
IHN0cnVjdCBrbWVtX2NhY2hlICpwaXBlX2luZm9fc2xhYjsKKwogc3RydWN0IHBpcGVfaW5vZGVf
aW5mbyAqYWxsb2NfcGlwZV9pbmZvKHZvaWQpCiB7CiAJc3RydWN0IHBpcGVfaW5vZGVfaW5mbyAq
cGlwZTsKIAotCXBpcGUgPSBremFsbG9jKHNpemVvZihzdHJ1Y3QgcGlwZV9pbm9kZV9pbmZvKSwg
R0ZQX0tFUk5FTCk7CisJcGlwZSA9IGttZW1fY2FjaGVfemFsbG9jKHBpcGVfaW5mb19zbGFiLCBH
RlBfS0VSTkVMKTsKIAlpZiAocGlwZSkgewogCQlwaXBlLT5idWZzID0ga3phbGxvYyhzaXplb2Yo
c3RydWN0IHBpcGVfYnVmZmVyKSAqIFBJUEVfREVGX0JVRkZFUlMsIEdGUF9LRVJORUwpOwogCQlp
ZiAocGlwZS0+YnVmcykgewpAQCAtNzkwLDcgKzc5Miw3IEBAIHN0cnVjdCBwaXBlX2lub2RlX2lu
Zm8gKmFsbG9jX3BpcGVfaW5mbyh2b2lkKQogCQkJbXV0ZXhfaW5pdCgmcGlwZS0+bXV0ZXgpOwog
CQkJcmV0dXJuIHBpcGU7CiAJCX0KLQkJa2ZyZWUocGlwZSk7CisJCWttZW1fY2FjaGVfZnJlZShw
aXBlX2luZm9fc2xhYiwgcGlwZSk7CiAJfQogCiAJcmV0dXJuIE5VTEw7CkBAIC04MDgsNyArODEw
LDcgQEAgdm9pZCBmcmVlX3BpcGVfaW5mbyhzdHJ1Y3QgcGlwZV9pbm9kZV9pbmZvICpwaXBlKQog
CWlmIChwaXBlLT50bXBfcGFnZSkKIAkJX19mcmVlX3BhZ2UocGlwZS0+dG1wX3BhZ2UpOwogCWtm
cmVlKHBpcGUtPmJ1ZnMpOwotCWtmcmVlKHBpcGUpOworCWttZW1fY2FjaGVfZnJlZShwaXBlX2lu
Zm9fc2xhYiwgcGlwZSk7CiB9CiAKIHN0YXRpYyBzdHJ1Y3QgdmZzbW91bnQgKnBpcGVfbW50IF9f
cmVhZF9tb3N0bHk7CkBAIC0xMzExLDggKzEzMTMsMTcgQEAgc3RhdGljIHN0cnVjdCBmaWxlX3N5
c3RlbV90eXBlIHBpcGVfZnNfdHlwZSA9IHsKIAogc3RhdGljIGludCBfX2luaXQgaW5pdF9waXBl
X2ZzKHZvaWQpCiB7Ci0JaW50IGVyciA9IHJlZ2lzdGVyX2ZpbGVzeXN0ZW0oJnBpcGVfZnNfdHlw
ZSk7CisJaW50IGVycjsKKworCXBpcGVfaW5mb19zbGFiID0ga21lbV9jYWNoZV9jcmVhdGUoInBp
cGUtaW5vZGUtaW5mbyIsCisJCXNpemVvZihzdHJ1Y3QgcGlwZV9pbm9kZV9pbmZvKSwKKwkJMCwK
KwkJU0xBQl9SRURfWk9ORSB8IFNMQUJfUE9JU09OIHwgU0xBQl9TVE9SRV9VU0VSIHwgU0xBQl9E
RUJVR19GUkVFLAorCQlOVUxMKTsKKwlpZiAoIXBpcGVfaW5mb19zbGFiKQorCQlyZXR1cm4gLUVO
T01FTTsKIAorCWVyciA9IHJlZ2lzdGVyX2ZpbGVzeXN0ZW0oJnBpcGVfZnNfdHlwZSk7CiAJaWYg
KCFlcnIpIHsKIAkJcGlwZV9tbnQgPSBrZXJuX21vdW50KCZwaXBlX2ZzX3R5cGUpOwogCQlpZiAo
SVNfRVJSKHBpcGVfbW50KSkgewo=
--047d7b33d0f4aa2d1904ec6b5a52--
