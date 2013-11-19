Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab3KSNUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:20:17 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:61145 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab3KSNUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:20:15 -0500
Date: Tue, 19 Nov 2013 14:20:11 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: akpm@linux-foundation.org, mingo@elte.hu, hpa@zytor.com,
        tglx@linutronix.de, dave.hansen@intel.com, mingo@redhat.com,
        n-horiguchi@ah.jp.nec.com, willy@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] x86, mm: get ASLR work for hugetlb mappings
Message-ID: <20131119132011.GD7263@gmail.com>
References: <20131115221406.1692E1E418F@corp2gmr1-2.eem.corp.google.com>
 <20131119083053.GB1243@gmail.com>
 <20131119131750.EA45CE0090@blue.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119131750.EA45CE0090@blue.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kirill A. Shutemov <kirill.shutemov@linux.intel.com> wrote:

> Ingo Molnar wrote:
> > 
> > * akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
> > 
> > > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > > Subject: x86, mm: get ASLR work for hugetlb mappings
> > > 
> > > Matthew noticed that hugetlb doesn't participate in ASLR on x86-64.  The
> > > reason is genereic hugetlb_get_unmapped_area() which is used on x86-64. 
> > > It doesn't support randomization and use bottom-up unmapped area lookup,
> > > instead of usual top-down on x86-64.
> > > 
> > > x86 has arch-specific hugetlb_get_unmapped_area(), but it's used only on
> > > x86-32.
> > > 
> > > Let's use arch-specific hugetlb_get_unmapped_area() on x86-64 too.  It
> > > fixes the issue and make hugetlb use top-down unmapped area lookup.
> > 
> > So the title and the changelog has typos (I counted three), which 
> > makes me wonder how well this was tested.
> > 
> > To show/document the testing effort a before/after /proc/PID/maps 
> > output showing hugetlb vma addresses would be nice, showing that ASLR 
> > didn't work before and that it works adequately after the patch.
> > 
> > A word about the range and granularity of randomization in the typical 
> > case would be nice as well.
> 
> What about this:
> 
> From 440f2cd4a7e6918b9238680e4eacd75dc30291b6 Mon Sep 17 00:00:00 2001
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Date: Fri, 15 Nov 2013 14:14:05 -0800
> Subject: [PATCH] x86, mm: get ASLR works for hugetlb mappings
> 
> Matthew noticed that hugetlb doesn't participate in ASLR on x86-64.
> 
> %  for i in `seq 3`; do
> > tools/testing/selftests/vm/map_hugetlb | grep address
> > done
> Returned address is 0x2aaaaac00000
> Returned address is 0x2aaaaac00000
> Returned address is 0x2aaaaac00000
> 
> /proc/PID/maps entries for the mapping are always the same (except inode
> number):
> 
> 2aaaaac00000-2aaabac00000 rw-p 00000000 00:0c 8200                       /anon_hugepage (deleted)
> 2aaaaac00000-2aaabac00000 rw-p 00000000 00:0c 256                        /anon_hugepage (deleted)
> 2aaaaac00000-2aaabac00000 rw-p 00000000 00:0c 7180                       /anon_hugepage (deleted)
> 
> The reason is generic hugetlb_get_unmapped_area() which is used on
> x86-64.  It doesn't support randomization and use bottom-up unmapped
> area lookup, instead of usual top-down on x86-64.
> 
> x86 has arch-specific hugetlb_get_unmapped_area(), but it's used only on
> x86-32.
> 
> Let's use arch-specific hugetlb_get_unmapped_area() on x86-64 too.
> It fixes the issue and switch hugetlb to use top-down unmapped area
> lookup.
> 
> %  for i in `seq 3`; do
> > tools/testing/selftests/vm/map_hugetlb | grep address
> > done
> Returned address is 0x7f4f08a00000
> Returned address is 0x7fdda4200000
> Returned address is 0x7febe0000000
> 
> /proc/PID/maps entries:
> 
> 7f4f08a00000-7f4f18a00000 rw-p 00000000 00:0c 1168                       /anon_hugepage (deleted)
> 7fdda4200000-7fddb4200000 rw-p 00000000 00:0c 7092                       /anon_hugepage (deleted)
> 7febe0000000-7febf0000000 rw-p 00000000 00:0c 7183                       /anon_hugepage (deleted)
>
> Unmapped area lookup policy for hugetlb mappings is consistent with
> normal mappings now -- the only difference is alignment requirements for
> huge pages.
> 
> libhugetlbfs test-suite didn't detect any regressions with the patch
> applied (although it shows few failures on my machine regardless the
> patch).

Perfect!

(I'll apply this to tip:x86/mm unless someone objects.)

Thanks,

	Ingo
