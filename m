Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082Ab3CGXqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 18:46:30 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:34796 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758786Ab3CGXq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 18:46:26 -0500
MIME-Version: 1.0
In-Reply-To: <20130307231442.GA4806@redhat.com>
References: <CA+55aFwDYocNRjSCJk1PYw0MFy7dpKf1yMMEiePP--=ewQcX6A@mail.gmail.com>
	<20130307213819.GB19543@redhat.com>
	<CA+55aFx424SX6S1zFegVaMZ_BkeZctDKCN6eYCLFfaJDKRVG9g@mail.gmail.com>
	<20130307220333.GA31039@redhat.com>
	<20130307223610.GA2494@redhat.com>
	<20130307231442.GA4806@redhat.com>
Date: Thu, 7 Mar 2013 15:46:24 -0800
X-Google-Sender-Auth: CjohxUL9_NSdhxnlsFXjKEzkgk0
Message-ID: <CA+55aFxDYcfxKO_h7ZTrs7o2+i=EjKxBtpeZWASQ75PVK7cJOA@mail.gmail.com>
Subject: Re: fasync_remove_entry oops
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: multipart/mixed; boundary=bcaec5171ebf8b826a04d75e5019
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec5171ebf8b826a04d75e5019
Content-Type: text/plain; charset=UTF-8

