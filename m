Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab3CHTjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 14:39:53 -0500
Received: from mail-ia0-f180.google.com ([209.85.210.180]:49696 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab3CHTjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 14:39:52 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQU7RP8zTsm9QMnANf8-a9=QRY9Y6sFdEev7+YWd87NDAw@mail.gmail.com>
References: <51397D1D.5030602@redhat.com>
	<1750036321.11235774.1362722613994.JavaMail.root@redhat.com>
	<CAE9FiQUtDcwJkPMPfjur8LQ+u0Hc2J7sbxC=xkcemqRQ1_Gd8g@mail.gmail.com>
	<CAE9FiQU7ccdWCL=t=Zn1w33GHpHk56=JXTcotn-Huq9Wiqu7wg@mail.gmail.com>
	<51399154.5030500@redhat.com>
	<CAE9FiQVPaG5P7mG9HoFzCkaxF62hkU5hEtq_FhdT7n+38aNs9A@mail.gmail.com>
	<51399442.1080609@redhat.com>
	<CAE9FiQWCfnOjOuWKihv1GamgHb4KLrrPEiBTspQMqK7_fBDunw@mail.gmail.com>
	<5139D5A0.6000600@redhat.com>
	<CAE9FiQU7RP8zTsm9QMnANf8-a9=QRY9Y6sFdEev7+YWd87NDAw@mail.gmail.com>
Date: Fri, 8 Mar 2013 11:39:51 -0800
X-Google-Sender-Auth: 39XWvUqj7rS8DYz6-wY19-san3E
Message-ID: <CAE9FiQUwWLUqdvtGZPY7WOFSiC5YZjm7Mcoj+V+m6qJzeRNCLQ@mail.gmail.com>
Subject: Re: 3.9-rc1: crash kernel panic - not syncing: Can not allocate
 SWIOTLB buffer earlier and can't now provide you with the DMA bounce buffer
From: Yinghai Lu <yinghai@kernel.org>
To: WANG Chao <chaowang@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuahkhan@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: CAI Qian <caiqian@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        kexec <kexec@lists.infradead.org>, Dave Young <dyoung@redhat.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>
Content-Type: multipart/mixed; boundary=f46d04462e0aa3bde104d76efcaa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d04462e0aa3bde104d76efcaa
Content-Type: text/plain; charset=ISO-8859-1

[ Add more to To list ]

On Fri, Mar 8, 2013 at 10:24 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Mar 8, 2013 at 4:12 AM, WANG Chao <chaowang@redhat.com> wrote:
>
>>> what is 00:02.0 in your system?
>> This IOMMU issue is related to https://lkml.org/lkml/2012/11/26/814. We can
>> discuss this IOMMU issue in that thread.
>> Anyway 00:02.0 is a video card, the box is Ivy Bridge.
>> # lspci -s 00:02.0 -v
>> 00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core processor
>> Graphics Controller (rev 09) (prog-if 00 [VGA controller])
>>         Subsystem: Intel Corporation Device 2211
>>         Flags: bus master, fast devsel, latency 0, IRQ 44
>>         Memory at afc00000 (64-bit, non-prefetchable) [size=4M]
>>         Memory at c0000000 (64-bit, prefetchable) [size=256M]
>>         I/O ports at 6000 [size=64]
>>         Expansion ROM at <unassigned> [disabled]
>>         Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
>>         Capabilities: [d0] Power Management version 2
>>         Capabilities: [a4] PCI Advanced Features
>>         Kernel driver in use: i915
>
> disable drm for i915 will make your iommu work with dump?
>
>>
>>
>> Is it expected to intel_iommu=on or crashkernel_low to make 2nd kernel boot in
>> 3.9? Back in 3.8, it works just fine w/ only crashkernel param.
>
> Yes, I really do not want to set crashkernel low range like 72M
> automatically for all.
> that would have the system with proper iommu support lose 72M under 4G
> in first kernel.
> And can not play allocate and return tricks, as first kernel have no
> idea if iommu will work
> on second kernel even iommu is working on first kernel.
>
> Better to fix iommu support at first.
>
> For old system that does not have DMAR or kernel does not have IOMMU
> support enabled, or
> user does not pass intel_iommu=on.
> We could set crashkernel low range to 72M automatically.

It seem that it is not worthy to check case that does not support
IOMMU in second kernel.

Please check attached patch that will just set crashkernel_low auto, and if the
system DO support iommu with kdump, user can specify crashkernel_low=0
to save low 72M.

Thanks

Yinghai

--f46d04462e0aa3bde104d76efcaa
Content-Type: application/octet-stream; name="fix_crashkernel_low.patch"
Content-Disposition: attachment; filename="fix_crashkernel_low.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_he1qwxp30

U3ViamVjdDogW1BBVENIfSB4ODYsIGtkdW1wOiBhdXRvIHNldCBjcmFzaGtlcm5lbCBsb3cgc2l6
ZQoKQ3VycmVudCBjb2RlIGRvZXMgbm90IHNldCBsb3cgcmFuZ2UgZm9yIGNyYXNoa2VybmVsIGlm
CnRoZSB1c2VyIGRvZXMgbm90IHNwZWNpZnkgdGhhdC4KClRoYXQgY2F1c2UgcmVncmVzc2lvbnMg
b24gc3lzdGVtIHRoYXQgZG9lcyBub3Qgc3VwcG9ydAppbnRlbF9pb21tdSBwcm9wZXJseS4KCkNo
YW8gc2FpZCBoaXMgc3lzdGVtIGRvZXMgd29yayB3ZWxsIG9uIDMuOCB3aXRob3V0IGV4dHJhIHBh
cmFtZXRlci4KYW5kIGlvbW11IGRvZXMgbm90IHdvcmsgd2l0aCBrZHVtcC4KClNldCBsb3cgYXV0
b21hdGljYWxseSBpZiB0aGUgdXNlciBkb2VzIG5vdCBzcGVjaWZ5IHRoYXQuCgpGb3Igc3lzdGVt
IHRoYXQgZG9lcyBzdXBwb3J0IElPTU1VIHdpdGgga2R1bXAgcHJvcGVybHksIHVzZXIgY291bGQK
c3BlY2lmeSBjcmFzaGtlcm5lbF9sb3c9MCB0byBzYXZlIHRoYXQgNzJNIGxvdyByYW0uCgpSZXBv
cnRlZC1ieTogV0FORyBDaGFvIDxjaGFvd2FuZ0ByZWRoYXQuY29tPgpTaWduZWQtb2ZmLWJ5OiBZ
aW5naGFpIEx1IDx5aW5naGFpQGtlcm5lbC5vcmc+CgotLS0KIGFyY2gveDg2L2tlcm5lbC9zZXR1
cC5jIHwgICAxNSArKysrKysrKysrKystLS0KIDEgZmlsZSBjaGFuZ2VkLCAxMiBpbnNlcnRpb25z
KCspLCAzIGRlbGV0aW9ucygtKQoKSW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwvc2V0
dXAuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9hcmNoL3g4Ni9rZXJuZWwvc2V0dXAu
YworKysgbGludXgtMi42L2FyY2gveDg2L2tlcm5lbC9zZXR1cC5jCkBAIC01MjEsMTkgKzUyMSwy
OCBAQCBzdGF0aWMgdm9pZCBfX2luaXQgcmVzZXJ2ZV9jcmFzaGtlcm5lbF9sCiAJdW5zaWduZWQg
bG9uZyBsb25nIGxvd19iYXNlID0gMCwgbG93X3NpemUgPSAwOwogCXVuc2lnbmVkIGxvbmcgdG90
YWxfbG93X21lbTsKIAl1bnNpZ25lZCBsb25nIGxvbmcgYmFzZTsKKwlib29sIGF1dG9fc2V0ID0g
ZmFsc2U7CiAJaW50IHJldDsKIAogCXRvdGFsX2xvd19tZW0gPSBtZW1ibG9ja19tZW1fc2l6ZSgx
VUw8PCgzMi1QQUdFX1NISUZUKSk7CiAJcmV0ID0gcGFyc2VfY3Jhc2hrZXJuZWxfbG93KGJvb3Rf
Y29tbWFuZF9saW5lLCB0b3RhbF9sb3dfbWVtLAogCQkJCQkJJmxvd19zaXplLCAmYmFzZSk7Ci0J
aWYgKHJldCAhPSAwIHx8IGxvd19zaXplIDw9IDApCi0JCXJldHVybjsKKwlpZiAocmV0ICE9IDAp
IHsKKwkJLyogZGVmYXVsdCBzd2lvdGxiIHNpemUgYW5kIG92ZXJmbG93OiA2NE0gKyA4TSAqLwor
CQlsb3dfc2l6ZSA9IDcyVUwgPDwgMjA7CisJCWF1dG9fc2V0ID0gdHJ1ZTsKKwl9IGVsc2Ugewor
CQkvKiBwYXNzZWQgd2l0aCBjcmFzaGtlcm5lbF9sb3c9MCA/ICovCisJCWlmICghbG93X3NpemUp
CisJCQlyZXR1cm47CisJfQogCiAJbG93X2Jhc2UgPSBtZW1ibG9ja19maW5kX2luX3JhbmdlKGxv
d19zaXplLCAoMVVMTDw8MzIpLAogCQkJCQlsb3dfc2l6ZSwgYWxpZ25tZW50KTsKIAogCWlmICgh
bG93X2Jhc2UpIHsKLQkJcHJfaW5mbygiY3Jhc2hrZXJuZWwgbG93IHJlc2VydmF0aW9uIGZhaWxl
ZCAtIE5vIHN1aXRhYmxlIGFyZWEgZm91bmQuXG4iKTsKKwkJaWYgKCFhdXRvX3NldCkKKwkJCXBy
X2luZm8oImNyYXNoa2VybmVsIGxvdyByZXNlcnZhdGlvbiBmYWlsZWQgLSBObyBzdWl0YWJsZSBh
cmVhIGZvdW5kLlxuIik7CiAKIAkJcmV0dXJuOwogCX0K
--f46d04462e0aa3bde104d76efcaa--
