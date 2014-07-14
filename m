Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbaGNRAD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:00:03 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:44136 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920AbaGNQ7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:59:52 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxYYKApOC+1TQkoxSzi-zTSB8OmkU=ypvNb_Gc2+K6Hmw@mail.gmail.com>
References: <87pph8kse7.fsf@nemi.mork.no>
	<53C3D7C3.7090505@redhat.com>
	<CA+55aFxYYKApOC+1TQkoxSzi-zTSB8OmkU=ypvNb_Gc2+K6Hmw@mail.gmail.com>
Date: Mon, 14 Jul 2014 09:59:51 -0700
X-Google-Sender-Auth: r1TfFpL7gKVVe5aGUzpvj_L-qd8
Message-ID: <CA+55aFzHo4BEO8W0yza7g0YMgg-b=hPbk20-vpR3s==ydpmAOg@mail.gmail.com>
Subject: Re: [BISECTED 3.16-rc REGREGRESSION] backlight control stopped working
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: multipart/mixed; boundary=001a1133da66356ff804fe2a388a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a1133da66356ff804fe2a388a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 9:24 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Bj=C3=B8rn, what's your setup? Is this perhaps solvable some other way?

For example, I wonder if we could fix the "dual brightness change"
problem automatically by making a new option for
'brightness_switch_enabled'.

Currently, there are two cases:

 - enabled: do the actual brightness change _and_ send the input
report keycode for a brightness change

 - disabled: just send the keycode, excpecting the desktop software to
handle it.

and maybe we could have a new case (and make *that* the default):

 - delayed: send the keycode, and set up a delayed timer (say, one
tenth of a second) to do the actual brightness change. And if a
brightness change from user mode comes in during that delay, we cancel
the kernel-induced pending change.

Something like the very hacky attached patch that is COMPLETELY UNTESTED.

My point being that I think we can get this right *without* some
stupid "user has to specify the behavior of their desktop application
and ACPI implementation" crap. Especially since it's entirely possible
that there are different behaviors for the same machine (ie the user
session may act differently from the login screen, which will act
differently from the text virtual terminal).

I really don't expect my patch to work as-is, it is really meant more
as an illustration of an approach that might work. There may well be
many other complications (ie how does this interact with the whole
"use_native_backlight" thing and user space possibly accessing *other*
backlight controls). But I have the feeling that this should be
solvable without breaking old setups or causing problems on newer
ones.

                Linus

--001a1133da66356ff804fe2a388a
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hxm19ug00

