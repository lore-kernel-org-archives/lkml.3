Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab3KNLYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 06:24:55 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:44347 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab3KNLYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 06:24:52 -0500
MIME-Version: 1.0
In-Reply-To: <CAORVsuUi+C=2pX1YuQY=yirqb5a8oQwzOfWzx85rdzbspd596Q@mail.gmail.com>
References: <1382108078-8807-1-git-send-email-jean.pihet@linaro.org>
	<CA+b37P0YCPm+4PWJobTOv02M0-mZyf4w02fDrBVYT0wfPL_hpA@mail.gmail.com>
	<CAORVsuUi+C=2pX1YuQY=yirqb5a8oQwzOfWzx85rdzbspd596Q@mail.gmail.com>
Date: Thu, 14 Nov 2013 16:54:50 +0530
Message-ID: <CA+b37P0O+Do3JkM22aSDjuCZb73YtbOyUsqGhHtyuFQQSXVkJQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] ARM64: perf: add support for the perf registers and
 dwarf unwinding
From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
To: Jean Pihet <jean.pihet@newoldbits.com>
Cc: Jean Pihet <jean.pihet@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Jiri Olsa <jolsa@redhat.com>, Arnaldo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 November 2013 16:45, Jean Pihet <jean.pihet@newoldbits.com> wrote:
> Hi Sandeepa,
>
> On Thu, Nov 14, 2013 at 12:04 PM, Sandeepa Prabhu
> <sandeepa.prabhu@linaro.org> wrote:
>> Hi Jean,
>>
>> I have applied this patchset on aarch64 upstream branch,cross-compiled
>> for arm64 and try running some tests for hardware breakpoints.
>>
>> I cross-compiled perf using linaro toolchain
>> "gcc-linaro-aarch64-linux-gnu-4.7-2013.04-20130415_linux" as
>>  $ cd tools/perf/
>>  $ make LDFLAGS=-static ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-
>>
>> Copied the static binary to my initrd image and tried running tests to
>> place hw_breakpoint on an kernel symbol as:
>>
>>  # perf record -e "mem:0xffffffc00013f640:x"
>> 737
>> 738  usage: perf record [<options>] [<command>]
>> 739     or: perf record [<options>] -- <command> [<options>]
>> 740
>> 741     -e, --event <event>   event selector. use 'perf list' to list
>> available events
>> 742         --filter <filter>
>> 743                           event filter
>> 744     -p, --pid <pid>       record events on existing process id
>> .....
>>
>> Somehow perf is not able run record, seems not accepting any
>> arguments. Do you have any idea what could be going wrong?
> Is the behavior caused by this very patch set? This patch set is about
> callchain unwinding, which is unrelated to the hardward breakpoint
> feature.
> Is perf list reporting something? Can you check the '-e mem' command
> correctness?
>
>> How did you
>> verify/cross-compile perf? Is the tool-chain version wrong?
> Since perf depends on external libraries it is not straight forward to
> cross compile it. You can compile it as part of a build system (for
> example an OE based build system), or compile it natively on the
> target.
> I am compiling perf and the libraries (libunwind) natively in my case.
Hmm, looks like cross-compiling is not good option.
>
>>
>> Thanks,
>> Sandeepa
>
> Please let me know how it goes.
>
> Jean
I tried this and workig:
 # ./perf record -- /bin/ls

