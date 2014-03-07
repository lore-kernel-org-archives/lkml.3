Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbaCGAiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 19:38:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.131]:56704 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaCGAiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 19:38:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v6 1/3] Fix ioport_map() for !CONFIG_GENERIC_IOMAP cases.
Date: Fri, 7 Mar 2014 01:37:38 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, "linux-pci" <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linaro-kernel" <linaro-kernel@lists.linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>, Tanmay Inamdar <tinamdar@apm.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>
References: <1394020150-1875-1-git-send-email-Liviu.Dudau@arm.com> <1394020150-1875-2-git-send-email-Liviu.Dudau@arm.com> <20140305233135.GZ21483@n2100.arm.linux.org.uk>
In-Reply-To: <20140305233135.GZ21483@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201403070137.38621.arnd@arndb.de>
X-Provags-ID: V02:K0:Rd7BpcFcB+8GQFd0NabR6q8rS4KInIlaIkDL2jOJ4Fc
 mq6Twi2ZsWGQgf5/KJ0VMOxlL9xkY68icr7juaNtx2IzkFtxJn
 LM/Ap76sQ5qgVWr/eghd1anH1TKrA721s3WMi3/wm87YePfhAg
 Kl51XRx9eFHou94S2cvPHFrnOqfCHhHbNENK/3Fu97WlDJVkQb
 fV0g/Y4NzZ9uYI4zdVNVZ1eN2wWuagwY8zdGrdhxh9dP2IZnOy
 9fW13cjgy+JWqYXXIMAXRKYYQG6ufP6DzOSlFa/T28ol83Jf1B
 Vrup+YFnKyeHdTugmR19SmPGqaqgdHcZ8iCevF9G7rI4+2KEsK
 DPoLRCePhSvcefO7DNmOVjLVz7Gt2cuBQf1higi5w
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 March 2014, Russell King - ARM Linux wrote:
> On Wed, Mar 05, 2014 at 11:49:08AM +0000, Liviu Dudau wrote:
> > The inline version of ioport_map() that gets used when !CONFIG_GENERIC_IOMAP
> > is wrong. It returns a mapped (i.e. virtual) address that can start from
> > zero and completely ignores the PCI_IOBASE and IO_SPACE_LIMIT that most
> > architectures that use !CONFIG_GENERIC_MAP define.
> 
> What value does PCI_IOBASE and IO_SPACE_LIMIT have on other architectures
> who make use of asm-generic/io.h ?
> 
> $ git grep asm-generic/io.h arch/
> arch/arc/include/asm/io.h:#include <asm-generic/io.h>

PCI support hasn't been upstreamed.

> arch/blackfin/include/asm/io.h:#include <asm-generic/io.h>
> arch/metag/include/asm/io.h:#include <asm-generic/io.h>

No PCI support

> arch/microblaze/include/asm/io.h:/* from asm-generic/io.h */

PCI_IOBASE=0, IO_SPACE_LIMIT=0xffffffff, so no change.

> arch/openrisc/include/asm/io.h:#include <asm-generic/io.h>

No PCI support

> arch/s390/include/asm/io.h:#include <asm-generic/io.h>

s390 supports PCI but no I/O space

> arch/score/include/asm/io.h:#include <asm-generic/io.h>

No PCI support

> arch/unicore32/include/asm/io.h:#include <asm-generic/io.h>

unicore32 is broken currently, the patch fixes it.

> arch/xtensa/include/asm/io.h:#include <asm-generic/io.h>

PCI_IOBASE=0, IO_SPACE_LIMIT=0xffffffff, so no change.

For most of these, I assume we actually want to remove support
for inb/outb as they don't support I/O space accesses. The other
ones look correct to me.

	Arnd