IGRyaXZlcnMvYWNwaS92aWRlby5jIHwgNDIgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
LS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMzAgaW5zZXJ0aW9ucygrKSwgMTIgZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9hY3BpL3ZpZGVvLmMgYi9kcml2ZXJzL2FjcGkv
dmlkZW8uYwppbmRleCAwNzFjMWRmYjkzZjMuLjljNGFmZmFjZThlNyAxMDA2NDQKLS0tIGEvZHJp
dmVycy9hY3BpL3ZpZGVvLmMKKysrIGIvZHJpdmVycy9hY3BpL3ZpZGVvLmMKQEAgLTY4LDggKzY4
LDggQEAgTU9EVUxFX0FVVEhPUigiQnJ1bm8gRHVjcm90Iik7CiBNT0RVTEVfREVTQ1JJUFRJT04o
IkFDUEkgVmlkZW8gRHJpdmVyIik7CiBNT0RVTEVfTElDRU5TRSgiR1BMIik7CiAKLXN0YXRpYyBi
b29sIGJyaWdodG5lc3Nfc3dpdGNoX2VuYWJsZWQ7Ci1tb2R1bGVfcGFyYW0oYnJpZ2h0bmVzc19z
d2l0Y2hfZW5hYmxlZCwgYm9vbCwgMDY0NCk7CitzdGF0aWMgaW50IGJyaWdodG5lc3Nfc3dpdGNo
X2VuYWJsZWQgPSAtMTsKK21vZHVsZV9wYXJhbShicmlnaHRuZXNzX3N3aXRjaF9lbmFibGVkLCBp
bnQsIDA2NDQpOwogCiAvKgogICogQnkgZGVmYXVsdCwgd2UgZG9uJ3QgYWxsb3cgZHVwbGljYXRl
IEFDUEkgdmlkZW8gYnVzIGRldmljZXMKQEAgLTI3MCwxMSArMjcwLDIxIEBAIHN0YXRpYyBpbnQg
YWNwaV92aWRlb19nZXRfYnJpZ2h0bmVzcyhzdHJ1Y3QgYmFja2xpZ2h0X2RldmljZSAqYmQpCiAJ
cmV0dXJuIDA7CiB9CiAKK3N0YXRpYyB1MzIgYWNwaV9icmlnaHRuZXNzX2V2ZW50Oworc3RhdGlj
IHN0cnVjdCBhY3BpX3ZpZGVvX2RldmljZSAqYWNwaV9icmlnaHRuZXNzX2RldmljZTsKK3N0YXRp
YyB2b2lkIGFjcGlfdmlkZW9fc2V0X2JyaWdobmVzc19kZWxheWVkKHN0cnVjdCB3b3JrX3N0cnVj
dCAqd29yaykKK3sKKwlhY3BpX3ZpZGVvX3N3aXRjaF9icmlnaHRuZXNzKGFjcGlfYnJpZ2h0bmVz
c19kZXZpY2UsIGFjcGlfYnJpZ2h0bmVzc19ldmVudCk7Cit9CisKK3N0YXRpYyBERUNMQVJFX0RF
TEFZRURfV09SSyhhY3BpX2JyaWdodG5lc3Nfd29yaywgYWNwaV92aWRlb19zZXRfYnJpZ2huZXNz
X2RlbGF5ZWQpOworCiBzdGF0aWMgaW50IGFjcGlfdmlkZW9fc2V0X2JyaWdodG5lc3Moc3RydWN0
IGJhY2tsaWdodF9kZXZpY2UgKmJkKQogewogCWludCByZXF1ZXN0X2xldmVsID0gYmQtPnByb3Bz
LmJyaWdodG5lc3MgKyAyOwogCXN0cnVjdCBhY3BpX3ZpZGVvX2RldmljZSAqdmQgPSBibF9nZXRf
ZGF0YShiZCk7CiAKKwljYW5jZWxfZGVsYXllZF93b3JrKCZhY3BpX2JyaWdodG5lc3Nfd29yayk7
CiAJcmV0dXJuIGFjcGlfdmlkZW9fZGV2aWNlX2xjZF9zZXRfbGV2ZWwodmQsCiAJCQkJdmQtPmJy
aWdodG5lc3MtPmxldmVsc1tyZXF1ZXN0X2xldmVsXSk7CiB9CkBAIC0xNjAxLDYgKzE2MTEsMTkg
QEAgc3RhdGljIHZvaWQgYWNwaV92aWRlb19idXNfbm90aWZ5KHN0cnVjdCBhY3BpX2RldmljZSAq
ZGV2aWNlLCB1MzIgZXZlbnQpCiAJcmV0dXJuOwogfQogCitzdGF0aWMgdm9pZCBicmlnaHRuZXNz
X3N3aXRjaF9ldmVudChzdHJ1Y3QgYWNwaV92aWRlb19kZXZpY2UgKnZpZGVvX2RldmljZSwgdTMy
IGV2ZW50KQoreworCWlmICghYnJpZ2h0bmVzc19zd2l0Y2hfZW5hYmxlZCkKKwkJcmV0dXJuOwor
CWlmIChicmlnaHRuZXNzX3N3aXRjaF9lbmFibGVkID4gMCkgeworCQlhY3BpX3ZpZGVvX3N3aXRj
aF9icmlnaHRuZXNzKHZpZGVvX2RldmljZSwgZXZlbnQpOworCQlyZXR1cm47CisJfQorCWFjcGlf
YnJpZ2h0bmVzc19kZXZpY2UgPSB2aWRlb19kZXZpY2U7CisJYWNwaV9icmlnaHRuZXNzX2V2ZW50
ID0gZXZlbnQ7CisJc2NoZWR1bGVfZGVsYXllZF93b3JrKCZhY3BpX2JyaWdodG5lc3Nfd29yaywg
SFovMTApOworfQorCiBzdGF0aWMgdm9pZCBhY3BpX3ZpZGVvX2RldmljZV9ub3RpZnkoYWNwaV9o
YW5kbGUgaGFuZGxlLCB1MzIgZXZlbnQsIHZvaWQgKmRhdGEpCiB7CiAJc3RydWN0IGFjcGlfdmlk
ZW9fZGV2aWNlICp2aWRlb19kZXZpY2UgPSBkYXRhOwpAQCAtMTYxOCwyOCArMTY0MSwyMyBAQCBz
dGF0aWMgdm9pZCBhY3BpX3ZpZGVvX2RldmljZV9ub3RpZnkoYWNwaV9oYW5kbGUgaGFuZGxlLCB1
MzIgZXZlbnQsIHZvaWQgKmRhdGEpCiAKIAlzd2l0Y2ggKGV2ZW50KSB7CiAJY2FzZSBBQ1BJX1ZJ
REVPX05PVElGWV9DWUNMRV9CUklHSFRORVNTOgkvKiBDeWNsZSBicmlnaHRuZXNzICovCi0JCWlm
IChicmlnaHRuZXNzX3N3aXRjaF9lbmFibGVkKQotCQkJYWNwaV92aWRlb19zd2l0Y2hfYnJpZ2h0
bmVzcyh2aWRlb19kZXZpY2UsIGV2ZW50KTsKKwkJYnJpZ2h0bmVzc19zd2l0Y2hfZXZlbnQodmlk
ZW9fZGV2aWNlLCBldmVudCk7CiAJCWtleWNvZGUgPSBLRVlfQlJJR0hUTkVTU19DWUNMRTsKIAkJ
YnJlYWs7CiAJY2FzZSBBQ1BJX1ZJREVPX05PVElGWV9JTkNfQlJJR0hUTkVTUzoJLyogSW5jcmVh
c2UgYnJpZ2h0bmVzcyAqLwotCQlpZiAoYnJpZ2h0bmVzc19zd2l0Y2hfZW5hYmxlZCkKLQkJCWFj
cGlfdmlkZW9fc3dpdGNoX2JyaWdodG5lc3ModmlkZW9fZGV2aWNlLCBldmVudCk7CisJCWJyaWdo
dG5lc3Nfc3dpdGNoX2V2ZW50KHZpZGVvX2RldmljZSwgZXZlbnQpOwogCQlrZXljb2RlID0gS0VZ
X0JSSUdIVE5FU1NVUDsKIAkJYnJlYWs7CiAJY2FzZSBBQ1BJX1ZJREVPX05PVElGWV9ERUNfQlJJ
R0hUTkVTUzoJLyogRGVjcmVhc2UgYnJpZ2h0bmVzcyAqLwotCQlpZiAoYnJpZ2h0bmVzc19zd2l0
Y2hfZW5hYmxlZCkKLQkJCWFjcGlfdmlkZW9fc3dpdGNoX2JyaWdodG5lc3ModmlkZW9fZGV2aWNl
LCBldmVudCk7CisJCWJyaWdodG5lc3Nfc3dpdGNoX2V2ZW50KHZpZGVvX2RldmljZSwgZXZlbnQp
OwogCQlrZXljb2RlID0gS0VZX0JSSUdIVE5FU1NET1dOOwogCQlicmVhazsKIAljYXNlIEFDUElf
VklERU9fTk9USUZZX1pFUk9fQlJJR0hUTkVTUzoJLyogemVybyBicmlnaHRuZXNzICovCi0JCWlm
IChicmlnaHRuZXNzX3N3aXRjaF9lbmFibGVkKQotCQkJYWNwaV92aWRlb19zd2l0Y2hfYnJpZ2h0
bmVzcyh2aWRlb19kZXZpY2UsIGV2ZW50KTsKKwkJYnJpZ2h0bmVzc19zd2l0Y2hfZXZlbnQodmlk
ZW9fZGV2aWNlLCBldmVudCk7CiAJCWtleWNvZGUgPSBLRVlfQlJJR0hUTkVTU19aRVJPOwogCQli
cmVhazsKIAljYXNlIEFDUElfVklERU9fTk9USUZZX0RJU1BMQVlfT0ZGOgkvKiBkaXNwbGF5IGRl
dmljZSBvZmYgKi8KLQkJaWYgKGJyaWdodG5lc3Nfc3dpdGNoX2VuYWJsZWQpCi0JCQlhY3BpX3Zp
ZGVvX3N3aXRjaF9icmlnaHRuZXNzKHZpZGVvX2RldmljZSwgZXZlbnQpOworCQlicmlnaHRuZXNz
X3N3aXRjaF9ldmVudCh2aWRlb19kZXZpY2UsIGV2ZW50KTsKIAkJa2V5Y29kZSA9IEtFWV9ESVNQ
TEFZX09GRjsKIAkJYnJlYWs7CiAJZGVmYXVsdDoK
--001a1133da66356ff804fe2a388a--
