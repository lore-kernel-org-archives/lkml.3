Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760285Ab3HOURp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 16:17:45 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21362 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759977Ab3HOURo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 16:17:44 -0400
Message-ID: <1376597702.24607.42.camel@concerto>
Subject: Re: [RFC PATCH] Fix aio performance regression for database caused
 by THP
From: Khalid Aziz <khalid.aziz@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: aarcange@redhat.com, akpm@linux-foundation.org, hannes@cmpxchg.org,
        mgorman@suse.de, riel@redhat.com, minchan@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Thu, 15 Aug 2013 14:15:02 -0600
In-Reply-To: <8738qakatu.fsf@tassilo.jf.intel.com>
References: <1376590389.24607.33.camel@concerto>
	 <8738qakatu.fsf@tassilo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-15 at 12:34 -0700, Andi Kleen wrote:
> Khalid Aziz <khalid.aziz@oracle.com> writes:
> 
> > I am working with a tool that simulates oracle database I/O workload.
> > This tool (orion to be specific -
> > <http://docs.oracle.com/cd/E11882_01/server.112/e16638/iodesign.htm#autoId24>)
> > allocates hugetlbfs pages using shmget() with SHM_HUGETLB flag. 
> 
> Is this tool available for download?

I am not sure if it is available separately. It is part of Oracle 11gR2
release.

> 
> I would rather prefer to address the locking overhead in THP too.
> 
> The fundamental problem is that we have to touch all the pages?

Not so much that THP has to touch all the pages, rather it checks the
head and tail flags multiple times with the assumption they could change
underneath. Then it executes memory barriers (in compound_trans_head())
to force any updates to these flags from all cores. It also locks the
head page (in put_compound_page()) which stops any other thread trying
to put reference to one of the pages in the compound page. I see a lot
of cycles being spent in compound_trans_head() and various atomic
operations in the path added by THP. 

--
Khalid


