Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750895Ab3GEEHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 00:07:19 -0400
Received: from intranet.asianux.com ([58.214.24.6]:58803 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab3GEEHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 00:07:16 -0400
X-Spam-Score: -100.5
Message-ID: <51D6463B.7050207@asianux.com>
Date: Fri, 05 Jul 2013 12:06:19 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, hannes@cmpxchg.org, riel@redhat.com,
        mhocko@suse.cz, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/vmscan.c: 'lru' may be used without initialized after
 the patch "3abf380..." in next-20130607 tree
References: <51C155D1.3090304@asianux.com> <20130619001029.ee623fae.akpm@linux-foundation.org> <51C15B7B.9060804@asianux.com>
In-Reply-To: <51C15B7B.9060804@asianux.com>
Content-Type: multipart/mixed;
 boundary="------------070505090509030405020205"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070505090509030405020205
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 06/19/2013 03:19 PM, Chen Gang wrote:
> On 06/19/2013 03:10 PM, Andrew Morton wrote:
>> On Wed, 19 Jun 2013 14:55:13 +0800 Chen Gang <gang.chen@asianux.com> wrote:
>>
>>>>
>>>> 'lru' may be used without initialized, so need regressing part of the
>>>> related patch.
>>>>
>>>> The related patch:
>>>>   "3abf380 mm: remove lru parameter from __lru_cache_add and lru_cache_add_lru"
>>>>
>>>> ...
>>>>
>>>> --- a/mm/vmscan.c
>>>> +++ b/mm/vmscan.c
>>>> @@ -595,6 +595,7 @@ redo:
>>>>  		 * unevictable page on [in]active list.
>>>>  		 * We know how to handle that.
>>>>  		 */
>>>> +		lru = !!TestClearPageActive(page) + page_lru_base_type(page);
>>>>  		lru_cache_add(page);
>>>>  	} else {
>>>>  		/*
>> That looks right.  Why the heck didn't gcc-4.4.4 (at least) warn about it?
>>
> 
> Sorry I don't know either, I find it by reading code, this time.
> 
> It is really necessary to continue analyzing why. In 2nd half of 2013, I
> have planned to make some patches outside kernel but related with kernel
> (e.g. LTP, gcc patches).
> 
> This kind of issue is a good chance for me to start in 2nd half of 2013
> (start from next month).
> 
> So if no others reply for it, I will start analyzing it in the next
> month, and plan to finish within a month (before 2013-07-31).
> 
> 
> Welcome additional suggestions or completions.
> 
> Thanks.
> 

Under gcc 4.7.2 20120921 (Red Hat 4.7.2-2) also cause this issue.

The root cause is:

  for putback_lur_page() in mm/vmscan.c for next-20130621 tree.
  the compiler assumes "lru == LRU_UNEVICTABLE" instead of report warnings (uninitializing lru)

The details are below, and the related info and warn are in
attachments, please check, thanks.

Next, I will compile gcc compiler with the gcc latest code, if also has
this issue, I should communicate with gcc mailing list for it.

Thanks.

------------------------------analyzing begin---------------------------------

/* source code in mm/vmscan.c for next-20130621 */

 580 void putback_lru_page(struct page *page)
 581 {
 582         int lru;
 583         int was_unevictable = PageUnevictable(page);
 584 
 585         VM_BUG_ON(PageLRU(page));
 586 
 587 redo:
 588         ClearPageUnevictable(page);
 589 
 590         if (page_evictable(page)) {
 591                 /*
 592                  * For evictable pages, we can use the cache.
 593                  * In event of a race, worst case is we end up with an
 594                  * unevictable page on [in]active list.
 595                  * We know how to handle that.
 596                  */
 597                 lru_cache_add(page);
 598         } else {
 599                 /*
 600                  * Put unevictable pages directly on zone's unevictable
 601                  * list.
 602                  */
 603                 lru = LRU_UNEVICTABLE;
 604                 add_page_to_unevictable_list(page);
 605                 /*
 606                  * When racing with an mlock or AS_UNEVICTABLE clearing
 607                  * (page is unlocked) make sure that if the other thread
 608                  * does not observe our setting of PG_lru and fails
 609                  * isolation/check_move_unevictable_pages,
 610                  * we see PG_mlocked/AS_UNEVICTABLE cleared below and move
 611                  * the page back to the evictable list.
 612                  *
 613                  * The other side is TestClearPageMlocked() or shmem_lock().
 614                  */
 615                 smp_mb();
 616         }
 617 
 618         /*
 619          * page's status can change while we move it among lru. If an evictable
 620          * page is on unevictable list, it never be freed. To avoid that,
 621          * check after we added it to the list, again.
 622          */
 623         if (lru == LRU_UNEVICTABLE && page_evictable(page)) {
 624                 if (!isolate_lru_page(page)) {
 625                         put_page(page);
 626                         goto redo;
 627                 }
 628                 /* This means someone else dropped this page from LRU
 629                  * So, it will be freed or putback to LRU again. There is
 630                  * nothing to do here.
 631                  */
 632         }
 633 
 634         if (was_unevictable && lru != LRU_UNEVICTABLE)
 635                 count_vm_event(UNEVICTABLE_PGRESCUED);
 636         else if (!was_unevictable && lru == LRU_UNEVICTABLE)
 637                 count_vm_event(UNEVICTABLE_PGCULLED);
 638 
 639         put_page(page);         /* drop ref from isolate */
 640 }


/*
 * Related disassemble code:
 *   make defconfig under x86_64 PC.
 *   make menuconfig (choose "Automount devtmpfs at /dev..." and KGDB)
 *   make V=1 EXTRA_CFLAGS=-W (not find related warnings, ref warn.log in attachment)
 *   objdump -d vmlinux > vmlinux.S
 *   vi vmlinux.S
 *
 * The issue is: compiler assumes "lru == LRU_UNEVICTABLE" instead of report warnings (uninitializing lru)
 */

ffffffff810ffda0 <putback_lru_page>:
ffffffff810ffda0:	55                   	push   %rbp
ffffffff810ffda1:	48 89 e5             	mov    %rsp,%rbp
ffffffff810ffda4:	41 55                	push   %r13
ffffffff810ffda6:	41 54                	push   %r12
ffffffff810ffda8:	4c 8d 67 02          	lea    0x2(%rdi),%r12		; %r12 for ClearPageUnevictable(page);
ffffffff810ffdac:	53                   	push   %rbx
ffffffff810ffdad:	48 89 fb             	mov    %rdi,%rbx		; %rbx = page
ffffffff810ffdb0:	48 83 ec 08          	sub    $0x8,%rsp		; for lru, was_unevictable, but not used.

ffffffff810ffdb4:	4c 8b 2f             	mov    (%rdi),%r13		; %r13 = "was_unevictable = PageUnevictable(page);"
ffffffff810ffdb7:	49 c1 ed 14          	shr    $0x14,%r13
ffffffff810ffdbb:	41 83e5 01          	and    $0x1,%r13d
ffffffff810ffdbf:	90                   	nop

/* redo */
ffffffff810ffdc0:	f0 41 80 24 24 ef    	lock andb $0xef,(%r12)		; ClearPageUnevictable(page);

/* if (page_evictable(page)) { */
ffffffff810ffdc6:	48 89 df             	mov    %rbx,%rdi
ffffffff810ffdc9:	e8 92 ff ff ff       	callq  ffffffff810ffd60 <page_evictable>
ffffffff810ffdce:	85 c0                	test   %eax,%eax
ffffffff810ffdd0:	48 89 df             	mov    %rbx,%rdi
ffffffff810ffdd3:	74 0b                	je     ffffffff810ffde0 <putback_lru_page+0x40>

ffffffff810ffdd5:	e8 96 c5 ff ff       	callq  ffffffff810fc370 <lru_cache_add>
ffffffff810ffdda:	eb 0c                	jmp    ffffffff810ffde8 <putback_lru_page+0x48>
ffffffff810ffddc:	0f 1f 40 00          	nopl   0x0(%rax)

/* } else { */
						; assume lru == LRU_UNEVICTABLE
ffffffff810ffde0:	e8 ab c5 ff ff       	callq  ffffffff810fc390 <add_page_to_unevictable_list>
ffffffff810ffde5:	0f ae f0             	mfence 

/* } */

/* if (lru == LRU_UNEVICTABLE && page_evictable(page)) { */
ffffffff810ffde8:	48 89 df             	mov    %rbx,%rdi
ffffffff810ffdeb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
ffffffff810ffdf0:	e8 6b ff ff ff       	callq  ffffffff810ffd60 <page_evictable>
ffffffff810ffdf5:	85 c0                	test   %eax,%eax
ffffffff810ffdf7:	74 1f                	je     ffffffff810ffe18 <putback_lru_page+0x78>  ; assume lru == LRU_UNEVICTABLE

ffffffff810ffdf9:	48 89 df             	mov    %rbx,%rdi
ffffffff810ffdfc:	e8 0f fb ff ff       	callq  ffffffff810ff910 <isolate_lru_page>
ffffffff810ffe01:	85 c0                	test   %eax,%eax
ffffffff810ffe03:	75 13                	jne    ffffffff810ffe18 <putback_lru_page+0x78>
ffffffff810ffe05:	48 89 df             	mov    %rbx,%rdi
ffffffff810ffe08:	e8 93 c0 ff ff       	callq  ffffffff810fbea0 <put_page>
ffffffff810ffe0d:	0f 1f 00             	nopl   (%rax)
ffffffff810ffe10:	eb ae                	jmp    ffffffff810ffdc0 <putback_lru_page+0x20>	; goto redo;
ffffffff810ffe12:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

/* } */

/* if (was_unevictable && lru != LRU_UNEVICTABLE) */
	/* skip... */

/* else if (!was_unevictable && lru == LRU_UNEVICTABLE) */
ffffffff810ffe18:	4d 85 ed             	test   %r13,%r13		; !was_unevictable, and assume lru == LRU_UNEVICTABLE
ffffffff810ffe1b:	75 09                	jne    ffffffff810ffe26 <putback_lru_page+0x86>
ffffffff810ffe1d:	65 48 ff 04 25 68 f0 	incq   %gs:0xf068	; it is for count_vm_event(UNEVICTABLE_PGCULLED)
									; and "incq   %gs:0xf078" is for count_vm_event(UNEVICTABLE_PGRESCUED)
ffffffff810ffe24:	00 00 

/* put_page(); */
ffffffff810ffe26:	48 89 df             	mov    %rbx,%rdi
ffffffff810ffe29:	e8 72 c0 ff ff       	callq  ffffffff810fbea0 <put_page>
ffffffff810ffe2e:	48 83 c4 08          	add    $0x8,%rsp
ffffffff810ffe32:	5b                   	pop    %rbx
ffffffff810ffe33:	41 5c                	pop    %r12
ffffffff810ffe35:	41 5d                	pop    %r13
ffffffff810ffe37:	5d                   	pop    %rbp
ffffffff810ffe38:	c3                   	retq   
ffffffff810ffe39:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)


------------------------------analyzing end-----------------------------------



Thanks.
-- 
Chen Gang

--------------070505090509030405020205
Content-Type: text/x-log;
 name="info.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="info.log"


[root@dhcp122 linux-next]# gcc -v
Using built-in specs.
COLLECT_GCC=3Dgcc
COLLECT_LTO_WRAPPER=3D/usr/libexec/gcc/x86_64-redhat-linux/4.7.2/lto-wrap=
per
Target: x86_64-redhat-linux
Configured with: ../configure --prefix=3D/usr --mandir=3D/usr/share/man -=
-infodir=3D/usr/share/info --with-bugurl=3Dhttp://bugzilla.redhat.com/bug=
zilla --enable-bootstrap --enable-shared --enable-threads=3Dposix --enabl=
e-checking=3Drelease --disable-build-with-cxx --disable-build-poststage1-=
with-cxx --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exc=
eptions --enable-gnu-unique-object --enable-linker-build-id --with-linker=
-hash-style=3Dgnu --enable-languages=3Dc,c++,objc,obj-c++,java,fortran,ad=
a,go,lto --enable-plugin --enable-initfini-array --enable-java-awt=3Dgtk =
--disable-dssi --with-java-home=3D/usr/lib/jvm/java-1.5.0-gcj-1.5.0.0/jre=
 --enable-libgcj-multifile --enable-java-maintainer-mode --with-ecj-jar=3D=
/usr/share/java/eclipse-ecj.jar --disable-libjava-multilib --with-ppl --w=
ith-cloog --with-tune=3Dgeneric --with-arch_32=3Di686 --build=3Dx86_64-re=
dhat-linux
Thread model: posix
gcc version 4.7.2 20120921 (Red Hat 4.7.2-2) (GCC)=20


  gcc -Wp,-MD,mm/.vmscan.o.d  -nostdinc -isystem /usr/lib/gcc/x86_64-redh=
at-linux/4.7.2/include -I/root/linux-next/arch/x86/include -Iarch/x86/inc=
lude/generated  -Iinclude -I/root/linux-next/arch/x86/include/uapi -Iarch=
/x86/include/generated/uapi -I/root/linux-next/include/uapi -Iinclude/gen=
erated/uapi -include /root/linux-next/include/linux/kconfig.h -D__KERNEL_=
_ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -=
fno-common -Werror-implicit-function-declaration -Wno-format-security -fn=
o-delete-null-pointer-checks -O2 -m64 -mtune=3Dgeneric -mno-red-zone -mcm=
odel=3Dkernel -funit-at-a-time -maccumulate-outgoing-args -DCONFIG_AS_CFI=
=3D1 -DCONFIG_AS_CFI_SIGNAL_FRAME=3D1 -DCONFIG_AS_CFI_SECTIONS=3D1 -DCONF=
IG_AS_FXSAVEQ=3D1 -DCONFIG_AS_AVX=3D1 -DCONFIG_AS_AVX2=3D1 -pipe -Wno-sig=
n-compare -fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mn=
o-3dnow -mno-avx -Wframe-larger-than=3D2048 -fno-stack-protector -Wno-unu=
sed-but-set-variable -fno-omit-frame-pointer -fno-optimize-sibling-calls =
-Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fco=
nserve-stack -DCC_HAVE_ASM_GOTO -W    -D"KBUILD_STR(s)=3D#s" -D"KBUILD_BA=
SENAME=3DKBUILD_STR(vmscan)"  -D"KBUILD_MODNAME=3DKBUILD_STR(vmscan)" -c =
-o mm/vmscan.o mm/vmscan.c


