Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965504AbaGPPrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 11:47:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33229 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965166AbaGPPre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 11:47:34 -0400
Message-ID: <53C69E92.70608@suse.cz>
Date: Wed, 16 Jul 2014 17:47:30 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bob Liu <bob.liu@oracle.com>, David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v2] mm, tmp: only collapse hugepages to nodes with affinity
 for zone_reclaim_mode
References: <alpine.DEB.2.02.1407141807030.8808@chino.kir.corp.google.com> <alpine.DEB.2.02.1407151712520.12279@chino.kir.corp.google.com> <53C5D3D2.8080000@oracle.com>
In-Reply-To: <53C5D3D2.8080000@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 03:22 AM, Bob Liu wrote:
>> @@ -2545,6 +2571,11 @@ static int khugepaged_scan_pmd(struct mm_struct *mm,
>>  		 * hit record.
>>  		 */
>>  		node = page_to_nid(page);
>> +		if (node != last_node) {
>> +			if (khugepaged_scan_abort(node))
>> +				goto out_unmap;
> 
> Nitpick: How about not break the loop but only reset the related
> khugepaged_node_load[] to zero. E.g. modify khugepaged_scan_abort() like
> this:
> if (node_distance(nid, i) > RECLAIM_DISTANCE)
>    khugepaged_node_load[i] = 0;
> 
> By this way, we may have a chance to find a more suitable node.

Hm theoretically there might be a suitable node, but this approach wouldn't
work. By resetting it to zero you forget that there ever was node 'i'. If there
is no more base page from node 'i', the load remains zero and the next call with
'nid' will think that 'nid' is OK.

So the correct way would be more complex but I wonder if it's worth the trouble...

>> +			last_node = node;
>> +		}
>>  		khugepaged_node_load[node]++;
>>  		VM_BUG_ON_PAGE(PageCompound(page), page);
>>  		if (!PageLRU(page) || PageLocked(page) || !PageAnon(page))
>> 
> 

