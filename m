Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab3KCAfQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 20:35:16 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:38181 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab3KCAfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 20:35:13 -0400
MIME-Version: 1.0
In-Reply-To: <1383427599-1980-2-git-send-email-minipli@googlemail.com>
References: <1383427599-1980-1-git-send-email-minipli@googlemail.com>
	<1383427599-1980-2-git-send-email-minipli@googlemail.com>
Date: Sat, 2 Nov 2013 17:35:12 -0700
X-Google-Sender-Auth: OM2leq2hJGZLHLnZmdck-MJQPA8
Message-ID: <CA+55aFxeGaZjWM37e4p1tAhjwocpv0_iU0jTYUfaAFagvCBxmQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] ipc, msg: fix message length check for negative values
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathias Krause <minipli@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Pax Team <pageexec@freemail.hu>,
        Brad Spengler <spender@grsecurity.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7bd6c5d0f75e9e04ea3af81a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7bd6c5d0f75e9e04ea3af81a
Content-Type: text/plain; charset=UTF-8

On Sat, Nov 2, 2013 at 2:26 PM, Mathias Krause <minipli@googlemail.com> wrote:
> On 64 bit systems the test for negative message sizes is bogus as the
> size, which may be positive when evaluated as a long, will get truncated
> to an int when passed to load_msg().

Quite frankly, wouldn't it be much nicer to just fix "load_msg()" instead?

Using "size_t" also gets rid of the games we play with DATALEN_MSG/SEG.

IOW, something like the attached..

Of course, we *also* should fix ns->msg_ctlmax to make clear you can't
use negative numbers there. No question about that. I think it would
be better to even avoid INT_MAX, because there are memory use concerns
and CPU usage ones too (we generate that list of
smaller-than-page-size fragments).

Hmm?

              Linus

--047d7bd6c5d0f75e9e04ea3af81a
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hnjjt2d40

