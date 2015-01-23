Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbbAWO5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:57:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbbAWO51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:57:27 -0500
Message-ID: <54C2613F.6080403@redhat.com>
Date: Fri, 23 Jan 2015 09:57:03 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Ebru Akagunduz <ebru.akagunduz@gmail.com>
CC: linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@suse.cz,
        mgorman@suse.de, rientjes@google.com, sasha.levin@oracle.com,
        hughd@google.com, hannes@cmpxchg.org, vbabka@suse.cz,
        linux-kernel@vger.kernel.org, aarcange@redhat.com
Subject: Re: [PATCH] mm: incorporate read-only pages into transparent huge
 pages
References: <1421999256-3881-1-git-send-email-ebru.akagunduz@gmail.com> <20150123113701.GB5975@node.dhcp.inet.fi>
In-Reply-To: <20150123113701.GB5975@node.dhcp.inet.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2015 06:37 AM, Kirill A. Shutemov wrote:
> On Fri, Jan 23, 2015 at 09:47:36AM +0200, Ebru Akagunduz wrote:
>> This patch aims to improve THP collapse rates, by allowing
>> THP collapse in the presence of read-only ptes, like those
>> left in place by do_swap_page after a read fault.
>>
>> Currently THP can collapse 4kB pages into a THP when
>> there are up to khugepaged_max_ptes_none pte_none ptes
>> in a 2MB range. This patch applies the same limit for
>> read-only ptes.

>> @@ -2179,6 +2179,17 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>  		 */
>>  		if (!trylock_page(page))
>>  			goto out;
>> +		if (!pte_write(pteval)) {
>> +			if (PageSwapCache(page) && !reuse_swap_page(page)) {
>> +					unlock_page(page);
>> +					goto out;
>> +			}
>> +			/*
>> +			 * Page is not in the swap cache, and page count is
>> +			 * one (see above). It can be collapsed into a THP.
>> +			 */
>> +		}
> 
> Hm. As a side effect it will effectevely allow collapse in PROT_READ vmas,
> right? I'm not convinced it's a good idea.

It will only allow a THP collapse if there is at least one
read-write pte.

I suspect that excludes read-only VMAs automatically.
