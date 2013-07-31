Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab3GaFl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 01:41:56 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:54583 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3GaFlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 01:41:55 -0400
X-AuditID: 9c930197-b7bfbae000000e88-a5-51f8a3a2f9de
Date: Wed, 31 Jul 2013 14:41:55 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v3 6/9] mm, hugetlb: do not use a page in page cache for
 cow optimization
Message-ID: <20130731054154.GN2548@lge.com>
References: <1375075701-5998-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375075701-5998-7-git-send-email-iamjoonsoo.kim@lge.com>
 <20130729223708.GG29970@voom.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729223708.GG29970@voom.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 08:37:08AM +1000, David Gibson wrote:
> On Mon, Jul 29, 2013 at 02:28:18PM +0900, Joonsoo Kim wrote:
> > Currently, we use a page with mapped count 1 in page cache for cow
> > optimization. If we find this condition, we don't allocate a new
> > page and copy contents. Instead, we map this page directly.
> > This may introduce a problem that writting to private mapping overwrite
> > hugetlb file directly. You can find this situation with following code.
> > 
> >         size = 20 * MB;
> >         flag = MAP_SHARED;
> >         p = mmap(NULL, size, PROT_READ|PROT_WRITE, flag, fd, 0);
> >         if (p == MAP_FAILED) {
> >                 fprintf(stderr, "mmap() failed: %s\n", strerror(errno));
> >                 return -1;
> >         }
> >         p[0] = 's';
> >         fprintf(stdout, "BEFORE STEAL PRIVATE WRITE: %c\n", p[0]);
> >         munmap(p, size);
> > 
> >         flag = MAP_PRIVATE;
> >         p = mmap(NULL, size, PROT_READ|PROT_WRITE, flag, fd, 0);
> >         if (p == MAP_FAILED) {
> >                 fprintf(stderr, "mmap() failed: %s\n", strerror(errno));
> >         }
> >         p[0] = 'c';
> >         munmap(p, size);
> > 
> >         flag = MAP_SHARED;
> >         p = mmap(NULL, size, PROT_READ|PROT_WRITE, flag, fd, 0);
> >         if (p == MAP_FAILED) {
> >                 fprintf(stderr, "mmap() failed: %s\n", strerror(errno));
> >                 return -1;
> >         }
> >         fprintf(stdout, "AFTER STEAL PRIVATE WRITE: %c\n", p[0]);
> >         munmap(p, size);
> > 
> > We can see that "AFTER STEAL PRIVATE WRITE: c", not "AFTER STEAL
> > PRIVATE WRITE: s". If we turn off this optimization to a page
> > in page cache, the problem is disappeared.
> 
> Please add this testcase to libhugetlbfs as well.

Okay!

Thanks.

> 
> -- 
> David Gibson			| I'll have my music baroque, and my code
> david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
> 				| _way_ _around_!
> http://www.ozlabs.org/~dgibson


