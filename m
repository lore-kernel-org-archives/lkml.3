Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323AbaFLSiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 14:38:51 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:60502 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaFLSiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 14:38:50 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrWMBAxz9yn4MMugjZGC_Dsi2p855+e99Qhr0Ab+OaGRXw@mail.gmail.com>
References: <CAKx2Y1kBy-mrxm+1u88XVL2Z7gYKQe5U-EG2SBTzNCRAs_UVVw@mail.gmail.com>
 <CALCETrWMBAxz9yn4MMugjZGC_Dsi2p855+e99Qhr0Ab+OaGRXw@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 12 Jun 2014 11:38:27 -0700
Message-ID: <CALCETrWTx5j9mx-CeXJDUAXh8KqVhGqBK+gpOPgJS1hOgH5tmg@mail.gmail.com>
Subject: Re: Segmentation fault on all golang executables
To: Kui Zhang <kuizhang@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: multipart/mixed; boundary=047d7b3a9b7430326004fba7df35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b3a9b7430326004fba7df35
Content-Type: text/plain; charset=UTF-8

On Thu, Jun 12, 2014 at 10:20 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Thu, Jun 12, 2014 at 9:59 AM, Kui Zhang <kuizhang@gmail.com> wrote:
>> Hello,
>>
>> This commit seem to cause Segmentation fault on any of my golang executables.
>
> Well, crap.  It looks like the Go people took my sample vDSO parser...
> and broke it.  WTF were they thinking?  I should have noticed that
> they screwed it up when I was cc'd on this thing:
>
> https://code.google.com/p/go/source/detail?r=56ea40aac72b
>
> but I didn't.  Sorry, everyone.  And the issue isn't even something
> sensibly broken like trying to find vdso symbols in the symbol table.
> No, they're using the size of the SHT_DYNSYM section to deduce the
> number of entries *in the dynamic table*.  This is just completely
> wrong.
>
> But even that's not all.  They borrowed by error handling, so they
> should have silently failed to parse the vdso instead of crashing.
> But then they broke it completely by failing to zero the state, so
> they're just reading from initialized memory.  Grr.
>
> The current offending code is here:
>
> https://code.google.com/p/go/source/browse/src/pkg/runtime/vdso_linux_amd64.c
>
> Since we don't get to break all Go executables, here are two options:
>
> 1. Try to keep the whole symbol table intact.  This is annoying:
> there's a reason I removed it.  The linker script doesn't know how big
> it is, so it's hard to make it compatible with the vvar table.
>
> 2. Write a dummy section table that contains a single empty section of
> type SHT_DYNSYM.  Hopefully the Go runtime will then get far enough to
> fail cleanly.  And they can go and write a real ELF parser or copy my
> reference parser correctly.  (hpa, can you apply my patches to make
> the reference parser 32-bit clean?)

Sigh.

See attached.  It seems to work for me.  Can you test it?  It'll hurt
performance for Go programs, but I don't feel too bad about that.

--Andy

--047d7b3a9b7430326004fba7df35
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-x86-vdso-Hack-to-keep-64-bit-Go-programs-working.patch"
Content-Disposition: attachment; 
	filename="0001-x86-vdso-Hack-to-keep-64-bit-Go-programs-working.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hwcesr4c0

