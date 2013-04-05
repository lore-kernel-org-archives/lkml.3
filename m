Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162070Ab3DEQg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 12:36:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39417 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162010Ab3DEQg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:36:28 -0400
From: Thomas Renninger <trenn@suse.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 00/22] x86, ACPI, numa: Parse numa info early
Date: Fri, 05 Apr 2013 18:36:25 +0200
Message-ID: <9825274.7u1gJKhUg4@skinner.arch.suse.de>
Organization: SUSE Products GmbH
User-Agent: KMail/4.10 (Linux/3.7.10-1.1-desktop; KDE/4.10.0; x86_64; ; )
In-Reply-To: <CAE9FiQXE5T=8RJ0FdrMfiTwZ_NDBwjsOM0q_SePWsuQ3tXMz6Q@mail.gmail.com>
References: <1365119186-23487-1-git-send-email-yinghai@kernel.org> <2084826.BkfVPXvXDZ@skinner.arch.suse.de> <CAE9FiQXE5T=8RJ0FdrMfiTwZ_NDBwjsOM0q_SePWsuQ3tXMz6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 04, 2013 08:09:46 PM Yinghai Lu wrote:
...
> can you try
> 
> git checkout -b for-x86-mm origin/for-x86-mm

That worked out much better :)

I see these changes in e820 table, the first part is probably unrelated:

BIOS-e820: [mem 0x0000000000000000-0x000000000009bbff] usable
...
BIOS-e820: [mem 0x0000000000100000-0x00000000ba294fff] usable

modified: [mem 0x0000000000000000-0x0000000000000fff] reserved
modified: [mem 0x0000000000001000-0x000000000009bbff] usable
modified: [mem 0x0000000000100000-0x00000000ba27bfff] usable
...
modified: [mem 0x00000000ba27c000-0x00000000ba2947fc] ACPI data
modified: [mem 0x00000000ba2947fd-0x00000000ba294fff] usable

And the ACPI data section where the modified tables are placed
seem to get correctly inserted at:
0x00000000ba27c000-0x00000000ba2947fc

-> 0x187FC == 100,348 bytes
DSDT and FACP (better known as FADT) I passed have a size
of (see dmesg parts below):
0x18709 + 0xF4 bytes = 100,349 bytes.

Ah wait the 0xba2947fc is inclusive, so it should exactly fit.

I then see:
DSDT ACPI table found in initrd [0x378f5208-0x3790d910]
FACP ACPI table found in initrd [0x3790d9a0-0x3790da93]
ACPI: RSDP 00000000000f0410 00024 (v02  INTEL)
ACPI: XSDT 00000000bdf24d98 0008C (v01  INTEL   ROMLEY 06222004 INTL 20090903)
ACPI: Override [FACP-  ROMLEY], this is unsafe: tainting kernel
Disabling lock debugging due to kernel taint
ACPI: FACP 00000000bdf24a98 Physical table override, new table: ffffffffff4af709
ACPI: FACP 00000000ba294709 000F4 (v04  INTEL   ROMLEY 06222004 INTL 20121220)
ACPI BIOS Bug: Warning: Invalid length for FADT/Pm1aControlBlock: 32, using default 16 (20130117/tbfadt-649)
ACPI: Override [DSDT-  ROMLEY], this is unsafe: tainting kernel
ACPI: DSDT 00000000bdf09018 Physical table override, new table: ffffffffff4af000
ACPI: DSDT 00000000ba27c000 18709 (v02  INTEL   ROMLEY 00000021 INTL 20121220)

Later I see my debug string added to the DSDT when the
PCI Routing Table (_PRT) is processed:
[    9.505419] [ACPI Debug]  String [0x0A] "XXXXXXXXXX"

And taking the FADT from /sys/firmware/acpi/tables/FACP:
my:
PM Profile : 04 [Enterprise Server]
changed (as expected) to:
PM Profile : 02 [Mobile]

>From acpi overriding parts:
Tested-by: Thomas Renninger <trenn@suse.de>

I also went through the override related patches and from
what I can judge (certainly not the early memory, flat 32 bit memory you call it?
specific parts), they look fine.

Nice work!

      Thomas