214 ^[[1;34mbin^[[0m                   ^[[0;0mkprobe_dbg_addr.ko^[[0m
  ^[[1;34mroot^[[0m
215 ^[[1;34mdata^[[0m                  ^[[0;0mkprobe_dbg_sym.ko^[[0m
  ^[[1;34msdcard^[[0m
216 ^[[0;0mdata_breakpoint.ko^[[0m    ^[[0;0mkprobe_example.ko^[[0m
 ^[[1;34msys^[[0m
217 ^[[1;36mdebug^[[0m
^[[0;0mkretprobe_example.ko^[[0m  ^[[1;34msystem^[[0m
218 ^[[1;34mdev^[[0m                   ^[[1;32mperf^[[0m
   ^[[0;0mtext_breakpoint.ko^[[0m
219 ^[[1;34mhome^[[0m                  ^[[0;0mperf.data^[[0m
  ^[[1;34mtmp^[[0m
220 ^[[1;32minit^[[0m                  ^[[0;0mperf.data.old^[[0m
221 ^[[0;0mjprobe_example.ko^[[0m     ^[[1;34mproc^[[0m
222 [ perf record: Woken up 1 times to write data ]
223 [ perf record: Captured and wrote 0.002 MB perf.data (~104 samples) ]
224 / #

Also perf list shows "mem" option and checked the command format also
correct. [perf record -e "mem:0xffffffc00013f640:x"]
In fact none of the options under -e are functioning.

[I had tried without your patchset and behavior was same]

>
>>
>> On 18 October 2013 20:24, Jean Pihet <jean.pihet@linaro.org> wrote:
>>> From: Jean Pihet <jean.pihet@newoldbits.com>
>>>
>>> This patch implements the functions required for the perf registers API,
>>> allowing the perf tool to interface kernel register dumps with libunwind
>>> in order to provide userspace backtracing.
>>> Only the general purpose user space registers are exported, i.e.:
>>>  PERF_REG_ARM_X0,
>>>  ...
>>>  PERF_REG_ARM_X28,
>>>  PERF_REG_ARM_FP,
>>>  PERF_REG_ARM_LR,
>>>  PERF_REG_ARM_SP,
>>>  PERF_REG_ARM_PC
>>> and not the PERF_REG_ARM_V* registers.
>>>
>>> Dependencies:
>>>  . if present, libunwind >= 1.1 is needed to prevent a segfault when
>>>    parsing the dwarf info,
>>>  . libunwind needs to be configured with --enable-debug-frame. Note:
>>>    --enable-debug-frame is automatically selected on ARM, NOT on ARM64.
>>>
>>> The generated perf binary has been tested on ARMv8 (using the
>>> foundation model simulator) and x86_64, using the following commands:
>>>  perf record -g [fp,dwarf] -- <binary>
>>>  perf report --sort symbol --call-graph --stdio
>>>
>>>
>>> Jean Pihet (2):
>>>   ARM64: perf: add support for perf registers API
>>>   ARM64: perf: wire up perf_regs and unwind support
>>>
>>>  arch/arm64/Kconfig                        |  2 +
>>>  arch/arm64/include/uapi/asm/Kbuild        |  1 +
>>>  arch/arm64/include/uapi/asm/perf_regs.h   | 40 ++++++++++++++
>>>  arch/arm64/kernel/Makefile                |  1 +
>>>  arch/arm64/kernel/perf_regs.c             | 29 ++++++++++
>>>  tools/perf/arch/arm64/Makefile            |  7 +++
>>>  tools/perf/arch/arm64/include/perf_regs.h | 88 +++++++++++++++++++++++++++++++
>>>  tools/perf/arch/arm64/util/dwarf-regs.c   | 81 ++++++++++++++++++++++++++++
>>>  tools/perf/arch/arm64/util/unwind.c       | 82 ++++++++++++++++++++++++++++
>>>  tools/perf/config/Makefile                |  6 +++
>>>  10 files changed, 337 insertions(+)
>>>  create mode 100644 arch/arm64/include/uapi/asm/perf_regs.h
>>>  create mode 100644 arch/arm64/kernel/perf_regs.c
>>>  create mode 100644 tools/perf/arch/arm64/Makefile
>>>  create mode 100644 tools/perf/arch/arm64/include/perf_regs.h
>>>  create mode 100644 tools/perf/arch/arm64/util/dwarf-regs.c
>>>  create mode 100644 tools/perf/arch/arm64/util/unwind.c
>>>
>>> --
>>> 1.7.11.7
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
