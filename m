Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935844Ab3DHTuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 15:50:46 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48398 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935727Ab3DHTup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 15:50:45 -0400
Message-ID: <51631F89.5090407@linux.vnet.ibm.com>
Date: Mon, 08 Apr 2013 12:50:33 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Gilad Ben-Yossef <gilad@benyossef.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm: when handling percpu_pagelist_fraction, use on_each_cpu()
 to set percpu pageset fields.
References: <1365194030-28939-1-git-send-email-cody@linux.vnet.ibm.com> <1365194030-28939-4-git-send-email-cody@linux.vnet.ibm.com> <CAOtvUMdT0-oQMTsHAjFqL6K8vrLeCcXG2hX-sShxu6GGRBPxJw@mail.gmail.com> <5162FE4D.7020308@linux.vnet.ibm.com>
In-Reply-To: <5162FE4D.7020308@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040819-7182-0000-0000-0000062485B7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 10:28 AM, Cody P Schafer wrote:
> On 04/08/2013 05:20 AM, Gilad Ben-Yossef wrote:
>> On Fri, Apr 5, 2013 at 11:33 PM, Cody P Schafer
>> <cody@linux.vnet.ibm.com> wrote:
>>> In free_hot_cold_page(), we rely on pcp->batch remaining stable.
>>> Updating it without being on the cpu owning the percpu pageset
>>> potentially destroys this stability.
>>>
>>> Change for_each_cpu() to on_each_cpu() to fix.
>>
>> Are you referring to this? -
>
> This was the case I noticed.
>
>>
>> 1329         if (pcp->count >= pcp->high) {
>> 1330                 free_pcppages_bulk(zone, pcp->batch, pcp);
>> 1331                 pcp->count -= pcp->batch;
>> 1332         }
>>
>> I'm probably missing the obvious but won't it be simpler to do this in
>>   free_hot_cold_page() -
>>
>> 1329         if (pcp->count >= pcp->high) {
>> 1330                  unsigned int batch = ACCESS_ONCE(pcp->batch);
>> 1331                 free_pcppages_bulk(zone, batch, pcp);
>> 1332                 pcp->count -= batch;
>> 1333         }
>>
>
> Potentially, yes. Note that this was simply the one case I noticed,
> rather than certainly the only case.
>
> I also wonder whether there could be unexpected interactions between
> ->high and ->batch not changing together atomically. For example, could
> adjusting this knob cause ->batch to rise enough that it is greater than
> the previous ->high? If the code above then runs with the previous
> ->high, ->count wouldn't be correct (checking this inside
> free_pcppages_bulk() might help on this one issue).
>
>> Now the batch value used is stable and you don't have to IPI every CPU
>> in the system just to change a config knob...
>
> Is this really considered an issue? I wouldn't have expected someone to
> adjust the config knob often enough (or even more than once) to cause
> problems. Of course as a "It'd be nice" thing, I completely agree.

Would using schedule_on_each_cpu() instead of on_each_cpu() be an 
improvement, in your opinion?

