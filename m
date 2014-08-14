Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbaHNV4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 17:56:13 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43095 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbaHNV4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 17:56:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140814205143.GY6758@twins.programming.kicks-ass.net>
References: <1408046230-16439-1-git-send-email-ashwin.chaugule@linaro.org>
	<20140814205143.GY6758@twins.programming.kicks-ass.net>
Date: Thu, 14 Aug 2014 17:56:10 -0400
Message-ID: <CAJ5Y-ebgJi8Ngxg1X+h7KMundGZPFhYC0hr0Sog6htj=czszgQ@mail.gmail.com>
Subject: Re: [RFC 0/3] Experimental patchset for CPPC
From: Ashwin Chaugule <ashwin.chaugule@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mike Turquette <mike.turquette@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>, arjan@linux.intel.com,
        mingo@kernel.org, len.brown@intel.com, rjw@rjwysocki.net,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-acpi@vger.kernel.org,
        cpufreq@vger.kernel.org, Patch Tracking <patches@linaro.org>,
        dirk.brandewie@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 14 August 2014 16:51, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Aug 14, 2014 at 03:57:07PM -0400, Ashwin Chaugule wrote:
>>
>>
>> What is CPPC:
>> =============
>>
>> CPPC is the new interface for CPU performance control between the OS and the
>> platform defined in ACPI 5.0+. The interface is built on an abstract
>> representation of CPU performance rather than raw frequency.  Basic operation
>> consists of:
>
> Why do we want this? Typically we've ignored ACPI and gone straight to
> MSR access, intel_pstate and intel_idle were created especially to avoid
> ACPI, so why return to it.
>
> Also, the whole interface sounds like trainwreck (one would not expect
> anything else from ACPI).
>
> So _why_?

The overall idea is that tying the notion of CPU performance to CPU
frequency is no longer true these days.[1]. So, using some direction
from an OS , the platforms want to be able to decide how to adjust CPU
performance by using knowledge that may be very platform specific.
e.g. through the use of performance counters, thermal budgets and
other system specific constraints. So, CPPC describes a way for the OS
to request performance within certain bounds and then letting the
platform optimize it within those constraints. Expressing CPU
performance in an abstract way, should also help keep things uniform
across various architecture implementations.

I dont see CPPC as necessarily an ACPI specific thing. If the platform
can provide the information which CPPC lays out via MSRs or other
system IO, then the higher algorithms should still work. The CPPC
table itself is nothing but register descriptions. It describes how
and where to access the registers. The registers can be anything, from
system I/O addresses, MSRs, CP15, or Mailbox type addresses(PCC). CPPC
doesn't even you tell what to do with that information. So its really
just a descriptor.

If you see the example in [2], the aperf and mperf reads directly go
to MSR addresses as parsed from the tables. If the platform does not
have ACPI, but knows how to provide the same information, then it can
directly read its MSRs or other sys regs. e.g. as in the case of
core_get_{min,max}_pstate(), which are used to get highest and lowest
performance values.

But I think the problem is that we dont have an algorithm that can
make use of the information that CPPC supported platforms can provide,
nor can we provide CPPC related information back to the platform.

Cheers,
Ashwin

[1]- https://plus.google.com/+ArjanvandeVen/posts/dLn9T4ehywL
[2] - http://git.linaro.org/people/ashwin.chaugule/leg-kernel.git/blob/236d901d31fb06fda798880c9ca09d65123c5dd9:/drivers/cpufreq/cppc_x86.c
