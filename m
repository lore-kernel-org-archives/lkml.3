Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab3A2DGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 22:06:55 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:55377 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3A2DGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 22:06:53 -0500
Message-ID: <51073CC3.8030105@linux.vnet.ibm.com>
Date: Tue, 29 Jan 2013 11:06:43 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] kvm: IOMMU read-only mapping support
References: <20130124220027.11061.76400.stgit@bling.home> <20130125101704.b76b049d.yoshikawa_takuya_b1@lab.ntt.co.jp> <5101FBE8.9000206@linux.vnet.ibm.com> <20130128105903.GA22871@redhat.com>
In-Reply-To: <20130128105903.GA22871@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012902-9264-0000-0000-00000312AF5E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2013 06:59 PM, Gleb Natapov wrote:
> On Fri, Jan 25, 2013 at 11:28:40AM +0800, Xiao Guangrong wrote:
>> On 01/25/2013 09:17 AM, Takuya Yoshikawa wrote:
>>> On Thu, 24 Jan 2013 15:03:57 -0700
>>> Alex Williamson <alex.williamson@redhat.com> wrote:
>>>
>>>> A couple patches to make KVM IOMMU support honor read-only mappings.
>>>> This causes an un-map, re-map when the read-only flag changes and
>>>> makes use of it when setting IOMMU attributes.  Thanks,
>>>
>>> Looks good to me.
>>>
>>> I think I can naturally update my patch after this gets merged.
>>>
>>
>> Please wait.
>>
>> The commit c972f3b1 changed the write-protect behaviour - it does
>> wirte-protection only when dirty flag is set.
>> [ I did not see this commit when we discussed the problem before. ]
>>
>> Further more, i notice that write-protect is not enough, when do sync
>> shadow page:
>>
>> FNAME(sync_page):
>>
>> 		host_writable = sp->spt[i] & SPTE_HOST_WRITEABLE;
>>
>> 		set_spte(vcpu, &sp->spt[i], pte_access,
>> 			 PT_PAGE_TABLE_LEVEL, gfn,
>> 			 spte_to_pfn(sp->spt[i]), true, false,
>> 			 host_writable);
>>
>> It sets spte based on the old value that means the readonly flag check
>> is missed. We need to call kvm_arch_flush_shadow_all under this case.
> Why not just disallow changing memory region KVM_MEM_READONLY flag
> without deleting the region?

It will introduce some restriction when VM-sharing-mem is being implemented,
but we need to do some optimization for it, at least, properly write-protect
readonly pages (fix sync_page()) instead of zap_all_page.

So, i guess we can do the simple fix first.




