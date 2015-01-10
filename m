Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbbAJUO0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 15:14:26 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:41268 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbbAJUOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 15:14:24 -0500
MIME-Version: 1.0
In-Reply-To: <20150110142336.GC12218@pd.tnic>
References: <1420734315-30943-1-git-send-email-dvlasenk@redhat.com>
 <1420734315-30943-4-git-send-email-dvlasenk@redhat.com> <20150109121950.GD13637@pd.tnic>
 <CAK1hOcMsGJ7geRAzfazPLZitcO0o9XYRPJDYa8sJHR4i6DPL-g@mail.gmail.com> <20150110142336.GC12218@pd.tnic>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Sat, 10 Jan 2015 21:14:03 +0100
Message-ID: <CAK1hOcO7K=4N8CF=LOPmosXRNnogaNi5vLDPMdb0XiKsL=JOfg@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86: open-code register save/restore in
 trace_hardirqs thunks
To: Borislav Petkov <bp@alien8.de>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: multipart/mixed; boundary=047d7bdc81cc5a481a050c51ebb2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7bdc81cc5a481a050c51ebb2
Content-Type: text/plain; charset=UTF-8

On Sat, Jan 10, 2015 at 3:23 PM, Borislav Petkov <bp@alien8.de> wrote:
> Bah, I see it. This nasty '$' gets forgotten a lot, maybe we should have
> a check for that in some scripts :-)
>
> Here's the fix:
>
> ---
> Index: b/arch/x86/lib/thunk_64.S
> ===================================================================
> --- a/arch/x86/lib/thunk_64.S   2015-01-10 15:18:04.418737613 +0100
> +++ b/arch/x86/lib/thunk_64.S   2015-01-10 15:17:18.882736556 +0100
> @@ -67,7 +67,7 @@ restore:
>         movq_cfi_restore 6*8, rdx
>         movq_cfi_restore 7*8, rsi
>         movq_cfi_restore 8*8, rdi
> -       addq 9*8, %rsp
> +       addq $9*8, %rsp
>         CFI_ADJUST_CFA_OFFSET -9*8
>         ret

Thanks!

After I've seen the disassembly I myself posted, I can't help but wonder
why we use 5-byte instructions to store and load regs on stack when
pushes and pops are 1 or 2-byte long.

Especially that 32-bit code *does* use push/pops.

Can you test the attached patch with your kvm guest testcase?

--047d7bdc81cc5a481a050c51ebb2
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0003-x86-open-code-register-save-restore-in-trace_hardirq.patch"
Content-Disposition: attachment; 
	filename="0003-x86-open-code-register-save-restore-in-trace_hardirq.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i4rfgnv80

