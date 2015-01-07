Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbbAGXrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:47:47 -0500
Received: from mga14.intel.com ([192.55.52.115]:30041 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbbAGXp5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:45:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,718,1413270000"; 
   d="scan'208";a="634042693"
From: "Ong, Boon Leong" <boon.leong.ong@intel.com>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>,
        Darren Hart <dvhart@infradead.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
Thread-Topic: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
Thread-Index: AQHQI41CoFze/rj2YEaQrKcsZxtS4pyyOcYAgABmfYCAAr8x0A==
Date: Wed, 7 Jan 2015 23:45:52 +0000
Message-ID: <AF233D1473C1364ABD51D28909A1B1B7326E0C25@PGSMSX105.gar.corp.intel.com>
References: <1419873783-5161-1-git-send-email-pure.logic@nexus-software.ie>
 <1419873783-5161-2-git-send-email-pure.logic@nexus-software.ie>
 <20150106073634.GB59754@vmdeb7> <54ABE67B.1070706@nexus-software.ie>
In-Reply-To: <54ABE67B.1070706@nexus-software.ie>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> +/**
>>> + * imr_enabled
>>> + * Determines if an IMR is enabled based on address range
>>> + *
>>> + * @imr:	Pointer to IMR descriptor
>>> + * @return	true if IMR enabled false if disabled
>>> + */
>>> +static int imr_enabled(struct imr *imr) {
>>> +	return (imr_to_phys(imr->addr_lo) && imr_to_phys(imr->addr_hi));
>>
>> What are testing here? You have bit 30 marked as "Enabled" above (but
>> it isn't in the datasheet). With Reserved bits in each register, this
>> test for non-zero doesn't seem robust.
>
>Good question.
>
>Bit 30 is not present in X1000 silicon, though is present in the BSP code. Lets
>forget about all non-X1000 cases for now since X1000 is the only processor
>currently available.
>
>On X1000 the only means of determining if an IMR is enabled is if it's address
>bits are set to some address everybody agrees means 'off', since the enable
>bit doesn't exist. Everybody in this case is ROM, BIOS, 2nd stage bootloader
>and kernel.
>
>In the BSP code, that address is zero. So in lieu of bit 30 'enable' we have
>address 0x00000000.
>
>The kernel could define an alternative address to 0x00000000 but, then this
>would break with the convention in BIOS etc.
>
>Since BIOS and grub code both use 0x00000000 as the 'off' address I think it
>makes sense for the kernel to continue to use that address.

Just add on top of what Daren mentioned in another mail, based on the Quark document,
the base address can start from zero. Say lo=0, hi=0, and WM & RM may be changed from default value, 
1st 1KiB will be marked as IMR. It seems to me that there is no good way to test if an IMR is 'occupied' and/or 'enabled'
since enable-bit is not available. But, what is benefit of testing against lo=0 & hi=0? The logic to calculate size will work under
lo=0 & hi=0 anway.

>
>>> +	/* Error out if we have an overlap or no free IMR entries */
>>
>> According to the datasheet, overlapping ranges are valid, and access
>> must be granted by all IMRs associated with a given address. Why
>> declare an overlap as invalid here?
>
>Simplicity.
>
>It's more straight forward to define your IMR memory map if you don't allow
>the address ranges to stomp all over each other.
>
>None of the BSP reference code does overlap.
>
>If there's an argument for an overlap use-case it can be supported pretty
>simply by simply removing the overlap checks.
>
>My own view is that it's not really desirable and easier to debug IMRs
>generally on a platform if overlaps aren't allowed.
I do agree on the benefit listed above. Perhaps, you can add explanation here
to mention the design decision.

