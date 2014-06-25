Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbaFYUZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 16:25:26 -0400
Received: from fujitsu25.fnanic.fujitsu.com ([192.240.6.15]:47395 "EHLO
	fujitsu25.fnanic.fujitsu.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755473AbaFYUZT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 16:25:19 -0400
From: Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>
To: Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Rafael Aquini <aquini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        "Motohiro Kosaki JP" <kosaki.motohiro@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 25 Jun 2014 13:25:00 -0700
Subject: RE: [PATCH] mm: export NR_SHMEM via sysinfo(2) / si_meminfo()
 interfaces
Thread-Topic: [PATCH] mm: export NR_SHMEM via sysinfo(2) / si_meminfo()
 interfaces
Thread-Index: Ac+QpPZIB3FMYlBhQmm7ZoLTrYEHeAAAOTqwAAJA+yA=
Message-ID: <6B2BA408B38BA1478B473C31C3D2074E341D5854F7@SV-EXCHANGE1.Corp.FC.LOCAL>
References: <4b46c5b21263c446923caf3da3f0dca6febc7b55.1403709665.git.aquini@redhat.com>
 <6B2BA408B38BA1478B473C31C3D2074E341D585464@SV-EXCHANGE1.Corp.FC.LOCAL>
In-Reply-To: <6B2BA408B38BA1478B473C31C3D2074E341D585464@SV-EXCHANGE1.Corp.FC.LOCAL>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-25_06:2014-06-25,2014-06-25,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Motohiro.Kosaki@us.fujitsu.com [mailto:Motohiro.Kosaki@us.fujitsu.com]
> Sent: Wednesday, June 25, 2014 3:41 PM
> To: Rafael Aquini; linux-mm@kvack.org
> Cc: Andrew Morton; Rik van Riel; Mel Gorman; Johannes Weiner; Motohiro Kosaki JP; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH] mm: export NR_SHMEM via sysinfo(2) / si_meminfo() interfaces
> 
> 
> 
> > -----Original Message-----
> > From: Rafael Aquini [mailto:aquini@redhat.com]
> > Sent: Wednesday, June 25, 2014 2:40 PM
> > To: linux-mm@kvack.org
> > Cc: Andrew Morton; Rik van Riel; Mel Gorman; Johannes Weiner; Motohiro
> > Kosaki JP; linux-kernel@vger.kernel.org
> > Subject: [PATCH] mm: export NR_SHMEM via sysinfo(2) / si_meminfo()
> > interfaces
> >
> > This patch leverages the addition of explicit accounting for pages
> > used by shmem/tmpfs -- "4b02108 mm: oom analysis: add shmem vmstat" --
> > in order to make the users of sysinfo(2) and si_meminfo*() friends aware of that vmstat entry consistently across the interfaces.
> 
> Why?
> Traditionally sysinfo.sharedram was not used for shmem. It was totally strange semantics and completely outdated feature.
> So, we may reuse it for another purpose. But I'm not sure its benefit.
> 
> Why don't you use /proc/meminfo?
> I'm afraid userland programs get a confusion.

For the record. This is historical implementation at linux-2.3.12. I.e. account sum of page count.


void si_meminfo(struct sysinfo *val)
{
        int i;

        i = max_mapnr;
        val->totalram = 0;
        val->sharedram = 0;
        val->freeram = nr_free_pages << PAGE_SHIFT;
        val->bufferram = atomic_read(&buffermem);
        while (i-- > 0)  {
                if (PageReserved(mem_map+i))
                        continue;
                val->totalram++;
                if (!page_count(mem_map+i))
                        continue;
                val->sharedram += page_count(mem_map+i) - 1;
        }
        val->totalram <<= PAGE_SHIFT;
        val->sharedram <<= PAGE_SHIFT;
        return;
}


