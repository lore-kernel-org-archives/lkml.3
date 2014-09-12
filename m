Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbaILWII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 18:08:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:38978 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbaILWIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 18:08:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,515,1406617200"; 
   d="scan'208";a="572518329"
Message-ID: <54136EC4.6000905@intel.com>
Date: Fri, 12 Sep 2014 15:08:04 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 00/10] Intel MPX support
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com> <54124379.5090502@intel.com> <alpine.DEB.2.10.1409121543090.4178@nanos>
In-Reply-To: <alpine.DEB.2.10.1409121543090.4178@nanos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, here's some revised text for patch 00/10.  Again, this will
obviously be updated for the next post, but comments before that would
be much appreciated.

-----

This patch set adds support for the Memory Protection eXtensions
(MPX) feature found in future Intel processors.  MPX is used in
conjunction with compiler changes to check memory references, and can be
used to catch buffer overflow or underflow.

For MPX to work, changes are required in the kernel, binutils and
compiler.  No source changes are required for applications, just a
recompile.

There are a lot of moving parts of this to all work right:

===== Example Compiler / Application / Kernel Interaction =====

1. Application developer compiles with -fmpx.  The compiler will add the
   instrumentation as well as some setup code called early after the app
   starts.  New instruction prefixes are noops for old CPUs.
2. That setup code allocates (virtual) space for the "bounds directory",
   points the "bndcfgu" register to the directory and notifies the
   kernel (via the new prctl()) that the app will be using MPX.
3. The kernel detects that the CPU has MPX, allows the new prctl() to
   succeed, and notes the location of the bounds directory.  We note it
   instead of reading it each time because the 'xsave' operation needed
   to access the bounds directory register is an expensive operation.
4. If the application needs to spill bounds out of the 4 registers, it
   issues a bndstx instruction.  Since the bounds directory is empty at
   this point, a bounds fault (#BR) is raised, the kernel allocates a
   bounds table (in the user address space) and makes the relevant
   entry in the bounds directory point to the new table. [1]
5. If the application violates the bounds specified in the bounds
   registers, a separate kind of #BR is raised which will deliver a
   signal with information about the violation in the 'struct siginfo'.
6. Whenever memory is freed, we know that it can no longer contain
   valid pointers, and we attempt to free the associated space in the
   bounds tables.  If an entire table becomes unused, we will attempt
   to free the table and remove the entry in the directory.

To summarize, there are essentially three things interacting here:

GCC with -fmpx:
 * enables annotation of code with MPX instructions and prefixes
 * inserts code early in the application to call in to the "gcc runtime"
GCC MPX Runtime:
 * Checks for hardware MPX support in cpuid leaf
 * allocates virtual space for the bounds directory (malloc()
   essentially)
 * points the hardware BNDCFGU register at the directory
 * calls a new prctl() to notify the kernel to start managing the
   bounds directories
Kernel MPX Code:
 * Checks for hardware MPX support in cpuid leaf
 * Handles #BR exceptions and sends SIGSEGV to the app when it violates
   bounds, like during a buffer overflow.
 * When bounds are spilled in to an unallocated bounds table, the kernel
   notices in the #BR exception, allocates the virtual space, then
   updates the bounds directory to point to the new table.  It keeps
   special track of the memory with a VM_MPX flag.
 * Frees unused bounds tables at the time that the memory they described
   is unmapped. (See "cleanup unused bound tables")

===== Testing =====

This patchset has been tested on real internal hardware platform at
Intel.  We have some simple unit tests in user space, which directly
call MPX instructions to produce #BR to let kernel allocate bounds
tables and cause bounds violations. We also compiled several benchmarks
with an MPX-enabled compiler and ran them with this patch set.  We found
a number of bugs in this code in these tests.

1. For more info on why the kernel does these allocations, see the patch
"on-demand kernel allocation of bounds tables"