--------------070505090509030405020205
Content-Type: text/x-log;
 name="warn.log"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="warn.log"

In file included from /root/linux-next/arch/x86/include/asm/bitops.h:16:0,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:10,
                 from include/asm-generic/bug.h:13,
                 from /root/linux-next/arch/x86/include/asm/bug.h:38,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from mm/vmscan.c:14:
/root/linux-next/arch/x86/include/asm/alternative.h: In function ‘apply_paravirt’:
/root/linux-next/arch/x86/include/asm/alternative.h:203:63: warning: unused parameter ‘start’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/alternative.h:204:35: warning: unused parameter ‘end’ [-Wunused-parameter]
In file included from include/linux/kernel.h:13:0,
                 from include/asm-generic/bug.h:13,
                 from /root/linux-next/arch/x86/include/asm/bug.h:38,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from mm/vmscan.c:14:
include/linux/printk.h: In function ‘no_printk’:
include/linux/printk.h:95:27: warning: unused parameter ‘fmt’ [-Wunused-parameter]
In file included from include/linux/kernel.h:14:0,
                 from include/asm-generic/bug.h:13,
                 from /root/linux-next/arch/x86/include/asm/bug.h:38,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from mm/vmscan.c:14:
include/linux/dynamic_debug.h: In function ‘ddebug_remove_module’:
include/linux/dynamic_debug.h:114:52: warning: unused parameter ‘mod’ [-Wunused-parameter]
include/linux/dynamic_debug.h: In function ‘ddebug_dyndbg_module_param_cb’:
include/linux/dynamic_debug.h:119:68: warning: unused parameter ‘val’ [-Wunused-parameter]
include/linux/dynamic_debug.h:120:19: warning: unused parameter ‘modname’ [-Wunused-parameter]
In file included from include/asm-generic/bug.h:13:0,
                 from /root/linux-next/arch/x86/include/asm/bug.h:38,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from mm/vmscan.c:14:
include/linux/kernel.h: In function ‘__might_sleep’:
include/linux/kernel.h:166:48: warning: unused parameter ‘file’ [-Wunused-parameter]
include/linux/kernel.h:166:58: warning: unused parameter ‘line’ [-Wunused-parameter]
include/linux/kernel.h:167:12: warning: unused parameter ‘preempt_offset’ [-Wunused-parameter]
include/linux/kernel.h: In function ‘____trace_printk_check_format’:
include/linux/kernel.h:496:48: warning: unused parameter ‘fmt’ [-Wunused-parameter]
In file included from /root/linux-next/arch/x86/include/asm/thread_info.h:11:0,
                 from include/linux/thread_info.h:54,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from mm/vmscan.c:14:
/root/linux-next/arch/x86/include/asm/page.h: In function ‘clear_user_page’:
/root/linux-next/arch/x86/include/asm/page.h:24:62: warning: unused parameter ‘vaddr’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/page.h:25:21: warning: unused parameter ‘pg’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/page.h: In function ‘copy_user_page’:
/root/linux-next/arch/x86/include/asm/page.h:30:71: warning: unused parameter ‘vaddr’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/page.h:31:20: warning: unused parameter ‘topage’ [-Wunused-parameter]
In file included from /root/linux-next/arch/x86/include/asm/vm86.h:5:0,
                 from /root/linux-next/arch/x86/include/asm/processor.h:10,
                 from /root/linux-next/arch/x86/include/asm/thread_info.h:22,
                 from include/linux/thread_info.h:54,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from mm/vmscan.c:14:
/root/linux-next/arch/x86/include/asm/ptrace.h: In function ‘v8086_mode’:
/root/linux-next/arch/x86/include/asm/ptrace.h:113:46: warning: unused parameter ‘regs’ [-Wunused-parameter]
In file included from /root/linux-next/arch/x86/include/asm/processor.h:10:0,
                 from /root/linux-next/arch/x86/include/asm/thread_info.h:22,
                 from include/linux/thread_info.h:54,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from mm/vmscan.c:14:
/root/linux-next/arch/x86/include/asm/vm86.h: In function ‘handle_vm86_trap’:
/root/linux-next/arch/x86/include/asm/vm86.h:75:61: warning: unused parameter ‘a’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/vm86.h:75:69: warning: unused parameter ‘b’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/vm86.h:75:76: warning: unused parameter ‘c’ [-Wunused-parameter]
In file included from /root/linux-next/arch/x86/include/asm/cpumask.h:4:0,
                 from /root/linux-next/arch/x86/include/asm/msr.h:10,
                 from /root/linux-next/arch/x86/include/asm/processor.h:20,
                 from /root/linux-next/arch/x86/include/asm/thread_info.h:22,
                 from include/linux/thread_info.h:54,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from mm/vmscan.c:14:
include/linux/cpumask.h: In function ‘alloc_cpumask_var’:
include/linux/cpumask.h:676:53: warning: unused parameter ‘mask’ [-Wunused-parameter]
include/linux/cpumask.h:676:65: warning: unused parameter ‘flags’ [-Wunused-parameter]
include/linux/cpumask.h: In function ‘alloc_cpumask_var_node’:
include/linux/cpumask.h:681:58: warning: unused parameter ‘mask’ [-Wunused-parameter]
include/linux/cpumask.h:681:70: warning: unused parameter ‘flags’ [-Wunused-parameter]
include/linux/cpumask.h:682:12: warning: unused parameter ‘node’ [-Wunused-parameter]
include/linux/cpumask.h: In function ‘zalloc_cpumask_var’:
include/linux/cpumask.h:687:66: warning: unused parameter ‘flags’ [-Wunused-parameter]
include/linux/cpumask.h: In function ‘zalloc_cpumask_var_node’:
include/linux/cpumask.h:693:71: warning: unused parameter ‘flags’ [-Wunused-parameter]
include/linux/cpumask.h:694:12: warning: unused parameter ‘node’ [-Wunused-parameter]
include/linux/cpumask.h: In function ‘alloc_bootmem_cpumask_var’:
include/linux/cpumask.h:700:61: warning: unused parameter ‘mask’ [-Wunused-parameter]
include/linux/cpumask.h: In function ‘free_cpumask_var’:
include/linux/cpumask.h:704:51: warning: unused parameter ‘mask’ [-Wunused-parameter]
include/linux/cpumask.h: In function ‘free_bootmem_cpumask_var’:
include/linux/cpumask.h:708:59: warning: unused parameter ‘mask’ [-Wunused-parameter]
include/linux/cpumask.h: In function ‘__check_is_bitmap’:
include/linux/cpumask.h:748:58: warning: unused parameter ‘bitmap’ [-Wunused-parameter]
In file included from /root/linux-next/arch/x86/include/asm/thread_info.h:22:0,
                 from include/linux/thread_info.h:54,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from mm/vmscan.c:14:
/root/linux-next/arch/x86/include/asm/processor.h: In function ‘native_set_iopl_mask’:
/root/linux-next/arch/x86/include/asm/processor.h:496:50: warning: unused parameter ‘mask’ [-Wunused-parameter]
In file included from include/linux/spinlock_types.h:18:0,
                 from include/linux/spinlock.h:81,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from mm/vmscan.c:14:
include/linux/lockdep.h: In function ‘print_irqtrace_events’:
include/linux/lockdep.h:465:62: warning: unused parameter ‘curr’ [-Wunused-parameter]
In file included from include/linux/spinlock.h:87:0,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from mm/vmscan.c:14:
/root/linux-next/arch/x86/include/asm/spinlock.h: In function ‘arch_spin_lock_flags’:
/root/linux-next/arch/x86/include/asm/spinlock.h:127:23: warning: unused parameter ‘flags’ [-Wunused-parameter]
In file included from include/linux/mmzone.h:9:0,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from mm/vmscan.c:14:
include/linux/wait.h: In function ‘__remove_wait_queue’:
include/linux/wait.h:137:59: warning: unused parameter ‘head’ [-Wunused-parameter]
In file included from include/linux/notifier.h:13:0,
                 from include/linux/memory_hotplug.h:6,
                 from include/linux/mmzone.h:797,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from mm/vmscan.c:14:
include/linux/mutex.h: In function ‘mutex_destroy’:
include/linux/mutex.h:98:48: warning: unused parameter ‘lock’ [-Wunused-parameter]
In file included from include/linux/rwsem.h:40:0,
                 from include/linux/notifier.h:14,
                 from include/linux/memory_hotplug.h:6,
                 from include/linux/mmzone.h:797,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from mm/vmscan.c:14:
/root/linux-next/arch/x86/include/asm/rwsem.h: In function ‘__down_write_nested’:
/root/linux-next/arch/x86/include/asm/rwsem.h:102:70: warning: unused parameter ‘subclass’ [-Wunused-parameter]
In file included from include/linux/rcupdate.h:44:0,
                 from include/linux/srcu.h:33,
                 from include/linux/notifier.h:15,
                 from include/linux/memory_hotplug.h:6,
                 from include/linux/mmzone.h:797,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from mm/vmscan.c:14:
include/linux/debugobjects.h: In function ‘debug_object_init’:
include/linux/debugobjects.h:85:31: warning: unused parameter ‘addr’ [-Wunused-parameter]
include/linux/debugobjects.h:85:61: warning: unused parameter ‘descr’ [-Wunused-parameter]
include/linux/debugobjects.h: In function ‘debug_object_init_on_stack’:
include/linux/debugobjects.h:87:34: warning: unused parameter ‘addr’ [-Wunused-parameter]
include/linux/debugobjects.h:87:64: warning: unused parameter ‘descr’ [-Wunused-parameter]
include/linux/debugobjects.h: In function ‘debug_object_activate’:
include/linux/debugobjects.h:89:31: warning: unused parameter ‘addr’ [-Wunused-parameter]
include/linux/debugobjects.h:89:61: warning: unused parameter ‘descr’ [-Wunused-parameter]
include/linux/debugobjects.h: In function ‘debug_object_deactivate’:
include/linux/debugobjects.h:91:31: warning: unused parameter ‘addr’ [-Wunused-parameter]
include/linux/debugobjects.h:91:61: warning: unused parameter ‘descr’ [-Wunused-parameter]
include/linux/debugobjects.h: In function ‘debug_object_destroy’:
include/linux/debugobjects.h:93:31: warning: unused parameter ‘addr’ [-Wunused-parameter]
include/linux/debugobjects.h:93:61: warning: unused parameter ‘descr’ [-Wunused-parameter]
include/linux/debugobjects.h: In function ‘debug_object_free’:
include/linux/debugobjects.h:95:31: warning: unused parameter ‘addr’ [-Wunused-parameter]
include/linux/debugobjects.h:95:61: warning: unused parameter ‘descr’ [-Wunused-parameter]
include/linux/debugobjects.h: In function ‘debug_object_assert_init’:
include/linux/debugobjects.h:97:32: warning: unused parameter ‘addr’ [-Wunused-parameter]
include/linux/debugobjects.h:97:62: warning: unused parameter ‘descr’ [-Wunused-parameter]
include/linux/debugobjects.h: In function ‘debug_check_no_obj_freed’:
include/linux/debugobjects.h:107:38: warning: unused parameter ‘address’ [-Wunused-parameter]
include/linux/debugobjects.h:107:61: warning: unused parameter ‘size’ [-Wunused-parameter]
In file included from include/linux/srcu.h:33:0,
                 from include/linux/notifier.h:15,
                 from include/linux/memory_hotplug.h:6,
                 from include/linux/mmzone.h:797,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from mm/vmscan.c:14:
include/linux/rcupdate.h: In function ‘rcu_user_hooks_switch’:
include/linux/rcupdate.h:239:62: warning: unused parameter ‘prev’ [-Wunused-parameter]
include/linux/rcupdate.h:240:27: warning: unused parameter ‘next’ [-Wunused-parameter]
In file included from include/linux/srcu.h:33:0,
                 from include/linux/notifier.h:15,
                 from include/linux/memory_hotplug.h:6,
                 from include/linux/mmzone.h:797,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from mm/vmscan.c:14:
include/linux/rcupdate.h: In function ‘init_rcu_head_on_stack’:
include/linux/rcupdate.h:295:60: warning: unused parameter ‘head’ [-Wunused-parameter]
include/linux/rcupdate.h: In function ‘destroy_rcu_head_on_stack’:
include/linux/rcupdate.h:299:63: warning: unused parameter ‘head’ [-Wunused-parameter]
include/linux/rcupdate.h: In function ‘rcu_is_nocb_cpu’:
include/linux/rcupdate.h:1014:40: warning: unused parameter ‘cpu’ [-Wunused-parameter]
In file included from include/linux/workqueue.h:8:0,
                 from include/linux/srcu.h:34,
                 from include/linux/notifier.h:15,
                 from include/linux/memory_hotplug.h:6,
                 from include/linux/mmzone.h:797,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from mm/vmscan.c:14:
include/linux/timer.h: In function ‘destroy_timer_on_stack’:
include/linux/timer.h:103:62: warning: unused parameter ‘timer’ [-Wunused-parameter]
In file included from include/linux/srcu.h:34:0,
                 from include/linux/notifier.h:15,
                 from include/linux/memory_hotplug.h:6,
                 from include/linux/mmzone.h:797,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from mm/vmscan.c:14:
include/linux/workqueue.h: In function ‘__init_work’:
include/linux/workqueue.h:199:52: warning: unused parameter ‘work’ [-Wunused-parameter]
include/linux/workqueue.h:199:62: warning: unused parameter ‘onstack’ [-Wunused-parameter]
include/linux/workqueue.h: In function ‘destroy_work_on_stack’:
include/linux/workqueue.h:200:62: warning: unused parameter ‘work’ [-Wunused-parameter]
include/linux/workqueue.h: In function ‘work_static’:
include/linux/workqueue.h:201:60: warning: unused parameter ‘work’ [-Wunused-parameter]
In file included from include/linux/notifier.h:15:0,
                 from include/linux/memory_hotplug.h:6,
                 from include/linux/mmzone.h:797,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from mm/vmscan.c:14:
