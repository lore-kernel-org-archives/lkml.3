Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935762Ab3DIT14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:27:56 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:60686 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934655Ab3DIT1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:27:55 -0400
Message-ID: <51646B8B.7010507@linux.vnet.ibm.com>
Date: Tue, 09 Apr 2013 12:27:07 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Gilad Ben-Yossef <gilad@benyossef.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm: when handling percpu_pagelist_fraction, use on_each_cpu()
 to set percpu pageset fields.
References: <1365194030-28939-1-git-send-email-cody@linux.vnet.ibm.com> <1365194030-28939-4-git-send-email-cody@linux.vnet.ibm.com> <CAOtvUMdT0-oQMTsHAjFqL6K8vrLeCcXG2hX-sShxu6GGRBPxJw@mail.gmail.com> <5162FE4D.7020308@linux.vnet.ibm.com> <CAOtvUMcUZsfXT1km89mm4Hng=K8hbkhgsJW6tgxufNH4Kwb7sg@mail.gmail.com> <CAOtvUMc0Wzhr__U5P70Rf5yhp4zvK+vMgsAD3g0ew3a8R46Z6A@mail.gmail.com>
In-Reply-To: <CAOtvUMc0Wzhr__U5P70Rf5yhp4zvK+vMgsAD3g0ew3a8R46Z6A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040919-7408-0000-0000-00000EB79A8B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 11:06 PM, Gilad Ben-Yossef wrote:
> On Tue, Apr 9, 2013 at 9:03 AM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>
>>
>>> I also wonder whether there could be unexpected interactions between ->high
>>> and ->batch not changing together atomically. For example, could adjusting
>>> this knob cause ->batch to rise enough that it is greater than the previous
>>> ->high? If the code above then runs with the previous ->high, ->count
>>> wouldn't be correct (checking this inside free_pcppages_bulk() might help on
>>> this one issue).
>>
>> You are right, but that can be treated in  setup_pagelist_highmark()  e.g.:
>>
>> 3993 static void setup_pagelist_highmark(struct per_cpu_pageset *p,
>> 3994                                 unsigned long high)
>> 3995 {
>> 3996         struct per_cpu_pages *pcp;
>>                  unsigned int batch;
>> 3997
>> 3998         pcp = &p->pcp;
>>                  /* We're about to mess with PCP in an non atomic fashion.
>>                     Put an intermediate safe value of batch and make sure it
>>                     is visible before any other change */
>>                  pcp->batch = 1UL;
>>                  smb_mb();
>>
>> 3999         pcp->high = high;
>
> and i think I missed another needed barrier here:
>                    smp_mb();
>
>>
>> 4000         batch = max(1UL, high/4);
>> 4001         if ((high/4) > (PAGE_SHIFT * 8))
>> 4002                 batch = PAGE_SHIFT * 8;
>>
>>                 pcp->batch = batch;
>> 4003 }
>>
>

Yep, that appears to work, provided no additional users of ->batch and 
->high show up. It seems we'll also need some locking to prevent 
concurrent updaters, but that is relatively light weight.

I'll roll up a new patchset that uses this methodology.

