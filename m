Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab3EHW0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 18:26:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53565 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830Ab3EHW0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 18:26:31 -0400
Date: Thu, 9 May 2013 00:28:45 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lance Ortiz <lance.ortiz@hp.com>, bhelgaas@google.com,
        lance_ortiz@hotmail.com, jiang.liu@huawei.com, tony.luck@intel.com,
        rostedt@goodmis.org, mchehab@redhat.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aerdrv: Move cper_print_pcie() out of interrupt context
Message-ID: <20130508222845.GL30955@pd.tnic>
References: <20130508171519.26724.63307.stgit@grignak.americas.hpqcorp.net>
 <2598827.AVAqMcfGuF@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2598827.AVAqMcfGuF@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 12:01:21AM +0200, Rafael J. Wysocki wrote:
> On Wednesday, May 08, 2013 11:15:19 AM Lance Ortiz wrote:
> > The following warning was seen on 3.9 when a corrected PCIe error was being
> > handled by the AER subsystem.
> > 
> > WARNING: at .../drivers/pci/search.c:214 pci_get_dev_by_id+0x8a/0x90()
> > 
> > This occurred because code was added to the function cper_print_pcie() that
> > calls the pci_get_domain_bus_and_slot() function.
> 
> Do you know which commit added that code?

1d5210008bd3a26daf4b06aed9d6c330dd4c83e2

> > cper_print_pcie() is called
> > in an interrupt context and pci_get* functions are not supposed to be called
> > in that context hence the warning.
> > 
> > The solution is to move the call to cper_print_aer() out of the interrupt
> > context and into aer_recover_queue() to avoid any warnings when calling
> > pci_get* functions.
> 
> The way the changes are described here isn't particularly clear to me.  I'd say
> something like
> 
>   If cper_print_aer() is called by aer_recover_work_func(), there won't be any
>   reason to call it from cper_print_pcie() any more, in which case all of the
>   problematic code needed only to prepare for the cper_print_aer() call,
>   including the invocation of pci_get_domain_bus_and_slot() causing the warning
>   to be printed, may be removed from there.  Make that happen."
> 
> Also, since aer_recover_work_func() is going to be the only existing caller of
> cper_print_aer() after this change, as far as I can say, and it doesn't use the
> function's first argument, that argument should be dropped entirely.

Hmm, that needs more diddling: AFAICT __ghes_print_estatus() figures out
what the prefix is depending on the ->error_severity coming from the
acpi_hest_generic_status thing so it probably needs to be handed down or
similar...

Fun.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
