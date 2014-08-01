Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbaHAMVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 08:21:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881AbaHAMVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 08:21:35 -0400
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: <xen-devel@lists.xenproject.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Andrew Jones <drjones@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 0/4] xen/pvhvm: fix shared_info and pirq issues with kexec
References: <1405431640-649-1-git-send-email-vkuznets@redhat.com>
	<53D64F07.1070106@citrix.com>
Date: Fri, 01 Aug 2014 14:21:20 +0200
In-Reply-To: <53D64F07.1070106@citrix.com> (David Vrabel's message of "Mon, 28
	Jul 2014 14:24:23 +0100")
Message-ID: <87k36s9z9b.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Vrabel <david.vrabel@citrix.com> writes:

> On 15/07/14 14:40, Vitaly Kuznetsov wrote:
>> With this patch series I'm trying to address several issues with kexec on pvhvm:
>> - shared_info issue (1st patch, just sending Olaf's work with Konrad's fix)
>> - create specific pvhvm shutdown handler for kexec (2nd patch)
>> - GSI PIRQ issue (3rd patch, I'm pretty confident that it does the right thing)
>> - MSI PIRQ issue (4th patch, and I'm not sure it doesn't break anything -> RFC)
>> 
>> This patch series can be tested on single vCPU guest. We still have SMP issues with
>> pvhvm guests and kexec which require additional fixes.
>
> In addition to the fixes for multi-VCPU guests, what else remains?
>

I'm aware of grants and ballooned out pages.

> What's the plan for handling granted pages?
>

(if I got the design right) we have two issues:

1) Pages we grant access to other domains. We have the list so we can
try doing gnttab_end_foreign_access for all unmapped grants but there is
nothing we can do with mapped ones from guest. We can either assume that
all such usages are short-term and try waiting for them to finish or we
need to do something like force-unmap from hypervisor side.

2) Pages we mapped from other domains. There is no easy way to collect
all grant handles from different places in kernel atm so I can see two
possible solutions:
- we keep track of all handles with new kernel structure in guest and
unmap them all on kexec/kdump.
- we introduce new GNTTABOP_reset which does something similar to
gnttab_release_mappings().

There is nothing we need to do with transferred grants (and I don't see
transfer usages in kernel).

Please correct me if I'm wrong.

> I don't think we want to accept a partial solution unless the known
> non-working configurations fail fast on kexec load.

*I think* we can leave ballooned out pages out of scope for now.

Thanks,

>
> David

-- 
  Vitaly
