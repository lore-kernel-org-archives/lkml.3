Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850AbaKATA3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 15:00:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:47332 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbaKATA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 15:00:26 -0400
Date: Sat, 1 Nov 2014 19:59:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, x86@kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [Patch v7 14/18] x86, irq, ACPI: Introduce a rwsem to protect
 IOAPIC operations from hotplug
In-Reply-To: <1414387308-27148-15-git-send-email-jiang.liu@linux.intel.com>
Message-ID: <alpine.DEB.2.11.1411011949370.5308@nanos>
References: <1414387308-27148-1-git-send-email-jiang.liu@linux.intel.com> <1414387308-27148-15-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, Jiang Liu wrote:
> We are going to support ACPI based IOAPIC hotplug, so introduce a rwsem
> to protect IOAPIC data structures from IOAPIC hotplug. We choose to
> serialize in ACPI instead of in the IOAPIC core because:
> 1) currently we are only plan to support ACPI based IOAPIC hotplug
> 2) it's much more cleaner and easier
> 3) It does't affect IOAPIC discovered by devicetree, SFI and mpparse.

I had a last intensive look at this series as I was about to merge
it. So I looked at the locking rules here again
 
> +/*
> + * Locks related to IOAPIC hotplug
> + * Hotplug side:
> + * 	->lock_device_hotplug()	//device_hotplug_lock
> + *		->acpi_ioapic_rwsem
> + *			->ioapic_lock
> + * Interrupt mapping side:
> + *	->acpi_ioapic_rwsem
> + *		->ioapic_mutex
> + *			->ioapic_lock
> + */

This looks sane, but I cannot figure out at all why this needs to be a
rwsem.

> +static DECLARE_RWSEM(acpi_ioapic_rwsem);

I think it should be a simple mutex because the rwsem does not protect
against concurrent execution what taken for read.

And the site which takes it for write is in the early boot process
where nothing runs in parallel AFAICT.

Thanks,

	tglx
