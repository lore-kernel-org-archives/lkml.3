Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbaAFMIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 07:08:19 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:38753 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379AbaAFMIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:08:17 -0500
From: Satish Patel <satish.patel@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: <rob@landley.net>, <gregkh@linuxfoundation.org>, <arnd@arndb.de>
Subject: [RFC PATCH v1 0/5] Smart Card(SC) interface, TI USIM & NxP SC phy driver
Date: Mon, 6 Jan 2014 17:37:37 +0530
Message-ID: <1389010062-17185-1-git-send-email-satish.patel@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__no__ public interface present in linux between smart card phy and
smart card controller, which meets smart card protocol requirements
such as
- bit-banding of smart card pins (rst, clk, io, c4) for memory based
synchronous cards
- communication with phy having multiple slots for smart card
- EMV timing paratmers settings and voltage configuration for smart
card inserted to phy slot
- Notification for card insert/remove/overheat etc.

Also,
- Interface to make ease of configuration for smart card controller to work
with and without external smart card phy

EMV stands for Europay, Mastercard & Visa - smart card standard

Introduction to smart card stack:
---------------------------------

The use of smartcard is increasing in embedded industry. As smartcard
not only prevent duplication but also, brings key based
authentication flow into picture. Smart card standards like
EMV (EuroPay-Mastercard-Visa) are becoming mandatory for payment
terminals.

Till date, most of the smart card readers are based on USB serial
interface. Which drives its logic within firmware lies on device.
Few are based on FPGA solutions. But now SoCs are coming up with
inbuilt smartcard controller. e.g. TI-AM43x

Role of smart card controller and smart card phy:

Smartcard Phy:
Forms electrical interface between controller and smart card. Phy
enables access to more than one smartcard and in addition it provides
fast deactivation logic when card gets removed from the slot. It can
also generate the signals like card insert/remove/overheat etc.

Smartcard Controller:
In built mechanism to meet EMV L1 specification (e.g. T=0, T=1
protocol timings, ATR timeout etc..) for smart card transaction. In
addition to this, it has FIFO to store tx/rx bytes, internal state
machine for ATR, Tx/Rx, Synchronous/Asynchronous mode, timing
counters etc..

Controller can also have direct interface through which smart card
can be connected without phy.

Below is the brief of smart card block diagram from user to h/w
layer.


        -----------
        |PC/SC App|
        -----------
        -----------     -----------
        |PC/SC F/W|     | Visa APP|
        -----------     -----------
        -----------     ------------    ------------
        |IFD Hand.|     | EMV L1/L2|    | Test App |
        -----------     ------------    ------------
User Space
--------------------------------------------------------------------	

        -----------------------------------------
        |   smart Card Controller Driver        |
        -----------------------------------------
                 |                     |
                 |                     |
        -------------                  |	
        | Phy Driver |                 |
        -------------                  |
                 |                     |
Kernel Space     |                     |
--------------------------------------------------------------------	
                 |                     |
           ---------              ----------------
           | PHY   |              |Controller IP |
           ---------              ----------------
                |                       |
--------------------------------------------------------------------	
                |                       |
           _______________________________________
           |                |                |
         VISA card       Master Card      Custom Card
	

At present in Linux there is no public interface exist which acts as
bridge between controller and phy. Mostly vendors uses proprietary
solution in such cases. 

This is RFC proposed to demonstrate smart card phy interface that exposes
phy's capabilities to the smart card controller. Smart card
controller uses this interface to communicate with smart card via phy.
Such capabilities are:
1) Some smart card phy (TDA8026-NxP) has multiple slots for smart
cards. This interface enables controller to communicate with specific
smart card inserted to the specific phy's slot.
2) Warm reset to smart card inserted to phy slot.
3) Bit banging of smart card pins to support vendor specific memory
cards.
4) Notification of card insert/remove/overheat etc.
5) synchronous and asynchronous modes for smart card transaction

How to use:
-----------
The smart card phy, who wants to be interfaced with smart card
controller, can include this header file and implement applicable
functionalities mentioned inside the file. 

Smart card phy need to use "sc_phy structure" as device data.
Controller can get this data pointer from DT handle and call required
functions.

Patch set includes:
- Smart card phy interface
- NxP (tda8026) smart card phy driver
- TI USIM - smart card controller driver

