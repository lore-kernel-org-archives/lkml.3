Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbaHDPtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 11:49:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbaHDPtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 11:49:18 -0400
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: <xen-devel@lists.xenproject.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Andrew Jones <drjones@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 0/4] xen/pvhvm: fix shared_info and pirq issues with kexec
References: <1405431640-649-1-git-send-email-vkuznets@redhat.com>
	<53D64F07.1070106@citrix.com> <87k36s9z9b.fsf@vitty.brq.redhat.com>
	<53DB8F68.3060501@citrix.com>
Date: Mon, 04 Aug 2014 17:44:05 +0200
Message-ID: <874mxs6z0a.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Vrabel <david.vrabel@citrix.com> writes:

> On 01/08/14 13:21, Vitaly Kuznetsov wrote:
>> David Vrabel <david.vrabel@citrix.com> writes:
>> 
>>> On 15/07/14 14:40, Vitaly Kuznetsov wrote:
>>>> With this patch series I'm trying to address several issues with kexec on pvhvm:
>>>> - shared_info issue (1st patch, just sending Olaf's work with Konrad's fix)
>>>> - create specific pvhvm shutdown handler for kexec (2nd patch)
>>>> - GSI PIRQ issue (3rd patch, I'm pretty confident that it does the right thing)
>>>> - MSI PIRQ issue (4th patch, and I'm not sure it doesn't break anything -> RFC)
>>>>
>>>> This patch series can be tested on single vCPU guest. We still have SMP issues with
>>>> pvhvm guests and kexec which require additional fixes.
>>>
>>> In addition to the fixes for multi-VCPU guests, what else remains?
>>>
>> 
>> I'm aware of grants and ballooned out pages.
>> 
>>> What's the plan for handling granted pages?
>>>
>> 
>> (if I got the design right) we have two issues:
>> 
>> 1) Pages we grant access to other domains. We have the list so we can
>> try doing gnttab_end_foreign_access for all unmapped grants but there is
>> nothing we can do with mapped ones from guest. We can either assume that
>> all such usages are short-term and try waiting for them to finish or we
>> need to do something like force-unmap from hypervisor side.
>
> Shared rings and persistent grants (used in blkfront) remain mapped for
> long periods so just waiting won't work.
>
> Force unmap by the hypervisor might be a possibility but the hypervisor
> needs to atomically replace the grant mapping with a different valid
> mapping, or the force unmap would cause the backend that was accesses
> the pages to fault.
>
> Every writable mapping would have to be replaced with a mapping to a
> unique page (to prevent information leaking between different granted
> pages).  Read-only mappings could be replaces with a read-only mapping
> to shared zero page safely.
>
> The only way I can see how to do this requires co-operation from the
> backend kernel -- it would need to provide replacement frames for every
> grant map.  Xen would then use this frame when force-unmapping
> (revoking) the mapping.

We can introduce something like GNTTABOP_safe_map_grant_ref op with such
replacement frames and use then in 'force unmap' but to be honest I'd
like to avoid that.. What if xen could allocate and provide replacement
pages on its own? I understand we need to take some precautions against
malicious domains hogging all memory with such approach..

Actually if we narrow down our case to backend/frontend usage only we
can think that grants do not introduce any issue for kexec/kdump because:
- frontends are being closed on kexec so backends unmap corresponding
grants. That's not true for persistent grant case as persistent grants
are being unmaped only in xen_blkif_free() but not in
xen_blkif_disconnect() atm. The following patch helps:

diff --git a/drivers/block/xen-blkback/xenbus.c
b/drivers/block/xen-blkback/xenbus.c
index 3a8b810..54f4089 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -270,6 +270,9 @@ static int xen_blkif_disconnect(struct xen_blkif
*blkif)
                blkif->blk_rings.common.sring = NULL;
        }
 
+       /* Remove all persistent grants and the cache of ballooned
pages. */
+       xen_blkbk_free_caches(blkif);
+
        return 0;
 }
 
@@ -281,9 +284,6 @@ static void xen_blkif_free(struct xen_blkif *blkif)
        xen_blkif_disconnect(blkif);
        xen_vbd_free(&blkif->vbd);
 
-       /* Remove all persistent grants and the cache of ballooned
        pages. */
-       xen_blkbk_free_caches(blkif);
-
        /* Make sure everything is drained before shutting down */
        BUG_ON(blkif->persistent_gnt_c != 0);
        BUG_ON(atomic_read(&blkif->persistent_gnt_in_use) != 0);


- in kdump case our new kernel lives in its own space so we won't hit
granted pages (we can read some crap when collecting memory dump but
it's not any better in case these pages were unmapped)

- frontends are being reinitialized on new kernel startup, that also
causes the unmap (with the patch from above applied).

So I think we need to do something with grants in two cases: they were
used outside frontends/backends and we have no idea if they are going to
be unmapped (can be solved with kexec_is_safe flag) and when backend got
stuck and refused to close/unmap (should be rare).

>
>> 2) Pages we mapped from other domains. There is no easy way to collect
>> all grant handles from different places in kernel atm so I can see two
>> possible solutions:
>> - we keep track of all handles with new kernel structure in guest and
>> unmap them all on kexec/kdump.
>> - we introduce new GNTTABOP_reset which does something similar to
>> gnttab_release_mappings().
>
> I think you can ignore this for now -- frontend drivers do not grant
> map, but see suggestion about kexec_is_safe below.
>
>> There is nothing we need to do with transferred grants (and I don't see
>> transfer usages in kernel).
>
> Agreed.
>
>>> I don't think we want to accept a partial solution unless the known
>>> non-working configurations fail fast on kexec load.
>> 
>> *I think* we can leave ballooned out pages out of scope for now.
>
> I'm thinking we want a global flag (kexec_is_safe) that is cleared even
> any unsafe operation (e.g., ballooning, grant mapping) is done by the
> guest.  kexec load and exec can then be made to fail if this flag is clear.
>
> This would allow you to fix only the use cases you're interested in
> without introducing subtle failures if someone tries an unsupported
> configurations.

Makes sense but it would also be nice to have this flag supported in
kexec utility itself (so it will report something like "kexec is not
safe, use '-f' to override...).

Thanks,

>
> David

-- 
  Vitaly
