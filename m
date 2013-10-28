Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062Ab3J1Q2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:28:05 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38269 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756870Ab3J1Q2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:28:02 -0400
Date: Mon, 28 Oct 2013 12:26:03 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Vladimir =?utf-8?Q?'=CF=86-coder=2Fphcoder'?= Serbinenko" 
	<phcoder@gmail.com>,
        seth.goldberg@oracle.com
Cc: The development of GNU GRUB <grub-devel@gnu.org>,
        Daniel Kiper <daniel.kiper@oracle.com>, boris.ostrovsky@oracle.com,
        david.woodhouse@intel.com, ian.campbell@citrix.com, jbeulich@suse.com,
        keir@xen.org, pjones@redhat.com, richard.l.maliszewski@intel.com,
        ross.philipson@citrix.com, stefano.stabellini@eu.citrix.com,
        xen-devel@lists.xen.org, linux-kernel@vger.kernel.org
Subject: Re: EFI and multiboot2 devlopment work for Xen
Message-ID: <20131028162603.GA4716@phenom.dumpdata.com>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
 <526599A8.9090501@gmail.com>
 <52663D54.2020800@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <52663D54.2020800@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 22, 2013 at 10:54:44AM +0200, Vladimir '=CF=86-coder/phcoder'=
 Serbinenko wrote:
> On 21.10.2013 23:16, Vladimir '=CF=86-coder/phcoder' Serbinenko wrote:
> > Mail is big, I think I got your essential points but I didn't read it=
 whole.
> > On 21.10.2013 14:57, Daniel Kiper wrote:
> >> Hi,
> >>
> >> During work on multiboot2 protocol support for Xen it was discovered
> >> that memory map passed via relevant tag could not represent wide ran=
ge
> >> of memory types available on EFI platforms. Additionally, GRUB2
> >> implementation calls ExitBootServices() on them just before jumping
> >> into loaded image. In this situation loaded system could not clearly
> >> identify reserved memory regions, EFI runtime services regions and o=
thers.
> >>
> > Will a multiboot2 tag with whole EFI memory map solve your problem?
> I added such a tag in documentation and wrote a patch for it (attached)=
.
> Awaiting for someone to test it to commit

Great! I think from Xen perspective we first need to have Xen be able
to understand multiboot2 - that is something Daniel had been working on.
I will let Daniel talk more about it.

Seth, would you have any time to test the patch against Solaris to
make sure it works?

Thanks!
>=20





--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="efi.diff"

=== modified file 'grub-core/loader/i386/multiboot_mbi.c'
--- grub-core/loader/i386/multiboot_mbi.c	2013-10-14 14:33:44 +0000
+++ grub-core/loader/i386/multiboot_mbi.c	2013-10-22 06:57:45 +0000
@@ -36,6 +36,10 @@
 #include <grub/net.h>
 #include <grub/i18n.h>
 
+#ifdef GRUB_MACHINE_EFI
+#include <grub/efi/efi.h>
+#endif
+
 /* The bits in the required part of flags field we don't support.  */
 #define UNSUPPORTED_FLAGS			0x0000fff8
 
@@ -579,6 +583,12 @@
   ptrdest += sizeof (struct grub_vbe_mode_info_block);
 #endif
 
+#ifdef GRUB_MACHINE_EFI
+  err = grub_efi_finish_boot_services (NULL, NULL, NULL, NULL, NULL);
+  if (err)
+    return err;
+#endif
+
   return GRUB_ERR_NONE;
 }
 

=== modified file 'grub-core/loader/multiboot.c'
--- grub-core/loader/multiboot.c	2013-09-23 11:35:33 +0000
+++ grub-core/loader/multiboot.c	2013-10-22 06:51:30 +0000
@@ -131,12 +131,6 @@
   if (err)
     return err;
 
-#ifdef GRUB_MACHINE_EFI
-  err = grub_efi_finish_boot_services (NULL, NULL, NULL, NULL, NULL);
-  if (err)
-    return err;
-#endif
-
 #if defined (__i386__) || defined (__x86_64__)
   grub_relocator32_boot (grub_multiboot_relocator, state, 0);
 #else

=== modified file 'grub-core/loader/multiboot_mbi2.c'
--- grub-core/loader/multiboot_mbi2.c	2013-10-14 14:33:44 +0000
+++ grub-core/loader/multiboot_mbi2.c	2013-10-22 06:57:58 +0000
@@ -295,9 +295,55 @@
 #endif
 }
 
