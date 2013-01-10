Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab3AJXel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:34:41 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:63075 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab3AJXej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:34:39 -0500
MIME-Version: 1.0
In-Reply-To: <1586060.uJlkOEQfVW@hammer82.arch.suse.de>
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local>
	<201301081747.17853.trenn@suse.de>
	<CAE9FiQW=gT86Eo0gwPHi5iFi4sg=1SHkBohBAo2KXdoB_Ouqvw@mail.gmail.com>
	<1586060.uJlkOEQfVW@hammer82.arch.suse.de>
Date: Thu, 10 Jan 2013 15:34:37 -0800
X-Google-Sender-Auth: ZNIp4QMd0anz95vbvHvPllukBEA
Message-ID: <CAE9FiQVLVxj07TM1N6F2kmZdBYMUiS6Xz2bD-JZPtvps3a5-xw@mail.gmail.com>
Subject: Re: [PATCH] Only reset e820 once, even with multiple memmap=exactmap params
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Renninger <trenn@suse.de>
Cc: MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, ddutile@redhat.com,
        vgoyal@redhat.com, ishii.hironobu@jp.fujitsu.com, hpa@zytor.com,
        bhelgaas@google.com, tglx@linutronix.de, khalid@gonehiking.org,
        horms@verge.net.au
Content-Type: multipart/mixed; boundary=00151748e0f045c07b04d2f79f44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00151748e0f045c07b04d2f79f44
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Jan 9, 2013 at 7:21 PM, Thomas Renninger <trenn@suse.de> wrote:
> I still do not understand why:
>
> Kexec (kexec/firmware_memmap.c) is setting up the e820 map from:
> /sys/firmware/memmap/*
> and pass it via bootloader structures.
> And this e820 table gets immediately voided by memmap=exactmap
> and a new one passed via boot parameters is set up.
> If I read this correctly, this is what happens?

yes, kdump scripts append those memmap.

>
> Can kexec simply pass the memory to use via memmap=X@Y
> Then take the original e820 table, but not the usable entries (those
> are coming from above memmap=X@Y).
> That would mean that the kexec kernel takes all the
> original ACPI, ACPI NVS, reserved, unusable (everthing but usable) entries
> from the original e820 table and identifies the usable memory from
> memmap boot param?

kdump scripts already do that for acpi regions, need to update it
to append that for mmconf.

>
> This would be much smarter than trying to pass the mmconf reserved
> area and I could imagine other issues will show up if the reserved areas
> do not match the original ones in the kexec kernel.
>
> If this really can be done and memmap=exactmap was only used by kexec,
> it's logic could be redefined from "drop all e820 entries" to
> "drop all usable e820 entries" and no further adjustings in kexec/kernel are
> needed to get mmconf working (and other issues may be avoided before
> they happen). Beside that ACPI reserved aread is not needed anymore to get
> passed via memmap=X#Y by kexec.

yes, we have other user for debug  like simulating user memmap for some bugs.

current problem for exactmap is that we don't scan that at first.

attached patch could help that.

Thanks

Yinghai

--00151748e0f045c07b04d2f79f44
Content-Type: application/octet-stream; name="parse_exactmap_one_time.patch"
Content-Disposition: attachment; filename="parse_exactmap_one_time.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hbsjamlz0

LS0tCiBhcmNoL3g4Ni9rZXJuZWwvZTgyMC5jIHwgICAxMiArKysrKysrKysrKysKIDEgZmlsZSBj
aGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspCgpJbmRleDogbGludXgtMi42L2FyY2gveDg2L2tlcm5l
bC9lODIwLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYva2VybmVsL2U4
MjAuYworKysgbGludXgtMi42L2FyY2gveDg2L2tlcm5lbC9lODIwLmMKQEAgLTgzNSw2ICs4MzUs
OCBAQCBzdGF0aWMgaW50IF9faW5pdCBwYXJzZV9tZW1vcHQoY2hhciAqcCkKIH0KIGVhcmx5X3Bh
cmFtKCJtZW0iLCBwYXJzZV9tZW1vcHQpOwogCitzdGF0aWMgYm9vbCBfX2luaXRkYXRhIGV4YWN0
bWFwX3BhcnNlZDsKKwogc3RhdGljIGludCBfX2luaXQgcGFyc2VfbWVtbWFwX29uZShjaGFyICpw
KQogewogCWNoYXIgKm9sZHA7CkBAIC04NDQsNiArODQ2LDEwIEBAIHN0YXRpYyBpbnQgX19pbml0
IHBhcnNlX21lbW1hcF9vbmUoY2hhcgogCQlyZXR1cm4gLUVJTlZBTDsKIAogCWlmICghc3RybmNt
cChwLCAiZXhhY3RtYXAiLCA4KSkgeworCQlpZiAoZXhhY3RtYXBfcGFyc2VkKQorCQkJcmV0dXJu
IDA7CisKKwkJZXhhY3RtYXBfcGFyc2VkID0gdHJ1ZTsKICNpZmRlZiBDT05GSUdfQ1JBU0hfRFVN
UAogCQkvKgogCQkgKiBJZiB3ZSBhcmUgZG9pbmcgYSBjcmFzaCBkdW1wLCB3ZSBzdGlsbCBuZWVk
IHRvIGtub3cKQEAgLTg3OSw2ICs4ODUsMTIgQEAgc3RhdGljIGludCBfX2luaXQgcGFyc2VfbWVt
bWFwX29uZShjaGFyCiB9CiBzdGF0aWMgaW50IF9faW5pdCBwYXJzZV9tZW1tYXBfb3B0KGNoYXIg
KnN0cikKIHsKKwljaGFyICpwID0gYm9vdF9jb21tYW5kX2xpbmU7CisKKwlwID0gc3Ryc3RyKHAs
ICJleGFjdG1hcCIpOworCWlmIChwKQorCQlwYXJzZV9tZW1tYXBfb25lKCJleGFjdG1hcCIpOwor
CiAJd2hpbGUgKHN0cikgewogCQljaGFyICprID0gc3RyY2hyKHN0ciwgJywnKTsKIAo=
--00151748e0f045c07b04d2f79f44--
