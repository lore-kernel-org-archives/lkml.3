Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbaEATXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 15:23:12 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:54161 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaEATXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 15:23:10 -0400
MIME-Version: 1.0
In-Reply-To: <20140501183822.GA24823@p100.fritz.box>
References: <20140501183822.GA24823@p100.fritz.box>
Date: Thu, 1 May 2014 12:23:09 -0700
X-Google-Sender-Auth: ZPmp1NSKGpdVNrx73S2xPMuAEC0
Message-ID: <CA+55aFw+0_Wf+_2EAdi=OhVK3cZdMwsCV5cditaLz7LJroeByA@mail.gmail.com>
Subject: Re: [GIT PULL] parisc updates for v3.15
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Helge Deller <deller@gmx.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Content-Type: multipart/mixed; boundary=001a11c3dd186ce6b904f85b988e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c3dd186ce6b904f85b988e
Content-Type: text/plain; charset=UTF-8

On Thu, May 1, 2014 at 11:38 AM, Helge Deller <deller@gmx.de> wrote:
>
> - Make mmap() behave similiar to other architectures: If a file hasn't been
>   mapped yet, we can now map it at any given page-aligned address.

Ugh, so I pulled this, but I'm going to unpull it, because I dislike
your new "i_mmap_lastmap" field.

Now, the i_mmap_lastmap field itself, I could probably live with, but
this change to generic code:

  +       if (vma->vm_flags & VM_SHARED) {
                  mapping->i_mmap_writable--;
  +#ifdef CONFIG_MMAP_TRACKING
  +               if (mapping->i_mmap_writable == 0)
  +                       mapping->i_mmap_lastmmap = 0;
  +#endif
  +       }

makes me just gouge my eyes out. It's not only uglifying generic code,
it's _stupid_ even when it's used.

What's magic about "i_mmap_lastmmap" having the value zero? Nothing.
Maybe somebody wants to map stuff at that zero value, and has the
permissions to do so.

So zeroing it is wrong. It's also entirely unnecessary, since you can
just look at the "mapping->i_mmap_writable" value instead. So instead
of checking "is i_mmap_lastmmap zero" as a way to check whether you
can now use any virtual address, which is wrong _anyway_, you should
have checked "is i_mmap_writable zero".

Now, I *also* suspect that you could just get rid of i_mmap_lastmmap
_entirely_, and instead just make "GET_LAST_MMAP()" just look up the
first shared mapping it can find in the rb tree (if i_mmap_writable is
non-null).

But if it was just that one (unnecessary) field in the "struct
address_space", I probably wouldn't mind, and say "ok, parisc has
broken virtual caches, what else is new". But the fact that it adds
code to the generic file just adds insult to injury and makes me go
"no, I don't want to pull this".

Mind fixing this? Here's a TOTALLY UNTESTED patch that may or may not
work, but might at least act as a starting point.

Hmm?

              Linus

--001a11c3dd186ce6b904f85b988e
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_huofwtxf0

