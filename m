Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab3LOAyD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 19:54:03 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56351 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab3LOAyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 19:54:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sergei Ianovich <ynvich@gmail.com>
Subject: Re: [PATCH v2 00/16] ARM: support for ICP DAS LP-8x4x (with dts)
Date: Sun, 15 Dec 2013 01:53:53 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Mack <zonque@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com> <201312142203.45740.arnd@arndb.de> <1387058146.13062.24.camel@host5.omatika.ru>
In-Reply-To: <1387058146.13062.24.camel@host5.omatika.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312150153.54044.arnd@arndb.de>
X-Provags-ID: V02:K0:I+8dTQvueZo9NxV/MacCDqYftRjcQLf0cpgKT+XEsfQ
 x6RdxfjCi5CxVjXUvQnfReBvtQMqp560xj1xCAy3EWh8eMTjt1
 prqhCfiUHv03cIqFemKHalHgZQeq0hDmJshUPWS2AxOlVHFIpL
 696MAZDyY5VOmfGHYbwMBPgRnAcnX6mGuG1nEptpAiI86WoRfz
 CPoj7ymVBxO11fpSzcwaHoGsaQTNuld4o6NyAI56JxPBDNCvnC
 dQdHccqKHmOE5y9qFdO3G0NMAqEPY3FU63mJOnS2Spe39HoX7r
 UlBoRKgrz5aejgDEKxn+SIWt0QTs17f9KnwERGNg45lQrGaJHt
 c4EzNEmp/dRJWtImLB3A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 December 2013, Sergei Ianovich wrote:
> On Sat, 2013-12-14 at 22:03 +0100, Arnd Bergmann wrote:
> > On Friday 13 December 2013, Sergei Ianovich wrote:
> > > I've also decided not to create a single mfd device for
> > > machine-specific devices. Instead each type is supported by a separate
> > > driver in respective subsystem. It was tempting to hardcode all the
> > > constants in one source file, but that requires ugly initialization.
> > > The taken way produces much cleaner code.
> > 
> > I think you should at least change the DT representation for the FPGA
> > to show one device as the actual FPGA and attach children to that,
> > multiple indirection levels if necessary.
> > 
> > I suspect that the fpga is on some external-bus port with a specific
> > chip-select, so I would model this as
> > 
> >         extbus {
> >                 compatible = "simple-bus";
> >                 #address-cells = <1>;
> >                 #size-cells = <1>;
> >                 /* bus addresses 0-0xfffff mapped to 0x17000000 */
> >                 ranges = <0 0x17000000 0x100000>;
> >                 interrupt-parent = <&fpga-irq>;
> > 
> >                 fpga-irq: irq@6 {
> >                         regs = <6 16>; /* translated addresses
> >                         ...
> >                 };
> > 
> >                 fgpa-bus {
> >                         #address-cells = <1>;
> >                         #size-cells = <1>;
> >                         ranges;
> > 
> >                         serial@9050 {
> >                                 ...
> >                         };
> >                 };
> >         };
> > 
> > I also think you don't need to make the devices quite as fine-grained
> > here but instead group things together more. I would probably indeed
> > put everything that is not on one of the slots into a common device,
> > including the irqchip.
> 
> There are basically 2 options: one-for-all mfd device and one-for-one
> device drivers.
> 
> MFD
> pros:
> * easy to add into the tree (one file)
> * easy config (one option)
> 
> Separate devices
> * easy to support devices as respective subsystems evolve
> * easy to add new feature without breaking existing ones. Eg. it may
> make sense to provide industrial IO interface on analog IO devices
> * possible to have fine-grained configuration (eg. SRAM in kernel,
> serial and slot as modules)
> * proper device tree serves as a datasheet for the machine, so anyone
> who needs to work on it will have a decent view of the internals
> 
> I believe long-term benefits of separate devices outweigh immediate
> effects of an MFD. However, I certainly don't see the big picture and
> will accept your decision. Please make one.

Unfortunately I don't have a good way to judge the tradeoffs without
understanding more about the design of the hardware. Did I understand
you right that you expect future versions of the FPGA bitstream
to implement additional features or have a different set of endpoint
devices?

If so, I would argue that anything that you consider an optional
sub-device should have its own device node in the device tree.

Also, do you have to model hardware that is connected to the FPGA
rather than being part of it?

I suspect that you may have a different understanding of the term
MFD than what I was suggesting: A typical MFD driver in Linux is
basically a container device that has some registers on its own
like a version detection or the irqchip but mainly is there to
create sub-devices that each have a subset of the available
registers. The sub-devices may or may not be describe in DT in this
case.

	Arnd
