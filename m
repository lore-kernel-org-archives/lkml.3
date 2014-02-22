Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaBVGsJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 01:48:09 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54671 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbaBVGsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 01:48:08 -0500
Message-ID: <530847E3.4070401@ti.com>
Date: Fri, 21 Feb 2014 22:46:59 -0800
From: Russ Dill <Russ.Dill@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sebastian Capella <sebastian.capella@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Russell King <linux@arm.linux.org.uk>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Nicolas Pitre <nico@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH RFC v1 3/3] ARM hibernation / suspend-to-disk
References: <1392774729-3235-1-git-send-email-sebastian.capella@linaro.org> <1392774729-3235-4-git-send-email-sebastian.capella@linaro.org> <20140219161254.GB19343@e102568-lin.cambridge.arm.com> <20140219193315.3732.21819@capellas-linux> <20140220162754.GC15994@e102568-lin.cambridge.arm.com> <20140221183956.29890.80931@capellas-linux> <20140221235911.14777.13919@capellas-linux> <20140222043714.19852.67450@capellas-linux>
In-Reply-To: <20140222043714.19852.67450@capellas-linux>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2014 08:37 PM, Sebastian Capella wrote:
> Quoting Sebastian Capella (2014-02-21 15:59:11)
>> - Cyril Chemparathy as his email is bouncing back to me. 
>>
>> Quoting Sebastian Capella (2014-02-21 10:39:56)
>>> Quoting Lorenzo Pieralisi (2014-02-20 08:27:55)
>>>>>>> +     cpu_switch_mm(idmap_pgd, &init_mm);
>>   [ ... ]
>>> I can try removing it and seeing if there are side effects.
>>
>> FYI, It's definitely hanging with this removed, still looking.
> 
> I see when we reach this call, the 1st level page table @ TTBR0 is located
> at different memory locations each run (expected).  If we omit the
> cpu_switch_mm we're corrupting the page table causing the observed
> intermittent failures.  I believe these match the corruption you expected.
> 
> The reason this doesn't happen when I leave the call is that idmap_pgd
> is always at the same memory location.  I expect this is because it's
> allocated during init.  I've seen the same address 50/50 times for
> idmap_pgd.  I don't think it is correct to rely on this behavior.
> 
> Would it be appropriate to use the swapper_pg_dir directly in place
> of idmap_pgd?
>   - I do not see any modification to the swapper_pg_dir contents in the
>     code that would change from init time.
>   - swapper_pg_dir is always at the same offset.
> 
> Ideally we should have no issue with overwriting it with identical data.
> 
> I've run a couple hundred test loops using swapper_pg_dir and so far
> there are no failures.

If there is worry about this, you could setup a page mapping in a
__nosave region, preventing it from being overwritten.

