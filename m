Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029AbaFLJkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 05:40:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:35346 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932845AbaFLJk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 05:40:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,464,1400050800"; 
   d="scan'208";a="444622775"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Linux API <linux-api@vger.kernel.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>
In-Reply-To: <CAHO5Pa31WVrtG+2hU1grbLHiEPjkM_eB4JgSStskX8AvDjQRKA@mail.gmail.com>
References: <1399552888-11024-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1399552888-11024-2-git-send-email-kirill.shutemov@linux.intel.com>
 <CAHO5Pa31WVrtG+2hU1grbLHiEPjkM_eB4JgSStskX8AvDjQRKA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: mark remap_file_pages() syscall as deprecated
Content-Transfer-Encoding: 7bit
Message-Id: <20140612094014.BFEA4E00A2@blue.fi.intel.com>
Date: Thu, 12 Jun 2014 12:40:14 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk wrote:
> Hi Kirill,
> 
> On Thu, May 8, 2014 at 2:41 PM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> > The remap_file_pages() system call is used to create a nonlinear mapping,
> > that is, a mapping in which the pages of the file are mapped into a
> > nonsequential order in memory. The advantage of using remap_file_pages()
> > over using repeated calls to mmap(2) is that the former approach does not
> > require the kernel to create additional VMA (Virtual Memory Area) data
> > structures.
> >
> > Supporting of nonlinear mapping requires significant amount of non-trivial
> > code in kernel virtual memory subsystem including hot paths. Also to get
> > nonlinear mapping work kernel need a way to distinguish normal page table
> > entries from entries with file offset (pte_file). Kernel reserves flag in
> > PTE for this purpose. PTE flags are scarce resource especially on some CPU
> > architectures. It would be nice to free up the flag for other usage.
> >
> > Fortunately, there are not many users of remap_file_pages() in the wild.
> > It's only known that one enterprise RDBMS implementation uses the syscall
> > on 32-bit systems to map files bigger than can linearly fit into 32-bit
> > virtual address space. This use-case is not critical anymore since 64-bit
> > systems are widely available.
> >
> > The plan is to deprecate the syscall and replace it with an emulation.
> > The emulation will create new VMAs instead of nonlinear mappings. It's
> > going to work slower for rare users of remap_file_pages() but ABI is
> > preserved.
> >
> > One side effect of emulation (apart from performance) is that user can hit
> > vm.max_map_count limit more easily due to additional VMAs. See comment for
> > DEFAULT_MAX_MAP_COUNT for more details on the limit.
> 
> Best to CC linux-api@
> (https://www.kernel.org/doc/man-pages/linux-api-ml.html) on patches
> like this, as well as the man-pages maintainer, so that something goes
> into the man page. I added the following into the man page:
> 
>        Note:  this  system  call  is (since Linux 3.16) deprecated and
>        will eventually be replaced by a  slower  in-kernel  emulation.
>        Those  few  applications  that use this system call should con‐
>        sider migrating to alternatives.
> 
> Okay?

Yep. Looks okay to me.

-- 
 Kirill A. Shutemov
