Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbaHGBbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 21:31:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:20898 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289AbaHGBbS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 21:31:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="368983662"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] KVM: x86: always exit on EOIs for interrupts listed in
 the IOAPIC redir table
Thread-Topic: [PATCH] KVM: x86: always exit on EOIs for interrupts listed in
 the IOAPIC redir table
Thread-Index: AQHPrBEkMevXzPHWyEW1NdRMjvzN+JvDpASg//99kwCAAT84cA==
Date: Thu, 7 Aug 2014 01:31:14 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0AB5264D@SHSMSX104.ccr.corp.intel.com>
References: <1406736728-8516-1-git-send-email-pbonzini@redhat.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AB51BA1@SHSMSX104.ccr.corp.intel.com>
 <53E236E6.6050206@redhat.com>
In-Reply-To: <53E236E6.6050206@redhat.com>
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

Paolo Bonzini wrote on 2014-08-06:
> Il 06/08/2014 16:03, Zhang, Yang Z ha scritto:
>> Paolo Bonzini wrote on 2014-07-31:
>>> Probably, the guest is masking the interrupt in the redirection
>>> table in the interrupt routine, i.e. while the interrupt is set in a LAPIC's ISR.
>>> The simplest fix is to ignore the masking state, we would rather
>>> have an unnecessary exit rather than a missed IRQ ACK and anyway
>>> IOAPIC interrupts are not as performance-sensitive as for example MSIs.
>> 
>> I feel this fixing may hurt performance in some cases. If the mask
>> bit is set, this means the vector in this entry may be used by other
>> devices(like a assigned device). But here you set it in eoi exit
>> bitmap and this will cause vmexit on each EOI which should not happen.
> 
> Note that this *was* reported on an assigned device.
> 
> IOAPIC should not be a performance-sensitive path.  High-performance
> assigned devices should be using MSIs.

Let me give an example to see whether my concern is a real problem:
Guest allocates a vector and set it in IOAPIC entry to deliver interrupt. Later it masks the IOAPIC entry(means stop the corresponding device) and assign this vector to a MSI device. With this patch, even the vector is not used by IOAPIC, but it still set eoi exit bitmap unconditionally. The subsequent EOIs to MSI device will force vmexit. Could this happen?

I think the right fixing is to check the ISR plus TMR to construct the eoi exit bitmap.

> 
> Paolo


Best regards,
Yang

