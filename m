Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233Ab3GZOyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 10:54:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:1637 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757566Ab3GZOx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 10:53:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,752,1367996400"; 
   d="scan'208";a="352226784"
Message-ID: <51F28F05.50807@linux.intel.com>
Date: Fri, 26 Jul 2013 08:00:21 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ilia Mirkin <imirkin@alum.mit.edu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: 3.11-rc2: panic in __rdmsr_on_cpu
References: <CAKb7UvjQYeQjGsw4U_OrBuioF7KdVrBgCNmx5xi3aPXkPsTzaA@mail.gmail.com> <CAKb7Uvh+3BXkBjNkbfAQ=ginaoKyJj3+hNKL+WJ0XknAaZd==g@mail.gmail.com> <CAKb7UvjYNz8KRnny8EB6rxQcLPrp0Y8CWHZaVG0qzAJisC8dog@mail.gmail.com>
In-Reply-To: <CAKb7UvjYNz8KRnny8EB6rxQcLPrp0Y8CWHZaVG0qzAJisC8dog@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is already fixed and it is in Linus main line. Check commit id 
"f3ed0a17f0292300b3caca32d823ecd32554a667"


Thanks for analysis and you are correct.

Thanks,
Srinivas

On 07/26/2013 06:15 AM, Ilia Mirkin wrote:
> On Fri, Jul 26, 2013 at 7:59 AM, Ilia Mirkin <imirkin@alum.mit.edu> wrote:
>> On Thu, Jul 25, 2013 at 6:32 PM, Ilia Mirkin <imirkin@alum.mit.edu> wrote:
>>> Hi,
>>>
>>> I just built a 3.11-rc2 kernel (+ a few patches, but nothing
>>> arch-related), and I saw the following: http://i.imgur.com/dCTqOyR.jpg
>>>
>>> The rough transcription is
>>>
>>> Call Trace:
>>> <IRQ>
>>> generic_smp_call_fucntion_single_interrupt
>>> smp_call_function_single_interrupt
>>> call_function_single_interrupt
>>> <EOI>
>>> ? default_idle
>>> ? default_idle
>>> arch_cpu_idle
>>> cpu_startup_entry
>>> rest_init
>>> start_kernel
>>> ? repair_env_string
>>> x86_64_start_reservations
>>> x86_64_start_kernel
>>> Code: ... cc 81 8b 0f <0f> 32 48 c1 e2 20 89 c0 ...
>>> RIP: __rdmsr_on_cpu+0x2e/0x44
>>> Kernel panic - not syncing: Fatal exception in interrupt
>>>
>>> A 3.10-rc7 kernel booted just fine. Is this likely a real issue? Or
>>> perhaps a mis-build of some sort?
>> FWIW this is repeatable. I did a clean build (make clean && make) and
>> I still see the same thing. I have a Core i7-920 cpu, not sure what
>> other information would be relevant. I'd love to avoid a bisect, so
>> some likely candidates would be most welcome.
> Aha, figured it out. I had enabled "X86 package temperature thermal
> driver" = Y, which caused my Core i7-920 to produce the above trace on
> boot. Glancing over the code, should this:
>
>                  if (!cpu_has(c, X86_FEATURE_DTHERM) &&
>                                          !cpu_has(c, X86_FEATURE_PTS))
>                          return -ENODEV;
>
> perhaps be
>
>                  if (!cpu_has(c, X86_FEATURE_DTHERM) ||
>                                          !cpu_has(c, X86_FEATURE_PTS))
>                          return -ENODEV;
>
> i.e. are both of those things required, or just one of them? My cpu
> has DTHERM but not PTS, according to /proc/cpuinfo.
>
>    -ilia
>

