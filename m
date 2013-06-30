Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab3F3Nrx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 09:47:53 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:51116 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab3F3Nrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 09:47:49 -0400
Message-ID: <51D03700.1090709@message-id.googlemail.com>
Date: Sun, 30 Jun 2013 15:47:44 +0200
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Wang YanQing <udknight@gmail.com>
CC: stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: commit 8d2f8cd424 breaks parallel port, regression since 3.9-rc3
 / backported to stable (3.4.37)
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

the following commit:

commit 8d2f8cd424ca0b99001f3ff4f5db87c4e525f366
Author: Wang YanQing <udknight@gmail.com>
Date:   Fri Mar 1 11:47:20 2013 +0800

    serial: 8250_pci: add support for another kind of NetMos Technology PCI 9835 Multi-I/O Controller
    
    01:08.0 Communication controller: NetMos Technology PCI 9835 Multi-I/O Controller (rev 01)
        Subsystem: Device [1000:0012]
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin A routed to IRQ 20
        Region 0: I/O ports at e050 [size=8]
        Region 1: I/O ports at e040 [size=8]
        Region 2: I/O ports at e030 [size=8]
        Region 3: I/O ports at e020 [size=8]
        Region 4: I/O ports at e010 [size=8]
        Region 5: I/O ports at e000 [size=16]
    
    Signed-off-by: Wang YanQing <udknight@gmail.com>
    Cc: stable <stable@vger.kernel.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


breaks my
05:05.0 Communication controller: NetMos Technology PCI 9835 Multi-I/O Controller (rev 01)
05:05.0 0780: 9710:9835 (rev 01)
        Subsystem: 1000:0012

which has two serial and one parallel port, driven by parport_serial.

The reason is, that this commit adds the PCI ID to 8250_pci, when it
was handled by parport_serial before.
In my case (openSUSE kernel), 8250 is built in and parport_serial is
built as a module. Unfortunately with the device occupied by 8250,
parport_serial finds no device and thus does not drive the parport.

I bisected this in the stable series after the openSUSE kernel update
(which pulled in the stable kernel update) broke my printing.

Actually the above commit is totally unnecessary: the serial ports
work very well without it, they are just driven by another driver.

Can this please be reverted? I can't see which problem it solves, but
it definitely breaks the additional ports on my multi-i/o board.

Best regards,

	Stefan
-- 
Stefan Seyfried
Linux Consultant & Developer -- GPG Key: 0x731B665B

B1 Systems GmbH
Osterfeldstraße 7 / 85088 Vohburg / http://www.b1-systems.de
GF: Ralph Dehner / Unternehmenssitz: Vohburg / AG: Ingolstadt,HRB 3537
