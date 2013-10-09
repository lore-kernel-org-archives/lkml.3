Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab3JIKjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 06:39:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:55527 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab3JIKjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 06:39:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1062,1371106800"; 
   d="scan'208";a="408201376"
Message-ID: <5255320C.9020009@intel.com>
Date: Wed, 09 Oct 2013 13:38:04 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V5 3/9] perf tools: workaround objdump difficulties with
 kcore
References: <1381221956-16699-1-git-send-email-adrian.hunter@intel.com> <1381221956-16699-4-git-send-email-adrian.hunter@intel.com> <20131008140236.GD1348@krava.redhat.com> <525506C5.3020101@intel.com> <20131009101249.GC1005@krava.redhat.com>
In-Reply-To: <20131009101249.GC1005@krava.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/13 13:12, Jiri Olsa wrote:
> On Wed, Oct 09, 2013 at 10:33:25AM +0300, Adrian Hunter wrote:
>> On 08/10/13 17:02, Jiri Olsa wrote:
>>> On Tue, Oct 08, 2013 at 11:45:50AM +0300, Adrian Hunter wrote:
>>>> objdump fails to annotate module symbols when looking
>>>> at kcore.  Workaround this by extracting object code
>>>> from kcore and putting it in a temporary file for
>>>> objdump to use instead.  The temporary file is created
>>>> to look like kcore but contains only the function
>>>> being disassembled.
>>>
>>> Excited to ses this one, but looks like I'm hitting some
>>> issue.  All annotation starts for me like this:
>>>
>>>                                                                                                        ▒
>>>        │              Disassembly of section load0:                                                            ▒
>>>        │                                                                                                       ▒
>>>        │              ffffffff815eee80 <load0>:                                                                ◆
>>>   9.33 │ffffffff815eee80:   data32 data32 data32 xchg %ax,%ax                                                  
>>>
>>>
>>> which does not seem right
>>
>> Can you tell me the commits of the kernel and perf tools you
>> were using, plus the commands and what symbol it was?
> 
> kernel: 3.9.10-100.fc17.x86_64
> perf:   latest acme's perf/core (06de626 perf evlist: Fix perf_evlist__mmap_read event overflow )
>         plus your V5 patches
> 
> commands:
>   sudo ./perf record -e cycles:k -a 
>   sudo ./perf report
> 
> ---
> Samples: 2K of event 'cycles:k', Event count (approx.): 445188286                                               
>  14.73%          swapper  [kernel.kallsyms]   [k] intel_idle                                                   ◆
>   3.19%                X  [kernel.kallsyms]   [k] smp_call_function_many                                       ▒
>   1.58%                X  [kernel.kallsyms]   [k] i915_gem_write_fence__ipi                                    ▒
>   1.58%          swapper  [kernel.kallsyms]   [k] iwl_trans_pcie_read32                                        ▒
> 
> 
> annotation of 1st 4 symbols:
> 
> ---
> intel_idle  /proc/kcore                                                                                         
>        │                                                                                                       ▒
>        │                                                                                                       ▒
>        │                                                                                                       ▒
>        │     Disassembly of section load0:                                                                     ▒
>        │                                                                                                       ▒
>        │     ffffffff8135f490 <load0>:                                                                         ▒
>   1.18 │       data32 data32 data32 xchg %ax,%ax                                                               ▒
> 
> 
> ---
> smp_call_function_many  /proc/kcore                                                                             
>        │                                                                                                       ◆
>        │                                                                                                       ▒
>        │                                                                                                       ▒
>        │     Disassembly of section load0:                                                                     ▒
>        │                                                                                                       ▒
>        │     ffffffff810bc270 <load0>:                                                                         ▒
>        │       data32 data32 data32 xchg %ax,%ax                                                               ▒
> 
> ---
> i915_gem_write_fence__ipi  /proc/kcore                                                                          
>        │
>        │
>        │
>        │    Disassembly of section load0:
>        │
>        │    ffffffffa0086630 <load0>:
>        │      data32 data32 data32 xchg %ax,%ax
> 
> ---
> iwl_trans_pcie_read32  /proc/kcore                                                                              
>        │
>        │
>        │
>        │    Disassembly of section load0:
>        │
>        │    ffffffffa0414a50 <load0>:
>        │      data32 data32 data32 xchg %ax,%ax
> 
> 
> the rest of the instruction decode differs.. just the first
> line is same for all
> 
> addresses seem ok:
> 
> [jolsa@krava perf]$ egrep 'ffffffff8135f490|ffffffff810bc270|ffffffffa0086630|ffffffffa0414a50' /proc/kallsyms 
> ffffffff810bc270 T smp_call_function_many
> ffffffff8135f490 t intel_idle
> ffffffffa0414a50 t iwl_trans_pcie_read32        [iwlwifi]
> ffffffffa0086630 t i915_gem_write_fence__ipi    [i915]
> 
> so.. the name of the section, name of the <function> plus the first
> instruction decode seem wrong.. I can see that in every symbol I
> annotate in the report and in annotate command as well.

If you use the --asm-raw option you can see the bytes:

	66 66 66 90 

That looks like a "nop" e.g. K8_NOP4 in arch/x86/include/asm/nops.h

	/*
	 * Define nops for use with alternative() and for tracing.
	 *
	 * *_NOP5_ATOMIC must be a single instruction.
	 */

	#define NOP_DS_PREFIX 0x3e

	/* generic versions from gas
	   1: nop
	   the following instructions are NOT nops in 64-bit mode,
	   for 64-bit mode use K8 or P6 nops instead
	   2: movl %esi,%esi
	   3: leal 0x00(%esi),%esi
	   4: leal 0x00(,%esi,1),%esi
	   6: leal 0x00000000(%esi),%esi
	   7: leal 0x00000000(,%esi,1),%esi
	*/
	#define GENERIC_NOP1 0x90
	#define GENERIC_NOP2 0x89,0xf6
	#define GENERIC_NOP3 0x8d,0x76,0x00
	#define GENERIC_NOP4 0x8d,0x74,0x26,0x00
	#define GENERIC_NOP5 GENERIC_NOP1,GENERIC_NOP4
	#define GENERIC_NOP6 0x8d,0xb6,0x00,0x00,0x00,0x00
	#define GENERIC_NOP7 0x8d,0xb4,0x26,0x00,0x00,0x00,0x00
	#define GENERIC_NOP8 GENERIC_NOP1,GENERIC_NOP7
	#define GENERIC_NOP5_ATOMIC NOP_DS_PREFIX,GENERIC_NOP4

	/* Opteron 64bit nops
	   1: nop
	   2: osp nop
	   3: osp osp nop
	   4: osp osp osp nop
	*/
	#define K8_NOP1 GENERIC_NOP1
	#define K8_NOP2 0x66,K8_NOP1
	#define K8_NOP3 0x66,K8_NOP2
	#define K8_NOP4 0x66,K8_NOP3
	#define K8_NOP5 K8_NOP3,K8_NOP2
	#define K8_NOP6 K8_NOP3,K8_NOP3
	#define K8_NOP7 K8_NOP4,K8_NOP3
	#define K8_NOP8 K8_NOP4,K8_NOP4
	#define K8_NOP5_ATOMIC 0x66,K8_NOP4

I think what you see is correct.

