Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbaIIFgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 01:36:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbaIIFf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 01:35:59 -0400
Message-ID: <540E9175.1070807@redhat.com>
Date: Tue, 09 Sep 2014 01:34:45 -0400
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>
CC: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 09/17] ARM64 / ACPI: Parse MADT for SMP initialization
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org> <1409583475-6978-10-git-send-email-hanjun.guo@linaro.org> <20140903172138.GG1824@e102568-lin.cambridge.arm.com> <5408854B.9010703@linaro.org> <540E8212.8090304@redhat.com> <540E8C1F.5060802@linaro.org>
In-Reply-To: <540E8C1F.5060802@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 01:11 AM, Hanjun Guo wrote:
> On 2014年09月09日 12:29, Jon Masters wrote:
>> Hi Hanjun, Lorenzo,
> 
> Hi Jon,
> 
>>
>> Resending due to my mail client removing list CCs...sorry about that.
>>
>> On 09/04/2014 11:29 AM, Hanjun Guo wrote:
>>
>>>>> +	} else {
>>>>> +		/* Fist GICC entry must be BSP as ACPI spec said */
>>>> s/Fist/First/
>>>>
>>>>> +		if  (cpu_logical_map(0) != mpidr) {
>>>>> +			pr_err("First GICC entry is not BSP for MPIDR 0x%llx\n",
>>>>> +			       mpidr);
>>>>> +			return -EINVAL;
>>>>> +		}
>>>> Interesting, this means that if I want to change the boot CPU I have to
>>>> recompile the ACPI tables. Is that really true ?
>> Well, the ACPI5.1 specification does require that the PEs (cores) be
>> listed in a very specific order, with the boot CPU first, and then a
>> precisely defined sequence of interleaving of any possible SMT threads
>> with other cores. So I think you would in practice update your tables.
> 
> Thanks for the clarify.

No problem :) I'm trying to go through the various threads and ensure
various things are documented in the record. I'm skipping (for now)
notes on e.g. CPU cache flush behavior because we're not pushing for C3
support (or really any runtime power management) in the first round.

>>
>>>>> +	/*
>>>>> +	 * ACPI 5.1 only has two explicit methods to boot up SMP,
>>>>> +	 * PSCI and Parking protocol, but the Parking protocol is
>>>>> +	 * only specified for ARMv7 now, so make PSCI as the only
>>>>> +	 * way for the SMP boot protocol before some updates for
>>>>> +	 * the ACPI spec or the Parking protocol spec.
>>>>> +	 */
>> The Parking Protocol may be updated for a (limited) number of platforms
>> that may use it in the early days. The preferred option (as described in
>> the SBBR) is to use PSCI when at all possible. Some implementations of
>> the architecture may not be able to use PSCI for MP-Boot. Thus while
>> there may be some limited early use of the parking protocol (including
>> while PSCI firmware is being finalized during bringup activities), it
>> will ultimately be completely replaced by PSCI based boot over time.
> 
> Thank you for the clarify again :)
> 
> Will Parking Protocol be upstreamed?

Yes, a version against v8 will be posted (perhaps in the next few days),
but we should not wait for it in this general discussion. The default in
v8 will be PSCI other than for early bringup, or for an architecture
implementation that cannot use PSCI, which is rare.

(When we wrote the SBBR we had many discussions about this. A goal is to
be fair to everyone - those rare instances where PSCI is not possible
must be covered by a specification, but there must be a strong
preference established for a preferred course over the longer term)

> If yes, I think we can update the
> comments when Parking Protocol driver upstreamed.

Indeed so. For the moment, the logic you have in your patch to fail
setup in the case that there is no defined PSCI cpu ops for the
associated processor is fine IMHO.

Jon.