IGFyY2gvcGFyaXNjL2tlcm5lbC9zeXNfcGFyaXNjLmMgfCAzOCArKysrKysrKysrKysrKysrKysr
KysrKysrKy0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDI2IGluc2VydGlvbnMoKyksIDEy
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gvcGFyaXNjL2tlcm5lbC9zeXNfcGFyaXNj
LmMgYi9hcmNoL3BhcmlzYy9rZXJuZWwvc3lzX3BhcmlzYy5jCmluZGV4IDMxZmZhOWI1NTMyMi4u
ZGQ2NDM0NTljYmVmIDEwMDY0NAotLS0gYS9hcmNoL3BhcmlzYy9rZXJuZWwvc3lzX3BhcmlzYy5j
CisrKyBiL2FyY2gvcGFyaXNjL2tlcm5lbC9zeXNfcGFyaXNjLmMKQEAgLTM2LDEyICszNiwzMiBA
QAogI2luY2x1ZGUgPGxpbnV4L3BlcnNvbmFsaXR5Lmg+CiAjaW5jbHVkZSA8bGludXgvcmFuZG9t
Lmg+CiAKLS8qIHdlIGNvbnN0cnVjdCBhbiBhcnRpZmljaWFsIG9mZnNldCBmb3IgdGhlIG1hcHBp
bmcgYmFzZWQgb24gdGhlIHBoeXNpY2FsCi0gKiBhZGRyZXNzIG9mIHRoZSBrZXJuZWwgbWFwcGlu
ZyB2YXJpYWJsZSAqLwotI2RlZmluZSBHRVRfTEFTVF9NTUFQKGZpbHApCQlcCi0JKGZpbHAgPyAo
KHVuc2lnbmVkIGxvbmcpIGZpbHAtPmZfbWFwcGluZykgPj4gOCA6IDBVTCkKLSNkZWZpbmUgU0VU
X0xBU1RfTU1BUChmaWxwLCB2YWwpCVwKLQkgeyAvKiBub3RoaW5nICovIH0KK3N0YXRpYyBpbmxp
bmUgdW5zaWduZWQgbG9uZyBmaW5kX3NoYXJlZF9tYXBwaW5nX2FkZHJlc3Moc3RydWN0IGFkZHJl
c3Nfc3BhY2UgKm1hcHBpbmcpCit7CisJc3RydWN0IHJiX25vZGUgKm5kOworCisJZm9yIChuZCA9
IHJiX2ZpcnN0KHJvb3QpOyBuZDsgbmQgPSByYl9uZXh0KG5kKSkgeworCQlzdHJ1Y3Qgdm1fYXJl
YV9zdHJ1Y3QgKnZtYTsKKwkJdm1hID0gcmJfZW50cnkobmQsIHN0cnVjdCB2bV9hcmVhX3N0cnVj
dCwgdm1fcmIpOworCQlpZiAodm1hLT52bV9mbGFncyAmIFZNX1NIQVJFRCkKKwkJCXJldHVybiB2
bWEtPnN0YXJ0OworCX0KKwkvKiBTaG91bGRuJ3QgaGFwcGVuICovCisJcmV0dXJuIDA7Cit9CisK
Ky8qIHRoZSBhZGRyZXNzX3NwYWNlIHN0cnVjdCBob2xkcyBhIGZpZWxkIGlfbW1hcF9sYXN0bW1h
cCB3aXRoIHRoZSBsYXN0IG1hcHBpbmcKKyAqIG9mIHRoaXMgZmlsZSBmb3IgdXMgKi8KK3N0YXRp
YyBpbmxpbmUgdW5zaWduZWQgbG9uZyBHRVRfTEFTVF9NTUFQKHN0cnVjdCBmaWxlICpmaWxwKQor
eworCWlmIChmaWxwKSB7CisJCXN0cnVjdCBhZGRyZXNzX3NwYWNlICptYXBwaW5nID0gZmlscC0+
Zl9tYXBwaW5nOworCQlpZiAobWFwcGluZy0+aV9tbWFwX3dyaXRhYmxlKQorCQkJcmV0dXJuIGZp
bmRfc2hhcmVkX21hcHBpbmdfYWRkcmVzcyhtYXBwaW5nKTsKKwl9CisJcmV0dXJuIDA7Cit9CisK
IAogc3RhdGljIGludCBnZXRfb2Zmc2V0KHVuc2lnbmVkIGludCBsYXN0X21tYXApCiB7CkBAIC0x
MjcsOSArMTQ3LDYgQEAgdW5zaWduZWQgbG9uZyBhcmNoX2dldF91bm1hcHBlZF9hcmVhKHN0cnVj
dCBmaWxlICpmaWxwLCB1bnNpZ25lZCBsb25nIGFkZHIsCiAJYWRkciA9IHZtX3VubWFwcGVkX2Fy
ZWEoJmluZm8pOwogCiBmb3VuZF9hZGRyOgotCWlmIChkb19jb2xvcl9hbGlnbiAmJiAhbGFzdF9t
bWFwICYmICEoYWRkciAmIH5QQUdFX01BU0spKQotCQlTRVRfTEFTVF9NTUFQKGZpbHAsIGFkZHIg
LSAocGdvZmYgPDwgUEFHRV9TSElGVCkpOwotCiAJcmV0dXJuIGFkZHI7CiB9CiAKQEAgLTE5OCw5
ICsyMTUsNiBAQCBhcmNoX2dldF91bm1hcHBlZF9hcmVhX3RvcGRvd24oc3RydWN0IGZpbGUgKmZp
bHAsIGNvbnN0IHVuc2lnbmVkIGxvbmcgYWRkcjAsCiAJcmV0dXJuIGFyY2hfZ2V0X3VubWFwcGVk
X2FyZWEoZmlscCwgYWRkcjAsIGxlbiwgcGdvZmYsIGZsYWdzKTsKIAogZm91bmRfYWRkcjoKLQlp
ZiAoZG9fY29sb3JfYWxpZ24gJiYgIWxhc3RfbW1hcCAmJiAhKGFkZHIgJiB+UEFHRV9NQVNLKSkK
LQkJU0VUX0xBU1RfTU1BUChmaWxwLCBhZGRyIC0gKHBnb2ZmIDw8IFBBR0VfU0hJRlQpKTsKLQog
CXJldHVybiBhZGRyOwogfQogCg==
--001a11c3dd186ce6b904f85b988e--