+#ifdef GRUB_MACHINE_EFI
+
+static grub_efi_uintn_t efi_mmap_size = 0;
+
+/* Find the optimal number of pages for the memory map. Is it better to
+   move this code to efi/mm.c?  */
+static void
+find_efi_mmap_size (void)
+{
+  efi_mmap_size = (1 << 12);
+  while (1)
+    {
+      int ret;
+      grub_efi_memory_descriptor_t *mmap;
+      grub_efi_uintn_t desc_size;
+      grub_efi_uintn_t cur_mmap_size = efi_mmap_size;
+
+      mmap = grub_malloc (cur_mmap_size);
+      if (! mmap)
+	return;
+
+      ret = grub_efi_get_memory_map (&cur_mmap_size, mmap, 0, &desc_size, 0);
+      grub_free (mmap);
+
+      if (ret < 0)
+	return;
+      else if (ret > 0)
+	break;
+
+      if (efi_mmap_size < cur_mmap_size)
+	efi_mmap_size = cur_mmap_size;
+      efi_mmap_size += (1 << 12);
+    }
+
+  /* Increase the size a bit for safety, because GRUB allocates more on
+     later, and EFI itself may allocate more.  */
+  efi_mmap_size += (3 << 12);
+
+  efi_mmap_size = ALIGN_UP (efi_mmap_size, 4096);
+}
+#endif
+
 static grub_size_t
 grub_multiboot_get_mbi_size (void)
 {
+#ifdef GRUB_MACHINE_EFI
+  if (!efi_mmap_size)
+    find_efi_mmap_size ();    
+#endif
   return 2 * sizeof (grub_uint32_t) + sizeof (struct multiboot_tag)
     + (sizeof (struct multiboot_tag_string)
        + ALIGN_UP (cmdline_size, MULTIBOOT_TAG_ALIGN))
@@ -318,6 +364,10 @@
     + ALIGN_UP (sizeof (struct multiboot_tag_old_acpi)
 		+ sizeof (struct grub_acpi_rsdp_v10), MULTIBOOT_TAG_ALIGN)
     + acpiv2_size ()
+#ifdef GRUB_MACHINE_EFI
+    + ALIGN_UP (sizeof (struct multiboot_tag_efi_mmap)
+		+ efi_mmap_size, MULTIBOOT_TAG_ALIGN)
+#endif
     + sizeof (struct multiboot_tag_vbe) + MULTIBOOT_TAG_ALIGN - 1
     + sizeof (struct multiboot_tag_apm) + MULTIBOOT_TAG_ALIGN - 1;
 }
@@ -760,6 +810,28 @@
   }
 #endif
 
+#ifdef GRUB_MACHINE_EFI
+  {
+    struct multiboot_tag_efi_mmap *tag = (struct multiboot_tag_efi_mmap *) ptrorig;
+    grub_efi_uintn_t efi_desc_size;
+    grub_efi_uint32_t efi_desc_version;
+
+    tag->type = MULTIBOOT_TAG_TYPE_EFI_MMAP;
+    tag->size = sizeof (*tag) + efi_mmap_size;
+
+    err = grub_efi_finish_boot_services (&efi_mmap_size, tag->efi_mmap, NULL,
+					 &efi_desc_size, &efi_desc_version);
+    if (err)
+      return err;
+    tag->descr_size = efi_desc_size;
+    tag->descr_vers = efi_desc_version;
+    tag->size = sizeof (*tag) + efi_mmap_size;
+
+    ptrorig += ALIGN_UP (tag->size, MULTIBOOT_TAG_ALIGN)
+      / sizeof (grub_properly_aligned_t);
+  }
+#endif
+
   {
     struct multiboot_tag *tag = (struct multiboot_tag *) ptrorig;
     tag->type = MULTIBOOT_TAG_TYPE_END;

=== modified file 'include/multiboot2.h'
--- include/multiboot2.h	2010-09-21 00:06:14 +0000
+++ include/multiboot2.h	2013-10-22 06:37:55 +0000
@@ -58,6 +58,7 @@
 #define MULTIBOOT_TAG_TYPE_ACPI_OLD          14
 #define MULTIBOOT_TAG_TYPE_ACPI_NEW          15
 #define MULTIBOOT_TAG_TYPE_NETWORK           16
+#define MULTIBOOT_TAG_TYPE_EFI_MMAP          17
 
 #define MULTIBOOT_HEADER_TAG_END  0
 #define MULTIBOOT_HEADER_TAG_INFORMATION_REQUEST  1
@@ -361,6 +362,15 @@
   multiboot_uint8_t dhcpack[0];
 };
 
+struct multiboot_tag_efi_mmap
+{
+  multiboot_uint32_t type;
+  multiboot_uint32_t size;
+  multiboot_uint32_t descr_size;
+  multiboot_uint32_t descr_vers;
+  multiboot_uint8_t efi_mmap[0];
+}; 
+
 #endif /* ! ASM_FILE */
 
 #endif /* ! MULTIBOOT_HEADER */


--pf9I7BMVVzbSWLtt--
