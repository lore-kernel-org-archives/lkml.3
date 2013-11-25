Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab3KYJCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:02:48 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44489 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab3KYJCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:02:34 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <529311F1.90603@jp.fujitsu.com>
Date: Mon, 25 Nov 2013 18:01:37 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
CC: Vivek Goyal <vgoyal@redhat.com>, "bhe@redhat.com" <bhe@redhat.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "dyoung@redhat.com" <dyoung@redhat.com>,
        "chaowang@redhat.com" <chaowang@redhat.com>
Subject: Re: /proc/vmcore mmap() failure issue
References: <5284A689.70903@jp.fujitsu.com> <20131114151359.GA3913@redhat.com> <5285EC60.1060906@jp.fujitsu.com> <20131115142617.GC6637@redhat.com> <0910DD04CBD6DE4193FCF86B9C00BE971BF592@BPXM01GP.gisp.nec.co.jp> <20131118135511.GA30637@redhat.com> <0910DD04CBD6DE4193FCF86B9C00BE971C3862@BPXM01GP.gisp.nec.co.jp> <20131120145901.GB27924@redhat.com> <0910DD04CBD6DE4193FCF86B9C00BE971C43E3@BPXM01GP.gisp.nec.co.jp> <528DC4F2.5040000@jp.fujitsu.com> <20131121165237.GG16208@redhat.com> <0910DD04CBD6DE4193FCF86B9C00BE971C5AB3@BPXM01GP.gisp.nec.co.jp>
In-Reply-To: <0910DD04CBD6DE4193FCF86B9C00BE971C5AB3@BPXM01GP.gisp.nec.co.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/25 17:10), Atsushi Kumagai wrote:
> On 2013/11/22 1:53:14, kexec <kexec-bounces@lists.infradead.org> wrote:
>> On Thu, Nov 21, 2013 at 05:31:46PM +0900, HATAYAMA Daisuke wrote:
>>
>> [..]
>>>> So I think the patch I sent is enough, the policy will be simpler as
>>>> "Don't use mmap() for buggy kernels".
>>>>
>>>> [PATCH] Fall back to read() when mmap() fails.
>>>> http://lists.infradead.org/pipermail/kexec/2013-November/010199.html
>>>>
>>>
>>> I think logic becomes not so complex. For example, if input vmcore
>>> format is ELF, then:
>>>
>>> o in update_mmap_range():
>>>    - first calculate a range of the corresponding PT_LOAD entry truncated with
>>>      PAGE_SIZE.
>>>    - Then, truncate range of mmap() by the truncated range of the corresponding
>>>      PT_LOAD entry, i.e., exlucde partial pages from mmap() target range.
>>>    - Then determine offsets of two partial pages; the number of partial pages
>>>      are always at most two. The offsets can easily be calculated from the
>>>      original range of the corresponding PT_LOAD entry
>>>
>>> o in read_from_vmcore(), if a given offset belongs to either of two partial
>>>    pages, then go to read() path; if not, go to mmap() path.
>>
>> I agree that we should do mmap() on all non-partial pages and do read()
>> on all partial pages. Otherwise we lose the benefit of faster speed of
>> mmap().
> 
> I agree to avoid this issue by fixing makedumpfile as workaround while to
> fix kernel is so tough and risky. However, it sounds strange to me to fix
> userspace side elaborately for such definite kernel issue whose cause is
> known, so we should fix the kernel itself.
> 

> Otherwise, will you continue to add specific fixes into user tools to
> address kernel issues like this case ?
> 

makedumpfile supports a wide range of kernel versions and needs to satisfy
backward compatibility. mmap() on /proc/vmcore might be backported to some of
the old versions on some distributions if necessary. Then, it's hard to fix
each old kernel at each back port. The method that can be applied to all the
kernels in general, is necessary.

Also, looking at ia64 case where there's boot loader data on partial pages,
there could be other environments where partial pages contain other important
data other components have. So, the issue depends not only on kernels but also
other components such as boot loader and firmwares that can put data on
partial pages. We need to get there as long as there's important data there
and we have access to there.

-- 
Thanks.
HATAYAMA, Daisuke

