Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbaELIfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 04:35:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51399 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639AbaELIfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 04:35:46 -0400
Message-ID: <537087E1.6070703@suse.cz>
Date: Mon, 12 May 2014 10:35:45 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Greg Thelen <gthelen@google.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch v3 2/6] mm, compaction: return failed migration target
 pages back to freelist
References: <alpine.DEB.2.02.1404301744110.8415@chino.kir.corp.google.com> <alpine.DEB.2.02.1405011434140.23898@chino.kir.corp.google.com> <alpine.DEB.2.02.1405061920470.18635@chino.kir.corp.google.com> <alpine.DEB.2.02.1405061921040.18635@chino.kir.corp.google.com> <20140507141534.d4def933b3a9999e7826df5c@linux-foundation.org> <alpine.DEB.2.02.1405071420110.8454@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1405071420110.8454@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 11:21 PM, David Rientjes wrote:
> On Wed, 7 May 2014, Andrew Morton wrote:
>
>>> Memory compaction works by having a "freeing scanner" scan from one end of a
>>> zone which isolates pages as migration targets while another "migrating scanner"
>>> scans from the other end of the same zone which isolates pages for migration.
>>>
>>> When page migration fails for an isolated page, the target page is returned to
>>> the system rather than the freelist built by the freeing scanner.  This may
>>> require the freeing scanner to continue scanning memory after suitable migration
>>> targets have already been returned to the system needlessly.
>>>
>>> This patch returns destination pages to the freeing scanner freelist when page
>>> migration fails.  This prevents unnecessary work done by the freeing scanner but
>>> also encourages memory to be as compacted as possible at the end of the zone.
>>>
>>> Reported-by: Greg Thelen <gthelen@google.com>
>>
>> What did Greg actually report?  IOW, what if any observable problem is
>> being fixed here?
>>
>
> Greg reported by code inspection that he found isolated free pages were
> returned back to the VM rather than the compaction freelist.  This will
> cause holes behind the free scanner and cause it to reallocate additional
> memory if necessary later.

More precisely, there shouldn't be holes as the free scanner restarts at 
highest pageblock where it isolated something, exactly to avoid making 
holes due to returned pages. But that can be now avoided, as my patch does.

