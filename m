Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbaI2SGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:06:41 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:2139 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770AbaI2SGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:06:40 -0400
X-IronPort-AV: E=Sophos;i="5.04,621,1406592000"; 
   d="scan'208";a="177209778"
Message-ID: <54299F8F.304@citrix.com>
Date: Mon, 29 Sep 2014 19:06:07 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <sgruszka@redhat.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>, <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH] Revert "xen/acpi-processor: fix enabling interrupts on
 syscore_resume"
References: <1412002276-30873-1-git-send-email-konrad.wilk@oracle.com> <5429730E.1050506@citrix.com> <20140929175517.GA5000@laptop.dumpdata.com>
In-Reply-To: <20140929175517.GA5000@laptop.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/09/14 18:55, Konrad Rzeszutek Wilk wrote:
> 
> This patch should be a good start to discussing the fix.
> 
> From 3544815f7c44508e2c9a0c55caf4a32cc8283685 Mon Sep 17 00:00:00 2001
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date: Mon, 29 Sep 2014 13:48:57 -0400
> Subject: [PATCH] xen-acpi-processor: Use spinlock and GFP_ATOMIC to deal with
>  resume
> 
> hitting the IRQs being enabled during resume.
> 
> WARNING: CPU: 0 PID: 6733 at drivers/base/syscore.c:104 syscore_resume+0x9a/0xe0()
> Interrupts enabled after xen_acpi_processor_resume+0x0/0x34 [xen_acpi_processor]
> 
> Call Trace:
>  [<ffffffff81667a8b>] dump_stack+0x45/0x56
>  [<ffffffff8106921d>] warn_slowpath_common+0x7d/0xa0
>  [<ffffffff8106928c>] warn_slowpath_fmt+0x4c/0x50
>  [<ffffffffa0261bb0>] ? xen_upload_processor_pm_data+0x300/0x300 [xen_acpi_processor]
>  [<ffffffff814055fa>] syscore_resume+0x9a/0xe0
>  [<ffffffff810aef42>] suspend_devices_and_enter+0x402/0x470
>  [<ffffffff810af128>] pm_suspend+0x178/0x260
> 
> Converting the mutex to a spinlock and all of the GPF_KERNEL
> to GFP_ATOMIC take care of that.

Do we need to load this into Xen so early?  I'd much prefer not adding a
bunch of GFP_ATOMIC allocations into the resume path.

I'd probably just schedule some work in the syscore resume to do the load.

David