FAQs:
-----
Que: Why interface exposes voltage level to the controller or
application ?
Ans: It is requirement of smartcard protocols(PC/SC, EMVL2). At
present only open source protocol on this is PC/SC. But many vendor
who implements EMV L1/L2 stack, require smart card voltage to be set
from application. As per EMV standard - smartcard should support
1.8/3/5V volts. It defines class of smart card.

Smart card can be enumerated with either of voltage level (if it is
EMV) but further operation to smart card should be done with voltage
level information which comes as a part of answer to reset. - ATR
byes will be parsed by user level stack, as it contains vendor ( who
supply the smart card and end application which will work with that
card like VISA) specific information 

Ref# - section# voltage selection
http://anonscm.debian.org/viewvc/pcsclite/trunk/Drivers/ccid/README?view=markup

EMV - book1 section# supply voltage
http://www.emvco.com/specifications.aspx?id=223


Que: Why pin configuration settings are exposed ?
Ans: Mostly all memory based (synchronous) cards runs on propriety
algorithm running on user space. Algorithm toggles the level on pins
like -i/o,clock,c4,rst to get require information from the smart
card. These smart card are customized by vendor/product owner.

Que: Why interface like activation/deactivation and warm-reset are
exposed ? Can't it be done as a part of phy initialization ?
Ans: Here activation/deactivation is different than power on/off for
smart card phy. This is an activation and deactivation of smart card
not the phy. Normally in case of smart card - user application/stack
will decide when to carry out this sequence once card is inserted to
the slot. 
e.g. Certain stack will carry out warm reset if activation fails and
some will decide to do de-activation. 
http://pcsclite.alioth.debian.org/api/group__IFDHandler.html

Que: Why not generic phy framework ?
Ans: We will be more than happy to adapt generic phy if it
includes/add support for smart card requirement.

Currently,
(1) That does not support the requirement of memory card and EMV
card, where application (who are supplying smartcards) need 
control to set voltage, and timing parameters.
(2) Does not support warm reset and does not expose pin configuration
to application.
(3) Does not support notification of events from phy.


References
----------
[1] NxP Phy's datasheet
	www.nxp.com/documents/data_sheet/TDA8026.pdf
	http://www.nxp.com/documents/application_note/AN10724.pdf

[2] TI smart card controller
	coming soon

[3] EVM specification
	http://www.emvco.com

[4] Smart card framework and applications
	https://code.google.com/p/cardpeek
	http://www.linuxnet.com/index.html

Satish Patel (5):
  sc_phy:SmartCard(SC) PHY interface to SC controller
  misc: tda8026: Add NXP TDA8026 PHY driver
  char: ti-usim: Add driver for USIM module on AM43xx
  ARM: dts: AM43xx: DT entries added for ti-usim
  ARM: dts: AM43xx-epos-evm: DT entries  for ti-usim

 Documentation/devicetree/bindings/misc/tda8026.txt |   14 +
 .../devicetree/bindings/ti-usim/ti-usim.txt        |   31 +
 Documentation/sc_phy.txt                           |  171 ++
 arch/arm/boot/dts/am4372.dtsi                      |   11 +
 arch/arm/boot/dts/am43x-epos-evm.dts               |   30 +
 drivers/char/Kconfig                               |    7 +
 drivers/char/Makefile                              |    1 +
 drivers/char/ti-usim-hw.h                          |  863 +++++++++
 drivers/char/ti-usim.c                             | 1851 ++++++++++++++++++++
 drivers/misc/Kconfig                               |    7 +
 drivers/misc/Makefile                              |    1 +
 drivers/misc/tda8026.c                             | 1271 ++++++++++++++
 include/linux/sc_phy.h                             |  132 ++
 include/linux/ti-usim.h                            |   97 +
 14 files changed, 4487 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/misc/tda8026.txt
 create mode 100644 Documentation/devicetree/bindings/ti-usim/ti-usim.txt
 create mode 100644 Documentation/sc_phy.txt
 create mode 100644 drivers/char/ti-usim-hw.h
 create mode 100644 drivers/char/ti-usim.c
 create mode 100644 drivers/misc/tda8026.c
 create mode 100644 include/linux/sc_phy.h
 create mode 100644 include/linux/ti-usim.h