include/linux/srcu.h: In function ‘srcu_read_lock_held’:
include/linux/srcu.h:167:59: warning: unused parameter ‘sp’ [-Wunused-parameter]
In file included from include/linux/mmzone.h:797:0,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from mm/vmscan.c:14:
include/linux/memory_hotplug.h: In function ‘pgdat_resize_lock’:
include/linux/memory_hotplug.h:201:58: warning: unused parameter ‘p’ [-Wunused-parameter]
include/linux/memory_hotplug.h:201:76: warning: unused parameter ‘f’ [-Wunused-parameter]
include/linux/memory_hotplug.h: In function ‘pgdat_resize_unlock’:
include/linux/memory_hotplug.h:202:60: warning: unused parameter ‘p’ [-Wunused-parameter]
include/linux/memory_hotplug.h:202:78: warning: unused parameter ‘f’ [-Wunused-parameter]
include/linux/memory_hotplug.h: In function ‘pgdat_resize_init’:
include/linux/memory_hotplug.h:203:58: warning: unused parameter ‘pgdat’ [-Wunused-parameter]
include/linux/memory_hotplug.h: In function ‘zone_span_seqbegin’:
include/linux/memory_hotplug.h:205:56: warning: unused parameter ‘zone’ [-Wunused-parameter]
include/linux/memory_hotplug.h: In function ‘zone_span_seqretry’:
include/linux/memory_hotplug.h:209:51: warning: unused parameter ‘zone’ [-Wunused-parameter]
include/linux/memory_hotplug.h:209:66: warning: unused parameter ‘iv’ [-Wunused-parameter]
include/linux/memory_hotplug.h: In function ‘zone_span_writelock’:
include/linux/memory_hotplug.h:213:53: warning: unused parameter ‘zone’ [-Wunused-parameter]
include/linux/memory_hotplug.h: In function ‘zone_span_writeunlock’:
include/linux/memory_hotplug.h:214:55: warning: unused parameter ‘zone’ [-Wunused-parameter]
include/linux/memory_hotplug.h: In function ‘zone_seqlock_init’:
include/linux/memory_hotplug.h:215:51: warning: unused parameter ‘zone’ [-Wunused-parameter]
include/linux/memory_hotplug.h: In function ‘register_page_bootmem_info_node’:
include/linux/memory_hotplug.h:224:72: warning: unused parameter ‘pgdat’ [-Wunused-parameter]
include/linux/memory_hotplug.h: In function ‘is_mem_section_removable’:
include/linux/memory_hotplug.h:241:58: warning: unused parameter ‘pfn’ [-Wunused-parameter]
include/linux/memory_hotplug.h:242:20: warning: unused parameter ‘nr_pages’ [-Wunused-parameter]
include/linux/memory_hotplug.h: In function ‘try_offline_node’:
include/linux/memory_hotplug.h:247:41: warning: unused parameter ‘nid’ [-Wunused-parameter]
include/linux/memory_hotplug.h: In function ‘offline_pages’:
include/linux/memory_hotplug.h:249:47: warning: unused parameter ‘start_pfn’ [-Wunused-parameter]
include/linux/memory_hotplug.h:249:72: warning: unused parameter ‘nr_pages’ [-Wunused-parameter]
include/linux/memory_hotplug.h: In function ‘remove_memory’:
include/linux/memory_hotplug.h:254:38: warning: unused parameter ‘nid’ [-Wunused-parameter]
include/linux/memory_hotplug.h:254:47: warning: unused parameter ‘start’ [-Wunused-parameter]
include/linux/memory_hotplug.h:254:58: warning: unused parameter ‘size’ [-Wunused-parameter]
In file included from include/linux/gfp.h:4:0,
                 from include/linux/mm.h:8,
                 from mm/vmscan.c:14:
include/linux/mmzone.h: In function ‘is_highmem_idx’:
include/linux/mmzone.h:865:49: warning: unused parameter ‘idx’ [-Wunused-parameter]
include/linux/mmzone.h: In function ‘is_highmem’:
include/linux/mmzone.h:881:43: warning: unused parameter ‘zone’ [-Wunused-parameter]
In file included from /root/linux-next/arch/x86/include/uapi/asm/bootparam.h:33:0,
                 from /root/linux-next/arch/x86/include/asm/x86_init.h:5,
                 from /root/linux-next/arch/x86/include/asm/mpspec.h:7,
                 from /root/linux-next/arch/x86/include/asm/smp.h:12,
                 from /root/linux-next/arch/x86/include/asm/mmzone_64.h:10,
                 from /root/linux-next/arch/x86/include/asm/mmzone.h:4,
                 from include/linux/mmzone.h:920,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from mm/vmscan.c:14:
/root/linux-next/arch/x86/include/asm/e820.h: In function ‘early_memtest’:
/root/linux-next/arch/x86/include/asm/e820.h:48:48: warning: unused parameter ‘start’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/e820.h:48:69: warning: unused parameter ‘end’ [-Wunused-parameter]
In file included from /root/linux-next/arch/x86/include/asm/numa.h:6:0,
                 from /root/linux-next/arch/x86/include/asm/acpi.h:28,
                 from /root/linux-next/arch/x86/include/asm/fixmap.h:19,
                 from /root/linux-next/arch/x86/include/asm/apic.h:12,
                 from /root/linux-next/arch/x86/include/asm/smp.h:13,
                 from /root/linux-next/arch/x86/include/asm/mmzone_64.h:10,
                 from /root/linux-next/arch/x86/include/asm/mmzone.h:4,
                 from include/linux/mmzone.h:920,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from mm/vmscan.c:14:
/root/linux-next/arch/x86/include/asm/topology.h: In function ‘arch_fix_phys_package_id’:
/root/linux-next/arch/x86/include/asm/topology.h:132:49: warning: unused parameter ‘num’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/topology.h:132:58: warning: unused parameter ‘slot’ [-Wunused-parameter]
In file included from /root/linux-next/arch/x86/include/asm/smp.h:13:0,
                 from /root/linux-next/arch/x86/include/asm/mmzone_64.h:10,
                 from /root/linux-next/arch/x86/include/asm/mmzone.h:4,
                 from include/linux/mmzone.h:920,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from mm/vmscan.c:14:
/root/linux-next/arch/x86/include/asm/apic.h: In function ‘flat_vector_allocation_domain’:
/root/linux-next/arch/x86/include/asm/apic.h:622:35: warning: unused parameter ‘cpu’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/apic.h:623:32: warning: unused parameter ‘mask’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/apic.h: In function ‘default_vector_allocation_domain’:
/root/linux-next/arch/x86/include/asm/apic.h:639:28: warning: unused parameter ‘mask’ [-Wunused-parameter]
In file included from include/linux/gfp.h:4:0,
                 from include/linux/mm.h:8,
                 from mm/vmscan.c:14:
include/linux/mmzone.h: In function ‘memmap_valid_within’:
include/linux/mmzone.h:1271:53: warning: unused parameter ‘pfn’ [-Wunused-parameter]
include/linux/mmzone.h:1272:19: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/mmzone.h:1272:38: warning: unused parameter ‘zone’ [-Wunused-parameter]
In file included from include/linux/mm.h:8:0,
                 from mm/vmscan.c:14:
include/linux/gfp.h: In function ‘arch_free_page’:
include/linux/gfp.h:293:48: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/gfp.h:293:58: warning: unused parameter ‘order’ [-Wunused-parameter]
include/linux/gfp.h: In function ‘arch_alloc_page’:
include/linux/gfp.h:296:49: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/gfp.h:296:59: warning: unused parameter ‘order’ [-Wunused-parameter]
In file included from include/linux/mm.h:14:0,
                 from mm/vmscan.c:14:
include/linux/debug_locks.h: In function ‘debug_show_held_locks’:
include/linux/debug_locks.h:60:62: warning: unused parameter ‘task’ [-Wunused-parameter]
include/linux/debug_locks.h: In function ‘debug_check_no_locks_freed’:
include/linux/debug_locks.h:65:40: warning: unused parameter ‘from’ [-Wunused-parameter]
include/linux/debug_locks.h:65:60: warning: unused parameter ‘len’ [-Wunused-parameter]
In file included from include/linux/mm_types.h:14:0,
                 from include/linux/mm.h:15,
                 from mm/vmscan.c:14:
include/linux/uprobes.h: In function ‘uprobe_register’:
include/linux/uprobes.h:132:31: warning: unused parameter ‘inode’ [-Wunused-parameter]
include/linux/uprobes.h:132:45: warning: unused parameter ‘offset’ [-Wunused-parameter]
include/linux/uprobes.h:132:77: warning: unused parameter ‘uc’ [-Wunused-parameter]
include/linux/uprobes.h: In function ‘uprobe_apply’:
include/linux/uprobes.h:137:28: warning: unused parameter ‘inode’ [-Wunused-parameter]
include/linux/uprobes.h:137:42: warning: unused parameter ‘offset’ [-Wunused-parameter]
include/linux/uprobes.h:137:74: warning: unused parameter ‘uc’ [-Wunused-parameter]
include/linux/uprobes.h:137:83: warning: unused parameter ‘add’ [-Wunused-parameter]
include/linux/uprobes.h: In function ‘uprobe_unregister’:
include/linux/uprobes.h:142:33: warning: unused parameter ‘inode’ [-Wunused-parameter]
include/linux/uprobes.h:142:47: warning: unused parameter ‘offset’ [-Wunused-parameter]
include/linux/uprobes.h:142:79: warning: unused parameter ‘uc’ [-Wunused-parameter]
include/linux/uprobes.h: In function ‘uprobe_mmap’:
include/linux/uprobes.h:145:54: warning: unused parameter ‘vma’ [-Wunused-parameter]
include/linux/uprobes.h: In function ‘uprobe_munmap’:
include/linux/uprobes.h:150:38: warning: unused parameter ‘vma’ [-Wunused-parameter]
include/linux/uprobes.h:150:57: warning: unused parameter ‘start’ [-Wunused-parameter]
include/linux/uprobes.h:150:78: warning: unused parameter ‘end’ [-Wunused-parameter]
include/linux/uprobes.h: In function ‘uprobe_dup_mmap’:
include/linux/uprobes.h:160:35: warning: unused parameter ‘oldmm’ [-Wunused-parameter]
include/linux/uprobes.h:160:60: warning: unused parameter ‘newmm’ [-Wunused-parameter]
include/linux/uprobes.h: In function ‘uprobe_notify_resume’:
include/linux/uprobes.h:163:57: warning: unused parameter ‘regs’ [-Wunused-parameter]
include/linux/uprobes.h: In function ‘uprobe_get_swbp_addr’:
include/linux/uprobes.h:170:66: warning: unused parameter ‘regs’ [-Wunused-parameter]
include/linux/uprobes.h: In function ‘uprobe_free_utask’:
include/linux/uprobes.h:174:58: warning: unused parameter ‘t’ [-Wunused-parameter]
include/linux/uprobes.h: In function ‘uprobe_copy_process’:
include/linux/uprobes.h:177:60: warning: unused parameter ‘t’ [-Wunused-parameter]
include/linux/uprobes.h: In function ‘uprobe_clear_state’:
include/linux/uprobes.h:180:57: warning: unused parameter ‘mm’ [-Wunused-parameter]
In file included from include/linux/mm.h:15:0,
                 from mm/vmscan.c:14:
include/linux/mm_types.h: In function ‘mm_init_cpumask’:
include/linux/mm_types.h:443:54: warning: unused parameter ‘mm’ [-Wunused-parameter]
In file included from mm/vmscan.c:14:0:
include/linux/mm.h: In function ‘set_max_mapnr’:
include/linux/mm.h:36:48: warning: unused parameter ‘limit’ [-Wunused-parameter]
In file included from /root/linux-next/arch/x86/include/asm/pgtable.h:413:0,
                 from include/linux/mm.h:50,
                 from mm/vmscan.c:14:
/root/linux-next/arch/x86/include/asm/pgtable_64.h: In function ‘native_pte_clear’:
/root/linux-next/arch/x86/include/asm/pgtable_64.h:46:55: warning: unused parameter ‘mm’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/pgtable_64.h:46:73: warning: unused parameter ‘addr’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/pgtable_64.h: In function ‘pgd_large’:
/root/linux-next/arch/x86/include/asm/pgtable_64.h:128:35: warning: unused parameter ‘pgd’ [-Wunused-parameter]
In file included from include/linux/mm.h:50:0,
                 from mm/vmscan.c:14:
/root/linux-next/arch/x86/include/asm/pgtable.h: In function ‘native_set_pte_at’:
/root/linux-next/arch/x86/include/asm/pgtable.h:665:56: warning: unused parameter ‘mm’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/pgtable.h:665:74: warning: unused parameter ‘addr’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/pgtable.h: In function ‘native_set_pmd_at’:
/root/linux-next/arch/x86/include/asm/pgtable.h:671:56: warning: unused parameter ‘mm’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/pgtable.h:671:74: warning: unused parameter ‘addr’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/pgtable.h: In function ‘ptep_get_and_clear’:
/root/linux-next/arch/x86/include/asm/pgtable.h:718:58: warning: unused parameter ‘mm’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/pgtable.h:718:76: warning: unused parameter ‘addr’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/pgtable.h: In function ‘ptep_set_wrprotect’:
/root/linux-next/arch/x86/include/asm/pgtable.h:745:57: warning: unused parameter ‘mm’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/pgtable.h:746:25: warning: unused parameter ‘addr’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/pgtable.h: In function ‘pmdp_get_and_clear’:
/root/linux-next/arch/x86/include/asm/pgtable.h:781:58: warning: unused parameter ‘mm’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/pgtable.h:781:76: warning: unused parameter ‘addr’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/pgtable.h: In function ‘pmdp_set_wrprotect’:
/root/linux-next/arch/x86/include/asm/pgtable.h:790:57: warning: unused parameter ‘mm’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/pgtable.h:791:25: warning: unused parameter ‘addr’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/pgtable.h: In function ‘update_mmu_cache’:
/root/linux-next/arch/x86/include/asm/pgtable.h:830:60: warning: unused parameter ‘vma’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/pgtable.h:831:17: warning: unused parameter ‘addr’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/pgtable.h:831:30: warning: unused parameter ‘ptep’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/pgtable.h: In function ‘update_mmu_cache_pmd’:
/root/linux-next/arch/x86/include/asm/pgtable.h:834:64: warning: unused parameter ‘vma’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/pgtable.h:835:17: warning: unused parameter ‘addr’ [-Wunused-parameter]
/root/linux-next/arch/x86/include/asm/pgtable.h:835:30: warning: unused parameter ‘pmd’ [-Wunused-parameter]
In file included from /root/linux-next/arch/x86/include/asm/pgtable.h:839:0,
                 from include/linux/mm.h:50,
                 from mm/vmscan.c:14:
