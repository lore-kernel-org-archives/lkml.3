Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965497AbaFTIKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 04:10:42 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:62341 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbaFTIKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 04:10:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140618125355.GA2186@arm.com>
References: <CAFrcx1n-cPXm=w+84gQiUjZoFKi7gYnvJ0BQ+8yXKS=k3nEt3g@mail.gmail.com>
	<1403025065-18001-1-git-send-email-jean.pihet@linaro.org>
	<20140618125355.GA2186@arm.com>
Date: Fri, 20 Jun 2014 10:10:35 +0200
Message-ID: <CAFrcx1mA7kXiG9wMQqn=zYPYqrpGxDYWfoMP97RvkkrMTvNoRw@mail.gmail.com>
Subject: Re: [PATCH] ARM: perf: allow tracing with kernel tracepoints events
From: Jean Pihet <jean.pihet@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Sneha Priya <sneha.cse@hotmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On 18 June 2014 14:53, Will Deacon <will.deacon@arm.com> wrote:
> Hi Jean,
>
> On Tue, Jun 17, 2014 at 06:11:05PM +0100, Jean Pihet wrote:
>> When tracing with tracepoints events the IP and CPSR are set to 0,
>> preventing the perf code to resolve the symbols:
>>
>> ./perf record -e kmem:kmalloc cal
>> [ perf record: Woken up 1 times to write data ]
>> [ perf record: Captured and wrote 0.007 MB perf.data (~321 samples) ]
>>
>> ./perf report
>> Overhead Command Shared Object Symbol
>> ........ ....... ............. ...........
>> 40.78%   cal     [unknown]     [.]00000000
>> 31.6%    cal     [unknown]     [.]00000000
>>
>> The examination of the gathered samples (perf report -D) shows the IP
>> is set to 0 and that the samples are considered as user space samples,
>> while the IP should be set from the registers and the samples should be
>> considered as kernel samples.
>>
>> The fix is to implement perf_arch_fetch_caller_regs for ARM, which
>> fills the necessary registers used for the callchain unwinding and
>> to determine the user/kernel space property of the samples: ip, sp, fp
>> and cpsr.
>
> Surely its only the CPSR that identifies whether it's user or kernel?
Yes, user_mode() is used to determine the user/kernel property of the
samples. user_mode is defined as (((regs)->ARM_cpsr & 0xf) == 0) in
ptrace.h.

>
>> Tested with perf record and tracepoints filtering (-e <tracepoint>), with
>> unwinding using fp (--call-graph fp) and dwarf info (--call-graph dwarf).
>
> Whilst the old ACPS unwinding only needs PC, FP and SP, is this definitely
> true for exidx and DWARF-based unwinding? Given that libunwind ends up
> running a state machine for the latter, can we guarantee that we won't hit
> instructions that require access to other general purpose registers?
Yes. dwarf unwinding does not need anything extra. Once seeded all the
rest is extracted from the dwarf trace info.

I am currently stress testing the change, let me come back to you with
the results.

Thx,
Jean

>
> Will
