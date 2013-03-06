Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab3CFVUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 16:20:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:37207 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294Ab3CFVUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 16:20:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,797,1355126400"; 
   d="scan'208";a="209968942"
Message-ID: <5137B30D.8060509@linux.intel.com>
Date: Wed, 06 Mar 2013 13:20:13 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Feng Tang <feng.tang@intel.com>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
Subject: Re: [PATCH v3 4/5] clocksource: Enable clocksource_cyc2ns() to cover
 big cycles
References: <1362554271-22382-1-git-send-email-feng.tang@intel.com> <1362554271-22382-5-git-send-email-feng.tang@intel.com> <alpine.LFD.2.02.1303061451340.22263@ionos> <5137AF96.6050003@linux.intel.com> <alpine.LFD.2.02.1303062215190.22263@ionos>
In-Reply-To: <alpine.LFD.2.02.1303062215190.22263@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 01:15 PM, Thomas Gleixner wrote:
> On Wed, 6 Mar 2013, H. Peter Anvin wrote:
> 
>> On 03/06/2013 06:09 AM, Thomas Gleixner wrote:
>>>
>>> This breaks everything which does not have a 64/32bit divide
>>> instruction. And you can't replace it with do_div() as that would
>>> impose massive overhead on those architectures in the fast path.
>>>
>>
>> Could we do the same kind of scaling-by-multiplication that we do in
>> kernel/time.c for this?
> 
> Not sure what you are referring to. kernel/time.c contains a lot of stuff :)
> 

This stuff, specifically the third clause (which incidentally could be
extended to the fourth clause without much trouble... I have
experimented with it already.)

It uses a N*N->2N multiply and a shift to do overflowless scaling; it is
±1 LSB in the upper half of the value range with can be remedied with an
additional 2N add.

	-hpa

/*
 * Convert jiffies to milliseconds and back.
 *
 * Avoid unnecessary multiplications/divisions in the
 * two most common HZ cases:
 */
unsigned int jiffies_to_msecs(const unsigned long j)
{
#if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
        return (MSEC_PER_SEC / HZ) * j;
#elif HZ > MSEC_PER_SEC && !(HZ % MSEC_PER_SEC)
        return (j + (HZ / MSEC_PER_SEC) - 1)/(HZ / MSEC_PER_SEC);
#else
# if BITS_PER_LONG == 32
        return (HZ_TO_MSEC_MUL32 * j) >> HZ_TO_MSEC_SHR32;	<---
# else
        return (j * HZ_TO_MSEC_NUM) / HZ_TO_MSEC_DEN;
# endif
#endif
}

