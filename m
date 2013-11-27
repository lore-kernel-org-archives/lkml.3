Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab3K0SzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 13:55:04 -0500
Received: from top.free-electrons.com ([176.31.233.9]:33403 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752003Ab3K0Sy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 13:54:59 -0500
Date: Wed, 27 Nov 2013 15:54:49 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Jason Cooper <jason@lakedaemon.net>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] serial: 8250_dw: Improve unwritable LCR workaround
Message-ID: <20131127185448.GA21422@localhost>
References: <1380647888-32473-1-git-send-email-tim.kryger@linaro.org>
 <20131126183559.GA18570@localhost>
 <CAAYSxhqU9GZdaoTjoCAeyQ4h-KPVzU0BH0D1eLYJoFZ+s8tPgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAYSxhqU9GZdaoTjoCAeyQ4h-KPVzU0BH0D1eLYJoFZ+s8tPgQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 03:03:03PM -0800, Tim Kryger wrote:
> On Tue, Nov 26, 2013 at 10:36 AM, Ezequiel Garcia
> <ezequiel.garcia@free-electrons.com> wrote:
> 
> > Since v3.13-rc1, this commit seems to have introduced some oddities on
> > some of our boards. See this log snippet:
> >
> > Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> > ����R�console [ttyS0] enabled
> > console [ttyS0] enabled
> > bootconsole [earlycon0] disabled
> > bootconsole [earlycon0] disabled
> > dw-apb-uart d0012100.serial: Couldn't set LCR to 191
> > dw-apb-uart d0012100.serial: Couldn't set LCR to 191
> > dw-apb-uart d0012100.serial: Couldn't set LCR to 224
> > dw-apb-uart d0012100.serial: Couldn't set LCR to 224
> > d0012100.serial: ttyS1 at MMIO 0xd0012100 (irq = 18, base_baud = 15625000) is a 16550A
> >
> > This behavior appear in at least Armada 370 and Armada XP boxes.
> >
> > I confirm reverting this commit fixes the issue and things get back to normal.
> > Here's the complete kernel log: sprunge.us/gMdL
> >
> > Ideas?
> 
> Hi Ezequiel,
> 
> An external device may be keeping the UART busy and preventing LCR
> from being written.
> 
> What device is attached to ttyS1?

There's no device attached at ttyS1. I've just tested this in another
box and it seems the same error is obtained on each unused port:

[...]
dw-apb-uart d0012100.serial: Couldn't set LCR to 191
dw-apb-uart d0012100.serial: Couldn't set LCR to 191
dw-apb-uart d0012100.serial: Couldn't set LCR to 224
dw-apb-uart d0012100.serial: Couldn't set LCR to 224
d0012100.serial: ttyS1 at MMIO 0xd0012100 (irq = 18, base_baud = 15625000) is a 16550A
dw-apb-uart d0012200.serial: Couldn't set LCR to 191
dw-apb-uart d0012200.serial: Couldn't set LCR to 191
dw-apb-uart d0012200.serial: Couldn't set LCR to 224
dw-apb-uart d0012200.serial: Couldn't set LCR to 224
d0012200.serial: ttyS2 at MMIO 0xd0012200 (irq = 31, base_baud = 15625000) is a 16550A
dw-apb-uart d0012300.serial: Couldn't set LCR to 191
dw-apb-uart d0012300.serial: Couldn't set LCR to 191
dw-apb-uart d0012300.serial: Couldn't set LCR to 224
dw-apb-uart d0012300.serial: Couldn't set LCR to 224
d0012300.serial: ttyS3 at MMIO 0xd0012300 (irq = 32, base_baud = 15625000) is a 16550A

In this board, I only have ttyS0 (console) connected.

> Also, do you know the version of the Synopsys IP?
> If built with ADDITIONAL_FEATURES=YES, the version can be read from
> the hardware:
> 
> # busybox devmem 0xd00121f8 32
> 

No, I don't know this IP version and ADDITIONAL_FEATURES seems not built.

Thanks for taking a look at this!
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
