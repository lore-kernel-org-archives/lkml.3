Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab3G2GSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 02:18:23 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49668 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab3G2GSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 02:18:21 -0400
X-AuditID: 9c930179-b7c49ae000000e68-ce-51f6092cd9ca
Date: Mon, 29 Jul 2013 15:18:20 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>,
        "AneeshKumarK.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hillf Danton <dhillf@gmail.com>, Hugh Dickins <hughd@google.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric B Munson <emunson@mgebm.net>, Anton Blanchard <anton@samba.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] hugepage: optimize page fault path locking
Message-ID: <20130729061820.GA4784@lge.com>
References: <1374848845-1429-1-git-send-email-davidlohr.bueso@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374848845-1429-1-git-send-email-davidlohr.bueso@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 07:27:23AM -0700, Davidlohr Bueso wrote:
> This patchset attempts to reduce the amount of contention we impose
> on the hugetlb_instantiation_mutex by replacing the global mutex with
> a table of mutexes, selected based on a hash. The original discussion can 
> be found here: http://lkml.org/lkml/2013/7/12/428

Hello, Davidlohr.

I recently sent a patchset which remove the hugetlb_instantiation_mutex
entirely ('mm, hugetlb: remove a hugetlb_instantiation_mutex').
This patchset can be found here: https://lkml.org/lkml/2013/7/29/54

If possible, could you review it and test it whether your problem is
disappered with it or not?

Thanks.

> 
> Patch 1: Allows the file region tracking list to be serialized by its own rwsem.
> This is necessary because the next patch allows concurrent hugepage fault paths,
> getting rid of the hugetlb_instantiation_mutex - which protects chains of struct 
> file_regionin inode->i_mapping->private_list (VM_MAYSHARE) or vma_resv_map(vma)->regions 
> (!VM_MAYSHARE).
> 
> Patch 2: From David Gibson, for some reason never made it into the kernel. 
> Further cleanups and enhancements from Anton Blanchard and myself.
> Details of how the hash key is selected is in the patch.
> 
> Davidlohr Bueso (2):
>   hugepage: protect file regions with rwsem
>   hugepage: allow parallelization of the hugepage fault path
> 
>  mm/hugetlb.c | 134 ++++++++++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 106 insertions(+), 28 deletions(-)
> 
> -- 
> 1.7.11.7
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
