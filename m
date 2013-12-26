Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab3LZTAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 14:00:53 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:38554 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770Ab3LZTAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 14:00:51 -0500
MIME-Version: 1.0
In-Reply-To: <20131224204625.GB20471@gmail.com>
References: <CA+55aFxZ2u+M72u3HSD7TVY2+WRRi27pYC=_4Wawr5y1m8DfnQ@mail.gmail.com>
	<20131224204625.GB20471@gmail.com>
Date: Thu, 26 Dec 2013 11:00:49 -0800
X-Google-Sender-Auth: dKPYNajARN2xSPYhe2N7NsWcTeU
Message-ID: <CA+55aFzPBdbfKovMT8Edr4SmE2_=+OKJFac9XW2awegogTkVTA@mail.gmail.com>
Subject: Re: [RFC] speeding up the stat() family of system calls...
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a11c2a3368d2fe404ee7498ac
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c2a3368d2fe404ee7498ac
Content-Type: text/plain; charset=UTF-8

On Tue, Dec 24, 2013 at 12:46 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Looks cool - it looks rather similar to the try/catch model Richard
> Henderson came up with many eons ago when we implemented the original
> exception mechanism for Linux, which IIRC we decided wasn't safe due
> to lack of compiler support.
>
> Now we have compiler support ... written by Richard Henderson ;-)

Interestingly, looking at the cp_new_stat() profiles, the games we
play to get efficient range checking seem to actually hurt us. Maybe
it's the "sbb" that is just expensive, or maybe it's turning a (very
predictable) conditional branch into a data dependency chain instead.
Or maybe it's just random noise in my profiles that happened to make
those sbb's look bad.

What do people think about this access_ok() simplification that gets
rid of inline asm, and instead optimizes the (reasonably common) case
of a constant size. The complex case that requires overflow checking
*might* get a bit slower (it's not clear: it really wasn't generating
wonderful code), but the simple case of a known constant size actually
gets simpler.

Random aside: this simplification made the special spurious
access_ok() check in kernel/futex.c (the NULL user pointer check in
futex_init()) just go away entirely, because the compiler could now
see that it can never trigger for a NULL pointer.. Not a performance
issue, but it was kind of funny to notice how getting rid of the
inline asm actually made the compiler able to notice that.

                  Linus

--001a11c2a3368d2fe404ee7498ac
Content-Type: application/octet-stream; name=vfs-simplify-uaccess-range
Content-Disposition: attachment; filename=vfs-simplify-uaccess-range
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hpodmihc0

IGFyY2gveDg2L2luY2x1ZGUvYXNtL3VhY2Nlc3MuaCB8IDI4ICsrKysrKysrKysrKysrKysrLS0t
LS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspLCAxMSBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS91YWNjZXNzLmggYi9hcmNoL3g4
Ni9pbmNsdWRlL2FzbS91YWNjZXNzLmgKaW5kZXggOGVjNTdjMDdiMTI1Li44NGVjZjFkZjJhYzYg
MTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3VhY2Nlc3MuaAorKysgYi9hcmNoL3g4
Ni9pbmNsdWRlL2FzbS91YWNjZXNzLmgKQEAgLTQwLDIyICs0MCwyOCBAQAogLyoKICAqIFRlc3Qg
d2hldGhlciBhIGJsb2NrIG9mIG1lbW9yeSBpcyBhIHZhbGlkIHVzZXIgc3BhY2UgYWRkcmVzcy4K
ICAqIFJldHVybnMgMCBpZiB0aGUgcmFuZ2UgaXMgdmFsaWQsIG5vbnplcm8gb3RoZXJ3aXNlLgot
ICoKLSAqIFRoaXMgaXMgZXF1aXZhbGVudCB0byB0aGUgZm9sbG93aW5nIHRlc3Q6Ci0gKiAodTMz
KWFkZHIgKyAodTMzKXNpemUgPiAodTMzKWN1cnJlbnQtPmFkZHJfbGltaXQuc2VnICh1NjUgZm9y
IHg4Nl82NCkKLSAqCi0gKiBUaGlzIG5lZWRzIDMzLWJpdCAoNjUtYml0IGZvciB4ODZfNjQpIGFy
aXRobWV0aWMuIFdlIGhhdmUgYSBjYXJyeS4uLgogICovCitzdGF0aWMgaW5saW5lIGludCBfX2No
a19yYW5nZV9ub3Rfb2sodW5zaWduZWQgbG9uZyBhZGRyLCB1bnNpZ25lZCBsb25nIHNpemUsIHVu
c2lnbmVkIGxvbmcgbGltaXQpCit7CisJLyoKKwkgKiBJZiB3ZSBoYXZlIHVzZWQgInNpemVvZigp
IiBmb3IgdGhlIHNpemUsCisJICogd2Uga25vdyBpdCB3b24ndCBvdmVyZmxvdyB0aGUgbGltaXQg
KGJ1dAorCSAqIGl0IG1pZ2h0IG92ZXJmbG93IHRoZSAnYWRkcicsIHNvIGl0J3MKKwkgKiBpbXBv
cnRhbnQgdG8gc3VidHJhY3QgdGhlIHNpemUgZnJvbSB0aGUKKwkgKiBsaW1pdCwgbm90IGFkZCBp
dCB0byB0aGUgYWRkcmVzcykuCisJICovCisJaWYgKF9fYnVpbHRpbl9jb25zdGFudF9wKHNpemUp
KQorCQlyZXR1cm4gYWRkciA+IGxpbWl0IC0gc2l6ZTsKKworCS8qIEFyYml0cmFyeSBzaXplcz8g
QmUgY2FyZWZ1bCBhYm91dCBvdmVyZmxvdyAqLworCWFkZHIgKz0gc2l6ZTsKKwlyZXR1cm4gKGFk
ZHIgPCBzaXplKSB8fCAoYWRkciA+IGxpbWl0KTsKK30KIAogI2RlZmluZSBfX3JhbmdlX25vdF9v
ayhhZGRyLCBzaXplLCBsaW1pdCkJCQkJXAogKHsJCQkJCQkJCQlcCi0JdW5zaWduZWQgbG9uZyBm
bGFnLCByb2tzdW07CQkJCQlcCiAJX19jaGtfdXNlcl9wdHIoYWRkcik7CQkJCQkJXAotCWFzbSgi
YWRkICUzLCUxIDsgc2JiICUwLCUwIDsgY21wICUxLCU0IDsgc2JiICQwLCUwIgkJXAotCSAgICA6
ICI9JnIiIChmbGFnKSwgIj1yIiAocm9rc3VtKQkJCQlcCi0JICAgIDogIjEiIChhZGRyKSwgImci
ICgobG9uZykoc2l6ZSkpLAkJCQlcCi0JICAgICAgInJtIiAobGltaXQpKTsJCQkJCQlcCi0JZmxh
ZzsJCQkJCQkJCVwKKwlfX2Noa19yYW5nZV9ub3Rfb2soKHVuc2lnbmVkIGxvbmcgX19mb3JjZSko
YWRkciksIHNpemUsIGxpbWl0KTsgXAogfSkKIAogLyoqCg==
--001a11c2a3368d2fe404ee7498ac--
