Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab3ANPF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 10:05:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60032 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab3ANPFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 10:05:54 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] x86 e820: only void usable memory areas in memmap=exactmap case
Date: Mon, 14 Jan 2013 16:05:43 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-24-desktop; KDE/4.6.0; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, ddutile@redhat.com,
        vgoyal@redhat.com, ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com,
        tglx@linutronix.de, khalid@gonehiking.org, horms@verge.net.au
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local> <2741365.qqWvlU8HGl@hammer82.arch.suse.de> <CAE9FiQV+W21WcZuuWJYJKXhN4sf0mi=iAFgjX644c3EytPXptw@mail.gmail.com>
In-Reply-To: <CAE9FiQV+W21WcZuuWJYJKXhN4sf0mi=iAFgjX644c3EytPXptw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201301141605.43428.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 14, 2013 03:43:46 AM Yinghai Lu wrote:
> On Sun, Jan 13, 2013 at 6:08 PM, Thomas Renninger <trenn@suse.de> wrote:
> > On Saturday, January 12, 2013 09:07:12 AM Yinghai Lu wrote:
...
> everyone could understand it straightforward:
> exactmap:  memmap will be specified, and it should be honored without
> considering old any memmap.
> exactusablemap: will make sure only old ram range get removed, and
> specified usable ranges will become final usable
> ranges in the final memmap. so we need to remove overlapping to old
> reserved ranges.
> 
> aka: exact means EXACT ...
The naming is not my point...
Anyway after a quick talk with Alexander Graf, I guess I won't have
much of a chance: rule is rule and a boot param is a public interface
which must not change just like that (deprecation phase, etc.).

...
 
> those just some kind of improvement without considering kdump.
> because kdump/scripts already does good job to provide right exactmap
> with usable and acpi reserved areas.
No it's conceptional wrong to provide the reserved areas via memmap
while the original ones are declared already via boot loader structures.

There are store ACPI NVS memory in suspend/resume workarounds (suspend does not
fit that much for kdump, but there may be more than this and mmconf).
The reserved areas in kdump kernel should be the same than with the
original e820 table to avoid any unforseen issues.
And kdump got them already passed and should use this info.

> for mmconf, some system that range reserved in e820, and some have that in ACPI.
> and those systems will have that mmconf enabled in kdumped kernel.

 
> attached is what I like to have with exactusablemap, but maybe is not
> needed, and we can just stay with exactmap...
> 
> ps: we don't need to add e820_remove_type...
I thought this tiny loop:
+       for (i = 0; i < e820.nr_map; i++) {
+               struct e820entry *ei = &e820.map[i];
+               if (ei->type == type) {
+                       memset(ei, 0, sizeof(struct e820entry));
+                       continue;
+               }
+       }
would be easier to evaluate what it's doing (cmp to.
e820_remove_range(0, ULLONG_MAX, E820_RAM, 1);)
But I do not have a strong opinion on that.

What is this for?:
@@ -871,6 +879,11 @@ static int __init parse_memmap_one(char
 	userdef = 1;
 	if (*p == '@') {
 		start_at = memparse(p+1, &p);
+		if (exactusablemap_parsed) {
+			/* remove all range with other types */
+			e820_remove_range(start_at, mem_size,
+						 E820_RAM, 0);
+		}
 		e820_add_region(start_at, mem_size, E820_RAM);
 	} else if (*p == '#') {
 		start_at = memparse(p+1, &p);


    Thomas
