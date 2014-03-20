Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759930AbaCTUjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 16:39:37 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61296 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759719AbaCTUje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 16:39:34 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Zhang, Rui" <rui.zhang@intel.com>, "Lu, Aaron" <aaron.lu@intel.com>,
        Borislav Petkov <bp@alien8.de>, lkml <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>,
        "Yan, Zheng Z" <zheng.z.yan@intel.com>
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
Date: Thu, 20 Mar 2014 21:55:06 +0100
Message-ID: <1558044.S1G2VU7srO@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc6+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAErSpo55DjkGQB=7ksow34BpCObnY+o3eNnt0n5oQEh6Lfw1pw@mail.gmail.com>
References: <20140224162400.GE16457@pd.tnic> <744357E9AAD1214791ACBA4B0B9092630121F201@SHSMSX101.ccr.corp.intel.com> <CAErSpo55DjkGQB=7ksow34BpCObnY+o3eNnt0n5oQEh6Lfw1pw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 20, 2014 10:45:52 AM Bjorn Helgaas wrote:
> On Wed, Mar 19, 2014 at 9:03 PM, Zhang, Rui <rui.zhang@intel.com> wrote:
> 
> > I've talked with Yan Zheng, and I was told that this resource "0xfed10000 - 0xfed15fff"
> > is got from PCI device register directly, which is not in its BAR range.
> > Thus IMO, it is impossible for PNP layer to be aware of this resource.
> 
> Slow down, this isn't quite correct.  The *base* address (0xfed10000)
> is from a PCI config register (MCHBAR, at PCI config offset 0x48) [1].
>  This is a device-dependent register, so the PCI core knows neither
> the base nor the size.
> 
> The device consumes address space that is not reported via the
> architected PCI mechanism, so the only way to report that space is via
> the PNP0C02 ACPI device.  The BIOS has to determine the base and size
> based on its knowledge of the hardware.  On this hardware, per the
> spec in [1], the region described by MCHBAR is 32KB in size.
> 
> The 0x6000 (24KB) size of the region above comes from the driver and
> is actually less than what the device consumes.  It is legal for a
> driver to request only the area it requires, but the entire area
> consumed by the device should be reported via the PNP0C02 device.  The
> fact that PNP0C02 reports 16KB but the device actually consumes 32KB
> is a BIOS defect.  This probably happened because previous versions of
> this chip consumed only 16KB, and the BIOS didn't get updated for the
> change.
> 
> > BTW, about drivers/pnp/system.c, if its ONLY purpose is to prevent those
> > resources from being allocated to uninitialized PCI devices, then IMO,
> > the best way to do this is make PCI bus handle those PNP0C01/PNP0C02
> > resources directly, probably via a platform callback, say,
> > 1. make drivers/pnp/system.c a no-op for PNPACPI, by checking pnp_dev->protocol.
> > 2. introduce acpi_check_reserved_resource() to parsing PNP0C01/PNP0C02 resources.
> > 3. in PCI bus, invoke acpi_check_reserved_resource() when assigning
> >    resources to PCI devices.
> 
> The purpose of system.c is indeed to prevent resources from being
> allocated to other devices.  This is really a question for Rafael, but
> in my opinion this function (reserving resources of PNP/ACPI devices
> to prevent their allocation to other devices) should be done for *all*
> PNP and ACPI devices, not just the PNP0C01/PNP0C02 devices handled by
> system.c.
> 
> So I think the best solution would be to move that into the ACPI core
> somehow so it happens for all devices.

Well, I think you got to the bottom of this, but that's something we can
do long-term.  Still, we need to find a short-term solution for the
particular issue at hand.

> If we had that, we could get
> rid of system.c altogether, and we wouldn't have to do anything
> special in PCI.  This is much easier to say than to do, however,
> because there are all kinds of issues with legacy resource
> reservations, and we currently can't really deal with overlapping
> resources.

Indeed.

All above said, appended is the relevant piece of the DSDT from the machine
in question (and that is in the PCI host bridge scope).

So we have a PCI device with an ACPI object called LPC which has a child
called SIO and the _HID of that child is "PNP0C02".

