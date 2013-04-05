Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab3DEJBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 05:01:10 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:61987 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3DEJBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 05:01:06 -0400
Message-ID: <515E92CA.4000507@gmail.com>
Date: Fri, 05 Apr 2013 17:00:58 +0800
From: Simon Jeons <simon.jeons@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Linux Memory Management List <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>,
        Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [RFC][PATCH 0/9] extend hugepage migration
References: <1361475708-25991-1-git-send-email-n-horiguchi@ah.jp.nec.com> <5148F830.3070601@gmail.com> <1363815326-urchkyxr-mutt-n-horiguchi@ah.jp.nec.com> <514A4B1C.6020201@gmail.com> <20130321125628.GB6051@dhcp22.suse.cz> <514B9BD8.9050207@gmail.com> <20130322081532.GC31457@dhcp22.suse.cz> <515E2592.7020607@gmail.com> <20130405080828.GA14882@dhcp22.suse.cz>
In-Reply-To: <20130405080828.GA14882@dhcp22.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,
On 04/05/2013 04:08 PM, Michal Hocko wrote:
> On Fri 05-04-13 09:14:58, Simon Jeons wrote:
>> Hi Michal,
>> On 03/22/2013 04:15 PM, Michal Hocko wrote:
>>> [getting off-list]
>>>
>>> On Fri 22-03-13 07:46:32, Simon Jeons wrote:
>>>> Hi Michal,
>>>> On 03/21/2013 08:56 PM, Michal Hocko wrote:
>>>>> On Thu 21-03-13 07:49:48, Simon Jeons wrote:
>>>>> [...]
>>>>>> When I hacking arch/x86/mm/hugetlbpage.c like this,
>>>>>> diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
>>>>>> index ae1aa71..87f34ee 100644
>>>>>> --- a/arch/x86/mm/hugetlbpage.c
>>>>>> +++ b/arch/x86/mm/hugetlbpage.c
>>>>>> @@ -354,14 +354,13 @@ hugetlb_get_unmapped_area(struct file *file,
>>>>>> unsigned long addr,
>>>>>>
>>>>>> #endif /*HAVE_ARCH_HUGETLB_UNMAPPED_AREA*/
>>>>>>
>>>>>> -#ifdef CONFIG_X86_64
>>>>>> static __init int setup_hugepagesz(char *opt)
>>>>>> {
>>>>>> unsigned long ps = memparse(opt, &opt);
>>>>>> if (ps == PMD_SIZE) {
>>>>>> hugetlb_add_hstate(PMD_SHIFT - PAGE_SHIFT);
>>>>>> - } else if (ps == PUD_SIZE && cpu_has_gbpages) {
>>>>>> - hugetlb_add_hstate(PUD_SHIFT - PAGE_SHIFT);
>>>>>> + } else if (ps == PUD_SIZE) {
>>>>>> + hugetlb_add_hstate(PMD_SHIFT - PAGE_SHIFT+4);
>>>>>> } else {
>>>>>> printk(KERN_ERR "hugepagesz: Unsupported page size %lu M\n",
>>>>>> ps >> 20);
>>>>>>
>>>>>> I set boot=hugepagesz=1G hugepages=10, then I got 10 32MB huge pages.
>>>>>> What's the difference between these pages which I hacking and normal
>>>>>> huge pages?
>>>>> How is this related to the patch set?
>>>>> Please _stop_ distracting discussion to unrelated topics!
>>>>>
>>>>> Nothing personal but this is just wasting our time.
>>>> Sorry kindly Michal, my bad.
>>>> Btw, could you explain this question for me? very sorry waste your time.
>>> Your CPU has to support GB pages. You have removed cpu_has_gbpages test
>>> and added a hstate for order 13 pages which is a weird number on its
>>> own (32MB) because there is no page table level to support them.
>> But after hacking, there is /sys/kernel/mm/hugepages/hugepages-*,
>> and have equal number of 32MB huge pages which I set up in boot
>> parameter.
> because hugetlb_add_hstate creates hstate for those pages and
> hugetlb_init_hstates allocates them later on.
>
>> If there is no page table level to support them, how can
>> them present?
> Because hugetlb hstate handling code doesn't care about page tables and
> the way how those pages are going to be mapped _at all_. Or put it in
> another way. Nobody prevents you to allocate order-5 page for a single
> pte but that would be a pure waste. Page fault code expects that pages
> with a proper size are allocated.
Do you mean 32MB pages will map to one pmd which should map 2MB pages?

