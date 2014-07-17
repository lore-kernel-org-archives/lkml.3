Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893AbaGQVds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 17:33:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816AbaGQVdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 17:33:46 -0400
Date: Thu, 17 Jul 2014 17:33:32 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Guillaume Morin <guillaume@morinfr.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [BUG] new copy_hugetlb_page_range() causing crashes
Message-ID: <20140717213332.GA20284@nhori.bos.redhat.com>
References: <019768ac467043a4aaea3e455cb74db7@BPXC18GP.gisp.nec.co.jp>
 <FC3CA273EA98D94B96901B237F5F506BB61DC0@irvmail101.necam.prv>
 <20140717201203.GA23591@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140717201203.GA23591@bender.morinfr.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 10:12:04PM +0200, Guillaume Morin wrote:
> Nayoa,
> 
> Thanks for your answer.
> 
> On 17 Jul 14:35, Horiguchi, Naoya wrote:
> > I tried some simple operation (below) on 3.14.12, but not reproduced the crash,
> > so some non-trivial condition seemed to trigger this.
> > Could you elaborate about how you reproduced the crash?
> 
> Well, It's just a bunch of fairly random unit tests and I was not able
> to make it happen on a small program.  However, I modified your program
> a bit and managed to reproduce the problem:

Great.

> $ cat heap.c 
> #include <stdio.h>
> #include <unistd.h>
> #include <stdlib.h>
> #include <string.h>
> 
> int main() {
>         int i;
>         char *p = malloc(4096*512);
>         for (i = 0; i < 512; i++)
>                 p[i*4096] = '1';
>         printf("p %p\n", p);
>         for (i = 0 ; i < 10; i++)
>                 if (!fork()) {
>                     memset(p, '2', 4096*512);
>                     p = malloc(4096*512);
>                     printf("pid %d\n", getpid());
>                     memset(p, '3', 4096*512);
>                     free(p);
> 
>                     return 0;
>                 }
>         pause();                                    
> }
> 
> This is what happens on my 3.14.12 machine:
> $ export HUGETLB_MORECORE=yes ; export HUGETLB_NO_PREFAULT= ; hugectl --heap ./h
> p 0x800010
> pid 7974
> pid 7975
> h: malloc.c:2369: sysmalloc: Assertion `(old_top == (((mbinptr) (((char *) &((av)->bins[((1) - 1) * 2])) - __builtin_offsetof (struct malloc_chunk, fd)))) && old_size == 0) || ((unsigned long) (old_size) >= (unsigned long)((((__builtin_offsetof (struct malloc_chunk, fd_nextsize))+((2 * (sizeof(size_t))) - 1)) & ~((2 * (sizeof(size_t))) - 1))) && ((old_top)->size & 0x1) && ((unsigned long)old_end & pagemask) == 0)' failed.
> 
> Sometimes the process gets stuck instead asserting out.  But I could not
> make it SIGSEGV
> 
> Same result with the 3.4.98 kernel.

In my environment (kernel-3.14.12, libhugetlbfs-utils-2.16-2.fc20.x86_64),
the crash looks like this:

[root@test_140717-1333 hugetlbfs_test]# $ export HUGETLB_MORECORE=yes ; export HUGETLB_NO_PREFAULT= ; hugectl --heap ./heap
bash: $: command not found...
p 0x2200010
pid 2809
*** Error in `./heap': break adjusted to free malloc space: 0x0000000002501000 ***
======= Backtrace: =========
/lib64/libc.so.6[0x3940e75cff]
/lib64/libc.so.6[0x3940e7f121]
/lib64/libc.so.6(__libc_malloc+0x5c)[0x3940e7ff6c]
./heap[0x400767]
/lib64/libc.so.6(__libc_start_main+0xf5)[0x3940e21d65]
./heap[0x400619]
======= Memory map: ========
00400000-00401000 r-xp 00000000 fd:01 272411                             /root/hugetlbfs_test/heap
00600000-00601000 r--p 00000000 fd:01 272411                             /root/hugetlbfs_test/heap
00601000-00602000 rw-p 00001000 fd:01 272411                             /root/hugetlbfs_test/heap
02200000-02600000 rw-p 00000000 00:0c 23209                              /anon_hugepage (deleted)
02600000-02800000 rw-p 00400000 00:0c 25663                              /anon_hugepage (deleted)
3940a00000-3940a20000 r-xp 00000000 fd:01 175094                         /usr/lib64/ld-2.18.so
3940c1f000-3940c20000 r--p 0001f000 fd:01 175094                         /usr/lib64/ld-2.18.so
3940c20000-3940c21000 rw-p 00020000 fd:01 175094                         /usr/lib64/ld-2.18.so
3940c21000-3940c22000 rw-p 00000000 00:00 0
3940e00000-3940fb4000 r-xp 00000000 fd:01 175095                         /usr/lib64/libc-2.18.so
3940fb4000-39411b4000 ---p 001b4000 fd:01 175095                         /usr/lib64/libc-2.18.so
39411b4000-39411b8000 r--p 001b4000 fd:01 175095                         /usr/lib64/libc-2.18.so
39411b8000-39411ba000 rw-p 001b8000 fd:01 175095                         /usr/lib64/libc-2.18.so
39411ba000-39411bf000 rw-p 00000000 00:00 0
3941200000-3941203000 r-xp 00000000 fd:01 175098                         /usr/lib64/libdl-2.18.so
3941203000-3941402000 ---p 00003000 fd:01 175098                         /usr/lib64/libdl-2.18.so
3941402000-3941403000 r--p 00002000 fd:01 175098                         /usr/lib64/libdl-2.18.so
3941403000-3941404000 rw-p 00003000 fd:01 175098                         /usr/lib64/libdl-2.18.so
7f3860277000-7f386028c000 r-xp 00000000 fd:01 184953                     /usr/lib64/libgcc_s-4.8.3-20140624.so.1
7f386028c000-7f386048b000 ---p 00015000 fd:01 184953                     /usr/lib64/libgcc_s-4.8.3-20140624.so.1
7f386048b000-7f386048c000 r--p 00014000 fd:01 184953                     /usr/lib64/libgcc_s-4.8.3-20140624.so.1
7f386048c000-7f386048d000 rw-p 00015000 fd:01 184953                     /usr/lib64/libgcc_s-4.8.3-20140624.so.1
7f38604a2000-7f38604a6000 rw-p 00000000 00:00 0
7f38604a6000-7f38604b6000 r-xp 00000000 fd:01 177014                     /usr/lib64/libhugetlbfs.so
7f38604b6000-7f38606b5000 ---p 00010000 fd:01 177014                     /usr/lib64/libhugetlbfs.so
7f38606b5000-7f38606b6000 r--p 0000f000 fd:01 177014                     /usr/lib64/libhugetlbfs.so
7f38606b6000-7f38606b7000 rw-p 00010000 fd:01 177014                     /usr/lib64/libhugetlbfs.so
7f38606b7000-7f38606c2000 rw-p 00000000 00:00 0
7f38606d5000-7f38606d6000 rw-p 00000000 00:00 0
7f38606d6000-7f38606d8000 rw-p 00000000 00:00 0
7fff07c44000-7fff07c65000 rw-p 00000000 00:00 0                          [stack]
7fff07d52000-7fff07d54000 r-xp 00000000 00:00 0                          [vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]

Is this crash the same as yours?

And it seems that this also happens on v3.16-rc5.
So it might be an upstream bug, not a stable-specific matter.

It looks strange to me that the problem is gone by removing the commit
4a705fef98 (although I confirmed it is,) because the kernel's behavior
shouldn't change unless (is_hugetlb_entry_migration(entry) ||
is_hugetlb_entry_hwpoisoned(entry)) is true. And I checked with systemtap
that both these check returned false in the above test program.
So I'm wondering why the commit makes difference for this test program.

Anyway I'll dig more.

Thanks,
Naoya Horiguchi
