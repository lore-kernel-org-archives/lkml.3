Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935627Ab3DHMUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:20:48 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:41832 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935606Ab3DHMUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:20:47 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <1365194030-28939-4-git-send-email-cody@linux.vnet.ibm.com>
References: <1365194030-28939-1-git-send-email-cody@linux.vnet.ibm.com>
	<1365194030-28939-4-git-send-email-cody@linux.vnet.ibm.com>
Date: Mon, 8 Apr 2013 15:20:44 +0300
Message-ID: <CAOtvUMdT0-oQMTsHAjFqL6K8vrLeCcXG2hX-sShxu6GGRBPxJw@mail.gmail.com>
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

On Fri, Apr 5, 2013 at 11:33 PM, Cody P Schafer <cody@linux.vnet.ibm.com> wrote:
> In free_hot_cold_page(), we rely on pcp->batch remaining stable.
> Updating it without being on the cpu owning the percpu pageset
> potentially destroys this stability.
>
> Change for_each_cpu() to on_each_cpu() to fix.

Are you referring to this? -

1329         if (pcp->count >= pcp->high) {
1330                 free_pcppages_bulk(zone, pcp->batch, pcp);
1331                 pcp->count -= pcp->batch;
1332         }

I'm probably missing the obvious but won't it be simpler to do this in
 free_hot_cold_page() -

1329         if (pcp->count >= pcp->high) {
1330                  unsigned int batch = ACCESS_ONCE(pcp->batch);
1331                 free_pcppages_bulk(zone, batch, pcp);
1332                 pcp->count -= batch;
1333         }

Now the batch value used is stable and you don't have to IPI every CPU
in the system just to change a config knob...

Thanks,
Gilad



--
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a situation
where the homework eats your dog?"
 -- Jean-Baptiste Queru