include/asm-generic/pgtable.h: In function ‘pte_clear_not_present_full’:
include/asm-generic/pgtable.h:126:16: warning: unused parameter ‘full’ [-Wunused-parameter]
include/asm-generic/pgtable.h: In function ‘pmd_same’:
include/asm-generic/pgtable.h:203:34: warning: unused parameter ‘pmd_a’ [-Wunused-parameter]
include/asm-generic/pgtable.h:203:47: warning: unused parameter ‘pmd_b’ [-Wunused-parameter]
include/asm-generic/pgtable.h: In function ‘my_zero_pfn’:
include/asm-generic/pgtable.h:496:55: warning: unused parameter ‘addr’ [-Wunused-parameter]
include/asm-generic/pgtable.h: In function ‘pmd_trans_huge’:
include/asm-generic/pgtable.h:506:40: warning: unused parameter ‘pmd’ [-Wunused-parameter]
include/asm-generic/pgtable.h: In function ‘pmd_trans_splitting’:
include/asm-generic/pgtable.h:510:45: warning: unused parameter ‘pmd’ [-Wunused-parameter]
include/asm-generic/pgtable.h: In function ‘pmd_trans_unstable’:
include/asm-generic/pgtable.h:599:45: warning: unused parameter ‘pmd’ [-Wunused-parameter]
include/asm-generic/pgtable.h: In function ‘pmd_numa’:
include/asm-generic/pgtable.h:683:34: warning: unused parameter ‘pmd’ [-Wunused-parameter]
include/asm-generic/pgtable.h: In function ‘pte_numa’:
include/asm-generic/pgtable.h:688:34: warning: unused parameter ‘pte’ [-Wunused-parameter]
In file included from include/linux/mm.h:271:0,
                 from mm/vmscan.c:14:
include/linux/page-flags.h: In function ‘PageHighMem’:
include/linux/page-flags.h:242:1: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/page-flags.h: In function ‘PageHWPoison’:
include/linux/page-flags.h:274:1: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/page-flags.h: In function ‘PageTransHuge’:
include/linux/page-flags.h:439:46: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/page-flags.h: In function ‘PageTransCompound’:
include/linux/page-flags.h:444:50: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/page-flags.h: In function ‘PageTransTail’:
include/linux/page-flags.h:449:46: warning: unused parameter ‘page’ [-Wunused-parameter]
In file included from include/linux/mm.h:272:0,
                 from mm/vmscan.c:14:
include/linux/huge_mm.h: In function ‘split_huge_page_to_list’:
include/linux/huge_mm.h:194:38: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/huge_mm.h:194:62: warning: unused parameter ‘list’ [-Wunused-parameter]
include/linux/huge_mm.h: In function ‘split_huge_page’:
include/linux/huge_mm.h:198:48: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/huge_mm.h: In function ‘hugepage_madvise’:
include/linux/huge_mm.h:209:59: warning: unused parameter ‘vma’ [-Wunused-parameter]
include/linux/huge_mm.h:210:23: warning: unused parameter ‘vm_flags’ [-Wunused-parameter]
include/linux/huge_mm.h:210:37: warning: unused parameter ‘advice’ [-Wunused-parameter]
include/linux/huge_mm.h: In function ‘vma_adjust_trans_huge’:
include/linux/huge_mm.h:215:65: warning: unused parameter ‘vma’ [-Wunused-parameter]
include/linux/huge_mm.h:216:21: warning: unused parameter ‘start’ [-Wunused-parameter]
include/linux/huge_mm.h:217:21: warning: unused parameter ‘end’ [-Wunused-parameter]
include/linux/huge_mm.h:218:12: warning: unused parameter ‘adjust_next’ [-Wunused-parameter]
include/linux/huge_mm.h: In function ‘pmd_trans_huge_lock’:
include/linux/huge_mm.h:221:46: warning: unused parameter ‘pmd’ [-Wunused-parameter]
include/linux/huge_mm.h:222:34: warning: unused parameter ‘vma’ [-Wunused-parameter]
include/linux/huge_mm.h: In function ‘do_huge_pmd_numa_page’:
include/linux/huge_mm.h:227:59: warning: unused parameter ‘mm’ [-Wunused-parameter]
include/linux/huge_mm.h:227:86: warning: unused parameter ‘vma’ [-Wunused-parameter]
include/linux/huge_mm.h:228:20: warning: unused parameter ‘addr’ [-Wunused-parameter]
include/linux/huge_mm.h:228:32: warning: unused parameter ‘pmd’ [-Wunused-parameter]
include/linux/huge_mm.h:228:44: warning: unused parameter ‘pmdp’ [-Wunused-parameter]
In file included from mm/vmscan.c:14:0:
include/linux/mm.h: In function ‘compound_lock’:
include/linux/mm.h:336:47: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/mm.h: In function ‘compound_unlock’:
include/linux/mm.h:344:49: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/mm.h: In function ‘compound_lock_irqsave’:
include/linux/mm.h:352:64: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/mm.h: In function ‘compound_unlock_irqrestore’:
include/linux/mm.h:362:60: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/mm.h:363:26: warning: unused parameter ‘flags’ [-Wunused-parameter]
include/linux/mm.h: In function ‘page_nid_xchg_last’:
include/linux/mm.h:708:61: warning: unused parameter ‘nid’ [-Wunused-parameter]
include/linux/mm.h: In function ‘page_nid_reset_last’:
include/linux/mm.h:718:53: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/mm.h: In function ‘set_page_links’:
include/linux/mm.h:754:36: warning: unused parameter ‘pfn’ [-Wunused-parameter]
In file included from include/linux/mm.h:766:0,
                 from mm/vmscan.c:14:
include/linux/vmstat.h: In function ‘__mod_zone_freepage_state’:
include/linux/vmstat.h:264:15: warning: unused parameter ‘migratetype’ [-Wunused-parameter]
In file included from mm/vmscan.c:14:0:
include/linux/mm.h: In function ‘kernel_map_pages’:
include/linux/mm.h:1745:31: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/mm.h:1745:41: warning: unused parameter ‘numpages’ [-Wunused-parameter]
include/linux/mm.h:1745:55: warning: unused parameter ‘enable’ [-Wunused-parameter]
include/linux/mm.h: In function ‘kernel_page_present’:
include/linux/mm.h:1747:53: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/mm.h: In function ‘page_is_guard’:
include/linux/mm.h:1842:47: warning: unused parameter ‘page’ [-Wunused-parameter]
In file included from include/linux/stat.h:19:0,
                 from include/linux/module.h:10,
                 from mm/vmscan.c:15:
include/linux/uidgid.h: In function ‘make_kuid’:
include/linux/uidgid.h:152:55: warning: unused parameter ‘from’ [-Wunused-parameter]
include/linux/uidgid.h: In function ‘make_kgid’:
include/linux/uidgid.h:157:55: warning: unused parameter ‘from’ [-Wunused-parameter]
include/linux/uidgid.h: In function ‘from_kuid’:
include/linux/uidgid.h:162:54: warning: unused parameter ‘to’ [-Wunused-parameter]
include/linux/uidgid.h: In function ‘from_kgid’:
include/linux/uidgid.h:167:54: warning: unused parameter ‘to’ [-Wunused-parameter]
include/linux/uidgid.h: In function ‘kuid_has_mapping’:
include/linux/uidgid.h:188:60: warning: unused parameter ‘ns’ [-Wunused-parameter]
include/linux/uidgid.h:188:71: warning: unused parameter ‘uid’ [-Wunused-parameter]
include/linux/uidgid.h: In function ‘kgid_has_mapping’:
include/linux/uidgid.h:193:60: warning: unused parameter ‘ns’ [-Wunused-parameter]
include/linux/uidgid.h:193:71: warning: unused parameter ‘gid’ [-Wunused-parameter]
In file included from include/linux/module.h:14:0,
                 from mm/vmscan.c:15:
include/linux/elf.h: In function ‘elf_coredump_extra_notes_write’:
include/linux/elf.h:45:63: warning: unused parameter ‘file’ [-Wunused-parameter]
include/linux/elf.h:46:12: warning: unused parameter ‘foffset’ [-Wunused-parameter]
In file included from include/linux/module.h:17:0,
                 from mm/vmscan.c:15:
include/linux/moduleparam.h: In function ‘__check_old_set_param’:
include/linux/moduleparam.h:197:29: warning: unused parameter ‘oldset’ [-Wunused-parameter]
In file included from include/linux/static_key.h:1:0,
                 from include/linux/tracepoint.h:20,
                 from include/linux/module.h:18,
                 from mm/vmscan.c:15:
include/linux/jump_label.h: In function ‘jump_label_text_reserved’:
include/linux/jump_label.h:177:50: warning: unused parameter ‘start’ [-Wunused-parameter]
include/linux/jump_label.h:177:63: warning: unused parameter ‘end’ [-Wunused-parameter]
include/linux/jump_label.h: In function ‘jump_label_apply_nops’:
include/linux/jump_label.h:185:56: warning: unused parameter ‘mod’ [-Wunused-parameter]
include/linux/jump_label.h: In function ‘jump_label_rate_limit’:
include/linux/jump_label.h:191:51: warning: unused parameter ‘key’ [-Wunused-parameter]
include/linux/jump_label.h:192:17: warning: unused parameter ‘rl’ [-Wunused-parameter]
In file included from include/linux/hardirq.h:7:0,
                 from include/linux/interrupt.h:12,
                 from include/linux/kernel_stat.h:8,
                 from mm/vmscan.c:17:
include/linux/vtime.h: In function ‘vtime_task_switch’:
include/linux/vtime.h:19:58: warning: unused parameter ‘prev’ [-Wunused-parameter]
include/linux/vtime.h: In function ‘vtime_account_system’:
include/linux/vtime.h:20:61: warning: unused parameter ‘tsk’ [-Wunused-parameter]
include/linux/vtime.h: In function ‘vtime_account_user’:
include/linux/vtime.h:21:59: warning: unused parameter ‘tsk’ [-Wunused-parameter]
include/linux/vtime.h: In function ‘vtime_account_irq_enter’:
include/linux/vtime.h:22:64: warning: unused parameter ‘tsk’ [-Wunused-parameter]
include/linux/vtime.h: In function ‘vtime_user_enter’:
include/linux/vtime.h:44:57: warning: unused parameter ‘tsk’ [-Wunused-parameter]
include/linux/vtime.h: In function ‘vtime_user_exit’:
include/linux/vtime.h:45:56: warning: unused parameter ‘tsk’ [-Wunused-parameter]
include/linux/vtime.h: In function ‘vtime_guest_enter’:
include/linux/vtime.h:46:58: warning: unused parameter ‘tsk’ [-Wunused-parameter]
include/linux/vtime.h: In function ‘vtime_guest_exit’:
include/linux/vtime.h:47:57: warning: unused parameter ‘tsk’ [-Wunused-parameter]
include/linux/vtime.h: In function ‘vtime_init_idle’:
include/linux/vtime.h:48:56: warning: unused parameter ‘tsk’ [-Wunused-parameter]
include/linux/vtime.h:48:65: warning: unused parameter ‘cpu’ [-Wunused-parameter]
include/linux/vtime.h: In function ‘irqtime_account_irq’:
include/linux/vtime.h:54:60: warning: unused parameter ‘tsk’ [-Wunused-parameter]
In file included from /root/linux-next/arch/x86/include/asm/sections.h:4:0,
                 from /root/linux-next/arch/x86/include/asm/hw_irq.h:26,
                 from include/linux/irq.h:363,
                 from /root/linux-next/arch/x86/include/asm/hardirq.h:5,
                 from include/linux/hardirq.h:8,
                 from include/linux/interrupt.h:12,
                 from include/linux/kernel_stat.h:8,
                 from mm/vmscan.c:17:
include/asm-generic/sections.h: In function ‘arch_is_kernel_text’:
include/asm-generic/sections.h:49:53: warning: unused parameter ‘addr’ [-Wunused-parameter]
include/asm-generic/sections.h: In function ‘arch_is_kernel_data’:
include/asm-generic/sections.h:56:53: warning: unused parameter ‘addr’ [-Wunused-parameter]
In file included from /root/linux-next/arch/x86/include/asm/hardirq.h:5:0,
                 from include/linux/hardirq.h:8,
                 from include/linux/interrupt.h:12,
                 from include/linux/kernel_stat.h:8,
                 from mm/vmscan.c:17:
include/linux/irq.h: In function ‘irq_set_parent’:
include/linux/irq.h:400:38: warning: unused parameter ‘irq’ [-Wunused-parameter]
include/linux/irq.h:400:47: warning: unused parameter ‘parent_irq’ [-Wunused-parameter]
In file included from include/linux/interrupt.h:16:0,
                 from include/linux/kernel_stat.h:8,
                 from mm/vmscan.c:17:
include/linux/hrtimer.h: In function ‘destroy_hrtimer_on_stack’:
include/linux/hrtimer.h:356:61: warning: unused parameter ‘timer’ [-Wunused-parameter]
In file included from include/linux/kernel_stat.h:8:0,
                 from mm/vmscan.c:17:
include/linux/interrupt.h: In function ‘disable_irq_nosync_lockdep_irqsave’:
include/linux/interrupt.h:312:88: warning: unused parameter ‘flags’ [-Wunused-parameter]
include/linux/interrupt.h: In function ‘enable_irq_lockdep_irqrestore’:
include/linux/interrupt.h:336:83: warning: unused parameter ‘flags’ [-Wunused-parameter]
In file included from include/linux/sched.h:42:0,
                 from include/linux/kernel_stat.h:9,
                 from mm/vmscan.c:17:
include/linux/rtmutex.h: In function ‘rt_mutex_debug_check_no_locks_freed’:
include/linux/rtmutex.h:48:68: warning: unused parameter ‘from’ [-Wunused-parameter]
include/linux/rtmutex.h:49:28: warning: unused parameter ‘len’ [-Wunused-parameter]
In file included from include/linux/sched.h:50:0,
                 from include/linux/kernel_stat.h:9,
                 from mm/vmscan.c:17:
include/linux/latencytop.h: In function ‘account_scheduler_latency’:
include/linux/latencytop.h:43:47: warning: unused parameter ‘task’ [-Wunused-parameter]
include/linux/latencytop.h:43:57: warning: unused parameter ‘usecs’ [-Wunused-parameter]
include/linux/latencytop.h:43:68: warning: unused parameter ‘inter’ [-Wunused-parameter]
include/linux/latencytop.h: In function ‘clear_all_latency_tracing’:
include/linux/latencytop.h:47:66: warning: unused parameter ‘p’ [-Wunused-parameter]
In file included from include/linux/sched.h:51:0,
                 from include/linux/kernel_stat.h:9,
                 from mm/vmscan.c:17:
