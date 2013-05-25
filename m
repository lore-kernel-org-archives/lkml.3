Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab3EYHbo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 03:31:44 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:53538 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab3EYHbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 03:31:43 -0400
MIME-Version: 1.0
In-Reply-To: <1369456201-24910-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1369456201-24910-1-git-send-email-yuanhan.liu@linux.intel.com>
Date: Sat, 25 May 2013 00:31:43 -0700
X-Google-Sender-Auth: PSE5Zd70juOQhBgVzLC9ynyo1ws
Message-ID: <CAE9FiQVZyizrB4=FV56hjeb_-vX_YWJ=Ur54ptTEeFpaekv16Q@mail.gmail.com>
Subject: Re: [PATCH] x86, mm: fix boot hang regression
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Content-Type: multipart/mixed; boundary=001a11c1be063a9c8404dd85e8f9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c1be063a9c8404dd85e8f9
Content-Type: text/plain; charset=ISO-8859-1

On Fri, May 24, 2013 at 9:30 PM, Yuanhan Liu
<yuanhan.liu@linux.intel.com> wrote:
> Commit 8d57470d introduced a kernel panic while setting mem=2G at
> boot time, and commit c9b3234a6 turns the the kernel panic to hang.
>
> While, the reason is the same: the are accessing a BAD address; I mean
> the mapping is broken.
>
> Here is a mem mapping range dumped at boot time:
>     [mem 0x00000000-0x000fffff] page 4k  (0)
>     [mem 0x7fe00000-0x7fffffff] page 1G  (1)
>     [mem 0x7c000000-0x7fdfffff] page 1G  (2)
>     [mem 0x00100000-0x001fffff] page 4k  (3)
>     [mem 0x00200000-0x7bffffff] page 2M  (4)
>
...
> I reported this panic regression long time ago, and I didn't notic the above
> panic->hang change before, which might confuse Yinghai for understanding
> what happened from 2 logs I sent before(one is from 8d57470d, another is
> from the HEAD commit at that time, which turn to a hang as stated).
> More, it seems that Yinghai can't produce it. And I was busying at
> something else. And I finally got a day yesterday(and a good mood ;).
>
> Last, Thanks Changlong's effort for bisecting the 2 above commit.
> ---
>  arch/x86/mm/init_64.c |   51 +++++++++++++++++++++++++++++++++++++++++-------
>  1 files changed, 43 insertions(+), 8 deletions(-)

oh, I know the reason, my intel box has acpi or reserved area just below 2GiB.

your patch is not right fix.

Attached patch should fix the problem.

Thanks

Yinghai

--001a11c1be063a9c8404dd85e8f9
Content-Type: application/octet-stream; 
	name="fix_adjust_page_mask_with_1g.patch"
Content-Disposition: attachment; 
	filename="fix_adjust_page_mask_with_1g.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hh4h82ry0

