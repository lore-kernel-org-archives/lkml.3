Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaDVE6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 00:58:40 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:45065 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaDVE6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 00:58:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140422031610.GC4564@dhcp-17-89.nay.redhat.com>
References: <20140421105232.GB4564@dhcp-17-89.nay.redhat.com>
	<CAE9FiQWf+3hMZbt7Ac+vgL+8kqqQS4LKVGmWgrd5fJ4nkSgmPA@mail.gmail.com>
	<CAGXu5j+-Aqe3H04mK=3wRQ-rhpvNVPm1yOKgZrd=Yc3gqrGq0w@mail.gmail.com>
	<20140422031610.GC4564@dhcp-17-89.nay.redhat.com>
Date: Mon, 21 Apr 2014 21:58:35 -0700
X-Google-Sender-Auth: JI_Sf522fQuG_XJyqr80-PafdaY
Message-ID: <CAE9FiQWMUAdzpNV02rhvpBm8m8FJQXmaiuT+HwFWQKVkJQkYsQ@mail.gmail.com>
Subject: Re: kaslr relocation incompitable with kernel loaded high
From: Yinghai Lu <yinghai@kernel.org>
To: WANG Chao <chaowang@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a11c1e914e8c14f04f79a77e1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c1e914e8c14f04f79a77e1
Content-Type: text/plain; charset=UTF-8

On Mon, Apr 21, 2014 at 8:16 PM, WANG Chao <chaowang@redhat.com> wrote:
> On 04/21/14 at 11:01am, Kees Cook wrote:
>> On Mon, Apr 21, 2014 at 10:56 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> > On Mon, Apr 21, 2014 at 3:52 AM, WANG Chao <chaowang@redhat.com> wrote:
>> >> Hi, Kees
>> >>
>> >> When I'm testing kaslr with kdump, I find that when 2nd kernel is loaded
>> >> high, it doesn't boot.
>> >>
>> >> I reserved 128M memory at high with kernel cmdline
>> >> "crashkernel=128M,high crashkernel=0,low", and for which I got:
>> >>
>> >> [    0.000000] Reserving 128MB of memory at 6896MB for crashkernel (System RAM: 6013MB)
>> >>
>> >> Then I load kdump kernel into the reserved memory region, using a local
>> >> modified kexec-tools which is passing e820 in boot_params.
>> >>
>> >> The e820 map of system RAM passed to 2nd kernel:
>> >>
>> >> E820 memmap (of RAM):
>> >> 0000000000001000-000000000009e3ff (1)
>> >> 00000001af000000-00000001b6f5dfff (1)
>> >> 00000001b6fff400-00000001b6ffffff (1)
>> >>
>> >> In which, 2nd kernel is loaded at 0x1b5000000.
>> >>
>> >> After triggerred a system crash, 2nd kernel doesn't boot even with
>> >> "nokaslr" cmdline:
>> >>
>> >> # echo c > /proc/sysrq-trigger
>> >> [..]
>> >>
>> >> I'm in purgatory
>> >> early console in decompress_kernel
>> >> KASLR disabled...
>> >>
>> >> Decompressing Linux... Parsing ELF... Performing relocations...
>> >>
>> >> 32-bit relocation outside of kernel!
>> >
>> > Interesting, when kernel get at "early console in decompress_kernel"
>> > kernel already in 64 bit...
>> >
>> > what does it mean "32-bit relocation outside of kernel" ?
>> >
>> > why 32-bit is involved ?
>>
>> The 64-bit kernel has both 64 and 32 bit relocations (there are two
>> tables at the end of the kernel image). The error means that the
>> resulting relocation is believed to be outside the kernel image:
>>
>> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/arch/x86/boot/compressed/misc.c#n283
>>
>> Which means there is likely something wrong with this calculation in
>> your situation:
>>
>> /*
>>  * Calculate the delta between where vmlinux was linked to load
>>  * and where it was actually loaded.
>>  */
>> delta = min_addr - LOAD_PHYSICAL_ADDR;
>>
>
> Probably.

Please check attached that patch that will solve nokaslr.

Somehow I got "KASLR could not find suitable E820 region..."
so i only have "No relocation needed"

will check that later.

--001a11c1e914e8c14f04f79a77e1
Content-Type: text/x-patch; charset=US-ASCII; name="aslr_1.patch"
Content-Disposition: attachment; filename="aslr_1.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_huaq2gnp0

