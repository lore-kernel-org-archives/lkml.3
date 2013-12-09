Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761497Ab3LIVCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:02:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756026Ab3LIVCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:02:03 -0500
Message-ID: <52A62FC2.3080601@redhat.com>
Date: Mon, 09 Dec 2013 16:01:54 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Mel Gorman <mgorman@suse.de>, Alex Thorlton <athorlton@sgi.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/15] mm: fix TLB flush race between migration, and change_protection_range
References: <529E641A.7040804@redhat.com> <20131203234637.GS11295@suse.de> <529F3D51.1090203@redhat.com> <20131204160741.GC11295@suse.de> <20131206141331.10880d2b@annuminas.surriel.com> <00000142c99cf5b0-69cc9987-aa36-4889-af6a-1a45032d0d13-000000@email.amazonses.com> <52A23FD1.3040102@redhat.com> <00000142ca7218fe-a5566a24-0ef5-4545-8a98-d33116b7d703-000000@email.amazonses.com> <52A29278.9000609@redhat.com> <00000142d816866f-615798f8-74d8-401c-b35a-88aa1dbc8eb5-000000@email.amazonses.com> <20131209162701.GZ11295@suse.de> <00000142d84d07dc-4a095b73-a35b-4c74-8cc0-a57283ef308f-000000@email.amazonses.com>
In-Reply-To: <00000142d84d07dc-4a095b73-a35b-4c74-8cc0-a57283ef308f-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 11:59 AM, Christoph Lameter wrote:
> On Mon, 9 Dec 2013, Mel Gorman wrote:
> 
>> I looked at what would be required to implement migration entry support for
>> PMDs. It's major surgery because we do not have something like swap-like
>> entries to use at that page table level. It looked like it would require
>> inserting a fake entry (easiest would be to point to a global page) that
>> all page table walkers would recognise, blocking on it and teaching every
>> page table walker to get it right.
> 
> Well something needs to cause a fault and stop accesses to the page.

The NUMA patches introduce such a state: the pmd_numa state.

The "issue" is that the NUMA code can race with itself, and with
CMA.

The code that markes PMDs as NUMA ones will change a bunch of
PMDs at once, and will then flush the TLB. Until that flush,
CPUs that have the old translation cached in their TLBs may
continue accessing the page.

Meanwhile, the code that does the migration may start running on
a CPU that does not have an old entry in the TLB, and it may
start the page migration.

The fundamental issue is that moving the PMD state from valid
to the intermediate state consists of multiple operations, and
there will always be some time window between them.

-- 
All rights reversed
