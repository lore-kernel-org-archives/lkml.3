Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbaAZDUn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 22:20:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:35485 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbaAZDUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 22:20:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,721,1384329600"; 
   d="scan'208";a="444656352"
Message-ID: <52E47DBA.4080203@intel.com>
Date: Sun, 26 Jan 2014 11:15:06 +0800
From: Ren Qiaowei <qiaowei.ren@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] x86, mpx: add documentation on Intel MPX
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com> <1390727338-20487-2-git-send-email-qiaowei.ren@intel.com> <52E47BD1.4050105@infradead.org>
In-Reply-To: <52E47BD1.4050105@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2014 11:06 AM, Randy Dunlap wrote:
> On 01/26/2014 01:08 AM, Qiaowei Ren wrote:
>> This patch adds the Documentation/x86/intel_mpx.txt file with some
>> information about Intel MPX.
>>
>> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
>> ---
>>   Documentation/x86/intel_mpx.txt |  226 +++++++++++++++++++++++++++++++++++++++
>>   1 files changed, 226 insertions(+), 0 deletions(-)
>>   create mode 100644 Documentation/x86/intel_mpx.txt
>>
>> diff --git a/Documentation/x86/intel_mpx.txt b/Documentation/x86/intel_mpx.txt
>> new file mode 100644
>> index 0000000..052001c
>> --- /dev/null
>> +++ b/Documentation/x86/intel_mpx.txt
>> @@ -0,0 +1,226 @@
>> +1. Intel(R) MPX Overview
>> +========================
>> +
>> +
>> +Intel(R) Memory Protection Extensions (Intel(R) MPX) is a new
>> +capability introduced into Intel Architecture. Intel MPX provides
>> +hardware features that can be used in conjunction with compiler
>> +changes to check memory references, for those references whose
>> +compile-time normal intentions are usurped at runtime due to
>> +buffer overflow or underflow.
>> +
>> +Two of the most important goals of Intel MPX are to provide
>> +this capability at very low performance overhead for newly
>> +compiled code, and to provide compatibility mechanisms with
>> +legacy software components. MPX architecture is designed
>
>                                                     designed to
>
>> +allow a machine (i.e., the processor(s) and the OS software)
>> +to run both MPX enabled software and legacy software that
>> +is MPX unaware. In such a case, the legacy software does not
>> +benefit from MPX, but it also does not experience any change
>> +in functionality or reduction in performance.
>> +
>> +Intel(R) MPX Programming Model
>> +------------------------------
>> +
>> +Intel MPX introduces new registers and new instructions that
>> +operate on these registers. Some of the registers added are
>> +bounds registers which store a pointer's lower bound and upper
>> +bound limits. Whenever the pointer is used, the requested
>> +reference is checked against the pointer's associated bounds,
>> +thereby preventing out-of-bound memory access (such as buffer
>> +overflows and overruns). Out-of-bounds memory references
>> +initiate a #BR exception which can then be handled in an
>> +appropriate manner.
>> +
>> +Loading and Storing Bounds using Translation
>> +--------------------------------------------
>> +
>> +Intel MPX defines two instructions for load/store of the linear
>> +address of a pointer to a buffer, along with the bounds of the
>> +buffer into a paging structure of extended bounds. Specifically
>> +when storing extended bounds, the processor will perform address
>> +translation of the address where the pointer is stored to an
>> +address in the Bound Table (BT) to determine the store location
>> +of extended bounds. Loading of an extended bounds performs the
>> +reverse sequence.
>> +
>> +The structure in memory to load/store an extended bound is a
>> +4-tuple consisting of lower bound, upper bound, pointer value
>> +and a reserved field. Bound loads and stores access 32-bit or
>> +64-bit operand size according to the operation mode. Thus,
>> +a bound table entry is 4*32 bits in 32-bit mode and 4*64 bits
>> +in 64-bit mode.
>> +
>> +The linear address of a bound table is stored in a Bound
>> +Directory (BD) entry. And the linear address of the bound
>
>                           The linear address
>
>> +directory is derived from either BNDCFGU or BNDCFGS registers.
>> +Bounds in memory are stored in Bound Tables (BT) as an extended
>> +bound, which are accessed via Bound Directory (BD) and address
>> +translation performed by BNDLDX/BNDSTX instructions.
>> +
>> +Bounds Directory (BD) and Bounds Tables (BT) are stored in
>> +application memory and are allocated by the application (in case
>> +of kernel use, the structures will be in kernel memory). The
>> +bound directory and each instance of bound table are in contiguous
>> +linear memory.
>> +
>> +XSAVE/XRESTOR Support of Intel MPX State
>> +----------------------------------------
>> +
>> +Enabling Intel MPX requires an OS to manage two bits in XCR0:
>> +  - BNDREGS for saving and restoring registers BND0-BND3,
>> +  - BNDCSR for saving and restoring the user-mode configuration
>> +(BNDCFGU) and the status register (BNDSTATUS).
>> +
>> +The reason for having two separate bits is that BND0-BND3 is
>
>                                                               are
>
>> +likely to be volatile state, while BNDCFGU and BNDSTATUS are not.
>> +Therefore, an OS has flexibility in handling these two states
>> +differently in saving or restoring them.
>> +
>> +For details about the Intel MPX instructions, see "Intel(R)
>> +Architecture Instruction Set Extensions Programming Reference".
>> +
>> +
>> +2. How to get the advantage of MPX
>
> drop trailing space above.
>
>> +==================================
>> +
>> +
>> +To get the advantage of MPX, changes are required in
>> +the OS kernel, binutils, compiler, system libraries support.
>
>                                        and system libraries support.
>
>> +
>> +MPX support in the GNU toolchain
>> +--------------------------------
>> +
>> +This section describes changes in GNU Binutils, GCC and Glibc
>> +to support MPX.
>> +
>> +The first step of MPX support is to implement support for new
>> +hardware features in binutils and the GCC.
>> +
>> +The second step is implementation of MPX instrumentation pass
>> +in the GCC compiler which is responsible for instrumenting all
>> +memory accesses with pointer checks. Compiler changes for runtime
>> +bound checks include:
>> +
>> +  * Bounds creation for statically allocated objects, objects
>> +    allocated on the stack and statically initialized pointers.
>> +
>> +  * MPX support in ABI: ABI extension allows passing bounds for
>> +    the pointers passed as function arguments and provide returned
>
>                                                       provides
>
>> +    bounds with the pointers.
>> +
>> +  * Bounds table content management: each pointer is stored into
>
>                                                       that is stored into
>
>> +    the memory should have its bounds stored in the corresponding
>
> drop "the":
>         memory should
>
>
Ok. Thanks for your review.

Thanks,
Qiaowei
