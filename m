Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab3LDNB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 08:01:56 -0500
Received: from top.free-electrons.com ([176.31.233.9]:40718 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755454Ab3LDNBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 08:01:54 -0500
Date: Wed, 4 Dec 2013 10:01:56 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Jason Cooper <jason@lakedaemon.net>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH v2] serial: 8250_dw: Improve unwritable LCR workaround
Message-ID: <20131204130156.GA2486@localhost>
References: <1380647888-32473-1-git-send-email-tim.kryger@linaro.org>
 <20131126183559.GA18570@localhost>
 <CAAYSxhqU9GZdaoTjoCAeyQ4h-KPVzU0BH0D1eLYJoFZ+s8tPgQ@mail.gmail.com>
 <20131127185448.GA21422@localhost>
 <20131128093034.5d61130a@skate>
 <20131128194720.GD13182@localhost>
 <20131128195337.GE13182@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131128195337.GE13182@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 04:53:37PM -0300, Ezequiel Garcia wrote:
> On Thu, Nov 28, 2013 at 04:47:20PM -0300, Ezequiel Garcia wrote:
> > Hi Thomas, Tim:
> > 
> > On Thu, Nov 28, 2013 at 09:30:34AM +0100, Thomas Petazzoni wrote:
> > > Dear Ezequiel Garcia,
> > > 
> > > On Wed, 27 Nov 2013 15:54:49 -0300, Ezequiel Garcia wrote:
> > > 
> > > > > An external device may be keeping the UART busy and preventing LCR
> > > > > from being written.
> > > > > 
> > > > > What device is attached to ttyS1?
> > > > 
> > > > There's no device attached at ttyS1. I've just tested this in another
> > > > box and it seems the same error is obtained on each unused port:
> > > 
> > > Are you sure about this? I suppose you're testing on the Armada XP GP
> > > board, and this board has a 4 ports FTDI chip, and according to the
> > > board schematics the four UARTs are all connected to the FTDI chip. So
> > > from the SoC perspective, ttyS1 is connected to something, as far as I
> > > can understand. Or maybe you also tested Armada XP DB ?
> > > 
> > 
> > Yeah, sorry about that. I missed the FTDI chip. As Thomas says the XP GP
> > board I'm testing this on, has its four UARTs connected to a FTDI chip.
> > 
> > Changing the console port by setting "console=ttyS1,115200" gives this:
> > 
> > [..]
> > Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> > dw-apb-uart d0012000.serial: Couldn't set LCR to 191
> > dw-apb-uart d0012000.serial: Couldn't set LCR to 191
> > dw-apb-uart d0012000.serial: Couldn't set LCR to 224
> > dw-apb-uart d0012000.serial: Couldn't set LCR to 224
> > d0012000.serial: ttyS0 at MMIO 0xd0012000 (irq = 17, base_baud = 15625000) is a 16550A
> > dw-apb-uart d0012100.serial: Couldn't set LCR to 191
> > dw-apb-uart d0012100.serial: Couldn't set LCR to 191
> > dw-apb-uart d0012100.serial: Couldn't set LCR to 224
> > dw-apb-uart d0012100.serial: Couldn't set LCR to 224
> > d0012100.serial: ttyS1 at MMIO 0xd0012100 (irq = 18, base_baud = 15625000) is a 16550A
> > console [ttyS1] enabled
> > dw-apb-uart d0012200.serial: Couldn't set LCR to 191
> > dw-apb-uart d0012200.serial: Couldn't set LCR to 191
> > dw-apb-uart d0012200.serial: Couldn't set LCR to 224
> > dw-apb-uart d0012200.serial: Couldn't set LCR to 224
> > d0012200.serial: ttyS2 at MMIO 0xd0012200 (irq = 31, base_baud = 15625000) is a 16550A
> > dw-apb-uart d0012300.serial: Couldn't set LCR to 191
> > dw-apb-uart d0012300.serial: Couldn't set LCR to 191
> > dw-apb-uart d0012300.serial: Couldn't set LCR to 224
> > dw-apb-uart d0012300.serial: Couldn't set LCR to 224
> > d0012300.serial: ttyS3 at MMIO 0xd0012300 (irq = 32, base_baud = 15625000) is a 16550A
> > 
> > So we get the "Couldn't set" message in all four ports.
> > 
> > Tim: Any ideas?
> 
> And another thing: the weird output on the console looks related to the
> early boot console. If I enable 'earlyprintk' on ttyS0 but set the console
> on ttyS1, this is what I get on ttyS0:
> 
> bootconsole [earlycon0] enabled
> [..]
> Kernel command line: earlyprintk console=ttyS1,115200 root=/dev/nfs rw nfsroot=192.168.0.45:/opt/buildrootfs,v3, ip=192.168.0.159:192.168.0.45:192.168.0.1:255.255.255.0:develboard:eth0:on rootwait
> [..]
> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> �Ɋ��Ɂ����Ɇ�������������������������������������
> Welcome to Buildroot
> buildroot login: 
> 
> Hope this helps you understand what's going on...

Gentle ping?

Any ideas about those weird characters?

Thanks!
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