RnJvbSBhZDlmMzEzMDI2OTQ5MjQ3ZWQyMDY3NjMxYjRlNWMyN2MxOTM1MDY0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8YWQ5ZjMxMzAyNjk0OTI0N2VkMjA2NzYzMWI0ZTVj
MjdjMTkzNTA2NC4xNDAyNTk4MjMzLmdpdC5sdXRvQGFtYWNhcGl0YWwubmV0PgpGcm9tOiBBbmR5
IEx1dG9taXJza2kgPGx1dG9AYW1hY2FwaXRhbC5uZXQ+CkRhdGU6IFRodSwgMTIgSnVuIDIwMTQg
MTE6MzE6NDYgLTA3MDAKU3ViamVjdDogW1BBVENIXSB4ODYsdmRzbzogSGFjayB0byBrZWVwIDY0
LWJpdCBHbyBwcm9ncmFtcyB3b3JraW5nCgpUaGUgR28gcnVudGltZSBoYXMgYSBidWdneSB2RFNP
IHBhcnNlciB0aGF0IGN1cnJlbnRseSBzZWdmYXVsdHMuClRoaXMgd3JpdGVzIGFuIGVtcHR5IFNI
VF9EWU5TWU0gZW50cnkgdGhhdCBjYXVzZXMgR28ncyBydW50aW1lIHRvCm1hbGZ1bmN0aW9uIGJ5
IHRoaW5raW5nIHRoYXQgdGhlIHZEU08gaXMgZW1wdHkgcmF0aGVyIHRoYW4KbWFsZnVuY3Rpb25p
bmcgYnkgcnVubmluZyBvZmYgdGhlIGVuZCBhbmQgc2VnZmF1bHRpbmcuCgpUaGlzIGlzIGN1cnJl
bnRseSBicm9rZW4gZm9yIGJpZy1lbmRpYW4gYnVpbGQgaG9zdHMuICBUaGUgaGFjawpzaG91bGQg
YWxzbyBiZSBkaXNhYmxlZCBmb3IgeDMyLCBidXQgSSdtIG5vdCBzdXJlIHdoYXQgdGhlIHJpZ2h0
IHdheQp0byBkbyB0aGF0IGlzLgoKU2lnbmVkLW9mZi1ieTogQW5keSBMdXRvbWlyc2tpIDxsdXRv
QGFtYWNhcGl0YWwubmV0PgotLS0KIGFyY2gveDg2L3Zkc28vTWFrZWZpbGUgICAgICAgICAgICB8
ICAyICstCiBhcmNoL3g4Ni92ZHNvL3Zkc28tZmFrZXNlY3Rpb25zLmMgfCAyMCArKysrKysrKysr
KysrKysrKysrKwogYXJjaC94ODYvdmRzby92ZHNvMmMuaCAgICAgICAgICAgIHwgMjEgKysrKysr
KysrKysrKysrKystLS0tCiAzIGZpbGVzIGNoYW5nZWQsIDM4IGluc2VydGlvbnMoKyksIDUgZGVs
ZXRpb25zKC0pCiBjcmVhdGUgbW9kZSAxMDA2NDQgYXJjaC94ODYvdmRzby92ZHNvLWZha2VzZWN0
aW9ucy5jCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvdmRzby9NYWtlZmlsZSBiL2FyY2gveDg2L3Zk
c28vTWFrZWZpbGUKaW5kZXggOTc2OWRmMC4uZmZkZWI1YiAxMDA2NDQKLS0tIGEvYXJjaC94ODYv
dmRzby9NYWtlZmlsZQorKysgYi9hcmNoL3g4Ni92ZHNvL01ha2VmaWxlCkBAIC0xNSw3ICsxNSw3
IEBAIHZkc28taW5zdGFsbC0kKFZEU08zMi15KQkrPSAkKHZkc28zMi1pbWFnZXMpCiAKIAogIyBm
aWxlcyB0byBsaW5rIGludG8gdGhlIHZkc28KLXZvYmpzLXkgOj0gdmRzby1ub3RlLm8gdmNsb2Nr
X2dldHRpbWUubyB2Z2V0Y3B1Lm8KK3ZvYmpzLXkgOj0gdmRzby1ub3RlLm8gdmNsb2NrX2dldHRp
bWUubyB2Z2V0Y3B1Lm8gdmRzby1mYWtlc2VjdGlvbnMubwogCiB2b2Jqcy0kKFZEU09YMzIteSkg
Kz0gJCh2b2JqeDMycy1jb21wYXQpCiAKZGlmZiAtLWdpdCBhL2FyY2gveDg2L3Zkc28vdmRzby1m
YWtlc2VjdGlvbnMuYyBiL2FyY2gveDg2L3Zkc28vdmRzby1mYWtlc2VjdGlvbnMuYwpuZXcgZmls
ZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwLi5lZjc1ZWNlCi0tLSAvZGV2L251bGwKKysrIGIv
YXJjaC94ODYvdmRzby92ZHNvLWZha2VzZWN0aW9ucy5jCkBAIC0wLDAgKzEsMjAgQEAKKy8qCisg
KiBDb3B5cmlnaHQgMjAxNCBBbmR5IEx1dG9taXJza2kKKyAqIFN1YmplY3QgdG8gdGhlIEdOVSBQ
dWJsaWMgTGljZW5zZSwgdi4yCisgKgorICogSGFjayB0byBrZWVwIGJyb2tlbiBHbyBwcm9ncmFt
cyB3b3JraW5nLgorICovCisKKyNpZiBfX3g4Nl82NF9fICAvKiBoYWNrIG9ubHkgbmVlZGVkIGZv
ciB0aGUgNjQtYml0IHZEU08gKi8KKworI2luY2x1ZGUgPGxpbnV4L2VsZi5oPgorCitleHRlcm4g
Y29uc3QgX192aXNpYmxlIHN0cnVjdCBlbGY2NF9zaGRyIHZkc29fZmFrZV9zZWN0aW9uc1tdOwor
Y29uc3QgX192aXNpYmxlIHN0cnVjdCBlbGY2NF9zaGRyIHZkc29fZmFrZV9zZWN0aW9uc1tdID0g
eworCXsKKwkJLnNoX3R5cGUgPSBTSFRfRFlOU1lNLAorCQkuc2hfZW50c2l6ZSA9IHNpemVvZihF
bGY2NF9TeW0pLAorCX0KK307CisKKyNlbmRpZgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvdmRzby92
ZHNvMmMuaCBiL2FyY2gveDg2L3Zkc28vdmRzbzJjLmgKaW5kZXggZDlmNmY2MS4uNDNkOWFiMSAx
MDA2NDQKLS0tIGEvYXJjaC94ODYvdmRzby92ZHNvMmMuaAorKysgYi9hcmNoL3g4Ni92ZHNvL3Zk
c28yYy5oCkBAIC0xOCw2ICsxOCw4IEBAIHN0YXRpYyB2b2lkIEdPRlVOQyh2b2lkICphZGRyLCBz
aXplX3QgbGVuLCBGSUxFICpvdXRmaWxlLCBjb25zdCBjaGFyICpuYW1lKQogCWNvbnN0IGNoYXIg
KnNlY3N0cmluZ3M7CiAJdWludDY0X3Qgc3ltc1tOU1lNU10gPSB7fTsKIAorCXVpbnQ2NF90IGZh
a2Vfc2VjdGlvbnNfdmFsdWUgPSAwLCBmYWtlX3NlY3Rpb25zX3NpemUgPSAwOworCiAJRWxmX1Bo
ZHIgKnB0ID0gKEVsZl9QaGRyICopKGFkZHIgKyBHRVRfTEUoJmhkci0+ZV9waG9mZikpOwogCiAJ
LyogV2FsayB0aGUgc2VnbWVudCB0YWJsZS4gKi8KQEAgLTg0LDYgKzg2LDcgQEAgc3RhdGljIHZv
aWQgR09GVU5DKHZvaWQgKmFkZHIsIHNpemVfdCBsZW4sIEZJTEUgKm91dGZpbGUsIGNvbnN0IGNo
YXIgKm5hbWUpCiAJCQlHRVRfTEUoJnN5bXRhYl9oZHItPnNoX2VudHNpemUpICogaTsKIAkJY29u
c3QgY2hhciAqbmFtZSA9IGFkZHIgKyBHRVRfTEUoJnN0cnRhYl9oZHItPnNoX29mZnNldCkgKwog
CQkJR0VUX0xFKCZzeW0tPnN0X25hbWUpOworCiAJCWZvciAoayA9IDA7IGsgPCBOU1lNUzsgaysr
KSB7CiAJCQlpZiAoIXN0cmNtcChuYW1lLCByZXF1aXJlZF9zeW1zW2tdKSkgewogCQkJCWlmIChz
eW1zW2tdKSB7CkBAIC05Myw2ICs5NiwxMyBAQCBzdGF0aWMgdm9pZCBHT0ZVTkModm9pZCAqYWRk
ciwgc2l6ZV90IGxlbiwgRklMRSAqb3V0ZmlsZSwgY29uc3QgY2hhciAqbmFtZSkKIAkJCQlzeW1z
W2tdID0gR0VUX0xFKCZzeW0tPnN0X3ZhbHVlKTsKIAkJCX0KIAkJfQorCisJCWlmICghc3RyY21w
KG5hbWUsICJ2ZHNvX2Zha2Vfc2VjdGlvbnMiKSkgeworCQkJaWYgKGZha2Vfc2VjdGlvbnNfdmFs
dWUpCisJCQkJZmFpbCgiZHVwbGljYXRlIHZkc29fZmFrZV9zZWN0aW9uc1xuIik7CisJCQlmYWtl
X3NlY3Rpb25zX3ZhbHVlID0gR0VUX0xFKCZzeW0tPnN0X3ZhbHVlKTsKKwkJCWZha2Vfc2VjdGlv
bnNfc2l6ZSA9IEdFVF9MRSgmc3ltLT5zdF9zaXplKTsKKwkJfQogCX0KIAogCS8qIFZhbGlkYXRl
IG1hcHBpbmcgYWRkcmVzc2VzLiAqLwpAQCAtMTEyLDEwICsxMjIsMTMgQEAgc3RhdGljIHZvaWQg
R09GVU5DKHZvaWQgKmFkZHIsIHNpemVfdCBsZW4sIEZJTEUgKm91dGZpbGUsIGNvbnN0IGNoYXIg
Km5hbWUpCiAJaWYgKHN5bXNbc3ltX2VuZF9tYXBwaW5nXSAlIDQwOTYpCiAJCWZhaWwoImVuZF9t
YXBwaW5nIG11c3QgYmUgYSBtdWx0aXBsZSBvZiA0MDk2XG4iKTsKIAotCS8qIFJlbW92ZSBzZWN0
aW9ucy4gKi8KLQloZHItPmVfc2hvZmYgPSAwOwotCWhkci0+ZV9zaGVudHNpemUgPSAwOwotCWhk
ci0+ZV9zaG51bSA9IDA7CisJLyogUmVtb3ZlIHNlY3Rpb25zIG9yIHVzZSBmYWtlcyAqLworCWlm
IChmYWtlX3NlY3Rpb25zX3NpemUgJSBzaXplb2YoRWxmX1NoZHIpKQorCQlmYWlsKCJ2ZHNvX2Zh
a2Vfc2VjdGlvbnMgc2l6ZSBpcyBub3QgYSBtdWx0aXBsZSBvZiAlbGRcbiIsCisJCSAgICAgKGxv
bmcpc2l6ZW9mKEVsZl9TaGRyKSk7CisJaGRyLT5lX3Nob2ZmID0gZmFrZV9zZWN0aW9uc192YWx1
ZTsKKwloZHItPmVfc2hlbnRzaXplID0gZmFrZV9zZWN0aW9uc192YWx1ZSA/IHNpemVvZihFbGZf
U2hkcikgOiAwOworCWhkci0+ZV9zaG51bSA9IGZha2Vfc2VjdGlvbnNfc2l6ZSAvIHNpemVvZihF
bGZfU2hkcik7CiAJaGRyLT5lX3Noc3RybmR4ID0gU0hOX1VOREVGOyAvKiBTSE5fVU5ERUYgPT0g
MCAqLwogCiAJaWYgKCFuYW1lKSB7Ci0tIAoxLjkuMwoK
--047d7b3a9b7430326004fba7df35--
