Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162417Ab3DEScM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 14:32:12 -0400
Received: from mail-ye0-f174.google.com ([209.85.213.174]:34171 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162396Ab3DEScK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 14:32:10 -0400
Message-ID: <515F18A8.7030102@gmail.com>
Date: Fri, 05 Apr 2013 14:32:08 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Michal Hocko <mhocko@suse.cz>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kosaki.motohiro@gmail.com
Subject: Re: [PATCH v3 1/3] hugetlbfs: stop setting VM_DONTDUMP in initializing
 vma(VM_HUGETLB)
References: <1365014138-19589-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1365014138-19589-2-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1365014138-19589-2-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/3/13 2:35 PM), Naoya Horiguchi wrote:
> Currently we fail to include any data on hugepages into coredump,
> because VM_DONTDUMP is set on hugetlbfs's vma. This behavior was recently
> introduced by commit 314e51b98 "mm: kill vma flag VM_RESERVED and
> mm->reserved_vm counter". This looks to me a serious regression,
> so let's fix it.

I don't think this is enough explanations. Let's explain the code meaning
time to time order.

First, we had no madvice(DONTDUMP) nor coredump_filter(HUGETLB). then hugetlb
pages were never dumped.

Second, I added coredump_filter(HUGETLB). and then vm_dump_size became..

vm_dump_size()
{
	/* Hugetlb memory check */
	if (vma->vm_flags & VM_HUGETLB) {
		..
		goto whole;
	}
	if (vma->vm_flags & VM_RESERVED)
		return 0;

The point is, hugetlb was checked before VM_RESERVED. i.e. hugetlb core dump ignored
VM_RESERVED. At this time, "if (vma->vm_flags & VM_HUGETLB)" statement don't need
return 0 because VM_RESERVED prevented to go into the subsequent flag checks.

Third, Jason added madvise(DONTDUMP). then vm_dump_size became...

vm_dump_size()
{
       if (vma->vm_flags & VM_NODUMP)
               return 0;

	/* Hugetlb memory check */
	if (vma->vm_flags & VM_HUGETLB) {
		..
		goto whole;
	}
	if (vma->vm_flags & VM_RESERVED)
		return 0;

Look, VM_NODUMP and VM_RESERVED had similar and different meanings at this time.

Finally, Konstantin removed VM_RESERVED and hugetlb coredump behavior
has been changed.

Thus, patch [1/3] and [2/3] should be marked [stable for v3.6 or later].

Anyway, this patch is correct. Thank you!

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


