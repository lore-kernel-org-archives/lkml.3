Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab3BBJo0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 04:44:26 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:58388 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab3BBJoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 04:44:23 -0500
Message-ID: <510CDFF1.80408@linaro.org>
Date: Sat, 02 Feb 2013 10:44:17 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>
Subject: Re: [PATCH 1/4] intel_idle: stop using driver_data for static flags
References: <1359691896-23567-1-git-send-email-lenb@kernel.org> <9a38405338d7464c852c4524465f84f8a2ac22fb.1359691799.git.len.brown@intel.com> <510B8059.5040609@linaro.org> <510C0C22.4000801@kernel.org> <510C3EC5.3060709@linaro.org> <510C7708.4080707@kernel.org>
In-Reply-To: <510C7708.4080707@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2013 03:16 AM, Len Brown wrote:
> 
>>> intel_idle already uses a driver-specific flag:
>>>
>>> #define CPUIDLE_FLAG_TLB_FLUSHED        0x10000
>>>
>>> This patch just uses 4 more bits along with that one.
>>
>> Ok. In this case it would make sense to move this flag out of the
>> generic core code to the intel_idle.c file ?
> 
> This flag is already local to intel_idle.c.
> If another architecture finds it useful,
> then yes, it would make sense to move it to the shared header.

Oh, right. Sorry I puzzled myself with the name. I was convinced it was
in the shared header.

>> and move the [dec/en]coding
>> macro flags_2_MWAIT_EAX and MWAIT_EAX_2_flags (with a more appropriate
>> name for a generic code) to the cpuidle.h file ?
> 
> I think that a driver's private flag definitions
> should remain local to the driver.  It makes no sense
> to pollute the name space of other drivers for stuff
> that doesn't mean anything to them.  MWAIT is pretty
> specific to x86 -- and re-naming it to something 'generic'
> isn't going to make the code easier to read.

Ok, let me rephrase it because I think how it was presented was not clear.

As we want to use the half of the state flags for private purpose, I
suggested to add the encoding/decoding function in the shared header file.

The mwait eax flags are not encoded and the CPUIDLE_FLAG_TLB_FLUSHED is
encoded.

I suggested to unify both and to use an encoding function from the
shared header file.

#define CPUIDLE_PRIVATE_FLAGS(_flags_) \
	((_flags_) << 16) & CPUIDLE_DRIVER_FLAGS_MASK

For example:

#define FLAG_TLB_FLUSHED CPUIDLE_PRIVATE_FLAGS(0x1)
#define FLAG_MWAIT_C1    CPUIDLE_PRIVATE_FLAGS(0x0)
#define FLAG_MWAIT_C2    CPUIDLE_PRIVATE_FLAGS(0x10)
#define FLAG_MWAIT_C3    CPUIDLE_PRIVATE_FLAGS(0x20)
#define FLAG_MWAIT_C4    CPUIDLE_PRIVATE_FLAGS(0x30)
#define FLAG_MWAIT_C5    CPUIDLE_PRIVATE_FLAGS(0x40)
#define FLAG_MWAIT_C6    CPUIDLE_PRIVATE_FLAGS(0x52)

And then:

...

.flags = FLAG_TLB_FLUSHED | FLAG_MWAIT_C2 | CPUIDLE_FLAG_TIME_VALID

...

But in the idle function, you need to retrieve the 'value' of the EAX
not a flag, so there is the need for an extra macro conversion and mask
the TLB flag.

Well, this is a detail, so feel free to ignore this suggestion :)

Thanks
  -- Daniel

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

