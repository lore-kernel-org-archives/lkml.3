Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab3BUMHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 07:07:05 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:36932 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab3BUMHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 07:07:03 -0500
MIME-Version: 1.0
In-Reply-To: <51254AD2.7000906@suse.cz>
References: <5121C7AF.2090803@numascale-asia.com>
	<CAJd=RBArPT8YowhLuE8YVGNfH7G-xXTOjSyDgdV2RsatL-9m+Q@mail.gmail.com>
	<51254AD2.7000906@suse.cz>
Date: Thu, 21 Feb 2013 20:07:03 +0800
Message-ID: <CAJd=RBCiYof5rRVK+62OFMw+5F=5rS=qxRYF+OHpuRz895bn4w@mail.gmail.com>
Subject: Re: kswapd craziness round 2
From: Hillf Danton <dhillf@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Daniel J Blueman <daniel@numascale-asia.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Steffen Persvold <sp@numascale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 6:14 AM, Jiri Slaby <jslaby@suse.cz> wrote:
>>
>> Does Ingo's revert help? https://lkml.org/lkml/2013/2/15/168
>
> Not at all...
>
Then mind taking a try?

--- a/mm/vmscan.c	Thu Feb 21 20:01:02 2013
+++ b/mm/vmscan.c	Thu Feb 21 20:05:58 2013
@@ -1715,7 +1715,7 @@ static void get_scan_count(struct lruvec
 	 * to swap.  Better start now and leave the - probably heavily
 	 * thrashing - remaining file pages alone.
 	 */
-	if (global_reclaim(sc)) {
+	if (global_reclaim(sc) && sc->priority >= DEF_PRIORITY - 2) {
 		free = zone_page_state(zone, NR_FREE_PAGES);
 		if (unlikely(file + free <= high_wmark_pages(zone))) {
 			scan_balance = SCAN_ANON;
@@ -2840,9 +2840,10 @@ out:
 		 * reclaim if they wish.
 		 */
 		if (sc.nr_reclaimed < SWAP_CLUSTER_MAX)
-			order = sc.order = 0;
-
-		goto loop_again;
+			if (order != 0) {
+				sc.order = order = 0;
+				goto loop_again;
+			}
 	}

 	/*
--
