Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaBCVKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 16:10:20 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:51853 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbaBCVKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 16:10:17 -0500
MIME-Version: 1.0
In-Reply-To: <1391459750.13157.16.camel@localhost>
References: <377a1c5ce05e25b068cf7576d094885c1396c6bc.1391454589.git.luto@amacapital.net>
 <1391459750.13157.16.camel@localhost>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 3 Feb 2014 13:09:54 -0800
Message-ID: <CALCETrWx2eQOyVXD-2xVCac4RYSu1toLG=Rd4fhpXTi+T0XkWA@mail.gmail.com>
Subject: Re: [PATCH v2.1] audit: Only use the syscall slowpath when syscall
 audit rules exist
To: Eric Paris <eparis@redhat.com>
Cc: linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>
Content-Type: multipart/mixed; boundary=047d7b6dce844ac1b304f186f3e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b6dce844ac1b304f186f3e5
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Feb 3, 2014 at 12:35 PM, Eric Paris <eparis@redhat.com> wrote:
> Hmmmm,
>
> My problem with doing this has always actually been because of SELinux.
> Knowing syscall information with AVCs can be a huge help running down
> problems.  We already make people load rules if they want to get
> pathname type records, so maybe this is fine.  Or we could make SELinux
> take a reference on the number of audit rules, but that was your
> particular use case.  Not sure how I feel about losing syscall
> information by default on AVCs...
>

Hmm.  I never noticed that feature.  That'll show me :)

I would personally happily give that up for a 30-50% reduction in
systemwide syscall latency.

Looking at the 64-bit syscall entry code, it looks like the syscall nr
is always saved to pt_regs (as orig_rax) and the arguments are shoved
into the usual places in pt_regs.  Have you ever tried using
syscall_get_nr and syscall_get_arguments from the audit code without
setting TIF_SYSCALL_AUDIT?  I may be missing something here, but it
looks like it'll work.

> Do we always have audit_context allocated?  I need to look how the TIF
> and audit_context are correlated.

In 3.13, TIF_SYSCALL_AUDIT is set iff audit_context is allocated.  In
3.12 and below that was not the case due to a bug.

>
> For a completely seperate non-audit patch idea I've toyed with making
> the arch/syscall_nr a0,a1,a2,a3 stored in task struct rather than audit
> context.  Would mean that recording that information on syscall entry
> could be fast/easy and done quickly in syscall entry assembly code.
> Then on entry we could track only if there are rules on the 'entry' list
> and skip if none.  On exit we could do the same only with exit rules.
> Right now all 3 of those different things are tracked in
> TIF_SYSCALL_AUDIT (As I recall the slow path is usually a lot of things
> other than audit, but audit is what forces us onto the slow patch)

I think that you can already fish out the syscall args on x86_64 at
least.  The attached awful patch appears to work, for example.

Test code:

#include <stdio.h>
#include <linux/prctl.h>

int main(int argc, char **argv)
{
  if (argc != 5) {
    printf("Usage: test_pr500 arg2 arg3 arg4 arg5\n");
    return 1;
  }

  prctl(500, atoi(argv[1]), atoi(argv[2]), atoi(argv[3]), atoi(argv[4]));
  return 0;
}

FWIW, I don't know *why* the syscall fast path does this, but it's
convenient for this use :)

Out of curiosity, why does the audit code ignore a4 and a5?

--Andy

--047d7b6dce844ac1b304f186f3e5
Content-Type: text/x-patch; charset=US-ASCII; name="awful_syscall_hack.patch"
Content-Disposition: attachment; filename="awful_syscall_hack.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hr88ek4x0

ZGlmZiAtLWdpdCBhL2tlcm5lbC9zeXMuYyBiL2tlcm5lbC9zeXMuYwppbmRleCBjMGE1OGJlLi40
OGI4MWQzIDEwMDY0NAotLS0gYS9rZXJuZWwvc3lzLmMKKysrIGIva2VybmVsL3N5cy5jCkBAIC00
MSw2ICs0MSw3IEBACiAjaW5jbHVkZSA8bGludXgvc3lzY29yZV9vcHMuaD4KICNpbmNsdWRlIDxs
aW51eC92ZXJzaW9uLmg+CiAjaW5jbHVkZSA8bGludXgvY3R5cGUuaD4KKyNpbmNsdWRlIDxhc20v
c3lzY2FsbC5oPgogCiAjaW5jbHVkZSA8bGludXgvY29tcGF0Lmg+CiAjaW5jbHVkZSA8bGludXgv
c3lzY2FsbHMuaD4KQEAgLTE5OTYsNiArMTk5NywxMyBAQCBTWVNDQUxMX0RFRklORTUocHJjdGws
IGludCwgb3B0aW9uLCB1bnNpZ25lZCBsb25nLCBhcmcyLCB1bnNpZ25lZCBsb25nLCBhcmczLAog
CQlpZiAoYXJnMiB8fCBhcmczIHx8IGFyZzQgfHwgYXJnNSkKIAkJCXJldHVybiAtRUlOVkFMOwog
CQlyZXR1cm4gY3VycmVudC0+bm9fbmV3X3ByaXZzID8gMSA6IDA7CisJY2FzZSA1MDA6CisJewor
CQlzdHJ1Y3QgcHRfcmVncyAqcmVncyA9IHRhc2tfcHRfcmVncyhjdXJyZW50KTsKKwkJdW5zaWdu
ZWQgbG9uZyBhWzZdOworCQlzeXNjYWxsX2dldF9hcmd1bWVudHMoY3VycmVudCwgcmVncywgMCwg
NiwgYSk7CisJCXByaW50aygibnI9JWQgYTA9JWx1IGExPSVsdSBhMj0lbHUgYTM9JWx1IGE0PSVs
dSBhNT0lbHVcbiIsIHN5c2NhbGxfZ2V0X25yKGN1cnJlbnQsIHJlZ3MpLCBhWzBdLCBhWzFdLCBh
WzJdLCBhWzNdLCBhWzRdLCBhWzVdKTsKKwl9CiAJZGVmYXVsdDoKIAkJZXJyb3IgPSAtRUlOVkFM
OwogCQlicmVhazsK
--047d7b6dce844ac1b304f186f3e5--
