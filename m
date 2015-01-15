Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbbAOORK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 09:17:10 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:48836 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbbAOORI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 09:17:08 -0500
Message-ID: <54B7CBDE.9040207@linux.vnet.ibm.com>
Date: Thu, 15 Jan 2015 15:17:02 +0100
From: Laurent Dufour <ldufour@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>
CC: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, paulus@samba.org
Subject: Re: [PATCH] pseries/le: Fix endiannes issue in RTAS call from xmon
References: <1416838073-16642-1-git-send-email-ldufour@linux.vnet.ibm.com> <1421295950.11409.3.camel@ellerman.id.au>
In-Reply-To: <1421295950.11409.3.camel@ellerman.id.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011514-0021-0000-0000-0000028EB10F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/01/2015 05:25, Michael Ellerman wrote:
> On Mon, 2014-11-24 at 15:07 +0100, Laurent Dufour wrote:
>> On pseries system (LPAR) xmon failed to enter when running in LE mode, system
>> is hunging. Inititating xmon will lead to such an output on the console:
>>
>> SysRq : Entering xmon
>> cpu 0x15: Vector: 0  at [c0000003f39ffb10]
>>     pc: c00000000007ed7c: sysrq_handle_xmon+0x5c/0x70
>>     lr: c00000000007ed7c: sysrq_handle_xmon+0x5c/0x70
>>     sp: c0000003f39ffc70
>>    msr: 8000000000009033
>>   current = 0xc0000003fafa7180
>>   paca    = 0xc000000007d75e80	 softe: 0	 irq_happened: 0x01
>>     pid   = 14617, comm = bash
>> Bad kernel stack pointer fafb4b0 at eca7cc4
>> cpu 0x15: Vector: 300 (Data Access) at [c000000007f07d40]
>>     pc: 000000000eca7cc4
>>     lr: 000000000eca7c44
>>     sp: fafb4b0
>>    msr: 8000000000001000
>>    dar: 10000000
>>  dsisr: 42000000
>>   current = 0xc0000003fafa7180
>>   paca    = 0xc000000007d75e80	 softe: 0	 irq_happened: 0x01
>>     pid   = 14617, comm = bash
>> cpu 0x15: Exception 300 (Data Access) in xmon, returning to main loop
>> xmon: WARNING: bad recursive fault on cpu 0x15
>>
>> The root cause is that xmon is calling RTAS to turn off the surveillance
>> when entering xmon, and RTAS is requiring big endian parameters.
>>
>> This patch is byte swapping the RTAS arguments when running in LE mode.
>>
>> Signed-off-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
>> ---
>>  arch/powerpc/xmon/xmon.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
>> index b988b5addf86..c8efbb37d6e0 100644
>> --- a/arch/powerpc/xmon/xmon.c
>> +++ b/arch/powerpc/xmon/xmon.c
>> @@ -293,10 +293,10 @@ static inline void disable_surveillance(void)
>>  	args.token = rtas_token("set-indicator");
>>  	if (args.token == RTAS_UNKNOWN_SERVICE)
>>  		return;
> 
> I just noticed we're not handling the token correctly here. It is be32 also.

Ouch, my mistake :(

I will drop a new patch to complete this one.

Cheers.

> cheers
> 
> 

