Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab3AYD2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 22:28:53 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:41002 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab3AYD2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 22:28:48 -0500
Message-ID: <5101FBE8.9000206@linux.vnet.ibm.com>
Date: Fri, 25 Jan 2013 11:28:40 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
CC: Alex Williamson <alex.williamson@redhat.com>, gleb@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] kvm: IOMMU read-only mapping support
References: <20130124220027.11061.76400.stgit@bling.home> <20130125101704.b76b049d.yoshikawa_takuya_b1@lab.ntt.co.jp>
In-Reply-To: <20130125101704.b76b049d.yoshikawa_takuya_b1@lab.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012503-5816-0000-0000-000006673300
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2013 09:17 AM, Takuya Yoshikawa wrote:
> On Thu, 24 Jan 2013 15:03:57 -0700
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
>> A couple patches to make KVM IOMMU support honor read-only mappings.
>> This causes an un-map, re-map when the read-only flag changes and
>> makes use of it when setting IOMMU attributes.  Thanks,
> 
> Looks good to me.
> 
> I think I can naturally update my patch after this gets merged.
> 

Please wait.

The commit c972f3b1 changed the write-protect behaviour - it does
wirte-protection only when dirty flag is set.
[ I did not see this commit when we discussed the problem before. ]

Further more, i notice that write-protect is not enough, when do sync
shadow page:

FNAME(sync_page):

		host_writable = sp->spt[i] & SPTE_HOST_WRITEABLE;

		set_spte(vcpu, &sp->spt[i], pte_access,
			 PT_PAGE_TABLE_LEVEL, gfn,
			 spte_to_pfn(sp->spt[i]), true, false,
			 host_writable);

It sets spte based on the old value that means the readonly flag check
is missed. We need to call kvm_arch_flush_shadow_all under this case.

