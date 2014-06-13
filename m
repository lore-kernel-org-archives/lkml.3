Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaFMKVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 06:21:37 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:34493 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaFMKVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 06:21:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140613052138.GN2878@cmpxchg.org>
References: <1402634191-3442-1-git-send-email-slaoub@gmail.com>
	<CALYGNiMENJ014dELVS8Ej+RP=WVkt8rF0=bxs5yDXO4+hr6B_Q@mail.gmail.com>
	<20140613052138.GN2878@cmpxchg.org>
Date: Fri, 13 Jun 2014 14:21:34 +0400
Message-ID: <CALYGNiN0UOvKdx=g0-_3FbnS5U2XBfCS2V035qh5h+0KmsEa0w@mail.gmail.com>
Subject: Re: [PATCH v2] mm/vmscan.c: wrap five parameters into shrink_result
 for reducing the stack consumption
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chen Yucong <slaoub@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, mhocko@suse.cz,
        Rik van Riel <riel@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 9:21 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Fri, Jun 13, 2014 at 08:52:22AM +0400, Konstantin Khlebnikov wrote:
>> On Fri, Jun 13, 2014 at 8:36 AM, Chen Yucong <slaoub@gmail.com> wrote:
>> > shrink_page_list() has too many arguments that have already reached ten.
>> > Some of those arguments and temporary variables introduces extra 80 bytes
>> > on the stack. This patch wraps five parameters into shrink_result and removes
>> > some temporary variables, thus making the relative functions to consume fewer
>> > stack space.
>>
>> I think it's better to put them into struct scan_control.
>> Reset them before calling shrinker or take a snapshot to get delta.
>
> scan_control applies to the whole reclaim invocation*, it would be
> confusing as hell to have things in there that only apply to certain
> sublevels.  Please don't do that.

scan_control is internal private structure and reclaimer is small and
simple enough to hold whole state here.
For me it's easier to track state of single structure which is alive
during whole invocation,
than several smaller structures especially if some of them disappears
from time to time.

If it would be easier for you -- shrink_result might be embedded as
sub-structure.

>
> If you on the other hand take snapshots and accumulate them over the
> whole run, it might actually make sense to move sc->nr_scanned and
> sc->nr_reclaimed into shrink_results instead.  But I'm not sure it's
> worth the extra snapshotting code, given that we don't actually need
> the accumulated numbers at the outer levels right now.
>
> * sc->swappiness being the recent exception, I'll send a fix for that.
