Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab3AaSwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:52:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207Ab3AaSwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:52:06 -0500
Date: Thu, 31 Jan 2013 20:52:00 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH] x86, x2apic: Only WARN on broken BIOSes inside a virtual
 guest
Message-ID: <20130131185200.GA1757@redhat.com>
References: <1359650435-73586-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359650435-73586-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 11:40:35AM -0500, Don Zickus wrote:
> In commit "41750d3 x86, x2apic: Enable the bios request for x2apic optout"
> it was explained how OEMs are trying to opt out of using x2apics.
> 
> That commit moved code around and screamed with a WARN if the BIOS
> opted out of x2apic mode.  Fair enough.
> 
> This code hit our RHEL distro and OEMs started complaining that the
> WARN is scaring their customers and asked we tone it down to a
> pr_warn().
> 
> Before we did that, we thought we should change it upstream too.
> Upstream complained that WARN was necessary due to a serious
> security threat, namely irq injections.  Hard to argue that.
> 
> This left us between a rock and a hard place.  We toned down the
> WARN in RHEL to keep our customers happy.  But this leaves us with
> a perpetual patch in RHEL and possibly covering up a security threat.
> 
> I poked around to understand the nature of the security threat and why
> OEMs would want to leave themselves vulnerable.  The only security
> threat I could find was this whitepaper talking about Xen and irq
> injections:
> 
> http://www.invisiblethingslab.com/resources/2011/Software%20Attacks%20on%20Intel%20VT-d.pdf
> 
> After talking with folks, the threat of irq injections on virtual guests
> made sense.  However, when discussing if this was possible on bare metal
> machines, we could not come up with a plausible scenario.
> 
The irq injections is something that a guest with assigned device does
to attack a hypervisor it runs on. Interrupt remapping protects host
from this attack. According to pdf above if x2apic is disabled in a
hypervisor interrupt remapping can be bypassed and leave host vulnerable
to guest attack. This means that situation is exactly opposite: warning
has sense on a bare metal, but not in a guest. I am not sure that there is
a hypervisor that emulates interrupt remapping device though and without
it the warning cannot be triggered in a guest.

--
			Gleb.
