Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab3JCJru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 05:47:50 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:56422 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab3JCJrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 05:47:47 -0400
X-IronPort-AV: E=Sophos;i="4.90,1024,1371081600"; 
   d="scan'208";a="57273291"
Message-ID: <524D3D40.4040907@citrix.com>
Date: Thu, 3 Oct 2013 10:47:44 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Frediano Ziglio <frediano.ziglio@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen: Fix possible user space selector corruption
References: <1380788677.30462.1.camel@hamster.uk.xensource.com>
In-Reply-To: <1380788677.30462.1.camel@hamster.uk.xensource.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/13 09:24, Frediano Ziglio wrote:
> Due to the way kernel is initialized under Xen is possible that the ring1
> selector used by the kernel for the boot cpu end up to be copied to
> userspace leading to segmentation fault in the userspace.
> 
> 
> Xen code in the kernel initialize no-boot cpus with correct selectors (ds
> and es set to __USER_DS) but the boot one keep the ring1 (passed by Xen).
> On task context switch (switch_to) we assume that ds, es and cs already
> point to __USER_DS and __KERNEL_CSso these selector are not changed.
> 
> If processor is an Intel that support sysenter instruction sysenter/sysexit
> is used so ds and es are not restored switching back from kernel to
> userspace. In the case the selectors point to a ring1 instead of __USER_DS
> the userspace code will crash on first memory access attempt (to be
> precise Xen on the emulated iret used to do sysexit will detect and set ds
> and es to zero which lead to GPF anyway).
> 
> Now if an userspace process call kernel using sysenter and get rescheduled
> (for me it happen on a specific init calling wait4) could happen that the
> ring1 selector is set to ds and es.
> 
> This is quite hard to detect cause after a while these selectors are fixed
> (__USER_DS seems sticky).
> 
> Bisecting the code commit 7076aada1040de4ed79a5977dbabdb5e5ea5e249 appears
> to be the first one that have this issue.
> 
> Signed-off-by: Frediano Ziglio <frediano.ziglio@citrix.com>

Looks okay to me but I don't really understand it...

David
