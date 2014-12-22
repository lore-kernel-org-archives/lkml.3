Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbaLVRhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 12:37:38 -0500
Received: from smtpsal1.cc.upv.es ([158.42.249.61]:48152 "EHLO smtpsalv.upv.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754503AbaLVRhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 12:37:36 -0500
Message-ID: <20141222183615.4193722q3opf4uj3@webmail.upv.es>
Date: Mon, 22 Dec 2014 18:36:15 +0100
From: Hector Marco Gisbert <hecmargi@upv.es>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Anton Blanchard <anton@samba.org>, Jiri Kosina <jkosina@suse.cz>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, David Daney <ddaney.cavm@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arun Chandran <achandran@mvista.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ismael Ripoll <iripoll@disca.upv.es>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hanno =?iso-8859-1?b?QvZjaw==?= <hanno@hboeck.de>,
        Will Deacon <will.deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kees Cook <keescook@chromium.org>, Reno Robert <renorobert@gmail.com>
Subject: Re: [PATCH] ASLRv3: randomize_va_space=3 preventing offset2lib
 attack
References: <5489E6D2.2060200@upv.es> <5489FAAD.7000606@upv.es>
 <20141211221158.GS18807@outflux.net> <548B18AC.9@upv.es>
 <CALCETrVAaDDvAttVkJ+1ygymE_uEZOCLtGHHN15v_VDf1PVsmA@mail.gmail.com>
 <5494A0DF.10905@upv.es>
 <CALCETrWB_T9ui=_JSQRLrtbNDx=sJ22im1XujhxptfZRtedeeg@mail.gmail.com>
 <CALCETrWtAM5VGokNkw0tHLXRnRsORND7YY6ehYArtvEtt19COA@mail.gmail.com>
In-Reply-To: <CALCETrWtAM5VGokNkw0tHLXRnRsORND7YY6ehYArtvEtt19COA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Dynamic Internet Messaging Program (DIMP) H3 (1.1.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATH] Randomize properly VVAR/VDSO areas

This is a simple patch to map the VVAR/VDSO areas in the mmap area,
rather than "close to the stack". Mapping the VVAR/VDSO in the mmap area
should fix the "VDSO weakness" (too little entropy). As I mentioned in a
previous message, this solutions should not break the userspace.

In fact, in the current kernel, the VVAR/VDSO are already mmaped in  
the mmap area under certain conditions. To check this you can run the  
following command, which causes to always locate the vdso in the mmap  
area:

$ setarch x86_64 -R cat /proc/self/maps

00400000-0040b000 r-xp         ...  /bin/cat
0060a000-0060b000 r--p         ...  /bin/cat
0060b000-0060c000 rw-p         ...  /bin/cat
0060c000-0062d000 rw-p         ...  [heap]
7ffff6c8c000-7ffff7a12000 r--p ...   /usr/lib/locale/locale-archive
7ffff7a12000-7ffff7bcf000 r-xp ...   /lib/x86_64-linux-gnu/libc-2.17.so
7ffff7bcf000-7ffff7dcf000 ---p ...   /lib/x86_64-linux-gnu/libc-2.17.so
7ffff7dcf000-7ffff7dd3000 r--p ...   /lib/x86_64-linux-gnu/libc-2.17.so
7ffff7dd3000-7ffff7dd5000 rw-p ...   /lib/x86_64-linux-gnu/libc-2.17.so
7ffff7dd5000-7ffff7dda000 rw-p ...
7ffff7dda000-7ffff7dfd000 r-xp ...   /lib/x86_64-linux-gnu/ld-2.17.so
7ffff7fd9000-7ffff7fdc000 rw-p ...
7ffff7ff8000-7ffff7ffa000 rw-p ...
7ffff7ffa000-7ffff7ffc000 r-xp ...   [vdso]
7ffff7ffc000-7ffff7ffd000 r--p ...   /lib/x86_64-linux-gnu/ld-2.17.so
7ffff7ffd000-7ffff7fff000 rw-p ...   /lib/x86_64-linux-gnu/ld-2.17.so
7ffffffde000-7ffffffff000 rw-p ...   [stack]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0   [vsyscall]

Besides using the setarch "to force" the location of the VDSO, the  
function get_unmapped_area may also return an address in the mmap area  
if the "suggested" address is not valid. This is a rare case, but  
which occurs from time to time.

Therefore, putting the VVAR/VDSO in the mmap area, as this patch does,  
should work smoothly.


Signed-off-by: Hector Marco-Gisbert <hecmargi@upv.es>
Signed-off-by: Ismael Ripoll <iripoll@upv.es>

diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 009495b..b61eed2 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -41,42 +41,7 @@ void __init init_vdso_image(const struct vdso_image *image)

  struct linux_binprm;

-/* Put the vdso above the (randomized) stack with another randomized offset.
-   This way there is no hole in the middle of address space.
-   To save memory make sure it is still in the same PTE as the stack top.
-   This doesn't give that many random bits.
-
-   Only used for the 64-bit and x32 vdsos. */
-static unsigned long vdso_addr(unsigned long start, unsigned len)
-{
-#ifdef CONFIG_X86_32
-    return 0;
-#else
-    unsigned long addr, end;
-    unsigned offset;
-    end = (start + PMD_SIZE - 1) & PMD_MASK;
-    if (end >= TASK_SIZE_MAX)
-        end = TASK_SIZE_MAX;
-    end -= len;
-    /* This loses some more bits than a modulo, but is cheaper */
-    offset = get_random_int() & (PTRS_PER_PTE - 1);
-    addr = start + (offset << PAGE_SHIFT);
-    if (addr >= end)
-        addr = end;
-
-    /*
-     * page-align it here so that get_unmapped_area doesn't
-     * align it wrongfully again to the next page. addr can come in 4K
-     * unaligned here as a result of stack start randomization.
-     */
-    addr = PAGE_ALIGN(addr);
-    addr = align_vdso_addr(addr);
-
-    return addr;
-#endif
-}
-
-static int map_vdso(const struct vdso_image *image, bool calculate_addr)
+static int map_vdso(const struct vdso_image *image)
  {
      struct mm_struct *mm = current->mm;
      struct vm_area_struct *vma;
@@ -88,16 +53,9 @@ static int map_vdso(const struct vdso_image *image,  
bool calculate_addr)
          .pages = no_pages,
      };

-    if (calculate_addr) {
-        addr = vdso_addr(current->mm->start_stack,
-                 image->size - image->sym_vvar_start);
-    } else {
-        addr = 0;
-    }
-
      down_write(&mm->mmap_sem);

-    addr = get_unmapped_area(NULL, addr,
+    addr = get_unmapped_area(NULL, 0,
                   image->size - image->sym_vvar_start, 0, 0);
      if (IS_ERR_VALUE(addr)) {
          ret = addr;
@@ -172,7 +130,7 @@ static int load_vdso32(void)
      if (vdso32_enabled != 1)  /* Other values all mean "disabled" */
          return 0;

-    ret = map_vdso(selected_vdso32, false);
+    ret = map_vdso(selected_vdso32);
      if (ret)
          return ret;

@@ -191,7 +149,7 @@ int arch_setup_additional_pages(struct  
linux_binprm *bprm, int uses_interp)
      if (!vdso64_enabled)
          return 0;

-    return map_vdso(&vdso_image_64, true);
+    return map_vdso(&vdso_image_64);
  }

  #ifdef CONFIG_COMPAT
@@ -203,7 +161,7 @@ int compat_arch_setup_additional_pages(struct  
linux_binprm *bprm,
          if (!vdso64_enabled)
              return 0;

-        return map_vdso(&vdso_image_x32, true);
+        return map_vdso(&vdso_image_x32);
      }
  #endif


Andy Lutomirski <luto@amacapital.net> escribió:

> On Fri, Dec 19, 2014 at 2:11 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Fri, Dec 19, 2014 at 2:04 PM, Hector Marco <hecmargi@upv.es> wrote:
>>>
>>>
>>> El 12/12/14 a las 18:17, Andy Lutomirski escribió:
>>>
>>>> On Dec 12, 2014 8:33 AM, "Hector Marco" <hecmargi@upv.es> wrote:
>>>>>
>>>>>
>>>>> Hello,
>>>>>
>>>>> I agree. I don't think a new randomization mode will be needed, just fix
>>>>> the current randomize_va_space=2. Said other way: fixing the offset2lib
>>>>> will not break any current program and so, no need to add additional
>>>>> configuration options. May be we shall wait for some inputs
>>>>> from the list (may be we are missing something).
>>>>>
>>>>>
>>>>> Regarding to VDSO, definitively, is not randomized enough in 64bits.
>>>>> Brute force attacks would be pretty fast even from the network.
>>>>> I have identified the bug and seems quite easy to fix it.
>>>>>
>>>>> On 32bit systems, this is not a issue because it is mapped in the
>>>>> mmap area. In order to fix the VDSO on 64bit, the following
>>>>> considerations shall
>>>>> be discussed:
>>>>>
>>>>>
>>>>> Performance:
>>>>>      It seems (reading the kernel comments) that the random allocation
>>>>>      algorithm tries to place the VDSO in the same PTE than the stack.
>>>>
>>>>
>>>> The comment is wrong.  It means PTE table.
>>>>
>>>>>      But since the permissions of the stack and the VDSO are different
>>>>>      it seems that are getting right the opposite.
>>>>
>>>>
>>>> Permissions have page granularity, so this isn't a problem.
>>>>
>>>>>
>>>>>      Effectively VDSO shall be correctly randomized because it contains
>>>>>      enough useful exploitable stuff.
>>>>>
>>>>>      I think that the possible solution is follow the x86_32 approach
>>>>>      which consist on map the VDSO in the mmap area.
>>>>>
>>>>>      It would be better fix VDSO in a different patch ? I can send a
>>>>>      patch which fixes the VDSO on 64 bit.
>>>>>
>>>>
>>>> What are the considerations for 64-bit memory layout?  I haven't
>>>> touched it because I don't want to break userspace, but I don't know
>>>> what to be careful about.
>>>>
>>>> --Andy
>>>
>>>
>>> I don't think that mapping the VDSO in the mmap area breaks the
>>> userspace. Actually, this is already happening with the current
>>> implementation. You can see it by running:
>>>
>>> setarch x86_64 -R cat /proc/self/maps
>>>
>>
>> Hmm.  So apparently we even switch which side of the stack the vdso is
>> on depending on the randomization setting.
>>
>>>
>>> Do this break the userspace in some way ?
>>>
>>>
>>> Regarding the solution to the offset2lib it seems that placing the
>>> executable in a different memory region area could increase the
>>> number of pages for the pages table (because it is more spread).
>>> We should consider this before fixing the current implementation
>>> (randomize_va_space=2).
>>>
>>> I guess that the current implementation places the PIE executable in
>>> the mmap base area jointly with the libraries in an attempt to reduce
>>> the size of the page table.
>>>
>>> Therefore, I can fix the current implementation (maintaining the
>>> randomize_va_space=2) by moving the PIE executable from the mmap base
>>> area to another one for x86*, ARM* and MIPS (as s390 and PowerPC do).
>>> But we shall agree that this increment in the page table is not a
>>> issue. Otherwise, the randomize_va_space=3 shall be considered.
>>
>> Wrt the vdso itself, though, there is an extra consideration: CRIU.  I
>> *think* that the CRIU vdso proxying scheme will work even if the vdso
>> changes sizes and is adjacent to other mappings.  Cyrill and/or Pavel,
>> am I right?
>>
>> I'm not fundamentally opposed to mapping the vdso just like any other
>> shared library.  I still think that we should have an extra-strong
>> randomization mode in which all the libraries are randomized wrt each
>> other, though.  For many applications, the extra page table cost will
>> be negligible.
>
> This is stupid.  The vdso randomization is just buggy, plain and
> simple.  Patch coming.
>
>>
>> --Andy
>>
>>>
>>>
>>> Hector Marco.
>>>
>>>>
>>>>>
>>>>>
>>>>> Regards,
>>>>> Hector Marco.
>>
>>
>>
>> --
>> Andy Lutomirski
>> AMA Capital Management, LLC
>
>
>
> --
> Andy Lutomirski
> AMA Capital Management, LLC
>



