Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab3ALLcU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 06:32:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab3ALLcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 06:32:18 -0500
From: Thomas Renninger <trenn@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, ddutile@redhat.com,
        vgoyal@redhat.com, ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com,
        tglx@linutronix.de, khalid@gonehiking.org, horms@verge.net.au
Subject: Re: [PATCH] x86 e820: only void usable memory areas in memmap=exactmap case
Date: Sat, 12 Jan 2013 12:31:59 +0100
Message-ID: <4068140.Uym9gOXymC@hammer82.arch.suse.de>
User-Agent: KMail/4.8.5 (Linux/3.4.11-2.16-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <50F08F43.7080604@zytor.com>
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local> <CAE9FiQWEan4Vq-pbp6sgMWVFHwWygQ4Hq2wRsPH166+7w7L2yg@mail.gmail.com> <50F08F43.7080604@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 11, 2013 02:16:35 PM H. Peter Anvin wrote:
> On 01/11/2013 01:09 PM, Yinghai Lu wrote:
> > On Fri, Jan 11, 2013 at 12:06 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> >> On 01/11/2013 11:59 AM, Yinghai Lu wrote:
> >>> On Fri, Jan 11, 2013 at 10:24 AM, Thomas Renninger <trenn@suse.de> wrote:
> >>>>> We may need to keep exactmap intact.
> >>>> 
> >>>> Why?
> >>>> Kexec/kdump should have been the only user?
> >>>> If older/current kexec calls still add ACPI maps via memmap=X#Y,
> >>>> they should already exist in the original e820 map and fall off or
> >>>> get glued to one region if (wrongly) overlapping via sanitize_map.
> >>> 
> >>> No, kexec/kdump is not the only user for memmap=exactmap.
> >> 
> >> Who is using it then, since you seem to know?
> > 
> > http://forums.gentoo.org/viewtopic-t-487476-highlight-proliant.html
> > 
> > http://forums.fedoraforum.org/archive/index.php/t-225347.html
> 
> Hm... both of those seem to be someone trying memmap=exactmap to hack
> around a problem which really was elsewhere, with a different solution.

Ok, boot params can be counted as "public interface" to the kernel that should/must
not change.
Generally there are several flavors of these:
  1) Purely (low level) debug options
  2) Workarounds for broken HW
  3) Real interface that may make sense on productive systems and which
      applications may pick up

In this case we have a mixture of all.
Kexec/kdump would be the only one for 3. I expect.

IMO nobody should run memmap=exactmap on a productive machine.
These have a sever BIOS (or whereever) bugs and will jump from one
trap to the other trying to update the kernel and similar.
This applies for above 2 links.

What is confusing for developers is if they used memmap=exactmap
already to try a self made up e820 table and might get angry if he realizes
after some time that its usage changed silently

Still introducing another memmap=param would be very unfortunate because
of the kexec version (and work) dependency to get this fixed properly.

Hm, whatabout this:
Tell user that memmap=exactmap usage has changed in !kdump case.
This would cover the very rare cases you mentioned.

In kdump case passing an extra exactmap option was broken anyway.
No need to bore the user with an additional message there.

is_kdump_kernel() cannot be used because it's too early.
But the check is exactly the same (will elfcorehdr_addr be set via
the corresponding boot param).

Compile tested only:


-----------------------------
x86 e820: only void usable memory areas in memmap=exactmap case

All unusable (reserved, ACPI, ACPI NVS,...) areas have to be
honored in kdump case.
Othwerise ACPI parts will quickly run into trouble when trying
to for example early_ioremap reserved areas which are not
declared reserved in kdump kernel.
mmconf area must also be a reserved mem region.

Passing unusable memory via memmap= is a design flaw as
this information is already (exactly for this purpose) passed
via bootloader structure.
In kdump case (when memmap=exactmap is passed), only void
(do not use) usable memory regions from the passed e820 table
and use memory areas defined via memmap=X@Y boot parameter instead.
But do still use the "unusable" memory regions from the original e820
table.

