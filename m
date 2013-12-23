Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab3LWBFE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 20:05:04 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:62668 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362Ab3LWBFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 20:05:02 -0500
X-AuditID: 9c93017d-b7c2eae000004ec2-e5-52b78c3c3ec2
Date: Mon, 23 Dec 2013 10:05:17 +0900
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
Subject: Re: [PATCH v3 03/14] mm, hugetlb: protect region tracking via newly
 introduced resv_map lock
Message-ID: <20131223010517.GB19388@lge.com>
References: <1387349640-8071-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1387349640-8071-4-git-send-email-iamjoonsoo.kim@lge.com>
 <20131221135819.GB12407@voom.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131221135819.GB12407@voom.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 22, 2013 at 12:58:19AM +1100, David Gibson wrote:
> On Wed, Dec 18, 2013 at 03:53:49PM +0900, Joonsoo Kim wrote:
> > There is a race condition if we map a same file on different processes.
> > Region tracking is protected by mmap_sem and hugetlb_instantiation_mutex.
> > When we do mmap, we don't grab a hugetlb_instantiation_mutex, but,
> > grab a mmap_sem. This doesn't prevent other process to modify region
> > structure, so it can be modified by two processes concurrently.
> > 
> > To solve this, I introduce a lock to resv_map and make region manipulation
> > function grab a lock before they do actual work. This makes region
> > tracking safe.
> 
> It's not clear to me if you're saying there is a list corruption race
> bug in the existing code, or only that there will be if the
> instantiation mutex goes away.

Hello,

The race exists in current code.
Currently, region tracking is protected by either down_write(&mm->mmap_sem) or
down_read(&mm->mmap_sem) + instantiation mutex. But if we map this hugetlbfs
file to two different processes, holding a mmap_sem doesn't have any impact on
the other process and concurrent access to data structure is possible.

Thanks.
