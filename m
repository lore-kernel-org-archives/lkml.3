Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750887AbaKBFYO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 01:24:14 -0400
Received: from mga03.intel.com ([134.134.136.65]:58665 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbaKBFYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 01:24:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="483807751"
Message-ID: <5455BFF4.6040401@linux.intel.com>
Date: Sun, 02 Nov 2014 13:24:04 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
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
References: <1414387308-27148-1-git-send-email-jiang.liu@linux.intel.com> <1414387308-27148-15-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.11.1411011949370.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1411011949370.5308@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/2 2:59, Thomas Gleixner wrote:
> On Mon, 27 Oct 2014, Jiang Liu wrote:
>> We are going to support ACPI based IOAPIC hotplug, so introduce a rwsem
>> to protect IOAPIC data structures from IOAPIC hotplug. We choose to
>> serialize in ACPI instead of in the IOAPIC core because:
>> 1) currently we are only plan to support ACPI based IOAPIC hotplug
>> 2) it's much more cleaner and easier
>> 3) It does't affect IOAPIC discovered by devicetree, SFI and mpparse.
> 
> I had a last intensive look at this series as I was about to merge
> it. So I looked at the locking rules here again
>  
>> +/*
>> + * Locks related to IOAPIC hotplug
>> + * Hotplug side:
>> + * 	->lock_device_hotplug()	//device_hotplug_lock
>> + *		->acpi_ioapic_rwsem
>> + *			->ioapic_lock
>> + * Interrupt mapping side:
>> + *	->acpi_ioapic_rwsem
>> + *		->ioapic_mutex
>> + *			->ioapic_lock
>> + */
> 
> This looks sane, but I cannot figure out at all why this needs to be a
> rwsem.
> 
>> +static DECLARE_RWSEM(acpi_ioapic_rwsem);
> 
> I think it should be a simple mutex because the rwsem does not protect
> against concurrent execution what taken for read.
> 
> And the site which takes it for write is in the early boot process
> where nothing runs in parallel AFAICT.
Hi Thomas,
	You are right. It's not on hot path, so a mutex is better than
a rwsem here. I will send out an updated version soon.
Regards!
Gerry
> 
> Thanks,
> 
> 	tglx
> 
