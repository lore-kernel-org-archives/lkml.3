Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbaEGVj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:39:27 -0400
Received: from mail-ie0-f202.google.com ([209.85.223.202]:46990 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbaEGVj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:39:26 -0400
References: <alpine.DEB.2.02.1404301744110.8415@chino.kir.corp.google.com> <alpine.DEB.2.02.1405011434140.23898@chino.kir.corp.google.com> <alpine.DEB.2.02.1405061920470.18635@chino.kir.corp.google.com> <alpine.DEB.2.02.1405061921040.18635@chino.kir.corp.google.com> <20140507141534.d4def933b3a9999e7826df5c@linux-foundation.org>
User-agent: mu4e 0.9.9.6pre2; emacs 24.3.1
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch v3 2/6] mm, compaction: return failed migration target pages back to freelist
In-reply-to: <20140507141534.d4def933b3a9999e7826df5c@linux-foundation.org>
Date: Wed, 07 May 2014 14:39:24 -0700
Message-ID: <xr93ha512rqr.fsf@gthelen.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, May 07 2014, Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 6 May 2014 19:22:43 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:
>
>> Memory compaction works by having a "freeing scanner" scan from one end of a 
>> zone which isolates pages as migration targets while another "migrating scanner" 
>> scans from the other end of the same zone which isolates pages for migration.
>> 
>> When page migration fails for an isolated page, the target page is returned to 
>> the system rather than the freelist built by the freeing scanner.  This may 
>> require the freeing scanner to continue scanning memory after suitable migration 
>> targets have already been returned to the system needlessly.
>> 
>> This patch returns destination pages to the freeing scanner freelist when page 
>> migration fails.  This prevents unnecessary work done by the freeing scanner but 
>> also encourages memory to be as compacted as possible at the end of the zone.
>> 
>> Reported-by: Greg Thelen <gthelen@google.com>
>
> What did Greg actually report?  IOW, what if any observable problem is
> being fixed here?

I detected the problem at runtime seeing that ext4 metadata pages (esp
the ones read by "sbi->s_group_desc[i] = sb_bread(sb, block)") were
constantly visited by compaction calls of migrate_pages().  These pages
had a non-zero b_count which caused fallback_migrate_page() ->
try_to_release_page() -> try_to_free_buffers() to fail.