On Thu, Mar 7, 2013 at 3:14 PM, Dave Jones <davej@redhat.com> wrote:
> And.. More fun with pipes.
>         for (fp = fapp; (fa = *fp) != NULL; fp = &fa->fa_next) {
>     1650:       49 8b 06                mov    (%r14),%rax
>
> So we got to fasync_remove_entry with a NULL fa struct.
>
> Can we just add more NULL checks here, or does that need to happen
> at a higher level ?

I think you'll find that it's not fapp that was NULL. The caller was
pipe_rdwr_fasync -> fasync_helper, and pipe_rdwr_fasync always passes
in

    &pipe->fasync_readers

(and writers) so it looks like it is pipe that was NULL. Really odd.
How did the open of the pipe succeed with a NULL i_pipe? We do have
i_pipe == NULL, but that should happen only with a not-yet-opened
pipe, or after the last close.

In neither case should you have that pipe_rdwr_fasync() call.

The fact that this happens for a delayed __fput() makes me think it
was never a successful open to begin with, but how did the FASYNC flag
get set in that case? Do we actually allow it in the open flags..
Hmm..

So if we need new NULL pointer checks, I think they'd need to be
something like the attached patch.

But this is definitely another of those "This is our most desperate
hour. Help me, Al-biwan Ke-Viro, you're my only hope" issues.

Al? Please don't make me wear that golden bikini.

            Linus

--bcaec5171ebf8b826a04d75e5019
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_he0k5vd80

IGZzL3BpcGUuYyB8IDI3ICsrKysrKysrKysrKysrKystLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5n
ZWQsIDE2IGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3Bp
cGUuYyBiL2ZzL3BpcGUuYwppbmRleCA2NGE0OTRjZWYwYTAuLmZkY2EzMWEzNGY2ZSAxMDA2NDQK
LS0tIGEvZnMvcGlwZS5jCisrKyBiL2ZzL3BpcGUuYwpAQCAtNzU5LDEwICs3NTksMTEgQEAgc3Rh
dGljIGludAogcGlwZV9yZWFkX2Zhc3luYyhpbnQgZmQsIHN0cnVjdCBmaWxlICpmaWxwLCBpbnQg
b24pCiB7CiAJc3RydWN0IGlub2RlICppbm9kZSA9IGZpbGVfaW5vZGUoZmlscCk7Ci0JaW50IHJl
dHZhbDsKKwlpbnQgcmV0dmFsID0gMDsKIAogCW11dGV4X2xvY2soJmlub2RlLT5pX211dGV4KTsK
LQlyZXR2YWwgPSBmYXN5bmNfaGVscGVyKGZkLCBmaWxwLCBvbiwgJmlub2RlLT5pX3BpcGUtPmZh
c3luY19yZWFkZXJzKTsKKwlpZiAoaW5vZGUtPmlfcGlwZSkKKwkJcmV0dmFsID0gZmFzeW5jX2hl
bHBlcihmZCwgZmlscCwgb24sICZpbm9kZS0+aV9waXBlLT5mYXN5bmNfcmVhZGVycyk7CiAJbXV0
ZXhfdW5sb2NrKCZpbm9kZS0+aV9tdXRleCk7CiAKIAlyZXR1cm4gcmV0dmFsOwpAQCAtNzczLDEw
ICs3NzQsMTEgQEAgc3RhdGljIGludAogcGlwZV93cml0ZV9mYXN5bmMoaW50IGZkLCBzdHJ1Y3Qg
ZmlsZSAqZmlscCwgaW50IG9uKQogewogCXN0cnVjdCBpbm9kZSAqaW5vZGUgPSBmaWxlX2lub2Rl
KGZpbHApOwotCWludCByZXR2YWw7CisJaW50IHJldHZhbCA9IDA7CiAKIAltdXRleF9sb2NrKCZp
bm9kZS0+aV9tdXRleCk7Ci0JcmV0dmFsID0gZmFzeW5jX2hlbHBlcihmZCwgZmlscCwgb24sICZp
bm9kZS0+aV9waXBlLT5mYXN5bmNfd3JpdGVycyk7CisJaWYgKGlub2RlLT5pX3BpcGUpCisJCXJl
dHZhbCA9IGZhc3luY19oZWxwZXIoZmQsIGZpbHAsIG9uLCAmaW5vZGUtPmlfcGlwZS0+ZmFzeW5j
X3dyaXRlcnMpOwogCW11dGV4X3VubG9jaygmaW5vZGUtPmlfbXV0ZXgpOwogCiAJcmV0dXJuIHJl
dHZhbDsKQEAgLTc4NywxNSArNzg5LDE4IEBAIHN0YXRpYyBpbnQKIHBpcGVfcmR3cl9mYXN5bmMo
aW50IGZkLCBzdHJ1Y3QgZmlsZSAqZmlscCwgaW50IG9uKQogewogCXN0cnVjdCBpbm9kZSAqaW5v
ZGUgPSBmaWxlX2lub2RlKGZpbHApOwotCXN0cnVjdCBwaXBlX2lub2RlX2luZm8gKnBpcGUgPSBp
bm9kZS0+aV9waXBlOwotCWludCByZXR2YWw7CisJc3RydWN0IHBpcGVfaW5vZGVfaW5mbyAqcGlw
ZTsKKwlpbnQgcmV0dmFsID0gMDsKIAogCW11dGV4X2xvY2soJmlub2RlLT5pX211dGV4KTsKLQly
ZXR2YWwgPSBmYXN5bmNfaGVscGVyKGZkLCBmaWxwLCBvbiwgJnBpcGUtPmZhc3luY19yZWFkZXJz
KTsKLQlpZiAocmV0dmFsID49IDApIHsKLQkJcmV0dmFsID0gZmFzeW5jX2hlbHBlcihmZCwgZmls
cCwgb24sICZwaXBlLT5mYXN5bmNfd3JpdGVycyk7Ci0JCWlmIChyZXR2YWwgPCAwKSAvKiB0aGlz
IGNhbiBoYXBwZW4gb25seSBpZiBvbiA9PSBUICovCi0JCQlmYXN5bmNfaGVscGVyKC0xLCBmaWxw
LCAwLCAmcGlwZS0+ZmFzeW5jX3JlYWRlcnMpOworCXBpcGUgPSBpbm9kZS0+aV9waXBlOworCWlm
IChwaXBlKSB7CisJCXJldHZhbCA9IGZhc3luY19oZWxwZXIoZmQsIGZpbHAsIG9uLCAmcGlwZS0+
ZmFzeW5jX3JlYWRlcnMpOworCQlpZiAocmV0dmFsID49IDApIHsKKwkJCXJldHZhbCA9IGZhc3lu
Y19oZWxwZXIoZmQsIGZpbHAsIG9uLCAmcGlwZS0+ZmFzeW5jX3dyaXRlcnMpOworCQkJaWYgKHJl
dHZhbCA8IDApIC8qIHRoaXMgY2FuIGhhcHBlbiBvbmx5IGlmIG9uID09IFQgKi8KKwkJCQlmYXN5
bmNfaGVscGVyKC0xLCBmaWxwLCAwLCAmcGlwZS0+ZmFzeW5jX3JlYWRlcnMpOworCQl9CiAJfQog
CW11dGV4X3VubG9jaygmaW5vZGUtPmlfbXV0ZXgpOwogCXJldHVybiByZXR2YWw7Cg==
--bcaec5171ebf8b826a04d75e5019--
