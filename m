Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935796Ab3DIGGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 02:06:19 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:65411 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762735Ab3DIGGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 02:06:18 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <CAOtvUMcUZsfXT1km89mm4Hng=K8hbkhgsJW6tgxufNH4Kwb7sg@mail.gmail.com>
References: <1365194030-28939-1-git-send-email-cody@linux.vnet.ibm.com>
	<1365194030-28939-4-git-send-email-cody@linux.vnet.ibm.com>
	<CAOtvUMdT0-oQMTsHAjFqL6K8vrLeCcXG2hX-sShxu6GGRBPxJw@mail.gmail.com>
	<5162FE4D.7020308@linux.vnet.ibm.com>
	<CAOtvUMcUZsfXT1km89mm4Hng=K8hbkhgsJW6tgxufNH4Kwb7sg@mail.gmail.com>
Date: Tue, 9 Apr 2013 09:06:16 +0300
Message-ID: <CAOtvUMc0Wzhr__U5P70Rf5yhp4zvK+vMgsAD3g0ew3a8R46Z6A@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm: when handling percpu_pagelist_fraction, use
 on_each_cpu() to set percpu pageset fields.
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 9:03 AM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:

>
>> I also wonder whether there could be unexpected interactions between ->high
>> and ->batch not changing together atomically. For example, could adjusting
>> this knob cause ->batch to rise enough that it is greater than the previous
>> ->high? If the code above then runs with the previous ->high, ->count
>> wouldn't be correct (checking this inside free_pcppages_bulk() might help on
>> this one issue).
>
> You are right, but that can be treated in  setup_pagelist_highmark()  e.g.:
>
> 3993 static void setup_pagelist_highmark(struct per_cpu_pageset *p,
> 3994                                 unsigned long high)
> 3995 {
> 3996         struct per_cpu_pages *pcp;
>                 unsigned int batch;
> 3997
> 3998         pcp = &p->pcp;
>                 /* We're about to mess with PCP in an non atomic fashion.
>                    Put an intermediate safe value of batch and make sure it
>                    is visible before any other change */
>                 pcp->batch = 1UL;
>                 smb_mb();
>
> 3999         pcp->high = high;

and i think I missed another needed barrier here:
                  smp_mb();

>
> 4000         batch = max(1UL, high/4);
> 4001         if ((high/4) > (PAGE_SHIFT * 8))
> 4002                 batch = PAGE_SHIFT * 8;
>
>                pcp->batch = batch;
> 4003 }
>

-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