I'm not sure if the way system.c handles this is correct in this particular
case to be honest.


            Device (LPC)
            {
                Name (_ADR, 0x001F0000)
                Name (_S3D, 0x03)
                Name (RID, 0x00)
                Device (SIO)
                {
                    Name (_HID, EisaId ("PNP0C02"))
                    Name (_UID, 0x00)
                    Name (SCRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0010,             // Range Minimum
                            0x0010,             // Range Maximum
                            0x01,               // Alignment
                            0x10,               // Length
                            )
                        IO (Decode16,
                            0x0090,             // Range Minimum
                            0x0090,             // Range Maximum
                            0x01,               // Alignment
                            0x10,               // Length
                            )
                        IO (Decode16,
                            0x0024,             // Range Minimum
                            0x0024,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0028,             // Range Minimum
                            0x0028,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x002C,             // Range Minimum
                            0x002C,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0030,             // Range Minimum
                            0x0030,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0034,             // Range Minimum
                            0x0034,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0038,             // Range Minimum
                            0x0038,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x003C,             // Range Minimum
                            0x003C,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00A4,             // Range Minimum
                            0x00A4,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00A8,             // Range Minimum
                            0x00A8,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00AC,             // Range Minimum
                            0x00AC,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00B0,             // Range Minimum
                            0x00B0,             // Range Maximum
                            0x01,               // Alignment
                            0x06,               // Length
                            )
                        IO (Decode16,
                            0x00B8,             // Range Minimum
                            0x00B8,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00BC,             // Range Minimum
                            0x00BC,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0050,             // Range Minimum
                            0x0050,             // Range Maximum
                            0x01,               // Alignment
                            0x04,               // Length
                            )
                        IO (Decode16,
                            0x0072,             // Range Minimum
                            0x0072,             // Range Maximum
                            0x01,               // Alignment
                            0x06,               // Length
                            )
                        IO (Decode16,
                            0x0400,             // Range Minimum
                            0x0400,             // Range Maximum
                            0x01,               // Alignment
                            0x80,               // Length
                            )
                        IO (Decode16,
                            0x0500,             // Range Minimum
                            0x0500,             // Range Maximum
                            0x01,               // Alignment
                            0x80,               // Length
                            )
                        IO (Decode16,
                            0x0800,             // Range Minimum
                            0x0800,             // Range Maximum
                            0x01,               // Alignment
                            0x10,               // Length
                            )
                        IO (Decode16,
                            0x15E0,             // Range Minimum
                            0x15E0,             // Range Maximum
                            0x01,               // Alignment
                            0x10,               // Length
                            )
                        IO (Decode16,
                            0x1600,             // Range Minimum
                            0x1600,             // Range Maximum
                            0x01,               // Alignment
                            0x80,               // Length
                            )
                        Memory32Fixed (ReadWrite,
                            0xF8000000,         // Address Base
                            0x04000000,         // Address Length
                            )
                        Memory32Fixed (ReadWrite,
                            0x00000000,         // Address Base
                            0x00001000,         // Address Length
                            _Y26)
                        Memory32Fixed (ReadWrite,
                            0xFED1C000,         // Address Base
                            0x00004000,         // Address Length
                            )
                        Memory32Fixed (ReadWrite,
                            0xFED10000,         // Address Base
                            0x00004000,         // Address Length
                            )
                        Memory32Fixed (ReadWrite,
                            0xFED18000,         // Address Base
                            0x00001000,         // Address Length
                            )
                        Memory32Fixed (ReadWrite,
                            0xFED19000,         // Address Base
                            0x00001000,         // Address Length
                            )
                        Memory32Fixed (ReadWrite,
                            0xFED45000,         // Address Base
                            0x00007000,         // Address Length
                            )
                    })
                    CreateDWordField (SCRS, \_SB.PCI0.LPC.SIO._Y26._BAS, TRMB)
                    Method (_CRS, 0, NotSerialized)
                    {
                        Store (\TBAB, TRMB)
                        If (LEqual (\_SB.PCI0.LPC.TPM._STA (), 0x0F))
                        {
                            Return (SCRS)
                        }
                        Else
                        {
                            Subtract (SizeOf (SCRS), 0x02, Local0)
                            Name (BUF0, Buffer (Local0) {})
                            Add (Local0, SizeOf (\_SB.PCI0.LPC.TPM.BUF1), Local0)
                            Name (BUF1, Buffer (Local0) {})
                            Store (SCRS, BUF0)
                            Concatenate (BUF0, \_SB.PCI0.LPC.TPM.BUF1, BUF1)
                            Return (BUF1)
                        }
                    }
                }

