Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbbAEVDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 16:03:13 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:46933 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbbAEVDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 16:03:11 -0500
MIME-Version: 1.0
In-Reply-To: <CANd1uZkn_Dk+s9vjxaA4B2oqWVoohzCQOHUuAdt3QK1ng37x6Q@mail.gmail.com>
References: <CANd1uZkn_Dk+s9vjxaA4B2oqWVoohzCQOHUuAdt3QK1ng37x6Q@mail.gmail.com>
Date: Mon, 5 Jan 2015 13:03:10 -0800
X-Google-Sender-Auth: HyI_DRQRTLSs-qPBlBog45c828I
Message-ID: <CA+55aFwTxbVSGg6F75X2Tt8pYEbV+jVVLOS8AoSqRrcYGELEGQ@mail.gmail.com>
Subject: Re: [2/3] mm: fix up some user-visible effects of the stack guard page
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jay Foad <jay.foad@gmail.com>
Cc: Greg KH <gregkh@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# .39.x" <stable@kernel.org>, stable-review@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: multipart/mixed; boundary=001a11c231da98448d050bee043d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c231da98448d050bee043d
Content-Type: text/plain; charset=UTF-8

On Mon, Jan 5, 2015 at 2:21 AM, Jay Foad <jay.foad@gmail.com> wrote:
> Sorry for replying to this old email...
>
>> commit d7824370e26325c881b665350ce64fb0a4fde24a upstream

Heh. From august 2010. That's 4+ years ago.. How come it was noticed
only now? You guys are running excessively old kernels, methinks.

> Address sanitizer tries to find the mapping for the current thread's
> stack by iterating through the entries in /proc/self/maps looking for
> one that contains the address of some random stack variable. This
> fails if the stack mapping has already used up all of its RLIMIT_STACK
> quota, because in that case check_stack_guard_page() will fail to add
> a guard page, but show_map_vma() will still assume that the first page
> of the stack *is* a guard page, and won't report it in /proc/maps.
>
> Here's a small program that demonstrates the failure:

Yup, your analysis sounds correct.  My completely untested gut feel is
that the problem is that we don't actually return the error from the
expand_stack() call, so then do_anonymous_page() will allow the extra
guard-page access.

IOW, *maybe* a patch like this. TOTALLY UNTESTED! I may have missed
something, and this may be complete crap.

                                 Linus

--001a11c231da98448d050bee043d
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i4kc4gzg0

IGluY2x1ZGUvbGludXgvbW0uaCB8IDIgKy0KIG1tL21lbW9yeS5jICAgICAgICB8IDQgKystLQog
MiBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvaW5jbHVkZS9saW51eC9tbS5oIGIvaW5jbHVkZS9saW51eC9tbS5oCmluZGV4IGY4MGQw
MTk0YzliYy4uODBmYzkyYTQ5NjQ5IDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L21tLmgKKysr
IGIvaW5jbHVkZS9saW51eC9tbS5oCkBAIC0xOTUyLDcgKzE5NTIsNyBAQCBleHRlcm4gaW50IGV4
cGFuZF9kb3dud2FyZHMoc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEsCiAjaWYgVk1fR1JPV1NV
UAogZXh0ZXJuIGludCBleHBhbmRfdXB3YXJkcyhzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSwg
dW5zaWduZWQgbG9uZyBhZGRyZXNzKTsKICNlbHNlCi0gICNkZWZpbmUgZXhwYW5kX3Vwd2FyZHMo
dm1hLCBhZGRyZXNzKSBkbyB7IH0gd2hpbGUgKDApCisgICNkZWZpbmUgZXhwYW5kX3Vwd2FyZHMo
dm1hLCBhZGRyZXNzKSAoMCkKICNlbmRpZgogCiAvKiBMb29rIHVwIHRoZSBmaXJzdCBWTUEgd2hp
Y2ggc2F0aXNmaWVzICBhZGRyIDwgdm1fZW5kLCAgTlVMTCBpZiBub25lLiAqLwpkaWZmIC0tZ2l0
IGEvbW0vbWVtb3J5LmMgYi9tbS9tZW1vcnkuYwppbmRleCBjYTkyMGQxZmQzMTQuLmQ3ZTQ5N2U5
OGY0NiAxMDA2NDQKLS0tIGEvbW0vbWVtb3J5LmMKKysrIGIvbW0vbWVtb3J5LmMKQEAgLTI1OTMs
NyArMjU5Myw3IEBAIHN0YXRpYyBpbmxpbmUgaW50IGNoZWNrX3N0YWNrX2d1YXJkX3BhZ2Uoc3Ry
dWN0IHZtX2FyZWFfc3RydWN0ICp2bWEsIHVuc2lnbmVkIGxvCiAJCWlmIChwcmV2ICYmIHByZXYt
PnZtX2VuZCA9PSBhZGRyZXNzKQogCQkJcmV0dXJuIHByZXYtPnZtX2ZsYWdzICYgVk1fR1JPV1NE
T1dOID8gMCA6IC1FTk9NRU07CiAKLQkJZXhwYW5kX2Rvd253YXJkcyh2bWEsIGFkZHJlc3MgLSBQ
QUdFX1NJWkUpOworCQlyZXR1cm4gZXhwYW5kX2Rvd253YXJkcyh2bWEsIGFkZHJlc3MgLSBQQUdF
X1NJWkUpOwogCX0KIAlpZiAoKHZtYS0+dm1fZmxhZ3MgJiBWTV9HUk9XU1VQKSAmJiBhZGRyZXNz
ICsgUEFHRV9TSVpFID09IHZtYS0+dm1fZW5kKSB7CiAJCXN0cnVjdCB2bV9hcmVhX3N0cnVjdCAq
bmV4dCA9IHZtYS0+dm1fbmV4dDsKQEAgLTI2MDIsNyArMjYwMiw3IEBAIHN0YXRpYyBpbmxpbmUg
aW50IGNoZWNrX3N0YWNrX2d1YXJkX3BhZ2Uoc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEsIHVu
c2lnbmVkIGxvCiAJCWlmIChuZXh0ICYmIG5leHQtPnZtX3N0YXJ0ID09IGFkZHJlc3MgKyBQQUdF
X1NJWkUpCiAJCQlyZXR1cm4gbmV4dC0+dm1fZmxhZ3MgJiBWTV9HUk9XU1VQID8gMCA6IC1FTk9N
RU07CiAKLQkJZXhwYW5kX3Vwd2FyZHModm1hLCBhZGRyZXNzICsgUEFHRV9TSVpFKTsKKwkJcmV0
dXJuIGV4cGFuZF91cHdhcmRzKHZtYSwgYWRkcmVzcyArIFBBR0VfU0laRSk7CiAJfQogCXJldHVy
biAwOwogfQo=
--001a11c231da98448d050bee043d--
