Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab3HUHej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 03:34:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35732 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab3HUHeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 03:34:37 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130821072940.GB27495@gmail.com>
References: <1377049949.18357.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC> <20130821072940.GB27495@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] reboot: perform warm/cold reset correctly for CF9 type
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 21 Aug 2013 09:33:23 +0200
To: Ingo Molnar <mingo@kernel.org>, Li Fei <fei.li@intel.com>
CC: mingo@redhat.com, tglx@linutronix.de, chuansheng.liu@intel.com,
        x86@kernel.org, akpm@linux-foundation.org, holt@sgi.com,
        rmk+kernel@arm.linux.org.uk, linux-kernel@vger.kernel.org
Message-ID: <69b80c44-3245-4393-b6e9-4d8a7f3d3c66@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Careful.  This is a very different definition of warm vs cold boot used elsewhere.

Ingo Molnar <mingo@kernel.org> wrote:
>
>* Li Fei <fei.li@intel.com> wrote:
>
>> In current implementation for reboot type CF9 and CF9_COND,
>> warm and cold reset are not differentiated, and both are
>> performed by writing 0x06 to port 0xCF9 as warm reset. It's not
>> correct.
>> 
>> This commit will differentiate warm and cold reset, and perform
>> them correctly as below:
>> For warm reset, write 0x06 to port 0xCF9;
>> For cold reset, write 0x0E to port 0xCF9.
>> 
>> From: Liu Chuansheng <chuansheng.liu@intel.com>
>> Signed-off-by: Li Fei <fei.li@intel.com>
>> ---
>>  arch/x86/kernel/reboot.c |    9 +++++++--
>>  1 files changed, 7 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
>> index 563ed91..6e06299 100644
>> --- a/arch/x86/kernel/reboot.c
>> +++ b/arch/x86/kernel/reboot.c
>> @@ -511,10 +511,15 @@ static void
>native_machine_emergency_restart(void)
>>  
>>  		case BOOT_CF9_COND:
>>  			if (port_cf9_safe) {
>> -				u8 cf9 = inb(0xcf9) & ~6;
>> +				u8 cf9 = inb(0xcf9) &
>> +						~(reboot_mode == REBOOT_WARM ?
>> +						0x06 : 0x0E);
>>  				outb(cf9|2, 0xcf9); /* Request hard reset */
>>  				udelay(50);
>> -				outb(cf9|6, 0xcf9); /* Actually do the reset */
>> +				/* Actually do the reset */
>> +				outb(cf9|(reboot_mode == REBOOT_WARM ?
>> +					0x06 : 0x0E),
>> +					0xcf9);
>>  				udelay(50);
>
>Looks good, but please introduce a reboot_val intermediate 
>variable instead of duplicating that ugly line-broken 
>construct twice.
>
>Thanks,
>
>	Ingo

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
