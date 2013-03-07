Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab3CGMHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 07:07:14 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:34746 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab3CGMHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 07:07:13 -0500
X-IronPort-AV: E=Sophos;i="4.84,800,1355097600"; 
   d="scan'208";a="11166410"
Message-ID: <513882ED.8040208@citrix.com>
Date: Thu, 7 Mar 2013 12:07:09 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: "carsten@schiers.de" <carsten@schiers.de>,
        "darren.s.shepherd@gmail.com" <darren.s.shepherd@gmail.com>,
        "james-xen@dingwall.me.uk" <james-xen@dingwall.me.uk>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 1/1] xen/balloon: Enforce various limits on target
References: <1362431691-5167-1-git-send-email-daniel.kiper@oracle.com> <513722DF.6010204@citrix.com> <20130306164744.GB11217@debian70-amd64.local.net-space.pl> <5137825C.4030805@citrix.com> <20130307112854.GC11217@debian70-amd64.local.net-space.pl>
In-Reply-To: <20130307112854.GC11217@debian70-amd64.local.net-space.pl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/13 11:28, Daniel Kiper wrote:
> On Wed, Mar 06, 2013 at 05:52:28PM +0000, David Vrabel wrote:
>
>> If you set the target above d->max_pages you won't be able to populate them.
>>
>> So, using the maximum_reservation call seems like the right thing to me.
> 
> Please look above. If you use this value you would not
> be able to increase reservation.

I don't think I'm understanding the use case you're talking about.

Do you mean we should allow a target <= d->tot_pages even if this is
above d->max_pages?  I agree with this.

Something like this:

void balloon_set_new_target(unsigned long target)
{
	domid_t domid = DOMID_SELF;
	int rc;
	unsigned long host_limit;

	target = min(target, MAX_DOMAIN_PAGES);

	/* Prevent target from attempting the expand the reservation
	   above the max enforced by the hypervisor. */
	rc = HYPERVISOR_memory_op(XENMEM_maximum_reservation, &domid);
	if (rc > 0) {
		host_limit = rc;
		target = min(target,
			max(host_limit, balloon_stats.current_pages));
	}

	balloon_stats.target_pages = target;
	schedule_delayed_work(&balloon_worker, 0);
}

David
