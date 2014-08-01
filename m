Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbaHANA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 09:00:28 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:16208 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323AbaHANA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 09:00:27 -0400
X-IronPort-AV: E=Sophos;i="5.01,780,1400025600"; 
   d="scan'208";a="158449636"
Message-ID: <53DB8F68.3060501@citrix.com>
Date: Fri, 1 Aug 2014 14:00:24 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Vitaly Kuznetsov <vkuznets@redhat.com>
CC: <xen-devel@lists.xenproject.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Andrew Jones <drjones@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 0/4] xen/pvhvm: fix shared_info and pirq issues with
 kexec
References: <1405431640-649-1-git-send-email-vkuznets@redhat.com>	<53D64F07.1070106@citrix.com> <87k36s9z9b.fsf@vitty.brq.redhat.com>
In-Reply-To: <87k36s9z9b.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/14 13:21, Vitaly Kuznetsov wrote:
> David Vrabel <david.vrabel@citrix.com> writes:
> 
>> On 15/07/14 14:40, Vitaly Kuznetsov wrote:
>>> With this patch series I'm trying to address several issues with kexec on pvhvm:
>>> - shared_info issue (1st patch, just sending Olaf's work with Konrad's fix)
>>> - create specific pvhvm shutdown handler for kexec (2nd patch)
>>> - GSI PIRQ issue (3rd patch, I'm pretty confident that it does the right thing)
>>> - MSI PIRQ issue (4th patch, and I'm not sure it doesn't break anything -> RFC)
>>>
>>> This patch series can be tested on single vCPU guest. We still have SMP issues with
>>> pvhvm guests and kexec which require additional fixes.
>>
>> In addition to the fixes for multi-VCPU guests, what else remains?
>>
> 
> I'm aware of grants and ballooned out pages.
> 
>> What's the plan for handling granted pages?
>>
> 
> (if I got the design right) we have two issues:
> 
> 1) Pages we grant access to other domains. We have the list so we can
> try doing gnttab_end_foreign_access for all unmapped grants but there is
> nothing we can do with mapped ones from guest. We can either assume that
> all such usages are short-term and try waiting for them to finish or we
> need to do something like force-unmap from hypervisor side.

Shared rings and persistent grants (used in blkfront) remain mapped for
long periods so just waiting won't work.

Force unmap by the hypervisor might be a possibility but the hypervisor
needs to atomically replace the grant mapping with a different valid
mapping, or the force unmap would cause the backend that was accesses
the pages to fault.

Every writable mapping would have to be replaced with a mapping to a
unique page (to prevent information leaking between different granted
pages).  Read-only mappings could be replaces with a read-only mapping
to shared zero page safely.

The only way I can see how to do this requires co-operation from the
backend kernel -- it would need to provide replacement frames for every
grant map.  Xen would then use this frame when force-unmapping
(revoking) the mapping.

> 2) Pages we mapped from other domains. There is no easy way to collect
> all grant handles from different places in kernel atm so I can see two
> possible solutions:
> - we keep track of all handles with new kernel structure in guest and
> unmap them all on kexec/kdump.
> - we introduce new GNTTABOP_reset which does something similar to
> gnttab_release_mappings().

I think you can ignore this for now -- frontend drivers do not grant
map, but see suggestion about kexec_is_safe below.

> There is nothing we need to do with transferred grants (and I don't see
> transfer usages in kernel).

Agreed.

>> I don't think we want to accept a partial solution unless the known
>> non-working configurations fail fast on kexec load.
> 
> *I think* we can leave ballooned out pages out of scope for now.

I'm thinking we want a global flag (kexec_is_safe) that is cleared even
any unsafe operation (e.g., ballooning, grant mapping) is done by the
guest.  kexec load and exec can then be made to fail if this flag is clear.

This would allow you to fix only the use cases you're interested in
without introducing subtle failures if someone tries an unsupported
configurations.

David
