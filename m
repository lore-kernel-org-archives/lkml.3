Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab3LJDKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 22:10:25 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:57737 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab3LJDKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 22:10:24 -0500
MIME-Version: 1.0
Date: Mon, 9 Dec 2013 19:10:23 -0800
Message-ID: <CAMe9rOob2T+VWkZyHpaoBy6fUeTyAocpw4-cBpdrar2rtdAeew@mail.gmail.com>
Subject: RFC: binutils PATCH: Set e_type to ET_EXEC for -pie -Ttext-segment=
From: "H.J. Lu" <hjl.tools@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Binutils <binutils@sourceware.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My original post was rejected by LKML.  Resend.

On Mon, Dec 9, 2013 at 4:41 PM, H.J. Lu <hjl.tools@gmail.com> wrote:
> On Mon, Dec 9, 2013 at 4:37 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 12/09/2013 03:53 PM, H.J. Lu wrote:
>>>>>
>>>>> x86-64 small model is limited to 4GB in size.  You can't build
>>>>> a dynamic executable in small model larger than 4GB.
>>>>>
>>>>> There are medium and large models.  But they are slower than
>>>>> small models as well as small models in PIE.  Also there are
>>>>> no glibc run-times for medium and large models.
>>>>>
>>>> Compiling for the small PIC model shouldn't automatically mean
>>>> generating a PIE (ET_DYN) executable, though (and if those are
>>>> inherently linked, that is a fundamental bug IMNSHO.)
>>>
>>> PIE uses PIC. But GCC has -fPIE and -fPIC.  They aren't
>>> the same.   You build PIE with
>>>
>>> 1. Compile with -fPIE.
>>> 2. Link with -pie.
>>>
>>
>> I'm talking about the memory model ("small PIC model").  I don't see why
>> it should be encapsulated in a PIE (ET_DYN) container if the user
>> doesn't want it to be relocatable.
>>
>
> I see.  Maybe linker can set ET_EXEC if vaddr is non-zero.
>

Hi,

Linker sets e_type in ELF header to ET_DYN for -pie -Ttext-segment=0xXXX.
When I added -Ttext-segment=0xXXX, one goal was to load
small model executable above 4GB on Linux/x86-64, which
was done with -pie -Ttext-segment=0xXXX.  But -pie sets
e_type in ELF header to ET_DYN and kernel may ignore
p_vaddr in ELF header to load ET_DYN binary at a random
address.  This patch changes ld to set e_type in ELF header
to ET_EXEC if the first PT_LOAD segment has non-zero
p_vaddr.  If this is unacceptable as generic ELF change,
I can make it specific to x86.

Thanks.


--
H.J.
--
diff --git a/bfd/elf.c b/bfd/elf.c
index 8df38ee..5862460 100644
--- a/bfd/elf.c
+++ b/bfd/elf.c
@@ -5152,6 +5152,27 @@ assign_file_positions_except_relocs (bfd *abfd,
         return FALSE;
     }

+      if (link_info != NULL
+      && link_info->executable
+      && link_info->shared)
+    {
+      Elf_Internal_Phdr *segment;
+      unsigned int i;
+      unsigned int num_segments = elf_elfheader (abfd)->e_phnum;
+      bfd_vma p_vaddr = 0;
+      for (i = 0, segment = elf_tdata (abfd)->phdr;
+           i < num_segments;
+           i++, segment++)
+        if (segment->p_type == PT_LOAD)
+          {
+        p_vaddr = segment->p_vaddr;
+        break;
+          }
+
+      if (p_vaddr)
+        i_ehdrp->e_type = ET_EXEC;
+    }
+
       /* Write out the program headers.  */
       alloc = elf_program_header_size (abfd) / bed->s->sizeof_phdr;
       if (bfd_seek (abfd, (bfd_signed_vma) bed->s->sizeof_ehdr, SEEK_SET) != 0


-- 
H.J.
