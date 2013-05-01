Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab3EAXxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 19:53:54 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55736 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355Ab3EAXxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 19:53:48 -0400
Message-ID: <5181AB06.5080805@linux.vnet.ibm.com>
Date: Wed, 01 May 2013 16:53:42 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Gilad Ben-Yossef <gilad@benyossef.com>,
        Simon Jeons <simon.jeons@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 00/11] mm: fixup changers of per cpu pageset's ->high
 and ->batch
References: <1365618219-17154-1-git-send-email-cody@linux.vnet.ibm.com> <20130410142354.6044338fd68ff2ad165b1bc8@linux-foundation.org> <5165D8DE.5090801@linux.vnet.ibm.com>
In-Reply-To: <5165D8DE.5090801@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050123-7182-0000-0000-0000067F4ACB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 02:25 PM, Cody P Schafer wrote:
> On 04/10/2013 02:23 PM, Andrew Morton wrote:
>> On Wed, 10 Apr 2013 11:23:28 -0700 Cody P Schafer
>> <cody@linux.vnet.ibm.com> wrote:
>>
>>> "Problems" with the current code:
>>>   1. there is a lack of synchronization in setting ->high and ->batch in
>>>      percpu_pagelist_fraction_sysctl_handler()
>>>   2. stop_machine() in zone_pcp_update() is unnecissary.
>>>   3. zone_pcp_update() does not consider the case where
>>> percpu_pagelist_fraction is non-zero
>>>
>>> To fix:
>>>   1. add memory barriers, a safe ->batch value, an update side mutex
>>> when
>>>      updating ->high and ->batch, and use ACCESS_ONCE() for ->batch
>>> users that
>>>      expect a stable value.
>>>   2. avoid draining pages in zone_pcp_update(), rely upon the memory
>>> barriers added to fix #1
>>>   3. factor out quite a few functions, and then call the appropriate
>>> one.
>>>
>>> Note that it results in a change to the behavior of
>>> zone_pcp_update(), which is
>>> used by memory_hotplug. I'm rather certain that I've diserned (and
>>> preserved)
>>> the essential behavior (changing ->high and ->batch), and only
>>> eliminated
>>> unneeded actions (draining the per cpu pages), but this may not be
>>> the case.
>>>
>>> Further note that the draining of pages that previously took place in
>>> zone_pcp_update() occured after repeated draining when attempting to
>>> offline a
>>> page, and after the offline has "succeeded". It appears that the
>>> draining was
>>> added to zone_pcp_update() to avoid refactoring setup_pageset() into 2
>>> funtions.
>>
>> There hasn't been a ton of review activity for this patchset :(
>>
>> I'm inclined to duck it until after 3.9.  Do the patches fix any
>> noticeably bad userspace behavior?
>
> No, all the bugs are theoretical. Waiting should be fine.
>

Andrew, do you want me to resend this patch set in the hope of obtaining 
more review? If so, when?

