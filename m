Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab3LDJHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:07:19 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46855 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab3LDJHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 04:07:03 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <529EF070.4080800@jp.fujitsu.com>
Date: Wed, 04 Dec 2013 18:05:52 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>
Subject: Re: [PATCH] vmcore: call remap_pfn_range() separately for respective
 partial pages
References: <52970342.8090302@jp.fujitsu.com> <20131202152754.GC18642@redhat.com> <529D3158.2080603@jp.fujitsu.com> <529D6933.9070609@jp.fujitsu.com> <20131203151247.GD4251@redhat.com>
In-Reply-To: <20131203151247.GD4251@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/04 0:12), Vivek Goyal wrote:
> On Tue, Dec 03, 2013 at 02:16:35PM +0900, HATAYAMA Daisuke wrote:
>
> [..]
>>> Even if copying partial pages into the 2nd kernel, we need to use ioremap()
>>> once on them, and I think the ioremap() is exactly similar to
>>> remap_pfn_range() for a single page. There seems no difference on safeness
>>> between them.
>>>
>>
>> I suspected some kind of pre-fetching could be performed when just page table
>> is created. But it's common thing between the two cases above. Then, as you say,
>> it would be safer to read less data from non-System-RAM area. Copying seems
>> better in our case.
>
> If we map page and just read *only* those bytes as advertized by ELF
> headers and fill rest of the bytes with zero, I think that seems like
> a right thing to do. We are only accessing what has been exported by
> ELF headers and not trying to read outside that range.
>
>>
>> Another concern to reading data from partial pages is a possibility of
>> undesirable hardware prefetch to non-System-RAM area. Is it better to disable this?
>
> If it becomes an issue, may be. I think we can fix it when we run into
> an actual issue.
>

I see.

>>
>>> Also, current /proc/vmcore shows user-land tools a shape with holes not
>>> filled with zeros both in case of read() and in case of mmap(). If we adapt
>>> copying one without reading data in holes, shape of /proc/vmcore gets
>>> changed again.
>>>
>>
>> So, next patch will change data in holes by filling them with zeros.
>>
>> BTW, we have now page cache interface implemented by Michael Holzheu, but
>> we have yet to use it on x86 because we've never wanted it so far. It's
>> natural to use it to read partial pages on-demand, but I also in part think
>> that it's not proper time to start using new mechanism that needs to be tested
>> more. How do you think?
>
> Do we gain anything significant by using that interface. To me it looks
> like this will just delay creation of mapping for partial pages. Does not
> save us any memory in second kernel?
>

Amount of partial pages seems not so problematic.
No, the number of partial pages are at most the number of System RAM entries * 2.
I guess the number of the entries doesn't exceed 100 even in the worst case.
Less than 1MiB even in the worst case.

The mechanism would be useful for platform that has large amount of note segment.
But per-cpu note segemnt of x86 is relatively small, so meaningful platform seems
the ones with a large number of cpus and they are still restrictive. Other archs
that has large per-cpu note segment would already want the feature, just as
Michael Holzheu explained previously for some of their s390 platform.

> I would think that in first pass, keep it simple. Copy partial pages in
> second kernel's memory. Read data as exported by ELF headers. Fill rest
> of the page with zeros. Adjust /proc/vmcore ELF headers accordingly and
> that should do it.
>

Yes, I also want to keep simplicity. I'll post a new patch tomorrow.

-- 
Thanks.
HATAYAMA, Daisuke

