Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaI3MKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 08:10:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbaI3MKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 08:10:40 -0400
Date: Tue, 30 Sep 2014 14:08:06 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, boris.ostrovsky@oracle.com
Subject: Re: [PATCH] Revert "xen/acpi-processor: fix enabling interrupts on
 syscore_resume"
Message-ID: <20140930120805.GA4153@redhat.com>
References: <1412002276-30873-1-git-send-email-konrad.wilk@oracle.com>
 <5429730E.1050506@citrix.com>
 <20140929175517.GA5000@laptop.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929175517.GA5000@laptop.dumpdata.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 01:55:17PM -0400, Konrad Rzeszutek Wilk wrote:
> On Mon, Sep 29, 2014 at 03:56:14PM +0100, David Vrabel wrote:
> > On 29/09/14 15:51, Konrad Rzeszutek Wilk wrote:
> > > This reverts commit cd979883b9ede90643e019f33cb317933eb867b4.
> > > 
> > > As it actually never gets called on the initial domain when
> > > resuming. That is after we suspend and go in resume, the
> > > do_suspend (from manage.c) is never called (it is if it
> > > was running as a guest)- so the 'resume' functionality of the driver
> > > was never called.
> > > 
> > > Which means that this whole patch was pointless (well, it did
> > > remove the WARNING splat).
> > > 
> > > This patch reverts the patch and allows the C and P states to
> > > be uploaded to the hypervisor on ACPI S3 resume of the
> > > initial domain. It sadly brings back the WARNING splat which
> > > will have to be dealt with at some point.
> > 
> > Incorrectly enabling interrupts in contexts where this is not permitted
> > is not just harmless "WARNING splat".
> > 
> > This has been broken since 3.15-rc1 without anyone else noticing so I
> > think we can afford to take a bit more time and fix the original bug
> > properly.
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

This is not enough to make xen_upload_processor_pm_data() run in atomic
context. Via check_acpi_ids() it call acpi_walk_namespace() and
acpi_walk_namespace(), which are internal ACPICA functions that
take internal ACPICA  mutexes.

Stanislaw
