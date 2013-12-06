Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779Ab3LFVVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:21:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758664Ab3LFVVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:21:32 -0500
Message-ID: <52A23FD1.3040102@redhat.com>
Date: Fri, 06 Dec 2013 16:21:21 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Mel Gorman <mgorman@suse.de>, Alex Thorlton <athorlton@sgi.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/15] mm: fix TLB flush race between migration, and change_protection_range
References: <1386060721-3794-1-git-send-email-mgorman@suse.de> <1386060721-3794-15-git-send-email-mgorman@suse.de> <529E641A.7040804@redhat.com> <20131203234637.GS11295@suse.de> <529F3D51.1090203@redhat.com> <20131204160741.GC11295@suse.de> <20131206141331.10880d2b@annuminas.surriel.com> <00000142c99cf5b0-69cc9987-aa36-4889-af6a-1a45032d0d13-000000@email.amazonses.com>
In-Reply-To: <00000142c99cf5b0-69cc9987-aa36-4889-af6a-1a45032d0d13-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 03:32 PM, Christoph Lameter wrote:
> On Fri, 6 Dec 2013, Rik van Riel wrote:
>>
>> The basic race looks like this:
>>
>> CPU A			CPU B			CPU C
>>
>> 						load TLB entry
>> make entry PTE/PMD_NUMA
>> 			fault on entry
>> 						read/write old page
>> 			start migrating page
> 
> When you start migrating a page a special page migration entry is
> created that will trap all accesses to the page. You can safely flush when
> the migration entry is there. Only allow a new PTE/PMD to be put there
> *after* the tlb flush.

A PROT_NONE or NUMA pte is just as effective as a migration pte.
The only problem is, the TLB flush was not always done...

> 
>> 			change PTE/PMD to new page
> 
> Dont do that. We have migration entries for a reason.

We do not have migration entries for hugepages, do we?

>> 						read/write old page [*]
> 
> Should cause a page fault which should put the process to sleep. Process
> will safely read the page after the migration entry is removed.
> 
>> flush TLB
> 
> Establish the new PTE/PMD after the flush removing the migration pte
> entry and thereby avoiding the race.

That is what this patch does.

-- 
All rights reversed
