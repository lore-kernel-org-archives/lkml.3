Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339Ab3KZXo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 18:44:29 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:46233 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab3KZXo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 18:44:27 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxmVteJApiC5e=d9NmYO6PSbNertq5ipLpunmVreCTYUQ@mail.gmail.com>
References: <20130706000949.GD16853@hostway.ca>
	<CAOJsxLGA+Aha8JcPsWyNd3BLQ6L0g7iznN0o2fG5yL5Xw0s8Lg@mail.gmail.com>
	<20130819201717.GA23608@hostway.ca>
	<0000014098447577-0d3e3f6b-f97b-4c73-946d-d70b697ce194-000000@email.amazonses.com>
	<CA+55aFxiYzxLDUnr+9BGQ+fsfmb1T8_zW4fOOC=SQ4rVzwbv4A@mail.gmail.com>
	<20130820040648.GG27005@ZenIV.linux.org.uk>
	<CAEcaRjip29P8TdMHF8zJ3zzsQj7o_B9chEz7Q6xH0Bqtw3A-jg@mail.gmail.com>
	<20130820072143.GJ27005@ZenIV.linux.org.uk>
	<CAEcaRjg7GJhEbQoduup6xQKea4Pn4+SOgv8GbbJUeU=xR74dVQ@mail.gmail.com>
	<20131126004456.GF19648@hostway.ca>
	<CA+55aFxmVteJApiC5e=d9NmYO6PSbNertq5ipLpunmVreCTYUQ@mail.gmail.com>
Date: Tue, 26 Nov 2013 15:44:26 -0800
X-Google-Sender-Auth: zHAp_TklkIepueHquDd99cnbZvU
Message-ID: <CA+55aFx8U4R9+wefpStwgXjTY+LoP0LJUa3eVCV2PK6MJWKBUw@mail.gmail.com>
Subject: Re: [3.10] Oopses in kmem_cache_allocate() via prepare_creds()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Simon Kirby <sim@hostway.ca>
Cc: Ian Applegate <ia@cloudflare.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Lameter <cl@gentwo.org>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>
Content-Type: multipart/mixed; boundary=047d7b2ed34195158204ec1d0f88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b2ed34195158204ec1d0f88
Content-Type: text/plain; charset=UTF-8

On Tue, Nov 26, 2013 at 3:16 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'm really not very happy with the whole pipe locking logic (or the
> refcounting we do, separately from the "struct inode"), and in that
> sense I'm perfectly willing to blame that code for doing bad things.
> But the fact that it all goes away with debugging makes me very very
> unhappy.

Al, I really hate the "pipe_lock()" function that tests for
"pipe->files" being non-zero. I don't think there are any valid cases
where pipe->file ever *could* be zero, and if there are, they are
fundamentally racy.

Is there really any reason for that test? It used to test for
"pipe->inode" and that kind of made sense as the pipe didn't even have
a lock (it re-used the inode one). But these days that test makes zero
sense, except as a "don't even bother locking if this is some fake
internal pipe", but is that even valid?

Also, why does "pipe_release()" still use i_pipe. I'd much rather it
used "file->private_data" like everything else (and then it
unconditionally clear it). We are, after all, talking about releasing
the *file*, and we shouldn't be mixing up that inode in there.

IOW, what is wrong with the attached patch? Then we could/should

 - make the free_pipe_info() happen from the drop_inode()

 - delete pipe->files counter entirely because it has no valid use

Hmm?

                 Linus

--047d7b2ed34195158204ec1d0f88
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hohsk5030

IGZzL3BpcGUuYyB8IDExICsrKysrKy0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25z
KCspLCA1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3BpcGUuYyBiL2ZzL3BpcGUuYwpp
bmRleCBkMmM0NWUxNGU2ZDguLjcxOTIxNGVkNWU1ZSAxMDA2NDQKLS0tIGEvZnMvcGlwZS5jCisr
KyBiL2ZzL3BpcGUuYwpAQCAtNTYsOCArNTYsOCBAQCB1bnNpZ25lZCBpbnQgcGlwZV9taW5fc2l6
ZSA9IFBBR0VfU0laRTsKIAogc3RhdGljIHZvaWQgcGlwZV9sb2NrX25lc3RlZChzdHJ1Y3QgcGlw
ZV9pbm9kZV9pbmZvICpwaXBlLCBpbnQgc3ViY2xhc3MpCiB7Ci0JaWYgKHBpcGUtPmZpbGVzKQot
CQltdXRleF9sb2NrX25lc3RlZCgmcGlwZS0+bXV0ZXgsIHN1YmNsYXNzKTsKKwlXQVJOX09OX09O
Q0UoIXBpcGUtPmZpbGVzKTsKKwltdXRleF9sb2NrX25lc3RlZCgmcGlwZS0+bXV0ZXgsIHN1YmNs
YXNzKTsKIH0KIAogdm9pZCBwaXBlX2xvY2soc3RydWN0IHBpcGVfaW5vZGVfaW5mbyAqcGlwZSkK
QEAgLTcxLDggKzcxLDggQEAgRVhQT1JUX1NZTUJPTChwaXBlX2xvY2spOwogCiB2b2lkIHBpcGVf
dW5sb2NrKHN0cnVjdCBwaXBlX2lub2RlX2luZm8gKnBpcGUpCiB7Ci0JaWYgKHBpcGUtPmZpbGVz
KQotCQltdXRleF91bmxvY2soJnBpcGUtPm11dGV4KTsKKwlXQVJOX09OX09OQ0UoIXBpcGUtPmZp
bGVzKTsKKwltdXRleF91bmxvY2soJnBpcGUtPm11dGV4KTsKIH0KIEVYUE9SVF9TWU1CT0wocGlw
ZV91bmxvY2spOwogCkBAIC03MjksOSArNzI5LDEwIEBAIHBpcGVfcG9sbChzdHJ1Y3QgZmlsZSAq
ZmlscCwgcG9sbF90YWJsZSAqd2FpdCkKIHN0YXRpYyBpbnQKIHBpcGVfcmVsZWFzZShzdHJ1Y3Qg
aW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkKIHsKLQlzdHJ1Y3QgcGlwZV9pbm9kZV9p
bmZvICpwaXBlID0gaW5vZGUtPmlfcGlwZTsKKwlzdHJ1Y3QgcGlwZV9pbm9kZV9pbmZvICpwaXBl
ID0gZmlsZS0+cHJpdmF0ZV9kYXRhOwogCWludCBraWxsID0gMDsKIAorCWZpbGUtPnByaXZhdGVf
ZGF0YSA9IE5VTEw7CiAJX19waXBlX2xvY2socGlwZSk7CiAJaWYgKGZpbGUtPmZfbW9kZSAmIEZN
T0RFX1JFQUQpCiAJCXBpcGUtPnJlYWRlcnMtLTsK
--047d7b2ed34195158204ec1d0f88--
