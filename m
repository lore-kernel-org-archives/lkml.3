Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbaCFWyY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 17:54:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbaCFWyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 17:54:22 -0500
Message-ID: <5318FC3F.4080204@redhat.com>
Date: Thu, 06 Mar 2014 17:52:47 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, mgorman@suse.de,
        hhuang@redhat.com, knoel@redhat.com, aarcange@redhat.com
Subject: Re: [PATCH -mm] mm,numa,mprotect: always continue after finding a
 stable thp page
References: <5318E4BC.50301@oracle.com> <20140306173137.6a23a0b2@cuia.bos.redhat.com>
In-Reply-To: <20140306173137.6a23a0b2@cuia.bos.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 05:31 PM, Rik van Riel wrote:
> On Thu, 06 Mar 2014 16:12:28 -0500
> Sasha Levin <sasha.levin@oracle.com> wrote:
>
>> While fuzzing with trinity inside a KVM tools guest running latest -next kernel I've hit the
>> following spew. This seems to be introduced by your patch "mm,numa: reorganize change_pmd_range()".
>
> That patch should not introduce any functional changes, except for
> the VM_BUG_ON that catches the fact that we fell through to the 4kB
> pte handling code, despite having just handled a THP pmd...
>
> Does this patch fix the issue?
>
> Mel, am I overlooking anything obvious? :)
>
> ---8<---
>
> Subject: mm,numa,mprotect: always continue after finding a stable thp page
>
> When turning a thp pmds into a NUMA one, change_huge_pmd will
> return 0 when the pmd already is a NUMA pmd.

I did miss something obvious.  In this case, the code returns 1.

> However, change_pmd_range would fall through to the code that
> handles 4kB pages, instead of continuing on to the next pmd.

Maybe the case that I missed is when khugepaged is in the
process of collapsing pages into a transparent huge page?

If the virtual CPU gets de-scheduled by the host for long
enough, it would be possible for khugepaged to run on
another virtual CPU, and turn the pmd into a THP pmd,
before that VM_BUG_ON test.

I see that khugepaged takes the mmap_sem for writing in the
collapse code, and it looks like task_numa_work takes the
mmap_sem for reading, so I guess that may not be possible?

Andrea, would you happen to know what case am I missing?
