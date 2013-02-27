Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596Ab3B0Q5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 11:57:14 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:61696 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760563Ab3B0Q5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 11:57:09 -0500
MIME-Version: 1.0
In-Reply-To: <CAPM=9tw8mefcYTqELXFbZWZ44a--SNcPnRMAvMSGTiODzRpDhg@mail.gmail.com>
References: <1352665488-13818-1-git-send-email-mathieu.poirier@linaro.org>
	<20121119072525.GA16730@core.coreip.homeip.net>
	<CAPM=9tw8mefcYTqELXFbZWZ44a--SNcPnRMAvMSGTiODzRpDhg@mail.gmail.com>
Date: Wed, 27 Feb 2013 08:57:08 -0800
X-Google-Sender-Auth: zsMQi0Iu13CQOE-AQecA8kONxFE
Message-ID: <CA+55aFysXNSJMHL-rKZ_fvPP3t357zTC-6hyHmh=S6K-Qx0WbQ@mail.gmail.com>
Subject: Re: [PATCH v4] drivers/tty: Folding Android's keyreset driver in sysRQ
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@gmail.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        arve@android.com, kernel-team@android.com,
        John Stultz <john.stultz@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: multipart/mixed; boundary=bcaec50406e422943d04d6b7aa26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec50406e422943d04d6b7aa26
Content-Type: text/plain; charset=UTF-8

On Tue, Feb 26, 2013 at 11:33 PM, Dave Airlie <airlied@gmail.com> wrote:
>
> It looks to me like the weak bit isn't working so well
>
>         if (platform_sysrq_reset_seq) {
>                 for (i = 0; i < ARRAY_SIZE(sysrq_reset_seq); i++) {
>                         key = platform_sysrq_reset_seq[i];
>   6d:   66 8b 8c 00 00 00 00    mov    0x0(%eax,%eax,1),%cx
>   74:   00
>
> is around where it craps out.
> gcc version 4.7.2 20121109 (Red Hat 4.7.2-8) (GCC)
> Fedora 18 machine.

Hmm. I would love to blame gcc, but no, I think the code is crap.

The whole 'platform_sysrq_reset_seq[]' thing is broken in current git,
and it apparently only happens to work by mistake for most of us.

Doing a "grep" for it shows all three uses:

   git grep platform_sysrq_reset_seq

  extern unsigned short platform_sysrq_reset_seq[] __weak;
  if (platform_sysrq_reset_seq) {
            key = platform_sysrq_reset_seq[i];

and the thing is, if it is declared as an array (not a pointer), then
I think it is perfectly understandable that when then testing the
*address* of that array, gcc just says "you're stupid, you're testing
something that cannot possibly be NULL, so I'll throw your idiotic
test away".

And gcc would be completely correct. That test is moronic. You just
said that platform_sysrq_reset_seq[] was an external array, there is
no way in hell that is NULL.

Now, if it was a _pointer_, that would be a different thing entirely.
A pointer can have a NULL value. A named array, not so much.

So I *think* the fix might be something like the attached. Totally
untested. It may compile, or it may not.

                Linus

--bcaec50406e422943d04d6b7aa26
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hdoq8mac2

IGRyaXZlcnMvdHR5L3N5c3JxLmMgfCAxNSArKysrKysrLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2Vk
LCA3IGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy90
dHkvc3lzcnEuYyBiL2RyaXZlcnMvdHR5L3N5c3JxLmMKaW5kZXggODE0NjU1ZWUyZDYxLi4zNjg3
ZjBjYWQ2NDIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvdHR5L3N5c3JxLmMKKysrIGIvZHJpdmVycy90
dHkvc3lzcnEuYwpAQCAtODcwLDIxICs4NzAsMjAgQEAgc3RhdGljIHN0cnVjdCBpbnB1dF9oYW5k
bGVyIHN5c3JxX2hhbmRsZXIgPSB7CiAKIHN0YXRpYyBib29sIHN5c3JxX2hhbmRsZXJfcmVnaXN0
ZXJlZDsKIAordW5zaWduZWQgc2hvcnQgcGxhdGZvcm1fc3lzcnFfcmVzZXRfc2VxW10gX193ZWFr
ID0geyBLRVlfUkVTRVJWRUQgfTsKKwogc3RhdGljIGlubGluZSB2b2lkIHN5c3JxX3JlZ2lzdGVy
X2hhbmRsZXIodm9pZCkKIHsKLQlleHRlcm4gdW5zaWduZWQgc2hvcnQgcGxhdGZvcm1fc3lzcnFf
cmVzZXRfc2VxW10gX193ZWFrOwogCXVuc2lnbmVkIHNob3J0IGtleTsKIAlpbnQgZXJyb3I7CiAJ
aW50IGk7CiAKLQlpZiAocGxhdGZvcm1fc3lzcnFfcmVzZXRfc2VxKSB7Ci0JCWZvciAoaSA9IDA7
IGkgPCBBUlJBWV9TSVpFKHN5c3JxX3Jlc2V0X3NlcSk7IGkrKykgewotCQkJa2V5ID0gcGxhdGZv
cm1fc3lzcnFfcmVzZXRfc2VxW2ldOwotCQkJaWYgKGtleSA9PSBLRVlfUkVTRVJWRUQgfHwga2V5
ID4gS0VZX01BWCkKLQkJCQlicmVhazsKKwlmb3IgKGkgPSAwOyBpIDwgQVJSQVlfU0laRShzeXNy
cV9yZXNldF9zZXEpOyBpKyspIHsKKwkJa2V5ID0gcGxhdGZvcm1fc3lzcnFfcmVzZXRfc2VxW2ld
OworCQlpZiAoa2V5ID09IEtFWV9SRVNFUlZFRCB8fCBrZXkgPiBLRVlfTUFYKQorCQkJYnJlYWs7
CiAKLQkJCXN5c3JxX3Jlc2V0X3NlcVtzeXNycV9yZXNldF9zZXFfbGVuKytdID0ga2V5OwotCQl9
CisJCXN5c3JxX3Jlc2V0X3NlcVtzeXNycV9yZXNldF9zZXFfbGVuKytdID0ga2V5OwogCX0KIAog
CWVycm9yID0gaW5wdXRfcmVnaXN0ZXJfaGFuZGxlcigmc3lzcnFfaGFuZGxlcik7Cg==
--bcaec50406e422943d04d6b7aa26--
