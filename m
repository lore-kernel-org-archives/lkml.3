Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab3LNVzv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 16:55:51 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:42630 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab3LNVzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 16:55:50 -0500
Message-ID: <1387058146.13062.24.camel@host5.omatika.ru>
Subject: Re: [PATCH v2 00/16] ARM: support for ICP DAS LP-8x4x (with dts)
From: Sergei Ianovich <ynvich@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Mack <zonque@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Date: Sun, 15 Dec 2013 01:55:46 +0400
In-Reply-To: <201312142203.45740.arnd@arndb.de>
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com>
	 <1386901645-28895-1-git-send-email-ynvich@gmail.com>
	 <201312142203.45740.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-12-14 at 22:03 +0100, Arnd Bergmann wrote:
> On Friday 13 December 2013, Sergei Ianovich wrote:
> > I've also decided not to create a single mfd device for
> > machine-specific devices. Instead each type is supported by a separate
> > driver in respective subsystem. It was tempting to hardcode all the
> > constants in one source file, but that requires ugly initialization.
> > The taken way produces much cleaner code.
> 
> I think you should at least change the DT representation for the FPGA
> to show one device as the actual FPGA and attach children to that,
> multiple indirection levels if necessary.
> 
> I suspect that the fpga is on some external-bus port with a specific
> chip-select, so I would model this as
> 
>         extbus {
>                 compatible = "simple-bus";
>                 #address-cells = <1>;
>                 #size-cells = <1>;
>                 /* bus addresses 0-0xfffff mapped to 0x17000000 */
>                 ranges = <0 0x17000000 0x100000>;
>                 interrupt-parent = <&fpga-irq>;
> 
>                 fpga-irq: irq@6 {
>                         regs = <6 16>; /* translated addresses
>                         ...
>                 };
> 
>                 fgpa-bus {
>                         #address-cells = <1>;
>                         #size-cells = <1>;
>                         ranges;
> 
>                         serial@9050 {
>                                 ...
>                         };
>                 };
>         };
> 
> I also think you don't need to make the devices quite as fine-grained
> here but instead group things together more. I would probably indeed
> put everything that is not on one of the slots into a common device,
> including the irqchip.

There are basically 2 options: one-for-all mfd device and one-for-one
device drivers.

MFD
pros:
* easy to add into the tree (one file)
* easy config (one option)

Separate devices
* easy to support devices as respective subsystems evolve
* easy to add new feature without breaking existing ones. Eg. it may
make sense to provide industrial IO interface on analog IO devices
* possible to have fine-grained configuration (eg. SRAM in kernel,
serial and slot as modules)
* proper device tree serves as a datasheet for the machine, so anyone
who needs to work on it will have a decent view of the internals

I believe long-term benefits of separate devices outweigh immediate
effects of an MFD. However, I certainly don't see the big picture and
will accept your decision. Please make one.

