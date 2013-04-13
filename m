Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab3DMRxw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 13:53:52 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:58256 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3DMRxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 13:53:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAOMFOmVO47+AuC1UgZQX1K0oSMSZ4DCzDEuJGF99ARTfnCDTpw@mail.gmail.com>
References: <1365805938-22826-1-git-send-email-anatol.pomozov@gmail.com>
	<CA+55aFzxxGBU3AOeNg3UEicHrx3nzWRyo5DOd=hh6SHJfYvB3g@mail.gmail.com>
	<CAOMFOmVO47+AuC1UgZQX1K0oSMSZ4DCzDEuJGF99ARTfnCDTpw@mail.gmail.com>
Date: Sat, 13 Apr 2013 10:53:50 -0700
X-Google-Sender-Auth: Slc1q5OR7ApLrsBEM3D_u8QUiXM
Message-ID: <CA+55aFxhwYO8wrHXHH6ry0pfpPHURsjN_aotT0xsDwZZZj7wvQ@mail.gmail.com>
Subject: Re: [PATCH] module: Fix race condition between load and unload module
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Salman Qazi <sqazi@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: multipart/mixed; boundary=089e01229cb6c3012804da41b3c1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e01229cb6c3012804da41b3c1
Content-Type: text/plain; charset=UTF-8

On Sat, Apr 13, 2013 at 8:41 AM, Anatol Pomozov
<anatol.pomozov@gmail.com> wrote:
>
> Does it make sense to move it to a separate function in kref.h?
>
> /** Useful when kref_get is racing with kref_put and refcounter might be 0 */
> int kref_get_not_zero(kref* ref) {
>     return atomic_inc_not_zero(&kref->refcount);
> }

It turns out we have that, except it's called "unless_zero", because
it uses "atomic_add_unless(x,1,0)", rather than the simplified
"atomic_inc_not_zero(x)".

> or maybe instead change default behavior of kref_get() to
> atomic_inc_not_zero and force callers check the return value from
> kref_get()?

That would be painful, and _most_ users should have a preexisting
refcount. So it's probably better in the long run to just keep the
warning (but perhaps fix it to be SMP-safe). So I think the part of
your patch that made kref_get() use atomic_inc_return() is probably a
good idea regardless.

Also, I changed my patch to be minimal, and not change other users of
kobject_get(). So other users (not kset_find_obj()) will continue to
get the warning, and kset_find_obj() uses the safe version. So this is
what I'm planning on committing as the minimal patch and marking for
stable. The rest (including that atomic_inc_return() in kref_get)
would be cleanup.

Can you give this a quick test?

                       Linus

--089e01229cb6c3012804da41b3c1
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hfh32w8j0

IGxpYi9rb2JqZWN0LmMgfCA5ICsrKysrKysrLQogMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9u
cygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2xpYi9rb2JqZWN0LmMgYi9saWIva29i
amVjdC5jCmluZGV4IGUwN2VlMWZjZDZmMS4uYTY1NDg2NjEzZDc5IDEwMDY0NAotLS0gYS9saWIv
a29iamVjdC5jCisrKyBiL2xpYi9rb2JqZWN0LmMKQEAgLTUyOSw2ICs1MjksMTMgQEAgc3RydWN0
IGtvYmplY3QgKmtvYmplY3RfZ2V0KHN0cnVjdCBrb2JqZWN0ICprb2JqKQogCXJldHVybiBrb2Jq
OwogfQogCitzdGF0aWMgc3RydWN0IGtvYmplY3QgKmtvYmplY3RfZ2V0X3VubGVzc196ZXJvKHN0
cnVjdCBrb2JqZWN0ICprb2JqKQoreworCWlmICgha3JlZl9nZXRfdW5sZXNzX3plcm8oJmtvYmot
PmtyZWYpKQorCQlrb2JqID0gTlVMTDsKKwlyZXR1cm4ga29iajsKK30KKwogLyoKICAqIGtvYmpl
Y3RfY2xlYW51cCAtIGZyZWUga29iamVjdCByZXNvdXJjZXMuCiAgKiBAa29iajogb2JqZWN0IHRv
IGNsZWFudXAKQEAgLTc1MSw3ICs3NTgsNyBAQCBzdHJ1Y3Qga29iamVjdCAqa3NldF9maW5kX29i
aihzdHJ1Y3Qga3NldCAqa3NldCwgY29uc3QgY2hhciAqbmFtZSkKIAogCWxpc3RfZm9yX2VhY2hf
ZW50cnkoaywgJmtzZXQtPmxpc3QsIGVudHJ5KSB7CiAJCWlmIChrb2JqZWN0X25hbWUoaykgJiYg
IXN0cmNtcChrb2JqZWN0X25hbWUoayksIG5hbWUpKSB7Ci0JCQlyZXQgPSBrb2JqZWN0X2dldChr
KTsKKwkJCXJldCA9IGtvYmplY3RfZ2V0X3VubGVzc196ZXJvKGspOwogCQkJYnJlYWs7CiAJCX0K
IAl9Cg==
--089e01229cb6c3012804da41b3c1--
