Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675Ab3DBX6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:58:33 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:54560 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab3DBX6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 19:58:32 -0400
Message-ID: <515B70A1.3040200@gmail.com>
Date: Wed, 03 Apr 2013 07:58:25 +0800
From: Simon Jeons <simon.jeons@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Zhouping Liu <zliu@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Amos Kong <akong@redhat.com>
Subject: Re: THP: AnonHugePages in /proc/[pid]/smaps is correct or not?
References: <383590596.664138.1364803227470.JavaMail.root@redhat.com> <alpine.DEB.2.02.1304011512490.17714@chino.kir.corp.google.com> <515ACDC9.2090506@gmail.com> <alpine.DEB.2.02.1304021106190.17138@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1304021106190.17138@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,
On 04/03/2013 02:09 AM, David Rientjes wrote:
> On Tue, 2 Apr 2013, Simon Jeons wrote:
>
>> Both thp and hugetlb pages should be 2MB aligned, correct?
>>
> To answer this question and your followup reply at the same time: they
> come from one level higher in the page table so they will naturally need
> to be 2MB aligned.

When I hacking arch/x86/mm/hugetlbpage.c like this,
diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
index ae1aa71..87f34ee 100644
--- a/arch/x86/mm/hugetlbpage.c
+++ b/arch/x86/mm/hugetlbpage.c
@@ -354,14 +354,13 @@ hugetlb_get_unmapped_area(struct file *file,
unsigned long addr,

#endif /*HAVE_ARCH_HUGETLB_UNMAPPED_AREA*/

-#ifdef CONFIG_X86_64
static __init int setup_hugepagesz(char *opt)
{
unsigned long ps = memparse(opt, &opt);
if (ps == PMD_SIZE) {
hugetlb_add_hstate(PMD_SHIFT - PAGE_SHIFT);
- } else if (ps == PUD_SIZE && cpu_has_gbpages) {
- hugetlb_add_hstate(PUD_SHIFT - PAGE_SHIFT);
+ } else if (ps == PUD_SIZE) {
+ hugetlb_add_hstate(PMD_SHIFT - PAGE_SHIFT+4);
} else {
printk(KERN_ERR "hugepagesz: Unsupported page size %lu M\n",
ps >> 20);

I set boot=hugepagesz=1G hugepages=10, then I got 10 32MB huge pages.
What's the difference between these pages which I hacking and normal
huge pages?
