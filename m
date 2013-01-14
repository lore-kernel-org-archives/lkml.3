Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab3ANCnu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 21:43:50 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44933 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab3ANCns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 21:43:48 -0500
MIME-Version: 1.0
In-Reply-To: <2741365.qqWvlU8HGl@hammer82.arch.suse.de>
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local>
	<4068140.Uym9gOXymC@hammer82.arch.suse.de>
	<CAE9FiQWNRS6rBzx+fbX+O9_L+Z-4T-oBWZUdzR0sS=P22ctZ0w@mail.gmail.com>
	<2741365.qqWvlU8HGl@hammer82.arch.suse.de>
Date: Sun, 13 Jan 2013 18:43:46 -0800
X-Google-Sender-Auth: xGe0tpD6Ql749T6d37kWmO7leAw
Message-ID: <CAE9FiQV+W21WcZuuWJYJKXhN4sf0mi=iAFgjX644c3EytPXptw@mail.gmail.com>
Subject: Re: [PATCH] x86 e820: only void usable memory areas in
 memmap=exactmap case
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Renninger <trenn@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, ddutile@redhat.com,
        vgoyal@redhat.com, ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com,
        tglx@linutronix.de, khalid@gonehiking.org, horms@verge.net.au
Content-Type: multipart/mixed; boundary=0015175d684e3f145c04d3369dbb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015175d684e3f145c04d3369dbb
Content-Type: text/plain; charset=ISO-8859-1

On Sun, Jan 13, 2013 at 6:08 PM, Thomas Renninger <trenn@suse.de> wrote:
> On Saturday, January 12, 2013 09:07:12 AM Yinghai Lu wrote:
>> On Sat, Jan 12, 2013 at 3:31 AM, Thomas Renninger <trenn@suse.de> wrote:
>> >         memmap=exactmap [KNL,X86] Enable setting of an exact
>> >
>> > -                       E820 memory map, as specified by the user.
>> > -                       Such memmap=exactmap lines can be constructed
>> > based on -                       BIOS output or other requirements. See
>> > the memmap=nn@ss -                       option description.
>> > +                       E820 usable memory map, as specified by the user.
>> > +                       All unusable (reserved, ACPI, NVS,...) ranges from
>> > the +                       original e820 table are preserved.
>> > +                       But the usable memory regions from the original
>> > e820 +                       table are removed.
>> > +                       This parameter is explicitly for kdump usage:
>> > +                       The memory the kdump kernel is allowed to use must
>> > +                       be passed via below memmap=nn[KMG]@ss[KMG] param.
>> > +                       All reserved regions the kernel may use for
>> > ioremapping +                       and similar are still considered.
>> > +
>> > +       memmap=voidmap  [KNL,X86] Do not use any e820 ranges from BIOS or
>> > +                       bootloader. Instead you have to pass regions via
>> > +                       below memmap= options.
>>
>> I would suggest to keep memmap=exactmap meaning not changed, and add
>> memmap=exactusablemap
>> instead.
> I disagree.
> I would like to change memmap=exactmap behavior.
>
> Why:
> 1)
> This is a sever bug (for kdump/kexec). I could imagine quite a lot
> kdump related bugs get silently solved by this fix.
> I expect we agree that the change, however it looks like in the end, should
> still get in in this kernel round?
> With my approach, I would also suggest to spread this to stable kernels.
> -> No need to update/patch kexec-tools, things will just work as they should.
>
> 2)
> I would introduce 2 new memmap= options. However they look like, for example:
> =void_usable_map
> =void_orig_map
> and deprecated exactmap= via
> printk(KERN_INFO "exactmap usage changed and is deprecated\n");
> but still fix it.
> Latest kexec-tools will just use memmap=void_usable_map, old ones
> are still fixed via stable kernel updates.

everyone could understand it straightforward:
exactmap:  memmap will be specified, and it should be honored without
considering old any memmap.
exactusablemap: will make sure only old ram range get removed, and
specified usable ranges will become final usable
ranges in the final memmap. so we need to remove overlapping to old
reserved ranges.

aka: exact means EXACT ...

>
>
>> kexec-tools could be updated to support exactusablemap with
>> kernelversion checking for kdump.
> No, please not. It will be a maintenance/compatibility issue that will remain
> for years or ever in kdump and/or the kernel and it's not necessary.

I don't see there is any problem with it.

those just some kind of improvement without considering kdump.
because kdump/scripts already does good job to provide right exactmap
with usable and acpi reserved areas.
for mmconf, some system that range reserved in e820, and some have that in ACPI.
and those systems will have that mmconf enabled in kdumped kernel.

attached is what I like to have with exactusablemap, but maybe is not
needed, and we can just stay with exactmap...

ps: we don't need to add e820_remove_type...

Yinghai

--0015175d684e3f145c04d3369dbb
Content-Type: application/octet-stream; name="e820_exactusablemap.patch"
Content-Disposition: attachment; filename="e820_exactusablemap.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hbx0cl1a0

