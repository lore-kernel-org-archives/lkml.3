Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769Ab3LDQpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:45:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59157 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932508Ab3LDQpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:45:30 -0500
Message-ID: <529F5C02.2060706@zytor.com>
Date: Wed, 04 Dec 2013 08:44:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Regression due to 0c44c2d0f459 x86: Use asm goto to implement
 better modify_and_test() functions
References: <529E8719.4070202@zytor.com> <20131204085953.GC31778@gmail.com>
In-Reply-To: <20131204085953.GC31778@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2013 12:59 AM, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> Hi guys,
>>
>> 0c44c2d0f459 x86: Use asm goto to implement better modify_and_test()
>> functions
>>
>> causes a regression, because it incorrectly changed the constraints of
>> bitops.
>>
>> Specifically, the GEN_BINARY_RMWcc() hardcodes a constraint as "er", but
>> it needs to be "Ir" for the bitops themselves.  "I" is correct (as
>> opposed to "J" even on 64 bits, because we only generate the 64-bit
>> version when we have a register operand.
>>
>> Unfortunately there isn't a way we can get gcc+gas to generate a version
>> with an offset pointer.
> 
> Does the regression manifest itself in any actual breakage - if yes, 
> how does it look like? (People experiencing similar symptoms will be 
> helped by seeing a fix matching their problems.)
> 

It was discovered because it caused a build failure in a
not-yet-submitted driver patch.  This happens when someone uses
test_and_set_bit() or another similar operation on a fixed bit index
above 255; the assembler throws an error at that point and the build fails.

*HOWEVER*, for bit indicies in the range 32-255, the current code will
instead silently miscompile, as the CPU will truncate the argument to 5
bits.  I don't know if there are any such instances in the current
kernel, but it is entirely possible there is, with unknown but
potentially disastrous results.

	-hpa

