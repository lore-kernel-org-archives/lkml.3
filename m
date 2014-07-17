Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbaGQV7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 17:59:45 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:1774 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757850AbaGQV7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 17:59:44 -0400
Date: Thu, 17 Jul 2014 23:59:36 +0200
From: Guillaume Morin <guillaume@morinfr.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Guillaume Morin <guillaume@morinfr.org>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [BUG] new copy_hugetlb_page_range() causing crashes
Message-ID: <20140717215936.GA28949@bender.morinfr.org>
Mail-Followup-To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
	Guillaume Morin <guillaume@morinfr.org>,
	Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Naoya Horiguchi <nao.horiguchi@gmail.com>
References: <019768ac467043a4aaea3e455cb74db7@BPXC18GP.gisp.nec.co.jp>
 <FC3CA273EA98D94B96901B237F5F506BB61DC0@irvmail101.necam.prv>
 <20140717201203.GA23591@bender.morinfr.org>
 <20140717213332.GA20284@nhori.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140717213332.GA20284@nhori.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 Jul 17:33, Naoya Horiguchi wrote:
> In my environment (kernel-3.14.12, libhugetlbfs-utils-2.16-2.fc20.x86_64),
> the crash looks like this:
> 
> [root@test_140717-1333 hugetlbfs_test]# $ export HUGETLB_MORECORE=yes ; export HUGETLB_NO_PREFAULT= ; hugectl --heap ./heap
> bash: $: command not found...
> p 0x2200010
> pid 2809
> *** Error in `./heap': break adjusted to free malloc space: 0x0000000002501000 ***
> ======= Backtrace: =========
> /lib64/libc.so.6[0x3940e75cff]
> /lib64/libc.so.6[0x3940e7f121]
> /lib64/libc.so.6(__libc_malloc+0x5c)[0x3940e7ff6c]
> ./heap[0x400767]
> /lib64/libc.so.6(__libc_start_main+0xf5)[0x3940e21d65]
> ./heap[0x400619]
> ======= Memory map: ========
> 00400000-00401000 r-xp 00000000 fd:01 272411                             /root/hugetlbfs_test/heap
> 00600000-00601000 r--p 00000000 fd:01 272411                             /root/hugetlbfs_test/heap
> 00601000-00602000 rw-p 00001000 fd:01 272411                             /root/hugetlbfs_test/heap
> 02200000-02600000 rw-p 00000000 00:0c 23209                              /anon_hugepage (deleted)
> 02600000-02800000 rw-p 00400000 00:0c 25663                              /anon_hugepage (deleted)
> 3940a00000-3940a20000 r-xp 00000000 fd:01 175094                         /usr/lib64/ld-2.18.so
> 3940c1f000-3940c20000 r--p 0001f000 fd:01 175094                         /usr/lib64/ld-2.18.so
> 3940c20000-3940c21000 rw-p 00020000 fd:01 175094                         /usr/lib64/ld-2.18.so
> 3940c21000-3940c22000 rw-p 00000000 00:00 0
> 3940e00000-3940fb4000 r-xp 00000000 fd:01 175095                         /usr/lib64/libc-2.18.so
> 3940fb4000-39411b4000 ---p 001b4000 fd:01 175095                         /usr/lib64/libc-2.18.so
> 39411b4000-39411b8000 r--p 001b4000 fd:01 175095                         /usr/lib64/libc-2.18.so
> 39411b8000-39411ba000 rw-p 001b8000 fd:01 175095                         /usr/lib64/libc-2.18.so
> 39411ba000-39411bf000 rw-p 00000000 00:00 0
> 3941200000-3941203000 r-xp 00000000 fd:01 175098                         /usr/lib64/libdl-2.18.so
> 3941203000-3941402000 ---p 00003000 fd:01 175098                         /usr/lib64/libdl-2.18.so
> 3941402000-3941403000 r--p 00002000 fd:01 175098                         /usr/lib64/libdl-2.18.so
> 3941403000-3941404000 rw-p 00003000 fd:01 175098                         /usr/lib64/libdl-2.18.so
> 7f3860277000-7f386028c000 r-xp 00000000 fd:01 184953                     /usr/lib64/libgcc_s-4.8.3-20140624.so.1
> 7f386028c000-7f386048b000 ---p 00015000 fd:01 184953                     /usr/lib64/libgcc_s-4.8.3-20140624.so.1
> 7f386048b000-7f386048c000 r--p 00014000 fd:01 184953                     /usr/lib64/libgcc_s-4.8.3-20140624.so.1
> 7f386048c000-7f386048d000 rw-p 00015000 fd:01 184953                     /usr/lib64/libgcc_s-4.8.3-20140624.so.1
> 7f38604a2000-7f38604a6000 rw-p 00000000 00:00 0
> 7f38604a6000-7f38604b6000 r-xp 00000000 fd:01 177014                     /usr/lib64/libhugetlbfs.so
> 7f38604b6000-7f38606b5000 ---p 00010000 fd:01 177014                     /usr/lib64/libhugetlbfs.so
> 7f38606b5000-7f38606b6000 r--p 0000f000 fd:01 177014                     /usr/lib64/libhugetlbfs.so
> 7f38606b6000-7f38606b7000 rw-p 00010000 fd:01 177014                     /usr/lib64/libhugetlbfs.so
> 7f38606b7000-7f38606c2000 rw-p 00000000 00:00 0
> 7f38606d5000-7f38606d6000 rw-p 00000000 00:00 0
> 7f38606d6000-7f38606d8000 rw-p 00000000 00:00 0
> 7fff07c44000-7fff07c65000 rw-p 00000000 00:00 0                          [stack]
> 7fff07d52000-7fff07d54000 r-xp 00000000 00:00 0                          [vdso]
> ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]
> 
> Is this crash the same as yours?

It's very similar in the sense that's an assert in malloc.  My error is
slightly different but I guess the exact error depends on a few runtime
parameters

> And it seems that this also happens on v3.16-rc5.
> So it might be an upstream bug, not a stable-specific matter.

That's my understanding as well. I just reported it for 3.4 and 3.14
since these were the kernels I could easily try my original test with.

> It looks strange to me that the problem is gone by removing the commit
> 4a705fef98 (although I confirmed it is,) because the kernel's behavior
> shouldn't change unless (is_hugetlb_entry_migration(entry) ||
> is_hugetlb_entry_hwpoisoned(entry)) is true. And I checked with systemtap
> that both these check returned false in the above test program.
> So I'm wondering why the commit makes difference for this test program.

I don't know why I am just thinking about that now.  Isn't this the fact
that your patch moved the huge_ptep_get() before
huge_ptep_set_wrprotect() in the pte_present() cow case?

Actually, I've just tried to re-add the huge_ptep_get call for that
case and it's fixing the problem for me...

Hmm, want a patch?

-- 
Guillaume Morin <guillaume@morinfr.org>