IGluY2x1ZGUvbGludXgvaXBjX25hbWVzcGFjZS5oIHwgIDYgKysrLS0tCiBpcGMvbXNndXRpbC5j
ICAgICAgICAgICAgICAgICB8IDE0ICsrKysrKystLS0tLS0tCiBpcGMvdXRpbC5oICAgICAgICAg
ICAgICAgICAgICB8ICA0ICsrLS0KIDMgZmlsZXMgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwg
MTIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9pcGNfbmFtZXNwYWNl
LmggYi9pbmNsdWRlL2xpbnV4L2lwY19uYW1lc3BhY2UuaAppbmRleCAxOWMxOWE1ZWVlMjkuLmY2
YzgyZGUxMjU0MSAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9pcGNfbmFtZXNwYWNlLmgKKysr
IGIvaW5jbHVkZS9saW51eC9pcGNfbmFtZXNwYWNlLmgKQEAgLTM0LDkgKzM0LDkgQEAgc3RydWN0
IGlwY19uYW1lc3BhY2UgewogCWludAkJc2VtX2N0bHNbNF07CiAJaW50CQl1c2VkX3NlbXM7CiAK
LQlpbnQJCW1zZ19jdGxtYXg7Ci0JaW50CQltc2dfY3RsbW5iOwotCWludAkJbXNnX2N0bG1uaTsK
Kwl1bnNpZ25lZCBpbnQJbXNnX2N0bG1heDsKKwl1bnNpZ25lZCBpbnQJbXNnX2N0bG1uYjsKKwl1
bnNpZ25lZCBpbnQJbXNnX2N0bG1uaTsKIAlhdG9taWNfdAltc2dfYnl0ZXM7CiAJYXRvbWljX3QJ
bXNnX2hkcnM7CiAJaW50CQlhdXRvX21zZ21uaTsKZGlmZiAtLWdpdCBhL2lwYy9tc2d1dGlsLmMg
Yi9pcGMvbXNndXRpbC5jCmluZGV4IDQ5MWU3MWYyYTFiOC4uM2NkOWNiOTU5Yzc0IDEwMDY0NAot
LS0gYS9pcGMvbXNndXRpbC5jCisrKyBiL2lwYy9tc2d1dGlsLmMKQEAgLTQxLDE1ICs0MSwxNSBA
QCBzdHJ1Y3QgbXNnX21zZ3NlZyB7CiAJLyogdGhlIG5leHQgcGFydCBvZiB0aGUgbWVzc2FnZSBm
b2xsb3dzIGltbWVkaWF0ZWx5ICovCiB9OwogCi0jZGVmaW5lIERBVEFMRU5fTVNHCShpbnQpKFBB
R0VfU0laRS1zaXplb2Yoc3RydWN0IG1zZ19tc2cpKQotI2RlZmluZSBEQVRBTEVOX1NFRwkoaW50
KShQQUdFX1NJWkUtc2l6ZW9mKHN0cnVjdCBtc2dfbXNnc2VnKSkKKyNkZWZpbmUgREFUQUxFTl9N
U0cJKFBBR0VfU0laRS1zaXplb2Yoc3RydWN0IG1zZ19tc2cpKQorI2RlZmluZSBEQVRBTEVOX1NF
RwkoUEFHRV9TSVpFLXNpemVvZihzdHJ1Y3QgbXNnX21zZ3NlZykpCiAKIAotc3RhdGljIHN0cnVj
dCBtc2dfbXNnICphbGxvY19tc2coaW50IGxlbikKK3N0YXRpYyBzdHJ1Y3QgbXNnX21zZyAqYWxs
b2NfbXNnKHNpemVfdCBsZW4pCiB7CiAJc3RydWN0IG1zZ19tc2cgKm1zZzsKIAlzdHJ1Y3QgbXNn
X21zZ3NlZyAqKnBzZWc7Ci0JaW50IGFsZW47CisJc2l6ZV90IGFsZW47CiAKIAlhbGVuID0gbWlu
KGxlbiwgREFUQUxFTl9NU0cpOwogCW1zZyA9IGttYWxsb2Moc2l6ZW9mKCptc2cpICsgYWxlbiwg
R0ZQX0tFUk5FTCk7CkBAIC04MCw3ICs4MCw3IEBAIG91dF9lcnI6CiAJcmV0dXJuIE5VTEw7CiB9
CiAKLXN0cnVjdCBtc2dfbXNnICpsb2FkX21zZyhjb25zdCB2b2lkIF9fdXNlciAqc3JjLCBpbnQg
bGVuKQorc3RydWN0IG1zZ19tc2cgKmxvYWRfbXNnKGNvbnN0IHZvaWQgX191c2VyICpzcmMsIHNp
emVfdCBsZW4pCiB7CiAJc3RydWN0IG1zZ19tc2cgKm1zZzsKIAlzdHJ1Y3QgbXNnX21zZ3NlZyAq
c2VnOwpAQCAtMTQ3LDkgKzE0Nyw5IEBAIHN0cnVjdCBtc2dfbXNnICpjb3B5X21zZyhzdHJ1Y3Qg
bXNnX21zZyAqc3JjLCBzdHJ1Y3QgbXNnX21zZyAqZHN0KQogCXJldHVybiBFUlJfUFRSKC1FTk9T
WVMpOwogfQogI2VuZGlmCi1pbnQgc3RvcmVfbXNnKHZvaWQgX191c2VyICpkZXN0LCBzdHJ1Y3Qg
bXNnX21zZyAqbXNnLCBpbnQgbGVuKQoraW50IHN0b3JlX21zZyh2b2lkIF9fdXNlciAqZGVzdCwg
c3RydWN0IG1zZ19tc2cgKm1zZywgc2l6ZV90IGxlbikKIHsKLQlpbnQgYWxlbjsKKwlzaXplX3Qg
YWxlbjsKIAlzdHJ1Y3QgbXNnX21zZ3NlZyAqc2VnOwogCiAJYWxlbiA9IG1pbihsZW4sIERBVEFM
RU5fTVNHKTsKZGlmZiAtLWdpdCBhL2lwYy91dGlsLmggYi9pcGMvdXRpbC5oCmluZGV4IGYyZjUw
MzZmMmVlZC4uNTlkNzhhYTk0OTg3IDEwMDY0NAotLS0gYS9pcGMvdXRpbC5oCisrKyBiL2lwYy91
dGlsLmgKQEAgLTE0OCw5ICsxNDgsOSBAQCBpbnQgaXBjX3BhcnNlX3ZlcnNpb24gKGludCAqY21k
KTsKICNlbmRpZgogCiBleHRlcm4gdm9pZCBmcmVlX21zZyhzdHJ1Y3QgbXNnX21zZyAqbXNnKTsK
LWV4dGVybiBzdHJ1Y3QgbXNnX21zZyAqbG9hZF9tc2coY29uc3Qgdm9pZCBfX3VzZXIgKnNyYywg
aW50IGxlbik7CitleHRlcm4gc3RydWN0IG1zZ19tc2cgKmxvYWRfbXNnKGNvbnN0IHZvaWQgX191
c2VyICpzcmMsIHNpemVfdCBsZW4pOwogZXh0ZXJuIHN0cnVjdCBtc2dfbXNnICpjb3B5X21zZyhz
dHJ1Y3QgbXNnX21zZyAqc3JjLCBzdHJ1Y3QgbXNnX21zZyAqZHN0KTsKLWV4dGVybiBpbnQgc3Rv
cmVfbXNnKHZvaWQgX191c2VyICpkZXN0LCBzdHJ1Y3QgbXNnX21zZyAqbXNnLCBpbnQgbGVuKTsK
K2V4dGVybiBpbnQgc3RvcmVfbXNnKHZvaWQgX191c2VyICpkZXN0LCBzdHJ1Y3QgbXNnX21zZyAq
bXNnLCBzaXplX3QgbGVuKTsKIAogZXh0ZXJuIHZvaWQgcmVjb21wdXRlX21zZ21uaShzdHJ1Y3Qg
aXBjX25hbWVzcGFjZSAqKTsKIAo=
--047d7bd6c5d0f75e9e04ea3af81a--
