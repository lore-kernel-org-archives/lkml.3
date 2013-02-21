Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab3BUSOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:14:01 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:35242 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755525Ab3BUSN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:13:59 -0500
Date: Thu, 21 Feb 2013 19:13:24 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: Juan David Gonzalez Cobas <dcobas@cern.ch>,
        "Emilio G. Cota" <cota@braap.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Subject: [PATCH RFC 0/8] drivers/fmc: bus support for ANSI-VITA 57.1
Message-ID: <cover.1361469465.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an RFC for upstreaming the Linux bus abstraction for FMC.  The
following text is a slightly modified extract from the documentation,
which is included in the fmc-bus package.  The code I'm
submitting is currently maintained outside of the kernel proper. See
http://www.ohwr.org/projects/fmc-bus/ . The public repository is at
git://ohwr.org/fmc-projects/fmc-bus.git and the current manual is at
http://www.ohwr.org/attachments/download/1845/fmc-bus-2013-01-release.pdf

The whole patch-set is sent to lkml, Greg K H (for drivers/), Rob Landley
and the linux-doc list (both for Documentation/).


FMC is a standard developed by the VME consortium called VITA (VMEbus
International Trade Association) and ratified by ANSI, the American
National Standard Institute.  The official documentation is called
"ANSI-VITA 57.1". The wikipedia article is
http://en.wikipedia.org/wiki/FMC_%E2%80%93_FPGA_Mezzanine_Card

FMC (FPGA Mezzanine Card) is what we use for our I/O devices,
in the context of White Rabbit and related hardware. White Rabbit
is a multi-lab synchronization project; bot software and hardware
for WR is hosted at www.ohwr.org .

In our I/O environments we need to write drivers for each mezzanine
card, and such drivers must work regardless of the carrier being used.
To achieve this, we abstract the FMC interface.

The FMC card is an almost square PCB, around 70x75 millimeters, that
is called mezzanine in code and documentation under drivers/fmc.  It
usually lives plugged into another PCB for power supply and
control; such bigger circuit board is called carrier from now on, and
a single carrier may host more than one mezzanine.