LS0tCiBhcmNoL3g4Ni9ib290L2NvbXByZXNzZWQvbWlzYy5jIHwgICAxNCArKysrKysrKystLS0t
LQogMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKCkluZGV4
OiBsaW51eC0yLjYvYXJjaC94ODYvYm9vdC9jb21wcmVzc2VkL21pc2MuYwo9PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0t
LSBsaW51eC0yLjYub3JpZy9hcmNoL3g4Ni9ib290L2NvbXByZXNzZWQvbWlzYy5jCisrKyBsaW51
eC0yLjYvYXJjaC94ODYvYm9vdC9jb21wcmVzc2VkL21pc2MuYwpAQCAtMjM1LDggKzIzNSw5IEBA
IHN0YXRpYyB2b2lkIGVycm9yKGNoYXIgKngpCiAJCWFzbSgiaGx0Iik7CiB9CiAKLSNpZiBDT05G
SUdfWDg2X05FRURfUkVMT0NTCi1zdGF0aWMgdm9pZCBoYW5kbGVfcmVsb2NhdGlvbnModm9pZCAq
b3V0cHV0LCB1bnNpZ25lZCBsb25nIG91dHB1dF9sZW4pCisjaWZkZWYgQ09ORklHX1g4Nl9ORUVE
X1JFTE9DUworc3RhdGljIHZvaWQgaGFuZGxlX3JlbG9jYXRpb25zKHZvaWQgKm91dHB1dF9vcmln
LCB2b2lkICpvdXRwdXQsCisJCQkgICAgICAgdW5zaWduZWQgbG9uZyBvdXRwdXRfbGVuKQogewog
CWludCAqcmVsb2M7CiAJdW5zaWduZWQgbG9uZyBkZWx0YSwgbWFwLCBwdHI7CkBAIC0yNDcsNyAr
MjQ4LDcgQEAgc3RhdGljIHZvaWQgaGFuZGxlX3JlbG9jYXRpb25zKHZvaWQgKm91dAogCSAqIENh
bGN1bGF0ZSB0aGUgZGVsdGEgYmV0d2VlbiB3aGVyZSB2bWxpbnV4IHdhcyBsaW5rZWQgdG8gbG9h
ZAogCSAqIGFuZCB3aGVyZSBpdCB3YXMgYWN0dWFsbHkgbG9hZGVkLgogCSAqLwotCWRlbHRhID0g
bWluX2FkZHIgLSBMT0FEX1BIWVNJQ0FMX0FERFI7CisJZGVsdGEgPSBtaW5fYWRkciAtICh1bnNp
Z25lZCBsb25nKW91dHB1dF9vcmlnOwogCWlmICghZGVsdGEpIHsKIAkJZGVidWdfcHV0c3RyKCJO
byByZWxvY2F0aW9uIG5lZWRlZC4uLiAiKTsKIAkJcmV0dXJuOwpAQCAtMzA0LDcgKzMwNSw4IEBA
IHN0YXRpYyB2b2lkIGhhbmRsZV9yZWxvY2F0aW9ucyh2b2lkICpvdXQKICNlbmRpZgogfQogI2Vs
c2UKLXN0YXRpYyBpbmxpbmUgdm9pZCBoYW5kbGVfcmVsb2NhdGlvbnModm9pZCAqb3V0cHV0LCB1
bnNpZ25lZCBsb25nIG91dHB1dF9sZW4pCitzdGF0aWMgaW5saW5lIHZvaWQgaGFuZGxlX3JlbG9j
YXRpb25zKHZvaWQgKm91dHB1dF9vcmlnLCB2b2lkICpvdXRwdXQsCisJCQkJICAgICAgdW5zaWdu
ZWQgbG9uZyBvdXRwdXRfbGVuKQogeyB9CiAjZW5kaWYKIApAQCAtMzY1LDYgKzM2Nyw4IEBAIGFz
bWxpbmthZ2Ugdm9pZCAqZGVjb21wcmVzc19rZXJuZWwodm9pZAogCQkJCSAgdW5zaWduZWQgY2hh
ciAqb3V0cHV0LAogCQkJCSAgdW5zaWduZWQgbG9uZyBvdXRwdXRfbGVuKQogeworCXVuc2lnbmVk
IGNoYXIgKm91dHB1dF9vcmlnID0gb3V0cHV0OworCiAJcmVhbF9tb2RlID0gcm1vZGU7CiAKIAlz
YW5pdGl6ZV9ib290X3BhcmFtcyhyZWFsX21vZGUpOwpAQCAtNDE3LDcgKzQyMSw3IEBAIGFzbWxp
bmthZ2Ugdm9pZCAqZGVjb21wcmVzc19rZXJuZWwodm9pZAogCWRlYnVnX3B1dHN0cigiLi4uICIp
OwogCWRlY29tcHJlc3MoaW5wdXRfZGF0YSwgaW5wdXRfbGVuLCBOVUxMLCBOVUxMLCBvdXRwdXQs
IE5VTEwsIGVycm9yKTsKIAlwYXJzZV9lbGYob3V0cHV0KTsKLQloYW5kbGVfcmVsb2NhdGlvbnMo
b3V0cHV0LCBvdXRwdXRfbGVuKTsKKwloYW5kbGVfcmVsb2NhdGlvbnMob3V0cHV0X29yaWcsIG91
dHB1dCwgb3V0cHV0X2xlbik7CiAJZGVidWdfcHV0c3RyKCJkb25lLlxuQm9vdGluZyB0aGUga2Vy
bmVsLlxuIik7CiAJcmV0dXJuIG91dHB1dDsKIH0K
--001a11c1e914e8c14f04f79a77e1--