RnJvbSAyZjYzNmUwYTkyZGI4OThmMmJkYjU5MjAyN2FhMzAyZmNiMzJhMzI2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEZW55cyBWbGFzZW5rbyA8ZHZsYXNlbmtAcmVkaGF0LmNvbT4K
VG86IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcKU3ViamVjdDogW1BBVENIIDMvNF0geDg2
OiBvcGVuLWNvZGUgcmVnaXN0ZXIgc2F2ZS9yZXN0b3JlIGluIHRyYWNlX2hhcmRpcnFzIHRodW5r
cwoKVGhpcyBpcyBhIHByZXBhcmF0b3J5IHBhdGNoIGZvciBjaGFuZ2UgaW4gInN0cnVjdCBwdF9y
ZWdzIgpoYW5kbGluZyBpbiBlbnRyeV82NC5TLgoKdHJhY2VfaGFyZGlycXMgdGh1bmtzIHdlcmUg
KGFiKXVzaW5nIGEgcGFydCBvZiBwdF9yZWdzCmhhbmRsaW5nIGNvZGUsIG5hbWVseSBTQVZFX0FS
R1MvUkVTVE9SRV9BUkdTIG1hY3JvcywKdG8gc2F2ZS9yZXN0b3JlIHJlZ2lzdGVycyBhY3Jvc3Mg
QyBmdW5jdGlvbiBjYWxscy4KClNpbmNlIFNBVkVfQVJHUyBpcyBnb2luZyB0byBiZSBjaGFuZ2Vk
LCBvcGVuLWNvZGUKcmVnaXN0ZXIgc2F2aW5nL3Jlc3RvcmluZyBoZXJlLiBUYWtlIGEgcGFnZSBm
cm9tIHRodW5rXzMyLlMKYW5kIHVzZSBwdXNoL3BvcCBpbnNucyBpbnN0ZWFkIG9mIG1vdnEsIHRo
ZXkgYXJlIGZhciBzaG9ydGVyOgoxIG9yIDIgYnl0ZXMgdmVyc3VzIDUsIGFuZCBubyBuZWVkIGZv
ciBpbnNucyB0byBhZGp1c3QgJXJzcDoKCiAgIHRleHQJICAgZGF0YQkgICAgYnNzCSAgICBkZWMJ
ICAgIGhleAlmaWxlbmFtZQogICAgMzMzCSAgICAgNDAJICAgICAgMAkgICAgMzczCSAgICAxNzUJ
dGh1bmtfNjRfbW92cS5vCiAgICAxMDQJICAgICA0MAkgICAgICAwCSAgICAxNDQJICAgICA5MAl0
aHVua182NF9wdXNoX3BvcC5vCgpJbmNpZGVudGFsbHksIHRoaXMgcmVtb3ZlcyBhIGJpdCBvZiBk
ZWFkIGNvZGU6Cm9uZSBTQVZFX0FSR1Mgd2FzIHVzZWQganVzdCB0byBlbWl0IGEgQ0ZJIGFubm90
YXRpb24sCmJ1dCBpdCBhbHNvIGdlbmVyYXRlZCB1bnJlYWNoYWJsZSBhc3NlbWJseSBpbnNucy4K
ClNpZ25lZC1vZmYtYnk6IERlbnlzIFZsYXNlbmtvIDxkdmxhc2Vua0ByZWRoYXQuY29tPgpDQzog
TGludXMgVG9ydmFsZHMgPHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnPgpDQzogT2xlZyBO
ZXN0ZXJvdiA8b2xlZ0ByZWRoYXQuY29tPgpDQzogIkguIFBldGVyIEFudmluIiA8aHBhQHp5dG9y
LmNvbT4KQ0M6IEJvcmlzbGF2IFBldGtvdiA8YnBAYWxpZW44LmRlPgpDQzogQW5keSBMdXRvbWly
c2tpIDxsdXRvQGFtYWNhcGl0YWwubmV0PgpDQzogRnJlZGVyaWMgV2Vpc2JlY2tlciA8ZndlaXNi
ZWNAZ21haWwuY29tPgpDQzogWDg2IE1MIDx4ODZAa2VybmVsLm9yZz4KQ0M6IEFsZXhlaSBTdGFy
b3ZvaXRvdiA8YXN0QHBsdW1ncmlkLmNvbT4KQ0M6IFdpbGwgRHJld3J5IDx3YWRAY2hyb21pdW0u
b3JnPgpDQzogS2VlcyBDb29rIDxrZWVzY29va0BjaHJvbWl1bS5vcmc+CkNDOiBsaW51eC1rZXJu
ZWxAdmdlci5rZXJuZWwub3JnCi0tLQogYXJjaC94ODYvbGliL3RodW5rXzY0LlMgfCA0NiArKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tCiAxIGZpbGUgY2hhbmdl
ZCwgNDIgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL3g4
Ni9saWIvdGh1bmtfNjQuUyBiL2FyY2gveDg2L2xpYi90aHVua182NC5TCmluZGV4IGIzMGI1ZWIu
LjhlYzQ0M2EgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2xpYi90aHVua182NC5TCisrKyBiL2FyY2gv
eDg2L2xpYi90aHVua182NC5TCkBAIC0xNyw5ICsxNywyNyBAQAogCUNGSV9TVEFSVFBST0MKIAog
CS8qIHRoaXMgb25lIHB1c2hlcyA5IGVsZW1zLCB0aGUgbmV4dCBvbmUgd291bGQgYmUgJXJJUCAq
LwotCVNBVkVfQVJHUworCXB1c2hxX2NmaSAlcmRpCisJQ0ZJX1JFTF9PRkZTRVQgcmRpLCAwCisJ
cHVzaHFfY2ZpICVyc2kKKwlDRklfUkVMX09GRlNFVCByc2ksIDAKKwlwdXNocV9jZmkgJXJkeAor
CUNGSV9SRUxfT0ZGU0VUIHJkeCwgMAorCXB1c2hxX2NmaSAlcmN4CisJQ0ZJX1JFTF9PRkZTRVQg
cmN4LCAwCisJcHVzaHFfY2ZpICVyYXgKKwlDRklfUkVMX09GRlNFVCByYXgsIDAKKwlwdXNocV9j
ZmkgJXI4CisJQ0ZJX1JFTF9PRkZTRVQgcjgsIDAKKwlwdXNocV9jZmkgJXI5CisJQ0ZJX1JFTF9P
RkZTRVQgcjksIDAKKwlwdXNocV9jZmkgJXIxMAorCUNGSV9SRUxfT0ZGU0VUIHIxMCwgMAorCXB1
c2hxX2NmaSAlcjExCisJQ0ZJX1JFTF9PRkZTRVQgcjExLCAwCiAKIAkuaWYgXHB1dF9yZXRfYWRk
cl9pbl9yZGkKKwkvKiA5KjgoJXJzcCkgaXMgcmV0dXJuIGFkZHIgb24gc3RhY2sgKi8KIAltb3Zx
X2NmaV9yZXN0b3JlIDkqOCwgcmRpCiAJLmVuZGlmCiAKQEAgLTQ1LDExICs2MywzMSBAQAogI2Vu
ZGlmCiAjZW5kaWYKIAotCS8qIFNBVkVfQVJHUyBiZWxvdyBpcyB1c2VkIG9ubHkgZm9yIHRoZSAu
Y2ZpIGRpcmVjdGl2ZXMgaXQgY29udGFpbnMuICovCisjaWYgZGVmaW5lZChDT05GSUdfVFJBQ0Vf
SVJRRkxBR1MpIFwKKyB8fCBkZWZpbmVkKENPTkZJR19ERUJVR19MT0NLX0FMTE9DKSBcCisgfHwg
ZGVmaW5lZChDT05GSUdfUFJFRU1QVCkKIAlDRklfU1RBUlRQUk9DCi0JU0FWRV9BUkdTCisJQ0ZJ
X0FESlVTVF9DRkFfT0ZGU0VUIDkqOAogcmVzdG9yZToKLQlSRVNUT1JFX0FSR1MKKwlwb3BxX2Nm
aSAlcjExCisJQ0ZJX1JFU1RPUkUgcjExCisJcG9wcV9jZmkgJXIxMAorCUNGSV9SRVNUT1JFIHIx
MAorCXBvcHFfY2ZpICVyOQorCUNGSV9SRVNUT1JFIHI5CisJcG9wcV9jZmkgJXI4CisJQ0ZJX1JF
U1RPUkUgcjgKKwlwb3BxX2NmaSAlcmF4CisJQ0ZJX1JFU1RPUkUgcmF4CisJcG9wcV9jZmkgJXJj
eAorCUNGSV9SRVNUT1JFIHJjeAorCXBvcHFfY2ZpICVyZHgKKwlDRklfUkVTVE9SRSByZHgKKwlw
b3BxX2NmaSAlcnNpCisJQ0ZJX1JFU1RPUkUgcnNpCisJcG9wcV9jZmkgJXJkaQorCUNGSV9SRVNU
T1JFIHJkaQogCXJldAogCUNGSV9FTkRQUk9DCiAJX0FTTV9OT0tQUk9CRShyZXN0b3JlKQorI2Vu
ZGlmCi0tIAoxLjguMS40Cgo=
--047d7bdc81cc5a481a050c51ebb2--
