Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaE0K7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 06:59:30 -0400
Received: from smtp.citrix.com ([66.165.176.89]:6826 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbaE0K72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 06:59:28 -0400
X-IronPort-AV: E=Sophos;i="4.98,918,1392163200"; 
   d="scan'208";a="136076862"
Message-ID: <5384700E.1030501@citrix.com>
Date: Tue, 27 May 2014 11:59:26 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>, <boris.ostrovsky@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [V1 PATCH] dom0 pvh: map foreign pfns in our p2m
 for toolstack
References: <1400898824-18769-1-git-send-email-mukesh.rathor@oracle.com> <1400898824-18769-2-git-send-email-mukesh.rathor@oracle.com> <53846C4C.1080701@citrix.com>
In-Reply-To: <53846C4C.1080701@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/05/14 11:43, Roger Pau Monné wrote:
> On 24/05/14 03:33, Mukesh Rathor wrote:
>> When running as dom0 in pvh mode, foreign pfns that are accessed must be
>> added to our p2m which is managed by xen. This is done via
>> XENMEM_add_to_physmap_range hypercall. This is needed for toolstack
>> building guests and mapping guest memory, xentrace mapping xen pages,
>> etc..

Thanks.

Applied to devel/for-linus-3.16, but see comments below.

>> +static int xlate_add_to_p2m(unsigned long lpfn, unsigned long fgmfn,
>> +			    unsigned int domid)

The preferred abbreviation is GFN not GMFN.  I fixed this up.

>> +{
>> +	int rc, err = 0;
>> +	xen_pfn_t gpfn = lpfn;
>> +	xen_ulong_t idx = fgmfn;
>> +
>> +	struct xen_add_to_physmap_range xatp = {
>> +		.domid = DOMID_SELF,
>> +		.foreign_domid = domid,
>> +		.size = 1,
>> +		.space = XENMAPSPACE_gmfn_foreign,
>> +	};
>> +	set_xen_guest_handle(xatp.idxs, &idx);
>> +	set_xen_guest_handle(xatp.gpfns, &gpfn);
>> +	set_xen_guest_handle(xatp.errs, &err);
>> +
>> +	rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap_range, &xatp);
>> +	return rc;
> 
> Thanks for the patches, I see two problems with this approach, the first
> one is that you are completely ignoring the error in the variable "err",
> which means that you can end up with a pfn that Linux thinks it's valid,
> but it's not mapped to any mfn, so when you try to access it you will
> trigger the vioapic crash.

I spotted this and fixed this up by adding:

+       if (rc < 0)
+               return rc;
+       return err;

> The second one is that this seems extremely inefficient, you are issuing
> one hypercall for each memory page, when you could instead batch all the
> pages into a single hypercall and map them in one shot.

I agree, but the 3.16 merge window is nearly here so I've applied it
as-is.  Note that the privcmd driver calls this function once per page,
so the lack of batching doesn't really hurt here.

David