include/linux/cred.h: In function ‘validate_creds’:
include/linux/cred.h:188:54: warning: unused parameter ‘cred’ [-Wunused-parameter]
include/linux/cred.h: In function ‘validate_creds_for_do_exit’:
include/linux/cred.h:191:67: warning: unused parameter ‘tsk’ [-Wunused-parameter]
In file included from include/linux/kernel_stat.h:9:0,
                 from mm/vmscan.c:17:
include/linux/sched.h: In function ‘prefetch_stack’:
include/linux/sched.h:910:55: warning: unused parameter ‘t’ [-Wunused-parameter]
include/linux/sched.h: In function ‘task_numa_fault’:
include/linux/sched.h:1423:40: warning: unused parameter ‘node’ [-Wunused-parameter]
include/linux/sched.h:1423:50: warning: unused parameter ‘pages’ [-Wunused-parameter]
include/linux/sched.h:1423:62: warning: unused parameter ‘migrated’ [-Wunused-parameter]
include/linux/sched.h: In function ‘set_numabalancing_state’:
include/linux/sched.h:1426:49: warning: unused parameter ‘enabled’ [-Wunused-parameter]
include/linux/sched.h: In function ‘rcu_copy_process’:
include/linux/sched.h:1732:57: warning: unused parameter ‘p’ [-Wunused-parameter]
include/linux/sched.h: In function ‘sched_autogroup_create_attach’:
include/linux/sched.h:1880:70: warning: unused parameter ‘p’ [-Wunused-parameter]
include/linux/sched.h: In function ‘sched_autogroup_detach’:
include/linux/sched.h:1881:63: warning: unused parameter ‘p’ [-Wunused-parameter]
include/linux/sched.h: In function ‘sched_autogroup_fork’:
include/linux/sched.h:1882:63: warning: unused parameter ‘sig’ [-Wunused-parameter]
include/linux/sched.h: In function ‘sched_autogroup_exit’:
include/linux/sched.h:1883:63: warning: unused parameter ‘sig’ [-Wunused-parameter]
include/linux/sched.h: In function ‘spin_needbreak’:
include/linux/sched.h:2454:46: warning: unused parameter ‘lock’ [-Wunused-parameter]
include/linux/sched.h: In function ‘mm_update_next_owner’:
include/linux/sched.h:2616:59: warning: unused parameter ‘mm’ [-Wunused-parameter]
include/linux/sched.h: In function ‘mm_init_owner’:
include/linux/sched.h:2620:52: warning: unused parameter ‘mm’ [-Wunused-parameter]
include/linux/sched.h:2620:76: warning: unused parameter ‘p’ [-Wunused-parameter]
In file included from include/linux/slub_def.h:15:0,
                 from include/linux/slab.h:297,
                 from include/linux/xattr.h:14,
                 from include/linux/cgroup.h:21,
                 from include/linux/memcontrol.h:22,
                 from include/linux/swap.h:8,
                 from mm/vmscan.c:18:
include/linux/kmemleak.h: In function ‘kmemleak_alloc’:
include/linux/kmemleak.h:64:47: warning: unused parameter ‘ptr’ [-Wunused-parameter]
include/linux/kmemleak.h:64:59: warning: unused parameter ‘size’ [-Wunused-parameter]
include/linux/kmemleak.h:64:69: warning: unused parameter ‘min_count’ [-Wunused-parameter]
include/linux/kmemleak.h:65:13: warning: unused parameter ‘gfp’ [-Wunused-parameter]
include/linux/kmemleak.h: In function ‘kmemleak_alloc_recursive’:
include/linux/kmemleak.h:68:57: warning: unused parameter ‘ptr’ [-Wunused-parameter]
include/linux/kmemleak.h:68:69: warning: unused parameter ‘size’ [-Wunused-parameter]
include/linux/kmemleak.h:69:14: warning: unused parameter ‘min_count’ [-Wunused-parameter]
include/linux/kmemleak.h:69:39: warning: unused parameter ‘flags’ [-Wunused-parameter]
include/linux/kmemleak.h:70:16: warning: unused parameter ‘gfp’ [-Wunused-parameter]
include/linux/kmemleak.h: In function ‘kmemleak_alloc_percpu’:
include/linux/kmemleak.h:73:63: warning: unused parameter ‘ptr’ [-Wunused-parameter]
include/linux/kmemleak.h:73:75: warning: unused parameter ‘size’ [-Wunused-parameter]
include/linux/kmemleak.h: In function ‘kmemleak_free’:
include/linux/kmemleak.h:76:46: warning: unused parameter ‘ptr’ [-Wunused-parameter]
include/linux/kmemleak.h: In function ‘kmemleak_free_part’:
include/linux/kmemleak.h:79:51: warning: unused parameter ‘ptr’ [-Wunused-parameter]
include/linux/kmemleak.h:79:63: warning: unused parameter ‘size’ [-Wunused-parameter]
include/linux/kmemleak.h: In function ‘kmemleak_free_recursive’:
include/linux/kmemleak.h:82:56: warning: unused parameter ‘ptr’ [-Wunused-parameter]
include/linux/kmemleak.h:82:75: warning: unused parameter ‘flags’ [-Wunused-parameter]
include/linux/kmemleak.h: In function ‘kmemleak_free_percpu’:
include/linux/kmemleak.h:85:62: warning: unused parameter ‘ptr’ [-Wunused-parameter]
include/linux/kmemleak.h: In function ‘kmemleak_not_leak’:
include/linux/kmemleak.h:88:50: warning: unused parameter ‘ptr’ [-Wunused-parameter]
include/linux/kmemleak.h: In function ‘kmemleak_ignore’:
include/linux/kmemleak.h:91:48: warning: unused parameter ‘ptr’ [-Wunused-parameter]
include/linux/kmemleak.h: In function ‘kmemleak_scan_area’:
include/linux/kmemleak.h:94:51: warning: unused parameter ‘ptr’ [-Wunused-parameter]
include/linux/kmemleak.h:94:63: warning: unused parameter ‘size’ [-Wunused-parameter]
include/linux/kmemleak.h:94:75: warning: unused parameter ‘gfp’ [-Wunused-parameter]
include/linux/kmemleak.h: In function ‘kmemleak_erase’:
include/linux/kmemleak.h:97:42: warning: unused parameter ‘ptr’ [-Wunused-parameter]
include/linux/kmemleak.h: In function ‘kmemleak_no_scan’:
include/linux/kmemleak.h:100:49: warning: unused parameter ‘ptr’ [-Wunused-parameter]
In file included from include/linux/fs.h:7:0,
                 from include/linux/cgroup.h:22,
                 from include/linux/memcontrol.h:22,
                 from include/linux/swap.h:8,
                 from mm/vmscan.c:18:
include/linux/kdev_t.h: In function ‘new_valid_dev’:
include/linux/kdev_t.h:38:39: warning: unused parameter ‘dev’ [-Wunused-parameter]
include/linux/kdev_t.h: In function ‘huge_valid_dev’:
include/linux/kdev_t.h:57:40: warning: unused parameter ‘dev’ [-Wunused-parameter]
In file included from include/linux/fs.h:15:0,
                 from include/linux/cgroup.h:22,
                 from include/linux/memcontrol.h:22,
                 from include/linux/swap.h:8,
                 from mm/vmscan.c:18:
include/linux/radix-tree.h: In function ‘radix_tree_deref_slot_protected’:
include/linux/radix-tree.h:166:20: warning: unused parameter ‘treelock’ [-Wunused-parameter]
In file included from include/linux/quota.h:48:0,
                 from include/linux/fs.h:247,
                 from include/linux/cgroup.h:22,
                 from include/linux/memcontrol.h:22,
                 from include/linux/swap.h:8,
                 from mm/vmscan.c:18:
include/linux/projid.h: In function ‘make_kprojid’:
include/linux/projid.h:79:61: warning: unused parameter ‘from’ [-Wunused-parameter]
include/linux/projid.h: In function ‘from_kprojid’:
include/linux/projid.h:84:60: warning: unused parameter ‘to’ [-Wunused-parameter]
include/linux/projid.h: In function ‘kprojid_has_mapping’:
include/linux/projid.h:97:63: warning: unused parameter ‘ns’ [-Wunused-parameter]
include/linux/projid.h:97:77: warning: unused parameter ‘projid’ [-Wunused-parameter]
In file included from include/linux/cgroup.h:22:0,
                 from include/linux/memcontrol.h:22,
                 from include/linux/swap.h:8,
                 from mm/vmscan.c:18:
include/linux/fs.h: In function ‘file_take_write’:
include/linux/fs.h:863:49: warning: unused parameter ‘filp’ [-Wunused-parameter]
include/linux/fs.h: In function ‘file_release_write’:
include/linux/fs.h:864:52: warning: unused parameter ‘filp’ [-Wunused-parameter]
include/linux/fs.h: In function ‘file_reset_write’:
include/linux/fs.h:865:50: warning: unused parameter ‘filp’ [-Wunused-parameter]
include/linux/fs.h: In function ‘file_check_state’:
include/linux/fs.h:866:50: warning: unused parameter ‘filp’ [-Wunused-parameter]
include/linux/fs.h: In function ‘file_check_writeable’:
include/linux/fs.h:867:53: warning: unused parameter ‘filp’ [-Wunused-parameter]
In file included from include/linux/cgroup.h:22:0,
                 from include/linux/memcontrol.h:22,
                 from include/linux/swap.h:8,
                 from mm/vmscan.c:18:
include/linux/fs.h: In function ‘i_readcount_dec’:
include/linux/fs.h:2287:50: warning: unused parameter ‘inode’ [-Wunused-parameter]
include/linux/fs.h: In function ‘i_readcount_inc’:
include/linux/fs.h:2291:50: warning: unused parameter ‘inode’ [-Wunused-parameter]
In file included from include/linux/cgroup.h:22:0,
                 from include/linux/memcontrol.h:22,
                 from include/linux/swap.h:8,
                 from mm/vmscan.c:18:
include/linux/fs.h: In function ‘lockdep_annotate_inode_mutex_key’:
include/linux/fs.h:2342:67: warning: unused parameter ‘inode’ [-Wunused-parameter]
include/linux/fs.h: In function ‘xip_truncate_page’:
include/linux/fs.h:2436:59: warning: unused parameter ‘mapping’ [-Wunused-parameter]
include/linux/fs.h:2436:75: warning: unused parameter ‘from’ [-Wunused-parameter]
include/linux/fs.h: In function ‘__simple_attr_check_format’:
include/linux/fs.h:2650:45: warning: unused parameter ‘fmt’ [-Wunused-parameter]
In file included from include/linux/swap.h:8:0,
                 from mm/vmscan.c:18:
