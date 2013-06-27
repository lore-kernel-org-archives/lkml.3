Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab3F0Mhl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:37:41 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:51642 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab3F0Mhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:37:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ_BOiBHZ=nXD+dHnbAwSexHkd=zfDWePK0WjEr=dvzmhu1bPw@mail.gmail.com>
References: <CAAfg0W5BoDLN_O9PwGTQC-0uFp+ZEgqAH2A9sSbbvOHsHutPkQ@mail.gmail.com>
	<CAJ_BOiBHZ=nXD+dHnbAwSexHkd=zfDWePK0WjEr=dvzmhu1bPw@mail.gmail.com>
Date: Thu, 27 Jun 2013 20:37:38 +0800
Message-ID: <CAAfg0W5fWu51QcD5gM66zoE_NQPPZhP+6GGuWRB=0MKTN0m-DQ@mail.gmail.com>
Subject: Re: 3.10-rc6 "perf test" seems unhappy
From: Andy Green <andy.green@linaro.org>
To: Prabhat Kumar Ravi <prabhatravi09@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 June 2013 21:39, Prabhat Kumar Ravi <prabhatravi09@gmail.com> wrote:
> Hi,
>
> On Wed, Jun 26, 2013 at 4:39 PM, Andy Green <andy.green@linaro.org> wrote:
>> Hi -
>>
>> Running perf test on 3.10-rc6 gives some unexpected behaviours.
>>
>> This is on a dual Cortex A9 board with perf userland cross-built from
>> same tree as the kernel.
>>
>> root@aa9-eb:~# perf test
>>  1: vmlinux symtab matches kallsyms                        : FAILED!
>
>> I started tracing the first failure... it stops because it can't find
>> "_stext" in /proc/kallsyms.  But it is there
>>
>> root@aa9-eb:~# cat /proc/kallsyms | grep _stext
>> 800081c0 T _stext
>>
>
>>
>> The others may be due to missing some config somewhere.
>>
>> Any ideas what I am (or perf is) doing wrong?
>>
>
> I Think your Perf test is failing at dso__find_symbol_by_name
> where in perf test we have something like:
>
>         kallsyms_map = machine__kernel_map(&kallsyms, type);
>
>         sym = map__find_symbol_by_name(kallsyms_map, ref_reloc_sym.name, NULL);
>         if (sym == NULL) {
>                 pr_debug("dso__find_symbol_by_name ");
>                 goto out;
>         }
>
> Here sym is search for "_stext" which is NULL here so perf test fails here only,

Hi Prabhat -

> Here _stext having same address as some other, like
>
> c00081c0 T asm_do_IRQ
> c00081c0 T _stext
> c00081c0 T __exception_text_start
>
> Function call is like this:
> machine__load_kallsyms
> --> dso__load_kallsyms
>     --> symbols__fixup_duplicate
>
> So, it getting deleted, I think we should disable symbols__fixup_duplicate.

That does indeed work around the first problem, thanks.

It succeeds to find _stext and then tries to load the vmlinux.

 1: vmlinux symtab matches kallsyms                        :trying
/root/.debug/.build-id/47/93c412145cb348574991bf4075995805175367
failed in symsrc__init
trying vmlinux
failed in symsrc__init
trying /boot/vmlinux
failed in symsrc__init
trying /boot/vmlinux-3.10.0-linaro_fjslt-tracking-bsp2.0.0-rc1+
failed in symsrc__init
trying /lib/modules/3.10.0-linaro_fjslt-tracking-bsp2.0.0-rc1+/build/vmlinux
failed in symsrc__init
trying /usr/lib/debug/lib/modules/3.10.0-linaro_fjslt-tracking-bsp2.0.0-rc1+/vmlinux
do_load_sym result 0
 Skip

Actually I put the correct vmlinux in the last place,
/usr/lib/debug/...  it's able to find it but do_load_sym is returning
0, which is taken as fail, because it's unable to confirm the vintage
of the vmlinux is correct for the running kernel.

As a side note I also copied ./lib, ./tools and ./include to the
target and built perf there.  The results are the same.

# perf test
 1: vmlinux symtab matches kallsyms                        :trying
/root/.debug/.build-id/47/93c412145cb348574991bf4075995805175367
failed in symsrc__init
trying vmlinux
failed in symsrc__init
trying /boot/vmlinux
failed in symsrc__init
trying /boot/vmlinux-3.10.0-linaro_fjslt-tracking-bsp2.0.0-rc1+
failed in symsrc__init
trying /lib/modules/3.10.0-linaro_fjslt-tracking-bsp2.0.0-rc1+/build/vmlinux
failed in symsrc__init
trying /usr/lib/debug/lib/modules/3.10.0-linaro_fjslt-tracking-bsp2.0.0-rc1+/vmlinux
do_load_sym result 0
 Skip
 2: detect open syscall event                              : Ok
 3: detect open syscall event on all cpus                  : Ok
 4: read samples using the mmap interface                  : Ok
 5: parse events tests                                     :  Warning:
function sizeof not defined
  Warning: function sizeof not defined
  Warning: function scsi_trace_parse_cdb not defined
  Warning: function scsi_trace_parse_cdb not defined
  Warning: function scsi_trace_parse_cdb not defined
  Warning: function scsi_trace_parse_cdb not defined
  Warning: function jiffies_to_msecs not defined
  Warning: function jiffies_to_msecs not defined
  Warning: bad op token {
  Warning: bad op token {
  Warning: bad op token {
  Warning: Error: expected type 4 but read 0
  Warning: bad op token {
  Warning: Error: expected type 4 but read 0
  Warning: bad op token {
  Warning: bad op token {
  Warning: bad op token {
  Warning: bad op token {
  Warning: bad op token {
  Warning: unknown op '{'
  Warning: unknown op '{'
 Ok
 6: Validate PERF_RECORD_* events & perf_sample fields     : FAILED!
 7: Test perf pmu format parsing                           : Ok
 8: Test dso data interface                                : Ok
 9: roundtrip evsel->name check                            : Ok
10: Check parsing of sched tracepoints fields              : FAILED!
11: Generate and check syscalls:sys_enter_open event fields: Ok
12: struct perf_event_attr setup                           : (omitted) Ok
13: Test matching and linking mutliple hists               : Ok
14: Try 'use perf' in python, checking link problems       : FAILED!
15: Test breakpoint overflow signal handler                : FAILED!
16: Test breakpoint overflow sampling                      : FAILED!
17: Test number of exit event of a simple workload         : FAILED!
18: Test software clock events have valid period values    : Ok

-Andy