LS0tCiBhcmNoL3g4Ni9rZXJuZWwvZTgyMC5jIHwgICAyMCArKysrKysrKysrKysrKysrKysrLQog
MSBmaWxlIGNoYW5nZWQsIDE5IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCkluZGV4OiBs
aW51eC0yLjYvYXJjaC94ODYva2VybmVsL2U4MjAuYwo9PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYu
b3JpZy9hcmNoL3g4Ni9rZXJuZWwvZTgyMC5jCisrKyBsaW51eC0yLjYvYXJjaC94ODYva2VybmVs
L2U4MjAuYwpAQCAtODM2LDYgKzgzNiw3IEBAIHN0YXRpYyBpbnQgX19pbml0IHBhcnNlX21lbW9w
dChjaGFyICpwKQogZWFybHlfcGFyYW0oIm1lbSIsIHBhcnNlX21lbW9wdCk7CiAKIHN0YXRpYyBi
b29sIF9faW5pdGRhdGEgZXhhY3RtYXBfcGFyc2VkOworc3RhdGljIGJvb2wgX19pbml0ZGF0YSBl
eGFjdHVzYWJsZW1hcF9wYXJzZWQ7CiAKIHN0YXRpYyBpbnQgX19pbml0IHBhcnNlX21lbW1hcF9v
bmUoY2hhciAqcCkKIHsKQEAgLTg0NSw3ICs4NDYsNyBAQCBzdGF0aWMgaW50IF9faW5pdCBwYXJz
ZV9tZW1tYXBfb25lKGNoYXIKIAlpZiAoIXApCiAJCXJldHVybiAtRUlOVkFMOwogCi0JaWYgKCFz
dHJuY21wKHAsICJleGFjdG1hcCIsIDgpKSB7CisJaWYgKCFzdHJuY21wKHAsICJleGFjdG1hcCIs
IDgpIHx8ICFzdHJuY21wKHAsICJleGFjdHVzYWJsZW1hcCIsIDE0KSkgewogCQlpZiAoZXhhY3Rt
YXBfcGFyc2VkKQogCQkJcmV0dXJuIDA7CiAKQEAgLTg1OCw2ICs4NTksMTMgQEAgc3RhdGljIGlu
dCBfX2luaXQgcGFyc2VfbWVtbWFwX29uZShjaGFyCiAJCSAqLwogCQlzYXZlZF9tYXhfcGZuID0g
ZTgyMF9lbmRfb2ZfcmFtX3BmbigpOwogI2VuZGlmCisJCWlmICghc3RybmNtcChwLCAiZXhhY3R1
c2FibGVtYXAiLCAxNCkpIHsKKwkJCS8qIHJlbW92ZSBhbGwgb2xkIEU4MjBfUkFNIHJhbmdlcyAq
LworCQkJZTgyMF9yZW1vdmVfcmFuZ2UoMCwgVUxMT05HX01BWCwgRTgyMF9SQU0sIDEpOworCQkJ
ZXhhY3R1c2FibGVtYXBfcGFyc2VkID0gdHJ1ZTsKKwkJCXVzZXJkZWYgPSAxOworCQkJcmV0dXJu
IDA7CisJCX0KIAkJZTgyMC5ucl9tYXAgPSAwOwogCQl1c2VyZGVmID0gMTsKIAkJcmV0dXJuIDA7
CkBAIC04NzEsNiArODc5LDExIEBAIHN0YXRpYyBpbnQgX19pbml0IHBhcnNlX21lbW1hcF9vbmUo
Y2hhcgogCXVzZXJkZWYgPSAxOwogCWlmICgqcCA9PSAnQCcpIHsKIAkJc3RhcnRfYXQgPSBtZW1w
YXJzZShwKzEsICZwKTsKKwkJaWYgKGV4YWN0dXNhYmxlbWFwX3BhcnNlZCkgeworCQkJLyogcmVt
b3ZlIGFsbCByYW5nZSB3aXRoIG90aGVyIHR5cGVzICovCisJCQllODIwX3JlbW92ZV9yYW5nZShz
dGFydF9hdCwgbWVtX3NpemUsCisJCQkJCQkgRTgyMF9SQU0sIDApOworCQl9CiAJCWU4MjBfYWRk
X3JlZ2lvbihzdGFydF9hdCwgbWVtX3NpemUsIEU4MjBfUkFNKTsKIAl9IGVsc2UgaWYgKCpwID09
ICcjJykgewogCQlzdGFydF9hdCA9IG1lbXBhcnNlKHArMSwgJnApOwpAQCAtODkwLDYgKzkwMywx
MSBAQCBzdGF0aWMgaW50IF9faW5pdCBwYXJzZV9tZW1tYXBfb3B0KGNoYXIKIAlwID0gc3Ryc3Ry
KHAsICJleGFjdG1hcCIpOwogCWlmIChwKQogCQlwYXJzZV9tZW1tYXBfb25lKCJleGFjdG1hcCIp
OworCWVsc2UgeworCQlwID0gc3Ryc3RyKGJvb3RfY29tbWFuZF9saW5lLCAiZXhhY3R1c2FibGVt
YXAiKTsKKwkJaWYgKHApCisJCQlwYXJzZV9tZW1tYXBfb25lKCJleGFjdHVzYWJsZW1hcCIpOwor
CX0KIAogCXdoaWxlIChzdHIpIHsKIAkJY2hhciAqayA9IHN0cmNocihzdHIsICcsJyk7Cg==
--0015175d684e3f145c04d3369dbb--
