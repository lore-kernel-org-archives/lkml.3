Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934196Ab3LIQ76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:59:58 -0500
Received: from b232-35.smtp-out.amazonses.com ([199.127.232.35]:22851 "EHLO
	b232-35.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933897Ab3LIQ75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:59:57 -0500
Date: Mon, 9 Dec 2013 16:59:56 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mgorman@suse.de>
cc: Rik van Riel <riel@redhat.com>, Alex Thorlton <athorlton@sgi.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/15] mm: fix TLB flush race between migration, and
 change_protection_range
In-Reply-To: <20131209162701.GZ11295@suse.de>
Message-ID: <00000142d84d07dc-4a095b73-a35b-4c74-8cc0-a57283ef308f-000000@email.amazonses.com>
References: <529E641A.7040804@redhat.com> <20131203234637.GS11295@suse.de> <529F3D51.1090203@redhat.com> <20131204160741.GC11295@suse.de> <20131206141331.10880d2b@annuminas.surriel.com> <00000142c99cf5b0-69cc9987-aa36-4889-af6a-1a45032d0d13-000000@email.amazonses.com>
 <52A23FD1.3040102@redhat.com> <00000142ca7218fe-a5566a24-0ef5-4545-8a98-d33116b7d703-000000@email.amazonses.com> <52A29278.9000609@redhat.com> <00000142d816866f-615798f8-74d8-401c-b35a-88aa1dbc8eb5-000000@email.amazonses.com>
 <20131209162701.GZ11295@suse.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.127.232.35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013, Mel Gorman wrote:

> I looked at what would be required to implement migration entry support for
> PMDs. It's major surgery because we do not have something like swap-like
> entries to use at that page table level. It looked like it would require
> inserting a fake entry (easiest would be to point to a global page) that
> all page table walkers would recognise, blocking on it and teaching every
> page table walker to get it right.

Well something needs to cause a fault and stop accesses to the page.

> One can't do something simple like clear the entry out because then the
> no page handlers for GUP or faults insert the zero page behind and it goes
> to hell and we can't hold the page table lock across the migration copy.

Right you need to have special migration entry there. Same as for regular
sized pages.


> The patch flushes the TLBs as it is and future accesses are help up in the
> NUMA hinting fault handler. It's functionally similar to having a migration
> entry albeit it is special cased to handle just automatic NUMA balancing

Hmmm... Hopefully that will work. I'd rather see a clean extension of what
we use for regular pages. If we add functionality to huge pages to operate
more like regular ones then this could be an issue.

