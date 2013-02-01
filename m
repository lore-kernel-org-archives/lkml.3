Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab3BASkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 13:40:40 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:42971 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3BASki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 13:40:38 -0500
Message-ID: <510C0C22.4000801@kernel.org>
Date: Fri, 01 Feb 2013 13:40:34 -0500
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] intel_idle: stop using driver_data for static flags
References: <1359691896-23567-1-git-send-email-lenb@kernel.org> <9a38405338d7464c852c4524465f84f8a2ac22fb.1359691799.git.len.brown@intel.com> <510B8059.5040609@linaro.org>
In-Reply-To: <510B8059.5040609@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2013 03:44 AM, Daniel Lezcano wrote:
> On 02/01/2013 05:11 AM, Len Brown wrote:
>> From: Len Brown <len.brown@intel.com>
>>
>> The commit, 4202735e8ab6ecfb0381631a0d0b58fefe0bd4e2
>> (cpuidle: Split cpuidle_state structure and move per-cpu statistics fields)
>> observed that the MWAIT flags for Cn on every processor to date were the
>> same, and created get_driver_data() to supply them.
>>
>> Unfortunately, that assumption is false, going forward.
>> So here we restore the MWAIT flags to the cpuidle_state table.
>> However, instead restoring the old "driver_data" field,
>> we put the flags into the existing "flags" field,
>> where they probalby should have lived all along.
> 
> Removing the driver_data is a good thing but I am not sure it is the
> case by moving the MWAIT flags to the cpuidle_state's flags field. We
> are mixing arch specific flags with a generic code.
> 
> This is prone to errors because new flags could appear for the cpuidle
> core code and could collide with the arch specific flags.
> 
> Wouldn't make sense to add a private field in the struct cpuidle_state
> structure to let the driver/arch specific to store whatever is needed ?
> 
> struct cpuidle_state {
> 
> 	...
> 	unsigned long private;
> 	...
> 
> }

The top half of the flags are reserved for the driver,
as noted by the definition of CPUIDLE_DRIVER_FLAGS_MASK
with the generic flag definitions:

#define CPUIDLE_FLAG_TIME_VALID (0x01) /* is residency time measurable? */
#define CPUIDLE_FLAG_COUPLED    (0x02) /* state applies to multiple cpus */

#define CPUIDLE_DRIVER_FLAGS_MASK (0xFFFF0000)

intel_idle already uses a driver-specific flag:

#define CPUIDLE_FLAG_TLB_FLUSHED        0x10000

This patch just uses 4 more bits along with that one.

Sure, if we run out of space, we can add an additional field.
But I don't see an immediate need for it.

thanks,
Len Brown
Intel Open Source Technology Center

