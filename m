Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaA3JT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 04:19:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:46306 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbaA3JTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 04:19:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,748,1384329600"; 
   d="scan'208";a="446921295"
Message-ID: <52EA1988.9050100@intel.com>
Date: Thu, 30 Jan 2014 11:21:12 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 1/9] perf tools: Fix symbol annotation for relocated
 kernel
References: <1391004884-10334-1-git-send-email-adrian.hunter@intel.com> <1391004884-10334-2-git-send-email-adrian.hunter@intel.com> <20140129185747.GE3998@ghostprotocols.net> <52E9FD31.108@intel.com> <20140130085940.GA2643@gmail.com>
In-Reply-To: <20140130085940.GA2643@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/01/14 10:59, Ingo Molnar wrote:
> 
> * Adrian Hunter <adrian.hunter@intel.com> wrote:
> 
>> On 29/01/14 20:57, Arnaldo Carvalho de Melo wrote:
>>> Em Wed, Jan 29, 2014 at 04:14:36PM +0200, Adrian Hunter escreveu:
>>>> Kernel maps map memory addresses to file offsets.
>>>> For symbol annotation, objdump needs the object VMA
>>>> addresses.  For an unrelocated kernel, that is the
>>>> same as the memory address.
>>>>
>>>> The addresses passed to objdump for symbol annotation
>>>> did not take into account kernel relocation.  This
>>>> patch fixes that.
>>>
>>> Question: To fix the problem reported by Linus, i.e. the very minimal
>>> fix, we only need this patch, right?
>>
>> Yes but the other fixes are needed too.
> 
> So, for the specific case of kernel address layout randomization, how 
> does this fix Linus's bug with KASLR enabled? How does the code 
> recover the random, runtime offset of the relocated kernel, which 
> varies from boot to boot?

By comparing the address of a symbol ("_text" or "_stext")
in /proc/kallsyms (or perf.data - see below) with the same
symbol in vmlinux.

perf tools call this the ref_reloc_sym and stores it in
perf.data hidden in the synthesized kernel mmap record.
e.g.

0xd8 [0x50]: event: 1
.
. ... raw event: size 80 bytes
.  0000:  01 00 00 00 01 00 50 00 ff ff ff ff 00 00 00 00  ......P.........
.  0010:  00 00 00 17 00 00 00 00 ff ff ff a8 ff ff ff ff  ................
.  0020:  c8 01 00 98 ff ff ff ff 5b 6b 65 72 6e 65 6c 2e  ........[kernel.
.  0030:  6b 61 6c 6c 73 79 6d 73 5d 5f 73 74 65 78 74 00  kallsyms]_stext.
.  0040:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
.
0 0xd8 [0x50]: PERF_RECORD_MMAP -1/0: [0x17000000(0xffffffffa8ffffff) @ 0xffffffff980001c8]: x [kernel.kallsyms]_stext

That tells perf tools that _stext was 0xffffffff980001c8.
Compare to vmlinux:

$ objdump -t vmlinux | grep _stext
ffffffff810001c8 g       .text	0000000000000000 _stext

So the relocation is 0xffffffff980001c8 - 0xffffffff810001c8
= 0x17000000


