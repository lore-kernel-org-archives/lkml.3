Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbaBOGkq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 01:40:46 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:33443 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbaBOGkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 01:40:45 -0500
MIME-Version: 1.0
In-Reply-To: <CAMrOTPgBtANS_ryRjan0-dTL97U7eRvtf3dCsss=Kn+Uk89fuA@mail.gmail.com>
References: <CAMrOTPgBtANS_ryRjan0-dTL97U7eRvtf3dCsss=Kn+Uk89fuA@mail.gmail.com>
From: Pradeep Sawlani <pradeep.sawlani@gmail.com>
Date: Fri, 14 Feb 2014 22:40:21 -0800
Message-ID: <CAMrOTPgbDt16Tg-REvhzVKHZacVrphPBPxjkEMa=64TJjyZBLA@mail.gmail.com>
Subject: Re: KSM on Android
To: Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: surim@lab126.com, Izik Eidus <izik.eidus@ravellosystems.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Re-sending this in plain text format (Apologies)
>
> Hello,
>
> In pursuit of saving memory on Android, I started experimenting with
> Kernel Same Page Merging(KSM).
> Number of pages shared because of KSM is reported by
> /sys/kernel/mm/pages_sharing.
> Documentation/vm/ksm.txt explains this as:
>
> "pages_sharing    - how many more sites are sharing them i.e. how much saved"
>
> After enabling KSM on Android device, this number was reported as 19666 pages.
> Obvious optimization is to find out source of sharing and see if we
> can avoid duplicate pages at first place.
> In order to collect the data needed, It needed few
> modifications(trace_printk) statement in mm/ksm.c.
> Data should be collected from second cycle because that's when ksm
> starts merging
> pages. First KSM cycle is only used to calculate the checksum, pages
> are added to
> unstable tree and eventually moved to stable tree after this.
>
> After analyzing data from second KSM cycle, few things which stood out:
> 1.  In the same cycle, KSM can scan same page multiple times. Scanning
> a page involves
>     comparing page with pages in stable tree, if no match is found
> checksum is calculated.
>     From the look of it, it seems to be cpu intensive operation and
> impacts dcache as well.
>
> 2.  Same page which is already shared by multiple process can be
> replaced by KSM page.
>     In this case, let say a particular page is mapped 24 times and is
> replaced by KSM page then
>     eventually all 24 entries will point to KSM page. pages_sharing
> will account for all 24 pages.
>     so pages _sharing does not actually report amount of memory saved.
> From the above example actual
>     savings is one page.
>
> Both cases happen very often with Android because of its architecture
> - Zygote spawning(fork) multiple
> applications. To calculate actual savings, we should account for same
> page(pfn)replaced by same KSM page only once.
> In the case 2 example, page_sharing should account only one page.
> After recalculating memory saving comes out to be 8602 pages (~34MB).
>
> I am trying to find out right solution to fix pages_sharing and
> eventually optimize KSM to scan page
> once even if it is mapped multiple times.
>
> Comments?
>
Correct Izik's email address.

Thanks.
