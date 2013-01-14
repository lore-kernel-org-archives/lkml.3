Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab3ANGAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 01:00:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:21964 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097Ab3ANGAy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 01:00:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,465,1355126400"; 
   d="scan'208";a="246194973"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: RE: [PATCH V2 2/2] Xen ACPI memory hotplug
Thread-Topic: [PATCH V2 2/2] Xen ACPI memory hotplug
Thread-Index: AQHN8Ch2gSdugiMySf2ZunvFOlFXHphIVELw
Date: Mon, 14 Jan 2013 06:00:50 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353C2472@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC82923353BB10D@SHSMSX101.ccr.corp.intel.com>
 <20130111182124.GB28685@phenom.dumpdata.com>
In-Reply-To: <20130111182124.GB28685@phenom.dumpdata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Agree, w/ minor comments below.


Konrad Rzeszutek Wilk wrote:
>> +
>> +	/*
>> +	 * Early boot code has recognized memory area by EFI/E820.
>> +	 * If DSDT shows these memory devices on boot, hotplug is not
>> necessary +	 * for them. So, it just returns until completion of
>> this driver's +	 * start up.
> 
> "So it just returns until completion of this drivers's start up."
> 
> Can you change that to be:
> "Return OK until this driver starts up."
> 
> But then.. how can this function be called with
> acpi_hotmem_initialized=false? Is it b/c of the acpi_walk_namespace
> call? How about you state that: 
> 
> "This can be done via the acpi_walk_namespace which is called during
> early boot and acpi_hotmem_initialized is set _after_ that call
> has completed."
> 

The action for booting existed memory and hot-added memory is different.
For booting existed memory devices, we don't need do xen_hotadd_memory.
For hot-added memory devices, we need do xen_hotadd_memory, hypercall to hypervisor to add memory.

I've updated comments as below to be more clear:
        /*
         * For booting existed memory devices, early boot code has recognized
         * memory area by EFI/E820. If DSDT shows these memory devices on boot,
         * hotplug is not necessary for them.
         * For hot-added memory devices during runtime, it need hypercall to
         * Xen hypervisor to add memory.
         */


>> +static void __exit xen_acpi_memory_device_exit(void) +{
>> +	acpi_status status;
>> +
>> +	if (!xen_initial_domain())
>> +		return;
>> +
>> +	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
>> +				     ACPI_UINT32_MAX, +				    
>> acpi_memory_deregister_notify_handler, +				     NULL, NULL, NULL);
>> +	if (ACPI_FAILURE(status))
>> +		pr_warn(PREFIX "walk_namespace failed\n");
>> +
>> +	acpi_bus_unregister_driver(&xen_acpi_memory_device_driver); +
>> +	/*
>> +	 * stub reserve space again to prevent any chance of native
>> +	 * driver loading, though not much meaning in real life
> 
> not much meaning in real life? What does that mean?
> 

Hmm, what I want to say here is, in real life module driver seldomly unloaded.
Anyway, the comments is ambiguous, I've dropped the word 'though not much meaning in real life'.

Thanks,
Jinsong

>> +	 */
>> +	acpi_bus_register_driver(&xen_stub_memory_device_driver); +	return;
>> +}
>> +