U3ViamVjdDogW1BBVENIXSB4ODY6IEZpeCBhZGp1c3RfcmFuZ2Vfc2l6ZV9tYXNrIGNhbGxpbmcg
cG9zaXRpb24KCkNvbW1pdCA4ZDU3NDcwZCBjYXVzZSBhIGtlcm5lbCBwYW5pYyB3aGlsZSBzZXR0
aW5nIG1lbT0yRy4KCj4gICAgIFttZW0gMHgwMDAwMDAwMC0weDAwMGZmZmZmXSBwYWdlIDRrCj4g
ICAgIFttZW0gMHg3ZmUwMDAwMC0weDdmZmZmZmZmXSBwYWdlIDFHCj4gICAgIFttZW0gMHg3YzAw
MDAwMC0weDdmZGZmZmZmXSBwYWdlIDFHCj4gICAgIFttZW0gMHgwMDEwMDAwMC0weDAwMWZmZmZm
XSBwYWdlIDRrCj4gICAgIFttZW0gMHgwMDIwMDAwMC0weDdiZmZmZmZmXSBwYWdlIDJNCgpidXQg
Zm9yIGxhc3QgZW50cnkgd2Ugc2hvdWxkIGhhdmUKPiAgICAgW21lbSAweDAwMjAwMDAwLTB4M2Zm
ZmZmZmZdIHBhZ2UgMk0KPiAgICAgW21lbSAweDQwMDAwMDAwLTB4N2JmZmZmZmZdIHBhZ2UgMUcK
CkFjdHVhbGx5IHRoZXJlIGlzIGJ1ZyBhYm91dCBjYWxsaW5nIHNlcXVlbmNlIGZvcgphZGp1c3Rf
cmFuZ2VfcGFnZV9zaXplX21hc2soKS4gbWVyZ2UgZmlyc3Qgd2lsbCBtYWtlCmFkanVzdCB0byAx
ZyBmb3IgcGFydGlhbCByYW5nZSBmYWlsLgoKRml4IHRoYXQgYnkgIGNhbGxpbmcgYWRqdXN0X3Jh
bmdlX3NpemVfbWFzayBiZWZvcmUgbWVyZ2luZyBtZW1fcmFuZ2UKd2l0aCBzYW1lIHBhZ2Ugc2l6
ZS4KCldlIG5lZWQgdGhpcyBvbmUgZm9yIHYzLjkgc3RhYmxlLgoKQmlzZWN0ZWQtYnk6ICJYaWUs
IENoYW5nbG9uZ1giIDxjaGFuZ2xvbmd4LnhpZUBpbnRlbC5jb20+CkJpc2VjdGVkLWJ5OiBZdWFu
aGFuIExpdSA8eXVhbmhhbi5saXVAbGludXguaW50ZWwuY29tPgpSZXBvcnRlZC1ieTogWXVhbmhh
biBMaXUgPHl1YW5oYW4ubGl1QGxpbnV4LmludGVsLmNvbT4KU2lnbmVkLW9mZi1ieTogWWluZ2hh
aSBMdSA8eWluZ2hhaUBrZXJuZWwub3JnPgoKLS0tCiBhcmNoL3g4Ni9tbS9pbml0LmMgfCAgICA2
ICsrKy0tLQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkK
CkluZGV4OiBsaW51eC0yLjYvYXJjaC94ODYvbW0vaW5pdC5jCj09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4
LTIuNi5vcmlnL2FyY2gveDg2L21tL2luaXQuYworKysgbGludXgtMi42L2FyY2gveDg2L21tL2lu
aXQuYwpAQCAtMjc3LDYgKzI3Nyw5IEBAIHN0YXRpYyBpbnQgX19tZW1pbml0IHNwbGl0X21lbV9y
YW5nZShzdHIKIAllbmRfcGZuID0gbGltaXRfcGZuOwogCW5yX3JhbmdlID0gc2F2ZV9tcihtciwg
bnJfcmFuZ2UsIHN0YXJ0X3BmbiwgZW5kX3BmbiwgMCk7CiAKKwlpZiAoIWFmdGVyX2Jvb3RtZW0p
CisJCWFkanVzdF9yYW5nZV9wYWdlX3NpemVfbWFzayhtciwgbnJfcmFuZ2UpOworCiAJLyogdHJ5
IHRvIG1lcmdlIHNhbWUgcGFnZSBzaXplIGFuZCBjb250aW51b3VzICovCiAJZm9yIChpID0gMDsg
bnJfcmFuZ2UgPiAxICYmIGkgPCBucl9yYW5nZSAtIDE7IGkrKykgewogCQl1bnNpZ25lZCBsb25n
IG9sZF9zdGFydDsKQEAgLTI5MSw5ICsyOTQsNiBAQCBzdGF0aWMgaW50IF9fbWVtaW5pdCBzcGxp
dF9tZW1fcmFuZ2Uoc3RyCiAJCW5yX3JhbmdlLS07CiAJfQogCi0JaWYgKCFhZnRlcl9ib290bWVt
KQotCQlhZGp1c3RfcmFuZ2VfcGFnZV9zaXplX21hc2sobXIsIG5yX3JhbmdlKTsKLQogCWZvciAo
aSA9IDA7IGkgPCBucl9yYW5nZTsgaSsrKQogCQlwcmludGsoS0VSTl9ERUJVRyAiIFttZW0gJSMw
MTBseC0lIzAxMGx4XSBwYWdlICVzXG4iLAogCQkJCW1yW2ldLnN0YXJ0LCBtcltpXS5lbmQgLSAx
LAo=
--001a11c1be063a9c8404dd85e8f9--
