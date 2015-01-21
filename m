Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbbAUCh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 21:37:26 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52609 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754060AbbAUChX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 21:37:23 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Len Brown <lenb@kernel.org>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [RFC Patch 09/19] ACPI: Fix a bug in parsing ACPI Memroy24 resource
Date: Wed, 21 Jan 2015 03:59:58 +0100
Message-ID: <1991525.eC7pfWWFK0@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54BF0BA5.8020806@linux.intel.com>
References: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com> <1633329.njF7Ian1Kn@vostro.rjw.lan> <54BF0BA5.8020806@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 21, 2015 10:15:01 AM Jiang Liu wrote:
> On 2015/1/21 8:42, Rafael J. Wysocki wrote:
> > On Thursday, January 08, 2015 10:32:56 AM Jiang Liu wrote:
> >> According to ACPI spec 5, section 6.4.3.1 "24-Bit Memory Range Descriptor",
> >> minimum, maximum and address_length field in struct acpi_resource_memory24
> >> is in granularity of 256-bytes. So shift 8-bit left to get correct address.
> > 
> > Are you sure about this?
> > 
> > I'm reading ACPI 5.1 ATM and (on page 316) it only says about the range length
> > being in 256 byte blocks.
> Hi Rafael,
> 	According to ACPI spec 5.a sec 6.4.3.1,
> Byte 4, "Range minimum base address, _MIN, bits[7:0]", "Address
> bits[15:8] of the minimum base memory address for which
> the card may be configured."
> Byte 5, "Range minimum base address, _MIN, bits[15:8]", "Address
> bits[23:16] of the minimum base memory address for
> which the card may be configured".

Ah, OK.

So bits [15:0] of the _MIN field are bits [23:8] of the address.  Tricky that.

I wonder why no problems with that have ever been reported ...

> Byte 10, "Range length, _LEN, bits[7:0]", "This field contains the lower
> eight bits of the memory range length. The range length provides the
> length of the memory range in 256 byte blocks."
> Byte 11, "Range length, _LEN, bits[15:8]", "This field contains the
> upper eight bits of the memory range length. The range length field
> provides the length of the memory range in 256 byte blocks."
> 
> That means _MIN defines bits[23:8] of the minimal address, and _LEN
> is in granularity of 256 bytes, so shift them left by 8 bits.
> Regards,
> Gerry
> 
> > 
> >> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> >> ---
> >>  drivers/acpi/resource.c |    4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
> >> index abe3a29ad802..f4aeef22a9d8 100644
> >> --- a/drivers/acpi/resource.c
> >> +++ b/drivers/acpi/resource.c
> >> @@ -90,8 +90,8 @@ bool acpi_dev_resource_memory(struct acpi_resource *ares, struct resource *res)
> >>  	switch (ares->type) {
> >>  	case ACPI_RESOURCE_TYPE_MEMORY24:
> >>  		memory24 = &ares->data.memory24;
> >> -		acpi_dev_get_memresource(res, memory24->minimum,
> >> -					 memory24->address_length,
> >> +		acpi_dev_get_memresource(res, memory24->minimum << 8,
> >> +					 memory24->address_length << 8,
> >>  					 memory24->write_protect);
> >>  		break;
> >>  	case ACPI_RESOURCE_TYPE_MEMORY32:
> >>
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
