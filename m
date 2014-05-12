Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbaELIhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 04:37:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51458 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbaELIhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 04:37:18 -0400
Message-ID: <5370883C.5080105@suse.cz>
Date: Mon, 12 May 2014 10:37:16 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch v3 2/6] mm, compaction: return failed migration target
 pages back to freelist
References: <alpine.DEB.2.02.1404301744110.8415@chino.kir.corp.google.com> <alpine.DEB.2.02.1405011434140.23898@chino.kir.corp.google.com> <alpine.DEB.2.02.1405061920470.18635@chino.kir.corp.google.com> <alpine.DEB.2.02.1405061921040.18635@chino.kir.corp.google.com> <20140507141534.d4def933b3a9999e7826df5c@linux-foundation.org> <xr93ha512rqr.fsf@gthelen.mtv.corp.google.com>
In-Reply-To: <xr93ha512rqr.fsf@gthelen.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 11:39 PM, Greg Thelen wrote:
>
> On Wed, May 07 2014, Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> On Tue, 6 May 2014 19:22:43 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:
>>
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
>
> I detected the problem at runtime seeing that ext4 metadata pages (esp
> the ones read by "sbi->s_group_desc[i] = sb_bread(sb, block)") were
> constantly visited by compaction calls of migrate_pages().  These pages
> had a non-zero b_count which caused fallback_migrate_page() ->
> try_to_release_page() -> try_to_free_buffers() to fail.

That sounds like something the "mm, compaction: add per-zone migration 
pfn cache for async compaction" patch would fix, not this one, though.
