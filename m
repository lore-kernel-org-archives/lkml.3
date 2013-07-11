Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab3GKWdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:33:24 -0400
Received: from sous-sol.org ([216.99.217.87]:49401 "EHLO sequoia2.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756373Ab3GKWdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:33:21 -0400
Date: Thu, 11 Jul 2013 15:31:51 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Chris Wright <chrisw@sous-sol.org>, Bjorn Helgaas <bhelgaas@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>
Subject: Re: WARNING: at drivers/iommu/dmar.c:484 warn_invalid_dmar with
 Intel Motherboard
Message-ID: <20130711223151.GD24833@sequoia2.sous-sol.org>
References: <20130709202406.GA11867@roeck-us.net>
 <CAErSpo6Ma1TnBP-UGGhWFN1rj48y+yTS=VmVw_s30_FWgjfdpg@mail.gmail.com>
 <20130709223106.GA16429@roeck-us.net>
 <20130709232252.GB2676@sequoia2.sous-sol.org>
 <20130709234331.GA10833@roeck-us.net>
 <20130711190054.GC24833@sequoia2.sous-sol.org>
 <20130711205902.GB22605@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130711205902.GB22605@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Guenter Roeck (linux@roeck-us.net) wrote:
> On Thu, Jul 11, 2013 at 12:00:54PM -0700, Chris Wright wrote:
> > * Guenter Roeck (linux@roeck-us.net) wrote:
> > > On Tue, Jul 09, 2013 at 04:22:52PM -0700, Chris Wright wrote:
> > > > One thing I've seen is the BIOS zeroing the base register address when
> > > > VT-d is disabled in BIOS.  So, Guenter, a "fix" may be simply enabling
> > > > VT-d in the BIOS.
> > > > 
> > > Ah, yes, I think I may have that disabled. I'll check it tonight.
> > 
> > Did you find out if BIOS change fixed this?
> > 
> No, it didn't. Enabling or disabling virtualization in the BIOS did not make
> a difference. It looks like there is a bad DMAR table entry (with address 0)
> in the ACPI data. In case you are interested how it looks like:
> 
> DMAR @ 0xcb3f3f90
>   0000: 44 4d 41 52 90 00 00 00 01 d5 49 4e 54 45 4c 20  DMAR......INTEL
>   0010: 44 48 38 37 52 4c 20 20 40 01 00 00 49 4e 54 4c  DH87RL  @...INTL
>   0020: 01 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00  ....&...........
>   0030: 00 00 10 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
>   0040: 01 00 30 00 00 00 00 00 00 b0 eb cb 00 00 00 00  ..0.............
>   0050: ff 9f ec cb 00 00 00 00 01 08 00 00 00 00 1d 00  ................
>   0060: 01 08 00 00 00 00 1a 00 01 08 00 00 00 00 14 00  ................
>   0070: 01 00 20 00 00 00 00 00 00 00 00 d7 00 00 00 00  .. .............
>   0080: ff ff 1f df 00 00 00 00 01 08 00 00 00 00 02 00  ................
> 
> Turns out the i7-4770K doesn't support VT-d, so my current understanding
> is that there should be no DMAR table in the first place.

OK, thanks for follow-up.  You can see why the warnings are there now.
This is your decoded DMAR table...has valid looking RMRR regions, and
mostly valid looking DRHD (minus the invalid base address).


/*
 * Intel ACPI Component Architecture
 * AML Disassembler version 20100528
 *
 * Disassembly of /tmp/dmar, Thu Jul 11 15:24:28 2013
 *
 * ACPI Data Table [DMAR]
 *
 * Format: [HexOffset DecimalOffset ByteLength]  FieldName : FieldValue
 */

[000h 0000  4]                    Signature : "DMAR"    /* DMA Remapping table */
[004h 0004  4]                 Table Length : 00000090
[008h 0008  1]                     Revision : 01
[009h 0009  1]                     Checksum : D5
[00Ah 0010  6]                       Oem ID : "INTEL "
[010h 0016  8]                 Oem Table ID : "DH87RL  "
[018h 0024  4]                 Oem Revision : 00000140
[01Ch 0028  4]              Asl Compiler ID : "INTL"
[020h 0032  4]        Asl Compiler Revision : 00000001

[024h 0036  1]           Host Address Width : 26
[025h 0037  1]                        Flags : 00

[030h 0048  2]                Subtable Type : 0000 <Hardware Unit Definition>
[032h 0050  2]                       Length : 0010
[034h 0052  1]                        Flags : 01
[035h 0053  1]                     Reserved : 00
[036h 0054  2]           PCI Segment Number : 0000
[038h 0056  8]        Register Base Address : 0000000000000000

[040h 0064  2]                Subtable Type : 0001 <Reserved Memory Region>
[042h 0066  2]                       Length : 0030
[044h 0068  2]                     Reserved : 0000
[046h 0070  2]           PCI Segment Number : 0000
[048h 0072  8]                 Base Address : 00000000CBEBB000
[050h 0080  8]          End Address (limit) : 00000000CBEC9FFF

[058h 0088  1]      Device Scope Entry Type : 01
[059h 0089  1]                 Entry Length : 08
[05Ah 0090  2]                     Reserved : 0000
[05Ch 0092  1]               Enumeration ID : 00
[05Dh 0093  1]               PCI Bus Number : 00
[05Eh 0094  2]                     PCI Path : [1D, 00]

[060h 0096  1]      Device Scope Entry Type : 01
[061h 0097  1]                 Entry Length : 08
[062h 0098  2]                     Reserved : 0000
[064h 0100  1]               Enumeration ID : 00
[065h 0101  1]               PCI Bus Number : 00
[066h 0102  2]                     PCI Path : [1A, 00]

[068h 0104  1]      Device Scope Entry Type : 01
[069h 0105  1]                 Entry Length : 08
[06Ah 0106  2]                     Reserved : 0000
[06Ch 0108  1]               Enumeration ID : 00
[06Dh 0109  1]               PCI Bus Number : 00
[06Eh 0110  2]                     PCI Path : [14, 00]

[070h 0112  2]                Subtable Type : 0001 <Reserved Memory Region>
[072h 0114  2]                       Length : 0020
[074h 0116  2]                     Reserved : 0000
[076h 0118  2]           PCI Segment Number : 0000
[078h 0120  8]                 Base Address : 00000000D7000000
[080h 0128  8]          End Address (limit) : 00000000DF1FFFFF

[088h 0136  1]      Device Scope Entry Type : 01
[089h 0137  1]                 Entry Length : 08
[08Ah 0138  2]                     Reserved : 0000
[08Ch 0140  1]               Enumeration ID : 00
[08Dh 0141  1]               PCI Bus Number : 00
[08Eh 0142  2]                     PCI Path : [02, 00]

Raw Table Data

  0000: 44 4D 41 52 90 00 00 00 01 D5 49 4E 54 45 4C 20  DMAR......INTEL 
  0010: 44 48 38 37 52 4C 20 20 40 01 00 00 49 4E 54 4C  DH87RL  @...INTL
  0020: 01 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00  ....&...........
  0030: 00 00 10 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
  0040: 01 00 30 00 00 00 00 00 00 B0 EB CB 00 00 00 00  ..0.............
  0050: FF 9F EC CB 00 00 00 00 01 08 00 00 00 00 1D 00  ................
  0060: 01 08 00 00 00 00 1A 00 01 08 00 00 00 00 14 00  ................
  0070: 01 00 20 00 00 00 00 00 00 00 00 D7 00 00 00 00  .. .............
  0080: FF FF 1F DF 00 00 00 00 01 08 00 00 00 00 02 00  ................
