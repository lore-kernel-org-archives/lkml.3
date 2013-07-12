Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870Ab3GLLGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 07:06:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33081 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932525Ab3GLLGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 07:06:14 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <51DFE2FB.2000804@jp.fujitsu.com>
Date: Fri, 12 Jul 2013 20:05:31 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, kexec@lists.infradead.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jan Willeke <willeke@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/5] vmcore: Introduce remap_oldmem_pfn_range()
References: <1372707159-10425-1-git-send-email-holzheu@linux.vnet.ibm.com> <1372707159-10425-4-git-send-email-holzheu@linux.vnet.ibm.com> <51DA4ED9.60903@jp.fujitsu.com> <20130708112839.498ccfc6@holzheu> <20130708142826.GA9094@redhat.com> <51DBA47C.8090708@jp.fujitsu.com> <20130710104252.479a0f92@holzheu> <51DD2E5A.1030200@jp.fujitsu.com> <20130710143309.GD5819@redhat.com>
In-Reply-To: <20130710143309.GD5819@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/10 23:33), Vivek Goyal wrote:
> On Wed, Jul 10, 2013 at 06:50:18PM +0900, HATAYAMA Daisuke wrote:
>
> [..]
>> If you want to avoid looking up vmcore_list that takes linear time w.r.t. the number
>> of the elements, you can still calculate the range of offsets in /proc/vmcore
>> corresponding to HSA during /proc/vmcore initialization.
>>
>> Also, could you tell me how often and how much the HSA region is during crash dumping?
>> I guess the read to HSA is done mainly during early part of crash dumping process only.
>> According to the code, it appears at most 64MiB only. Then, I feel performance is not
>> a big issue.
>>
>> Also, cost of WARN_ONCE() is one memory access only in the 2nd and later calls. I don't
>> think it too much overhead...
>
> Hi Hatayama,
>
> I think michael's proposal of just putting in WARN_ONCE for non s390 arch
> sounds reasonable. It is simple and meets your need of being able to
> detect that non s390 arch don't make use of mmap() path yet. Introducing
> in_valid_fault_range() kind of sounds overkill to me for this issue.
>
> Thanks
> Vivek
>

How about

static int mmap_vmcore_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
{
...
         char *buf;
         int rc;

#ifndef CONFIG_S390
         return VM_FAULT_SIGBUS;
#endif
         page = find_or_create_page(mapping, index, GFP_KERNEL);

Considering again, I don't think WARN_ONCE() is good now. The fact that fault occurs on
mmap() region indicates some kind of buggy situation occurs on the process. The process
should be killed as soon as possible. If user still wants to get crash dump, he should
try again in another process.

-- 
Thanks.
HATAYAMA, Daisuke

