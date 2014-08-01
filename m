Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaHANo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 09:44:27 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:34498 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaHANoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 09:44:25 -0400
X-IronPort-AV: E=Sophos;i="5.01,780,1400025600"; 
   d="scan'208";a="158463998"
Message-ID: <1406900658.27080.12.camel@hamster.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH 1/2] xen: Implement ioctl to restrict
 privcmd to a specific domain
From: Frediano Ziglio <frediano.ziglio@citrix.com>
To: Jan Beulich <JBeulich@suse.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        xen-devel <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-api@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 1 Aug 2014 14:44:18 +0100
In-Reply-To: <53DB6B8D02000078000284D3@mail.emea.novell.com>
References: <E1XCqEY-0005zn-V2@lists.xen.org>
	 <53DB6B8D02000078000284D3@mail.emea.novell.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-01 at 09:27 +0100, Jan Beulich wrote:
> >>> On 31.07.14 at 15:16, <frediano.ziglio@citrix.com> wrote:
> > Add a RESTRICT ioctl to /dev/xen/privcmd, which allows privileged commands
> > file descriptor to be restricted to only working with a particular domain.
> 
> The "with" here has been quite confusing, and I realized that you
> mean the subject domain rather than the actor one only after
> having gone through quite some parts of the patch. For a patch
> this size, a little more of a description (and the original motivation)
> would have helped.
> 

Yes, you are right.

> Wrt motivation: Why does this need enforcing in the kernel at all?
> Doesn't XSM_DM_PRIV mode deal specifically with what you're
> trying to do here? Or else I guess I really need some better
> explanation of what this is about.
> 
> Jan
> 

This is quite old for me but you are right, perhaps is not that clear
for other people. In XenServer we have some patches that allow Qemu
running in dom0 but work only for a specific domain. The patches
required changes to libxc, kernel and Qemu. We are reimplementing these
patches as the old implementation has some problems (one is that the
patch for libxc was quite big). This feature was removed as kernel
patches did not work with newer (3.x) kernels.

Now, XSM_DM_PRIV works checking if the domain target is the domain we
are going to handle. However if your dom0 (as in XenServer) has all Qemu
to handle all VMs it cannot be bound to a single target so XSM is not
usable. Xen has no knowledge of process or file descriptor (which are
kernel specific) so there is actually no way it can distinguish which
domain should be restricted to. It would solve if the restriction would
be done for system call (so we can say execute this hypercall(s) with
these policies). However this require to change the target to be at
least CPU specific and handle preemption correctly in order to not mix
policies. This could be quite heavy so we hack the kernel in order to do
the restriction instead (it also was easier to port the patches).

Actually changes in Qemu to handle the privcmd/evtchn restrictions are
quite small, mainly restrict these two handles with an ioctl. Other
parts of the patch (chroot, setuid, groups, resource limits, and mostly
xenstore accesses) are more heavy.

Frediano