Rename exactmap_parsed to memmap checked as voidmap needs the same checking.

Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 Documentation/kernel-parameters.txt |   18 ++++++++++---
 arch/x86/kernel/e820.c              |   46 ++++++++++++++++++++++++++++++++--
 2 files changed, 57 insertions(+), 7 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 363e348..739b665 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1510,10 +1510,20 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			per-device physically contiguous DMA buffers.
 
 	memmap=exactmap	[KNL,X86] Enable setting of an exact
-			E820 memory map, as specified by the user.
-			Such memmap=exactmap lines can be constructed based on
-			BIOS output or other requirements. See the memmap=nn@ss
-			option description.
+			E820 usable memory map, as specified by the user.
+			All unusable (reserved, ACPI, NVS,...) ranges from the
+			original e820 table are preserved.
+			But the usable memory regions from the original e820
+			table are removed.
+			This parameter is explicitly for kdump usage:
+			The memory the kdump kernel is allowed to use must
+			be passed via below memmap=nn[KMG]@ss[KMG] param.
+			All reserved regions the kernel may use for ioremapping
+			and similar are still considered.
+
+	memmap=voidmap  [KNL,X86] Do not use any e820 ranges from BIOS or
+			bootloader. Instead you have to pass regions via
+			below memmap= options.
 
 	memmap=nn[KMG]@ss[KMG]
 			[KNL] Force usage of a specific region of memory
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index dc0b9f0..4a3803a 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -559,6 +559,19 @@ u64 __init e820_remove_range(u64 start, u64 size, unsigned old_type,
 	return real_removed_size;
 }
 
+static void __init e820_remove_range_type(u32 type)
+{
+	int i;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+		if (ei->type == type) {
+			memset(ei, 0, sizeof(struct e820entry));
+			continue;
+		}
+	}
+}
+
 void __init update_e820(void)
 {
 	u32 nr_map;
@@ -835,21 +848,32 @@ static int __init parse_memopt(char *p)
 }
 early_param("mem", parse_memopt);
 
-static bool __initdata exactmap_parsed;
+static bool __initdata memmap_checked;
 
 static int __init parse_memmap_one(char *p)
 {
 	char *oldp;
 	u64 start_at, mem_size;
+	char *cmdline = boot_command_line;
 
 	if (!p)
 		return -EINVAL;
 
 	if (!strncmp(p, "exactmap", 8)) {
-		if (exactmap_parsed)
+		if (memmap_checked)
 			return 0;
 
-		exactmap_parsed = true;
+		memmap_checked = true;
+		cmdline = strstr(cmdline, "elfcorehdr");
+		if (!cmdline)
+			/*
+			 * No kdump kernel, but exactmap used.
+			 * Tell user about exactmap changes.
+			 * Remove this after some kernel revisions.
+			 */
+			pr_info(
+		"memmap=exactmap changed, use voidmap for old behavior\n");
+
 #ifdef CONFIG_CRASH_DUMP
 		/*
 		 * If we are doing a crash dump, we still need to know
@@ -858,6 +882,22 @@ static int __init parse_memmap_one(char *p)
 		 */
 		saved_max_pfn = e820_end_of_ram_pfn();
 #endif
+		/*
+		 * Remove all usable memory (this is for kdump), usable
+		 * memory will be passed via memmap=X@Y parameter
+		 */
+		e820_remove_range_type(E820_RAM);
+		userdef = 1;
+		return 0;
+	} else if (!strncmp(p, "voidmap", 7)) {
+		if (memmap_checked)
+			return 0;
+
+		memmap_checked = true;
+
+#ifdef CONFIG_CRASH_DUMP
+		saved_max_pfn = e820_end_of_ram_pfn();
+#endif
 		e820.nr_map = 0;
 		userdef = 1;
 		return 0;