We have a carrier for PCI-E called SPEC and one for VME called SVEC,
(http://www.ohwr.org/projects/spec/wiki and
http://www.ohwr.org/projects/svec/wiki) but more are planned.  Also,
we support stand-alone devices (usually plugged on a SPEC card),
controlled through Etherbone, which in turn is developed by GSI.de .
This submission does not include drivers for specific cards like the
SPEC or SVEC, but has software-only carriers and drivers.  Nothing in
the submission in specific to CERN: the code is designed to match FMC
features, not our own specific needs.

In the typical application the mezzanine is mostly analog while the
carrier is mostly digital, and hosts an FPGA that must be configured to
match the specific mezzanine and the desired application. Thus, you may
need to load different FPGA images to drive different instances of the
same mezzanine.

FMC, as such, is not a bus in the usual meaning of the term, because
most carriers have only one connector, and carriers with several
connectors have completely separate electrical connections to them.
This package, however, implements a bus as a software abstraction.


SDB (Self Describing Bus) is a set of data structures that we use for
enumerating the internal structure of an FPGA image. We also use it as
a filesystem inside the FMC EEPROM, but this submission only uses
it to enumerate cores inside and FPGA design.

SDB is not mandatory for use of this FMC kernel bus, but if you have SDB
this package can make good use of it.  SDB itself is developed in the
fpga-config-space OHWR project. The link to the repository is
`git://ohwr.org/hdl-core-lib/fpga-config-space.git' and what is used in
this project lives in the sdbfs subdirectory in there.


Alessandro Rubini (8):
  FMC: create drivers/fmc and toplevel Kconfig question
  FMC: add needed headers
  FMC: add core bus driver
  FMC: add documentation for the core
  FMC: add a software carrier driver
  FMC: add a software mezzanine driver
  FMC: add a driver to write mezzanine EEPROM
  FMC: add a char-device mezzanine driver

 Documentation/00-INDEX                 |    2 +
 Documentation/fmc/00-INDEX             |   38 ++++
 Documentation/fmc/API.txt              |   44 +++++
 Documentation/fmc/FMC-and-SDB.txt      |   89 +++++++++
 Documentation/fmc/carrier.txt          |  311 ++++++++++++++++++++++++++++++++
 Documentation/fmc/fmc-chardev.txt      |   64 +++++++
 Documentation/fmc/fmc-fakedev.txt      |   30 +++
 Documentation/fmc/fmc-trivial.txt      |   17 ++
 Documentation/fmc/fmc-write-eeprom.txt |  112 ++++++++++++
 Documentation/fmc/identifiers.txt      |  169 +++++++++++++++++
 Documentation/fmc/mezzanine.txt        |  123 +++++++++++++
 Documentation/fmc/parameters.txt       |   56 ++++++
 MAINTAINERS                            |    9 +
 drivers/Kconfig                        |    2 +
 drivers/Makefile                       |    1 +
 drivers/fmc/Kconfig                    |   51 ++++++
 drivers/fmc/Makefile                   |   13 ++
 drivers/fmc/fmc-chardev.c              |  197 ++++++++++++++++++++
 drivers/fmc/fmc-core.c                 |  255 ++++++++++++++++++++++++++
 drivers/fmc/fmc-dump.c                 |  100 ++++++++++
 drivers/fmc/fmc-fakedev.c              |  308 +++++++++++++++++++++++++++++++
 drivers/fmc/fmc-match.c                |  108 +++++++++++
 drivers/fmc/fmc-sdb.c                  |  258 ++++++++++++++++++++++++++
 drivers/fmc/fmc-trivial.c              |  101 +++++++++++
 drivers/fmc/fmc-write-eeprom.c         |  170 +++++++++++++++++
 drivers/fmc/fru-parse.c                |   82 +++++++++
 include/linux/fmc-sdb.h                |   36 ++++
 include/linux/fmc.h                    |  237 ++++++++++++++++++++++++
 include/linux/ipmi-fru.h               |  135 ++++++++++++++
 include/linux/sdb.h                    |  130 +++++++++++++
 30 files changed, 3248 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/fmc/00-INDEX
 create mode 100644 Documentation/fmc/API.txt
 create mode 100644 Documentation/fmc/FMC-and-SDB.txt
 create mode 100644 Documentation/fmc/carrier.txt
 create mode 100644 Documentation/fmc/fmc-chardev.txt
 create mode 100644 Documentation/fmc/fmc-fakedev.txt
 create mode 100644 Documentation/fmc/fmc-trivial.txt
 create mode 100644 Documentation/fmc/fmc-write-eeprom.txt
 create mode 100644 Documentation/fmc/identifiers.txt
 create mode 100644 Documentation/fmc/mezzanine.txt
 create mode 100644 Documentation/fmc/parameters.txt
 create mode 100644 drivers/fmc/Kconfig
 create mode 100644 drivers/fmc/Makefile
 create mode 100644 drivers/fmc/fmc-chardev.c
 create mode 100644 drivers/fmc/fmc-core.c
 create mode 100644 drivers/fmc/fmc-dump.c
 create mode 100644 drivers/fmc/fmc-fakedev.c
 create mode 100644 drivers/fmc/fmc-match.c
 create mode 100644 drivers/fmc/fmc-sdb.c
 create mode 100644 drivers/fmc/fmc-trivial.c
 create mode 100644 drivers/fmc/fmc-write-eeprom.c
 create mode 100644 drivers/fmc/fru-parse.c
 create mode 100644 include/linux/fmc-sdb.h
 create mode 100644 include/linux/fmc.h
 create mode 100644 include/linux/ipmi-fru.h
 create mode 100644 include/linux/sdb.h

-- 
1.7.7.2