include/linux/memcontrol.h: In function ‘mem_cgroup_newpage_charge’:
include/linux/memcontrol.h:206:58: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/memcontrol.h:207:24: warning: unused parameter ‘mm’ [-Wunused-parameter]
include/linux/memcontrol.h:207:34: warning: unused parameter ‘gfp_mask’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mem_cgroup_cache_charge’:
include/linux/memcontrol.h:212:56: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/memcontrol.h:213:24: warning: unused parameter ‘mm’ [-Wunused-parameter]
include/linux/memcontrol.h:213:34: warning: unused parameter ‘gfp_mask’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mem_cgroup_try_charge_swapin’:
include/linux/memcontrol.h:218:66: warning: unused parameter ‘mm’ [-Wunused-parameter]
include/linux/memcontrol.h:219:16: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/memcontrol.h:219:28: warning: unused parameter ‘gfp_mask’ [-Wunused-parameter]
include/linux/memcontrol.h:219:58: warning: unused parameter ‘memcgp’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mem_cgroup_commit_charge_swapin’:
include/linux/memcontrol.h:224:65: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/memcontrol.h:225:27: warning: unused parameter ‘memcg’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mem_cgroup_cancel_charge_swapin’:
include/linux/memcontrol.h:229:71: warning: unused parameter ‘memcg’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mem_cgroup_uncharge_page’:
include/linux/memcontrol.h:241:58: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mem_cgroup_uncharge_cache_page’:
include/linux/memcontrol.h:245:64: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mem_cgroup_zone_lruvec’:
include/linux/memcontrol.h:250:30: warning: unused parameter ‘memcg’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mem_cgroup_page_lruvec’:
include/linux/memcontrol.h:255:66: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘try_get_mem_cgroup_from_page’:
include/linux/memcontrol.h:261:76: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘try_get_mem_cgroup_from_mm’:
include/linux/memcontrol.h:266:79: warning: unused parameter ‘mm’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mm_match_cgroup’:
include/linux/memcontrol.h:271:54: warning: unused parameter ‘mm’ [-Wunused-parameter]
include/linux/memcontrol.h:272:22: warning: unused parameter ‘memcg’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘task_in_mem_cgroup’:
include/linux/memcontrol.h:277:59: warning: unused parameter ‘task’ [-Wunused-parameter]
include/linux/memcontrol.h:278:36: warning: unused parameter ‘memcg’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mem_cgroup_css’:
include/linux/memcontrol.h:284:38: warning: unused parameter ‘memcg’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mem_cgroup_prepare_migration’:
include/linux/memcontrol.h:290:43: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/memcontrol.h:290:62: warning: unused parameter ‘newpage’ [-Wunused-parameter]
include/linux/memcontrol.h:291:29: warning: unused parameter ‘memcgp’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mem_cgroup_end_migration’:
include/linux/memcontrol.h:295:64: warning: unused parameter ‘memcg’ [-Wunused-parameter]
include/linux/memcontrol.h:296:16: warning: unused parameter ‘oldpage’ [-Wunused-parameter]
include/linux/memcontrol.h:296:38: warning: unused parameter ‘newpage’ [-Wunused-parameter]
include/linux/memcontrol.h:296:52: warning: unused parameter ‘migration_ok’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mem_cgroup_iter’:
include/linux/memcontrol.h:301:36: warning: unused parameter ‘root’ [-Wunused-parameter]
include/linux/memcontrol.h:302:22: warning: unused parameter ‘prev’ [-Wunused-parameter]
include/linux/memcontrol.h:303:37: warning: unused parameter ‘reclaim’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mem_cgroup_iter_break’:
include/linux/memcontrol.h:308:61: warning: unused parameter ‘root’ [-Wunused-parameter]
include/linux/memcontrol.h:309:26: warning: unused parameter ‘prev’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mem_cgroup_inactive_anon_is_low’:
include/linux/memcontrol.h:319:48: warning: unused parameter ‘lruvec’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mem_cgroup_get_lru_size’:
include/linux/memcontrol.h:325:40: warning: unused parameter ‘lruvec’ [-Wunused-parameter]
include/linux/memcontrol.h:325:62: warning: unused parameter ‘lru’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mem_cgroup_update_lru_size’:
include/linux/memcontrol.h:331:43: warning: unused parameter ‘lruvec’ [-Wunused-parameter]
include/linux/memcontrol.h:331:65: warning: unused parameter ‘lru’ [-Wunused-parameter]
include/linux/memcontrol.h:332:14: warning: unused parameter ‘increment’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mem_cgroup_print_oom_info’:
include/linux/memcontrol.h:337:46: warning: unused parameter ‘memcg’ [-Wunused-parameter]
include/linux/memcontrol.h:337:73: warning: unused parameter ‘p’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mem_cgroup_begin_update_page_stat’:
include/linux/memcontrol.h:341:67: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/memcontrol.h:342:12: warning: unused parameter ‘locked’ [-Wunused-parameter]
include/linux/memcontrol.h:342:35: warning: unused parameter ‘flags’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mem_cgroup_end_update_page_stat’:
include/linux/memcontrol.h:346:65: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/memcontrol.h:347:12: warning: unused parameter ‘locked’ [-Wunused-parameter]
include/linux/memcontrol.h:347:35: warning: unused parameter ‘flags’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mem_cgroup_inc_page_stat’:
include/linux/memcontrol.h:351:58: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/memcontrol.h:352:41: warning: unused parameter ‘idx’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mem_cgroup_dec_page_stat’:
include/linux/memcontrol.h:356:58: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/memcontrol.h:357:41: warning: unused parameter ‘idx’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mem_cgroup_soft_limit_reclaim’:
include/linux/memcontrol.h:362:58: warning: unused parameter ‘zone’ [-Wunused-parameter]
include/linux/memcontrol.h:362:68: warning: unused parameter ‘order’ [-Wunused-parameter]
include/linux/memcontrol.h:363:16: warning: unused parameter ‘gfp_mask’ [-Wunused-parameter]
include/linux/memcontrol.h:364:25: warning: unused parameter ‘total_scanned’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mem_cgroup_split_huge_fixup’:
include/linux/memcontrol.h:369:61: warning: unused parameter ‘head’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mem_cgroup_count_vm_event’:
include/linux/memcontrol.h:374:50: warning: unused parameter ‘mm’ [-Wunused-parameter]
include/linux/memcontrol.h:374:73: warning: unused parameter ‘idx’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mem_cgroup_replace_page_cache’:
include/linux/memcontrol.h:377:63: warning: unused parameter ‘oldpage’ [-Wunused-parameter]
include/linux/memcontrol.h:378:18: warning: unused parameter ‘newpage’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mem_cgroup_bad_page_check’:
include/linux/memcontrol.h:385:40: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘mem_cgroup_print_bad_page’:
include/linux/memcontrol.h:391:40: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘sock_update_memcg’:
include/linux/memcontrol.h:407:51: warning: unused parameter ‘sk’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘sock_release_memcg’:
include/linux/memcontrol.h:410:52: warning: unused parameter ‘sk’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘memcg_kmem_newpage_charge’:
include/linux/memcontrol.h:575:33: warning: unused parameter ‘gfp’ [-Wunused-parameter]
include/linux/memcontrol.h:575:58: warning: unused parameter ‘memcg’ [-Wunused-parameter]
include/linux/memcontrol.h:575:69: warning: unused parameter ‘order’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘memcg_kmem_uncharge_pages’:
include/linux/memcontrol.h:580:59: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/memcontrol.h:580:69: warning: unused parameter ‘order’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘memcg_kmem_commit_charge’:
include/linux/memcontrol.h:585:39: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/memcontrol.h:585:64: warning: unused parameter ‘memcg’ [-Wunused-parameter]
include/linux/memcontrol.h:585:75: warning: unused parameter ‘order’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘memcg_cache_id’:
include/linux/memcontrol.h:589:53: warning: unused parameter ‘memcg’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘memcg_register_cache’:
include/linux/memcontrol.h:595:41: warning: unused parameter ‘memcg’ [-Wunused-parameter]
include/linux/memcontrol.h:595:67: warning: unused parameter ‘s’ [-Wunused-parameter]
include/linux/memcontrol.h:596:27: warning: unused parameter ‘root_cache’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘memcg_release_cache’:
include/linux/memcontrol.h:601:59: warning: unused parameter ‘cachep’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘memcg_cache_list_add’:
include/linux/memcontrol.h:605:60: warning: unused parameter ‘memcg’ [-Wunused-parameter]
include/linux/memcontrol.h:606:25: warning: unused parameter ‘s’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘memcg_kmem_get_cache’:
include/linux/memcontrol.h:611:55: warning: unused parameter ‘gfp’ [-Wunused-parameter]
include/linux/memcontrol.h: In function ‘kmem_cache_destroy_memcg_children’:
include/linux/memcontrol.h:616:73: warning: unused parameter ‘s’ [-Wunused-parameter]
In file included from include/linux/device.h:24:0,
                 from include/linux/node.h:17,
                 from include/linux/swap.h:10,
                 from mm/vmscan.c:18:
include/linux/pinctrl/devinfo.h: In function ‘pinctrl_bind_pins’:
include/linux/pinctrl/devinfo.h:43:52: warning: unused parameter ‘dev’ [-Wunused-parameter]
In file included from mm/vmscan.c:18:0:
include/linux/swap.h: In function ‘mem_cgroup_swappiness’:
include/linux/swap.h:325:60: warning: unused parameter ‘mem’ [-Wunused-parameter]
include/linux/swap.h: In function ‘mem_cgroup_uncharge_swap’:
include/linux/swap.h:333:57: warning: unused parameter ‘ent’ [-Wunused-parameter]
include/linux/swap.h: In function ‘mem_cgroup_uncharge_swapcache’:
include/linux/swap.h:410:44: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/swap.h:410:62: warning: unused parameter ‘ent’ [-Wunused-parameter]
include/linux/swap.h:410:72: warning: unused parameter ‘swapout’ [-Wunused-parameter]
In file included from include/linux/pagemap.h:10:0,
                 from mm/vmscan.c:19:
include/linux/highmem.h: In function ‘flush_anon_page’:
include/linux/highmem.h:14:59: warning: unused parameter ‘vma’ [-Wunused-parameter]
include/linux/highmem.h:14:77: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/highmem.h:14:97: warning: unused parameter ‘vmaddr’ [-Wunused-parameter]
include/linux/highmem.h: In function ‘flush_kernel_dcache_page’:
include/linux/highmem.h:20:58: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/highmem.h: In function ‘flush_kernel_vmap_range’:
include/linux/highmem.h:23:50: warning: unused parameter ‘vaddr’ [-Wunused-parameter]
include/linux/highmem.h:23:61: warning: unused parameter ‘size’ [-Wunused-parameter]
include/linux/highmem.h: In function ‘invalidate_kernel_vmap_range’:
include/linux/highmem.h:26:55: warning: unused parameter ‘vaddr’ [-Wunused-parameter]
include/linux/highmem.h:26:66: warning: unused parameter ‘size’ [-Wunused-parameter]
In file included from include/linux/pagemap.h:10:0,
                 from mm/vmscan.c:19:
include/linux/highmem.h: In function ‘kunmap’:
include/linux/highmem.h:62:40: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/highmem.h: In function ‘__kunmap_atomic’:
include/linux/highmem.h:73:42: warning: unused parameter ‘addr’ [-Wunused-parameter]
include/linux/highmem.h: In function ‘copy_user_highpage’:
include/linux/highmem.h:225:46: warning: unused parameter ‘vma’ [-Wunused-parameter]
In file included from mm/vmscan.c:22:0:
include/linux/vmpressure.h: In function ‘vmpressure’:
include/linux/vmpressure.h:42:37: warning: unused parameter ‘gfp’ [-Wunused-parameter]
include/linux/vmpressure.h:42:61: warning: unused parameter ‘memcg’ [-Wunused-parameter]
include/linux/vmpressure.h:43:24: warning: unused parameter ‘scanned’ [-Wunused-parameter]
include/linux/vmpressure.h:43:47: warning: unused parameter ‘reclaimed’ [-Wunused-parameter]
include/linux/vmpressure.h: In function ‘vmpressure_prio’:
include/linux/vmpressure.h:44:42: warning: unused parameter ‘gfp’ [-Wunused-parameter]
include/linux/vmpressure.h:44:66: warning: unused parameter ‘memcg’ [-Wunused-parameter]
include/linux/vmpressure.h:45:12: warning: unused parameter ‘prio’ [-Wunused-parameter]
In file included from include/linux/blkdev.h:14:0,
                 from mm/vmscan.c:26:
include/linux/backing-dev.h: In function ‘bdi_stat_error’:
include/linux/backing-dev.h:209:69: warning: unused parameter ‘bdi’ [-Wunused-parameter]
include/linux/backing-dev.h: In function ‘bdi_sched_wait’:
include/linux/backing-dev.h:353:40: warning: unused parameter ‘word’ [-Wunused-parameter]
In file included from include/linux/blkdev.h:17:0,
                 from mm/vmscan.c:26:
include/linux/bio.h: In function ‘bio_flush_dcache_pages’:
include/linux/bio.h:291:55: warning: unused parameter ‘bi’ [-Wunused-parameter]
include/linux/bio.h: In function ‘bio_associate_current’:
include/linux/bio.h:314:53: warning: unused parameter ‘bio’ [-Wunused-parameter]
include/linux/bio.h: In function ‘bio_disassociate_task’:
include/linux/bio.h:315:54: warning: unused parameter ‘bio’ [-Wunused-parameter]
include/linux/bio.h: In function ‘bvec_kmap_irq’:
include/linux/bio.h:348:72: warning: unused parameter ‘flags’ [-Wunused-parameter]
include/linux/bio.h: In function ‘bvec_kunmap_irq’:
include/linux/bio.h:353:42: warning: unused parameter ‘buffer’ [-Wunused-parameter]
include/linux/bio.h: In function ‘bio_integrity’:
include/linux/bio.h:594:45: warning: unused parameter ‘bio’ [-Wunused-parameter]
include/linux/bio.h: In function ‘bio_integrity_enabled’:
include/linux/bio.h:599:53: warning: unused parameter ‘bio’ [-Wunused-parameter]
include/linux/bio.h: In function ‘bioset_integrity_create’:
include/linux/bio.h:604:59: warning: unused parameter ‘bs’ [-Wunused-parameter]
include/linux/bio.h:604:67: warning: unused parameter ‘pool_size’ [-Wunused-parameter]
include/linux/bio.h: In function ‘bioset_integrity_free’:
include/linux/bio.h:609:59: warning: unused parameter ‘bs’ [-Wunused-parameter]
include/linux/bio.h: In function ‘bio_integrity_prep’:
include/linux/bio.h:614:50: warning: unused parameter ‘bio’ [-Wunused-parameter]
include/linux/bio.h: In function ‘bio_integrity_free’:
include/linux/bio.h:619:51: warning: unused parameter ‘bio’ [-Wunused-parameter]
include/linux/bio.h: In function ‘bio_integrity_clone’:
include/linux/bio.h:624:51: warning: unused parameter ‘bio’ [-Wunused-parameter]
include/linux/bio.h:624:68: warning: unused parameter ‘bio_src’ [-Wunused-parameter]
include/linux/bio.h:625:17: warning: unused parameter ‘gfp_mask’ [-Wunused-parameter]
include/linux/bio.h: In function ‘bio_integrity_split’:
include/linux/bio.h:630:52: warning: unused parameter ‘bio’ [-Wunused-parameter]
include/linux/bio.h:630:74: warning: unused parameter ‘bp’ [-Wunused-parameter]
include/linux/bio.h:631:16: warning: unused parameter ‘sectors’ [-Wunused-parameter]
include/linux/bio.h: In function ‘bio_integrity_advance’:
include/linux/bio.h:636:54: warning: unused parameter ‘bio’ [-Wunused-parameter]
include/linux/bio.h:637:20: warning: unused parameter ‘bytes_done’ [-Wunused-parameter]
include/linux/bio.h: In function ‘bio_integrity_trim’:
include/linux/bio.h:642:51: warning: unused parameter ‘bio’ [-Wunused-parameter]
include/linux/bio.h:642:69: warning: unused parameter ‘offset’ [-Wunused-parameter]
include/linux/bio.h:643:24: warning: unused parameter ‘sectors’ [-Wunused-parameter]
In file included from mm/vmscan.c:26:0:
include/linux/blkdev.h: In function ‘rq_flush_dcache_pages’:
include/linux/blkdev.h:726:58: warning: unused parameter ‘rq’ [-Wunused-parameter]
include/linux/blkdev.h: In function ‘blk_pm_runtime_init’:
include/linux/blkdev.h:979:62: warning: unused parameter ‘q’ [-Wunused-parameter]
include/linux/blkdev.h:980:17: warning: unused parameter ‘dev’ [-Wunused-parameter]
include/linux/blkdev.h: In function ‘blk_pre_runtime_suspend’:
include/linux/blkdev.h:981:65: warning: unused parameter ‘q’ [-Wunused-parameter]
include/linux/blkdev.h: In function ‘blk_post_runtime_suspend’:
include/linux/blkdev.h:985:67: warning: unused parameter ‘q’ [-Wunused-parameter]
include/linux/blkdev.h:985:74: warning: unused parameter ‘err’ [-Wunused-parameter]
include/linux/blkdev.h: In function ‘blk_pre_runtime_resume’:
include/linux/blkdev.h:986:65: warning: unused parameter ‘q’ [-Wunused-parameter]
include/linux/blkdev.h: In function ‘blk_post_runtime_resume’:
include/linux/blkdev.h:987:66: warning: unused parameter ‘q’ [-Wunused-parameter]
include/linux/blkdev.h:987:73: warning: unused parameter ‘err’ [-Wunused-parameter]
include/linux/blkdev.h: In function ‘set_start_time_ns’:
include/linux/blkdev.h:1348:54: warning: unused parameter ‘req’ [-Wunused-parameter]
include/linux/blkdev.h: In function ‘set_io_start_time_ns’:
include/linux/blkdev.h:1349:57: warning: unused parameter ‘req’ [-Wunused-parameter]
include/linux/blkdev.h: In function ‘rq_start_time_ns’:
include/linux/blkdev.h:1350:57: warning: unused parameter ‘req’ [-Wunused-parameter]
include/linux/blkdev.h: In function ‘rq_io_start_time_ns’:
include/linux/blkdev.h:1354:60: warning: unused parameter ‘req’ [-Wunused-parameter]
include/linux/blkdev.h: In function ‘blk_integrity_rq’:
include/linux/blkdev.h:1450:52: warning: unused parameter ‘rq’ [-Wunused-parameter]
include/linux/blkdev.h: In function ‘blk_rq_count_integrity_sg’:
include/linux/blkdev.h:1454:67: warning: unused parameter ‘q’ [-Wunused-parameter]
include/linux/blkdev.h:1455:22: warning: unused parameter ‘b’ [-Wunused-parameter]
include/linux/blkdev.h: In function ‘blk_rq_map_integrity_sg’:
include/linux/blkdev.h:1459:65: warning: unused parameter ‘q’ [-Wunused-parameter]
include/linux/blkdev.h:1460:20: warning: unused parameter ‘b’ [-Wunused-parameter]
include/linux/blkdev.h:1461:28: warning: unused parameter ‘s’ [-Wunused-parameter]
include/linux/blkdev.h: In function ‘bdev_get_integrity’:
include/linux/blkdev.h:1465:77: warning: unused parameter ‘b’ [-Wunused-parameter]
include/linux/blkdev.h: In function ‘blk_get_integrity’:
include/linux/blkdev.h:1469:71: warning: unused parameter ‘disk’ [-Wunused-parameter]
include/linux/blkdev.h: In function ‘blk_integrity_compare’:
include/linux/blkdev.h:1473:57: warning: unused parameter ‘a’ [-Wunused-parameter]
include/linux/blkdev.h:1473:76: warning: unused parameter ‘b’ [-Wunused-parameter]
include/linux/blkdev.h: In function ‘blk_integrity_register’:
include/linux/blkdev.h:1477:58: warning: unused parameter ‘d’ [-Wunused-parameter]
include/linux/blkdev.h:1478:29: warning: unused parameter ‘b’ [-Wunused-parameter]
include/linux/blkdev.h: In function ‘blk_integrity_unregister’:
include/linux/blkdev.h:1482:61: warning: unused parameter ‘d’ [-Wunused-parameter]
include/linux/blkdev.h: In function ‘blk_queue_max_integrity_segments’:
include/linux/blkdev.h:1485:75: warning: unused parameter ‘q’ [-Wunused-parameter]
include/linux/blkdev.h:1486:24: warning: unused parameter ‘segs’ [-Wunused-parameter]
include/linux/blkdev.h: In function ‘queue_max_integrity_segments’:
include/linux/blkdev.h:1489:81: warning: unused parameter ‘q’ [-Wunused-parameter]
include/linux/blkdev.h: In function ‘blk_integrity_merge_rq’:
include/linux/blkdev.h:1493:64: warning: unused parameter ‘rq’ [-Wunused-parameter]
include/linux/blkdev.h:1494:23: warning: unused parameter ‘r1’ [-Wunused-parameter]
include/linux/blkdev.h:1495:23: warning: unused parameter ‘r2’ [-Wunused-parameter]
include/linux/blkdev.h: In function ‘blk_integrity_merge_bio’:
include/linux/blkdev.h:1499:65: warning: unused parameter ‘rq’ [-Wunused-parameter]
include/linux/blkdev.h:1500:24: warning: unused parameter ‘r’ [-Wunused-parameter]
include/linux/blkdev.h:1501:20: warning: unused parameter ‘b’ [-Wunused-parameter]
include/linux/blkdev.h: In function ‘blk_integrity_is_initialized’:
include/linux/blkdev.h:1505:65: warning: unused parameter ‘g’ [-Wunused-parameter]
In file included from mm/vmscan.c:45:0:
include/linux/prefetch.h: In function ‘prefetch_range’:
include/linux/prefetch.h:53:41: warning: unused parameter ‘addr’ [-Wunused-parameter]
include/linux/prefetch.h:53:54: warning: unused parameter ‘len’ [-Wunused-parameter]
In file included from mm/vmscan.c:50:0:
include/linux/swapops.h: In function ‘make_hwpoison_entry’:
include/linux/swapops.h:177:60: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/swapops.h: In function ‘is_hwpoison_entry’:
include/linux/swapops.h:182:49: warning: unused parameter ‘swp’ [-Wunused-parameter]
In file included from mm/vmscan.c:55:0:
include/trace/events/vmscan.h: In function ‘check_trace_callback_type_mm_vmscan_kswapd_sleep’:
include/trace/events/vmscan.h:39:1: warning: unused parameter ‘cb’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘check_trace_callback_type_mm_vmscan_kswapd_wake’:
include/trace/events/vmscan.h:56:1: warning: unused parameter ‘cb’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘check_trace_callback_type_mm_vmscan_wakeup_kswapd’:
include/trace/events/vmscan.h:75:1: warning: unused parameter ‘cb’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘check_trace_callback_type_mm_vmscan_direct_reclaim_begin’:
include/trace/events/vmscan.h:123:1: warning: unused parameter ‘cb’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘check_trace_callback_type_mm_vmscan_memcg_reclaim_begin’:
include/trace/events/vmscan.h:130:1: warning: unused parameter ‘cb’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘check_trace_callback_type_mm_vmscan_memcg_softlimit_reclaim_begin’:
include/trace/events/vmscan.h:137:1: warning: unused parameter ‘cb’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘check_trace_callback_type_mm_vmscan_direct_reclaim_end’:
include/trace/events/vmscan.h:161:1: warning: unused parameter ‘cb’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘check_trace_callback_type_mm_vmscan_memcg_reclaim_end’:
include/trace/events/vmscan.h:168:1: warning: unused parameter ‘cb’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘check_trace_callback_type_mm_vmscan_memcg_softlimit_reclaim_end’:
include/trace/events/vmscan.h:175:1: warning: unused parameter ‘cb’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘check_trace_callback_type_mm_shrink_slab_start’:
include/trace/events/vmscan.h:182:1: warning: unused parameter ‘cb’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘check_trace_callback_type_mm_shrink_slab_end’:
include/trace/events/vmscan.h:227:1: warning: unused parameter ‘cb’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘check_trace_callback_type_mm_vmscan_lru_isolate’:
include/trace/events/vmscan.h:298:1: warning: unused parameter ‘cb’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘check_trace_callback_type_mm_vmscan_memcg_isolate’:
include/trace/events/vmscan.h:311:1: warning: unused parameter ‘cb’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘check_trace_callback_type_mm_vmscan_writepage’:
include/trace/events/vmscan.h:324:1: warning: unused parameter ‘cb’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘check_trace_callback_type_mm_vmscan_lru_shrink_inactive’:
include/trace/events/vmscan.h:347:1: warning: unused parameter ‘cb’ [-Wunused-parameter]
In file included from include/linux/ring_buffer.h:4:0,
                 from include/linux/ftrace_event.h:4,
                 from include/trace/ftrace.h:19,
                 from include/trace/define_trace.h:86,
                 from include/trace/events/vmscan.h:383,
                 from mm/vmscan.c:55:
include/linux/kmemcheck.h: In function ‘kmemcheck_alloc_shadow’:
include/linux/kmemcheck.h:93:37: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/kmemcheck.h:93:47: warning: unused parameter ‘order’ [-Wunused-parameter]
include/linux/kmemcheck.h:93:60: warning: unused parameter ‘flags’ [-Wunused-parameter]
include/linux/kmemcheck.h:93:71: warning: unused parameter ‘node’ [-Wunused-parameter]
include/linux/kmemcheck.h: In function ‘kmemcheck_free_shadow’:
include/linux/kmemcheck.h:98:36: warning: unused parameter ‘page’ [-Wunused-parameter]
include/linux/kmemcheck.h:98:46: warning: unused parameter ‘order’ [-Wunused-parameter]
include/linux/kmemcheck.h: In function ‘kmemcheck_slab_alloc’:
include/linux/kmemcheck.h:103:41: warning: unused parameter ‘s’ [-Wunused-parameter]
include/linux/kmemcheck.h:103:50: warning: unused parameter ‘gfpflags’ [-Wunused-parameter]
include/linux/kmemcheck.h:103:66: warning: unused parameter ‘object’ [-Wunused-parameter]
include/linux/kmemcheck.h:104:15: warning: unused parameter ‘size’ [-Wunused-parameter]
include/linux/kmemcheck.h: In function ‘kmemcheck_slab_free’:
include/linux/kmemcheck.h:108:59: warning: unused parameter ‘s’ [-Wunused-parameter]
include/linux/kmemcheck.h:108:68: warning: unused parameter ‘object’ [-Wunused-parameter]
include/linux/kmemcheck.h:109:19: warning: unused parameter ‘size’ [-Wunused-parameter]
include/linux/kmemcheck.h: In function ‘kmemcheck_pagealloc_alloc’:
include/linux/kmemcheck.h:113:59: warning: unused parameter ‘p’ [-Wunused-parameter]
include/linux/kmemcheck.h:114:15: warning: unused parameter ‘order’ [-Wunused-parameter]
include/linux/kmemcheck.h:114:28: warning: unused parameter ‘gfpflags’ [-Wunused-parameter]
include/linux/kmemcheck.h: In function ‘kmemcheck_page_is_tracked’:
include/linux/kmemcheck.h:118:59: warning: unused parameter ‘p’ [-Wunused-parameter]
include/linux/kmemcheck.h: In function ‘kmemcheck_mark_unallocated’:
include/linux/kmemcheck.h:123:53: warning: unused parameter ‘address’ [-Wunused-parameter]
include/linux/kmemcheck.h:123:75: warning: unused parameter ‘n’ [-Wunused-parameter]
include/linux/kmemcheck.h: In function ‘kmemcheck_mark_uninitialized’:
include/linux/kmemcheck.h:127:55: warning: unused parameter ‘address’ [-Wunused-parameter]
include/linux/kmemcheck.h:127:77: warning: unused parameter ‘n’ [-Wunused-parameter]
include/linux/kmemcheck.h: In function ‘kmemcheck_mark_initialized’:
include/linux/kmemcheck.h:131:53: warning: unused parameter ‘address’ [-Wunused-parameter]
include/linux/kmemcheck.h:131:75: warning: unused parameter ‘n’ [-Wunused-parameter]
include/linux/kmemcheck.h: In function ‘kmemcheck_mark_freed’:
include/linux/kmemcheck.h:135:47: warning: unused parameter ‘address’ [-Wunused-parameter]
include/linux/kmemcheck.h:135:69: warning: unused parameter ‘n’ [-Wunused-parameter]
include/linux/kmemcheck.h: In function ‘kmemcheck_mark_unallocated_pages’:
include/linux/kmemcheck.h:139:66: warning: unused parameter ‘p’ [-Wunused-parameter]
include/linux/kmemcheck.h:140:24: warning: unused parameter ‘n’ [-Wunused-parameter]
include/linux/kmemcheck.h: In function ‘kmemcheck_mark_uninitialized_pages’:
include/linux/kmemcheck.h:144:68: warning: unused parameter ‘p’ [-Wunused-parameter]
include/linux/kmemcheck.h:145:26: warning: unused parameter ‘n’ [-Wunused-parameter]
include/linux/kmemcheck.h: In function ‘kmemcheck_mark_initialized_pages’:
include/linux/kmemcheck.h:149:66: warning: unused parameter ‘p’ [-Wunused-parameter]
include/linux/kmemcheck.h:150:24: warning: unused parameter ‘n’ [-Wunused-parameter]
include/linux/kmemcheck.h: In function ‘kmemcheck_is_obj_initialized’:
include/linux/kmemcheck.h:154:63: warning: unused parameter ‘addr’ [-Wunused-parameter]
include/linux/kmemcheck.h:154:76: warning: unused parameter ‘size’ [-Wunused-parameter]
In file included from include/linux/ring_buffer.h:6:0,
                 from include/linux/ftrace_event.h:4,
                 from include/trace/ftrace.h:19,
                 from include/trace/define_trace.h:86,
                 from include/trace/events/vmscan.h:383,
                 from mm/vmscan.c:55:
include/linux/seq_file.h: In function ‘seq_user_ns’:
include/linux/seq_file.h:136:67: warning: unused parameter ‘seq’ [-Wunused-parameter]
In file included from include/linux/ftrace_event.h:4:0,
                 from include/trace/ftrace.h:19,
                 from include/trace/define_trace.h:86,
                 from include/trace/events/vmscan.h:383,
                 from mm/vmscan.c:55:
include/linux/ring_buffer.h: In function ‘ring_buffer_swap_cpu’:
include/linux/ring_buffer.h:150:42: warning: unused parameter ‘buffer_a’ [-Wunused-parameter]
include/linux/ring_buffer.h:151:28: warning: unused parameter ‘buffer_b’ [-Wunused-parameter]
include/linux/ring_buffer.h:151:42: warning: unused parameter ‘cpu’ [-Wunused-parameter]
In file included from include/linux/perf_event.h:35:0,
                 from include/linux/ftrace_event.h:8,
                 from include/trace/ftrace.h:19,
                 from include/trace/define_trace.h:86,
                 from include/trace/events/vmscan.h:383,
                 from mm/vmscan.c:55:
/root/linux-next/arch/x86/include/asm/hw_breakpoint.h: In function ‘hw_breakpoint_slots’:
/root/linux-next/arch/x86/include/asm/hw_breakpoint.h:45:43: warning: unused parameter ‘type’ [-Wunused-parameter]
In file included from include/linux/ftrace.h:10:0,
                 from include/linux/perf_event.h:47,
                 from include/linux/ftrace_event.h:8,
                 from include/trace/ftrace.h:19,
                 from include/trace/define_trace.h:86,
                 from include/trace/events/vmscan.h:383,
                 from mm/vmscan.c:55:
include/linux/kallsyms.h: In function ‘__check_printsym_format’:
include/linux/kallsyms.h:112:42: warning: unused parameter ‘fmt’ [-Wunused-parameter]
In file included from include/linux/perf_event.h:47:0,
                 from include/linux/ftrace_event.h:8,
                 from include/trace/ftrace.h:19,
                 from include/trace/define_trace.h:86,
                 from include/trace/events/vmscan.h:383,
                 from mm/vmscan.c:55:
include/linux/ftrace.h: In function ‘skip_trace’:
include/linux/ftrace.h:531:44: warning: unused parameter ‘ip’ [-Wunused-parameter]
include/linux/ftrace.h: In function ‘ftrace_release_mod’:
include/linux/ftrace.h:535:54: warning: unused parameter ‘mod’ [-Wunused-parameter]
include/linux/ftrace.h: In function ‘register_ftrace_command’:
include/linux/ftrace.h:536:71: warning: unused parameter ‘cmd’ [-Wunused-parameter]
include/linux/ftrace.h: In function ‘unregister_ftrace_command’:
include/linux/ftrace.h:540:51: warning: unused parameter ‘cmd_name’ [-Wunused-parameter]
include/linux/ftrace.h: In function ‘ftrace_text_reserved’:
include/linux/ftrace.h:544:46: warning: unused parameter ‘start’ [-Wunused-parameter]
include/linux/ftrace.h:544:59: warning: unused parameter ‘end’ [-Wunused-parameter]
include/linux/ftrace.h: In function ‘ftrace_location’:
include/linux/ftrace.h:548:59: warning: unused parameter ‘ip’ [-Wunused-parameter]
include/linux/ftrace.h: In function ‘ftrace_filter_write’:
include/linux/ftrace.h:565:56: warning: unused parameter ‘file’ [-Wunused-parameter]
include/linux/ftrace.h:565:81: warning: unused parameter ‘ubuf’ [-Wunused-parameter]
include/linux/ftrace.h:566:15: warning: unused parameter ‘cnt’ [-Wunused-parameter]
include/linux/ftrace.h:566:28: warning: unused parameter ‘ppos’ [-Wunused-parameter]
include/linux/ftrace.h: In function ‘ftrace_notrace_write’:
include/linux/ftrace.h:567:57: warning: unused parameter ‘file’ [-Wunused-parameter]
include/linux/ftrace.h:567:82: warning: unused parameter ‘ubuf’ [-Wunused-parameter]
include/linux/ftrace.h:568:16: warning: unused parameter ‘cnt’ [-Wunused-parameter]
include/linux/ftrace.h:568:29: warning: unused parameter ‘ppos’ [-Wunused-parameter]
include/linux/ftrace.h: In function ‘ftrace_regex_release’:
include/linux/ftrace.h:570:36: warning: unused parameter ‘inode’ [-Wunused-parameter]
include/linux/ftrace.h:570:56: warning: unused parameter ‘file’ [-Wunused-parameter]
include/linux/ftrace.h: In function ‘__ftrace_enabled_restore’:
include/linux/ftrace.h:601:49: warning: unused parameter ‘enabled’ [-Wunused-parameter]
include/linux/ftrace.h: In function ‘time_hardirqs_on’:
include/linux/ftrace.h:632:53: warning: unused parameter ‘a0’ [-Wunused-parameter]
include/linux/ftrace.h:632:71: warning: unused parameter ‘a1’ [-Wunused-parameter]
include/linux/ftrace.h: In function ‘time_hardirqs_off’:
include/linux/ftrace.h:633:54: warning: unused parameter ‘a0’ [-Wunused-parameter]
include/linux/ftrace.h:633:72: warning: unused parameter ‘a1’ [-Wunused-parameter]
include/linux/ftrace.h: In function ‘ftrace_graph_init_task’:
include/linux/ftrace.h:761:63: warning: unused parameter ‘t’ [-Wunused-parameter]
include/linux/ftrace.h: In function ‘ftrace_graph_exit_task’:
include/linux/ftrace.h:762:63: warning: unused parameter ‘t’ [-Wunused-parameter]
include/linux/ftrace.h: In function ‘ftrace_graph_init_idle_task’:
include/linux/ftrace.h:763:68: warning: unused parameter ‘t’ [-Wunused-parameter]
include/linux/ftrace.h:763:75: warning: unused parameter ‘cpu’ [-Wunused-parameter]
include/linux/ftrace.h: In function ‘register_ftrace_graph’:
include/linux/ftrace.h:765:64: warning: unused parameter ‘retfunc’ [-Wunused-parameter]
include/linux/ftrace.h:766:29: warning: unused parameter ‘entryfunc’ [-Wunused-parameter]
include/linux/ftrace.h: In function ‘task_curr_ret_stack’:
include/linux/ftrace.h:772:59: warning: unused parameter ‘tsk’ [-Wunused-parameter]
In file included from include/trace/ftrace.h:285:0,
                 from include/trace/define_trace.h:86,
                 from include/trace/events/vmscan.h:383,
                 from mm/vmscan.c:55:
include/trace/events/vmscan.h: In function ‘ftrace_raw_output_mm_vmscan_kswapd_sleep’:
include/trace/events/vmscan.h:39:1: warning: unused parameter ‘flags’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘ftrace_raw_output_mm_vmscan_kswapd_wake’:
include/trace/events/vmscan.h:56:1: warning: unused parameter ‘flags’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘ftrace_raw_output_mm_vmscan_wakeup_kswapd’:
include/trace/events/vmscan.h:75:1: warning: unused parameter ‘flags’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘ftrace_raw_output_mm_vmscan_direct_reclaim_begin_template’:
include/trace/events/vmscan.h:99:1: warning: unused parameter ‘flags’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘ftrace_raw_output_mm_vmscan_direct_reclaim_end_template’:
include/trace/events/vmscan.h:144:1: warning: unused parameter ‘flags’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘ftrace_raw_output_mm_shrink_slab_start’:
include/trace/events/vmscan.h:182:1: warning: unused parameter ‘flags’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘ftrace_raw_output_mm_shrink_slab_end’:
include/trace/events/vmscan.h:227:1: warning: unused parameter ‘flags’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘ftrace_raw_output_mm_vmscan_lru_isolate_template’:
include/trace/events/vmscan.h:260:1: warning: unused parameter ‘flags’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘ftrace_raw_output_mm_vmscan_writepage’:
include/trace/events/vmscan.h:324:1: warning: unused parameter ‘flags’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘ftrace_raw_output_mm_vmscan_lru_shrink_inactive’:
include/trace/events/vmscan.h:347:1: warning: unused parameter ‘flags’ [-Wunused-parameter]
In file included from include/trace/ftrace.h:393:0,
                 from include/trace/define_trace.h:86,
                 from include/trace/events/vmscan.h:383,
                 from mm/vmscan.c:55:
include/trace/events/vmscan.h: In function ‘ftrace_get_offsets_mm_vmscan_kswapd_sleep’:
include/trace/events/vmscan.h:39:1: warning: unused parameter ‘__data_offsets’ [-Wunused-parameter]
include/trace/events/vmscan.h:39:1: warning: unused parameter ‘nid’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘ftrace_get_offsets_mm_vmscan_kswapd_wake’:
include/trace/events/vmscan.h:56:1: warning: unused parameter ‘__data_offsets’ [-Wunused-parameter]
include/trace/events/vmscan.h:56:1: warning: unused parameter ‘nid’ [-Wunused-parameter]
include/trace/events/vmscan.h:56:1: warning: unused parameter ‘order’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘ftrace_get_offsets_mm_vmscan_wakeup_kswapd’:
include/trace/events/vmscan.h:75:1: warning: unused parameter ‘__data_offsets’ [-Wunused-parameter]
include/trace/events/vmscan.h:75:1: warning: unused parameter ‘nid’ [-Wunused-parameter]
include/trace/events/vmscan.h:75:1: warning: unused parameter ‘zid’ [-Wunused-parameter]
include/trace/events/vmscan.h:75:1: warning: unused parameter ‘order’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘ftrace_get_offsets_mm_vmscan_direct_reclaim_begin_template’:
include/trace/events/vmscan.h:99:1: warning: unused parameter ‘__data_offsets’ [-Wunused-parameter]
include/trace/events/vmscan.h:99:1: warning: unused parameter ‘order’ [-Wunused-parameter]
include/trace/events/vmscan.h:99:1: warning: unused parameter ‘may_writepage’ [-Wunused-parameter]
include/trace/events/vmscan.h:99:1: warning: unused parameter ‘gfp_flags’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘ftrace_get_offsets_mm_vmscan_direct_reclaim_end_template’:
include/trace/events/vmscan.h:144:1: warning: unused parameter ‘__data_offsets’ [-Wunused-parameter]
include/trace/events/vmscan.h:144:1: warning: unused parameter ‘nr_reclaimed’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘ftrace_get_offsets_mm_shrink_slab_start’:
include/trace/events/vmscan.h:182:1: warning: unused parameter ‘__data_offsets’ [-Wunused-parameter]
include/trace/events/vmscan.h:182:1: warning: unused parameter ‘shr’ [-Wunused-parameter]
include/trace/events/vmscan.h:182:1: warning: unused parameter ‘sc’ [-Wunused-parameter]
include/trace/events/vmscan.h:182:1: warning: unused parameter ‘nr_objects_to_shrink’ [-Wunused-parameter]
include/trace/events/vmscan.h:182:1: warning: unused parameter ‘pgs_scanned’ [-Wunused-parameter]
include/trace/events/vmscan.h:182:1: warning: unused parameter ‘lru_pgs’ [-Wunused-parameter]
include/trace/events/vmscan.h:182:1: warning: unused parameter ‘cache_items’ [-Wunused-parameter]
include/trace/events/vmscan.h:182:1: warning: unused parameter ‘delta’ [-Wunused-parameter]
include/trace/events/vmscan.h:182:1: warning: unused parameter ‘total_scan’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘ftrace_get_offsets_mm_shrink_slab_end’:
include/trace/events/vmscan.h:227:1: warning: unused parameter ‘__data_offsets’ [-Wunused-parameter]
include/trace/events/vmscan.h:227:1: warning: unused parameter ‘shr’ [-Wunused-parameter]
include/trace/events/vmscan.h:227:1: warning: unused parameter ‘shrinker_retval’ [-Wunused-parameter]
include/trace/events/vmscan.h:227:1: warning: unused parameter ‘unused_scan_cnt’ [-Wunused-parameter]
include/trace/events/vmscan.h:227:1: warning: unused parameter ‘new_scan_cnt’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘ftrace_get_offsets_mm_vmscan_lru_isolate_template’:
include/trace/events/vmscan.h:260:1: warning: unused parameter ‘__data_offsets’ [-Wunused-parameter]
include/trace/events/vmscan.h:260:1: warning: unused parameter ‘order’ [-Wunused-parameter]
include/trace/events/vmscan.h:260:1: warning: unused parameter ‘nr_requested’ [-Wunused-parameter]
include/trace/events/vmscan.h:260:1: warning: unused parameter ‘nr_scanned’ [-Wunused-parameter]
include/trace/events/vmscan.h:260:1: warning: unused parameter ‘nr_taken’ [-Wunused-parameter]
include/trace/events/vmscan.h:260:1: warning: unused parameter ‘isolate_mode’ [-Wunused-parameter]
include/trace/events/vmscan.h:260:1: warning: unused parameter ‘file’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘ftrace_get_offsets_mm_vmscan_writepage’:
include/trace/events/vmscan.h:324:1: warning: unused parameter ‘__data_offsets’ [-Wunused-parameter]
include/trace/events/vmscan.h:324:1: warning: unused parameter ‘page’ [-Wunused-parameter]
include/trace/events/vmscan.h:324:1: warning: unused parameter ‘reclaim_flags’ [-Wunused-parameter]
include/trace/events/vmscan.h: In function ‘ftrace_get_offsets_mm_vmscan_lru_shrink_inactive’:
include/trace/events/vmscan.h:347:1: warning: unused parameter ‘__data_offsets’ [-Wunused-parameter]
include/trace/events/vmscan.h:347:1: warning: unused parameter ‘nid’ [-Wunused-parameter]
include/trace/events/vmscan.h:347:1: warning: unused parameter ‘zid’ [-Wunused-parameter]
include/trace/events/vmscan.h:347:1: warning: unused parameter ‘nr_scanned’ [-Wunused-parameter]
include/trace/events/vmscan.h:347:1: warning: unused parameter ‘nr_reclaimed’ [-Wunused-parameter]
include/trace/events/vmscan.h:347:1: warning: unused parameter ‘priority’ [-Wunused-parameter]
include/trace/events/vmscan.h:347:1: warning: unused parameter ‘reclaim_flags’ [-Wunused-parameter]
mm/vmscan.c: In function ‘global_reclaim’:
mm/vmscan.c:143:49: warning: unused parameter ‘sc’ [-Wunused-parameter]
mm/vmscan.c: In function ‘may_write_to_queue’:
mm/vmscan.c:364:31: warning: unused parameter ‘sc’ [-Wunused-parameter]
mm/vmscan.c: In function ‘throttle_direct_reclaim’:
mm/vmscan.c:2507:18: warning: unused parameter ‘nodemask’ [-Wunused-parameter]
mm/vmscan.c: In function ‘cpu_callback’:
mm/vmscan.c:3381:48: warning: unused parameter ‘nfb’ [-Wunused-parameter]
mm/vmscan.c:3382:10: warning: unused parameter ‘hcpu’ [-Wunused-parameter]
mm/vmscan.c: In function ‘read_scan_unevictable_node’:
mm/vmscan.c:3763:58: warning: unused parameter ‘dev’ [-Wunused-parameter]
mm/vmscan.c:3764:33: warning: unused parameter ‘attr’ [-Wunused-parameter]
mm/vmscan.c: In function ‘write_scan_unevictable_node’:
mm/vmscan.c:3771:59: warning: unused parameter ‘dev’ [-Wunused-parameter]
mm/vmscan.c:3772:34: warning: unused parameter ‘attr’ [-Wunused-parameter]
mm/vmscan.c:3773:18: warning: unused parameter ‘buf’ [-Wunused-parameter]
mm/vmscan.c:3773:30: warning: unused parameter ‘count’ [-Wunused-parameter]

In file included from /root/linux-next/arch/x86/include/asm/bitops.h:16:0,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:10,
                 from include/asm-generic/bug.h:13,
                 from /root/linux-next/arch/x86/include/asm/bug.h:38,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/wait.h:7,
                 from include/linux/fs.h:6,
                 from mm/shmem.c:24:

--------------070505090509030405020205--
