Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbaFPJcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:32:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:47752 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816AbaFPJcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:32:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,485,1400050800"; 
   d="scan'208";a="529122349"
Message-ID: <539EB974.9030904@intel.com>
Date: Mon, 16 Jun 2014 12:31:32 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>, Simon Que <sque@chromium.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>,
        Sonny Rao <sonnyrao@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Get kernel start address by symbol name
References: <1402685121-32267-1-git-send-email-sque@chromium.org> <20140616080649.GB1148@krava.brq.redhat.com> <20140616080950.GA4632@krava.brq.redhat.com>
In-Reply-To: <20140616080950.GA4632@krava.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2014 11:09 AM, Jiri Olsa wrote:
> On Mon, Jun 16, 2014 at 10:06:49AM +0200, Jiri Olsa wrote:
>> On Fri, Jun 13, 2014 at 11:45:21AM -0700, Simon Que wrote:
>>> The function machine__get_kernel_start_addr() was taking the first symbol
>>> of kallsyms as the start address. This is incorrect in certain cases
>>> where the first symbol is something at 0, while the actual kernel
>>> functions begin at a later point (e.g. 0x80200000).
>>>
>>> This patch fixes machine__get_kernel_start_addr() to search for the
>>> symbol "_text" or "_stext", which marks the beginning of kernel mapping.
>>> This was already being done in machine__create_kernel_maps(). Thus, this
>>> patch is just a refactor, to move that code into
>>> machine__get_kernel_start_addr().
>>>
>>> Change-Id: I0c38c36f5e8b0f4fb92a6f57211fa45aabe545a6
>>> Signed-off-by: Simon Que <sque@chromium.org>
>>
>> hi,
>> looks good to me, adding Adrian to the loop

Yes, it looks fine except for the stuff below.

> 
> well, apart from this compile error ;-)
> 
> [jolsa@krava perf]$ make
>   BUILD:   Doing 'make -j4' parallel build
>   CC       util/machine.o
>   SUBDIR   /home/jolsa/kernel.org/linux-perf/tools/lib/traceevent/
> util/machine.c: In function ‘machine__get_kernel_start_addr’:
> util/machine.c:520:6: error: ‘addr’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
>   u64 addr;
>       ^
> util/machine.c: In function ‘machine__process_kernel_mmap_event’:
> util/machine.c:547:42: error: ‘addr’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
>    machine->vmlinux_maps[type] = map__new2(start, kernel, type);
>                                           ^
> util/machine.c:520:6: note: ‘addr’ was declared here
>   u64 addr;
>       ^
> cc1: all warnings being treated as errors
> make[1]: *** [util/machine.o] Error 1
> make: *** [all] Error 2
> 

There are checkpatch errors too:

ERROR: Remove Gerrit Change-Id's before submitting upstream.
#17:
Change-Id: I0c38c36f5e8b0f4fb92a6f57211fa45aabe545a6

ERROR: "foo** bar" should be "foo **bar"
#59: FILE: tools/perf/util/machine.c:515:
+                                         const char** symbol_name)

ERROR: "foo* bar" should be "foo *bar"
#64: FILE: tools/perf/util/machine.c:519:
+       const char* name;

total: 3 errors, 0 warnings, 0 checks, 90 lines checked


