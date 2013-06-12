Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3FLHOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 03:14:12 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:48458 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763Ab3FLHOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 03:14:11 -0400
Date: Wed, 12 Jun 2013 09:13:13 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Juan David Gonzalez Cobas <juan.david.gonzalez.cobas@cern.ch>,
        "Emilio G. Cota" <cota@braap.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        gregkh@linuxfoundation.org, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org
Subject: [PATCH 0/8] Support for FMC carriers and mezzanines
Message-ID: <cover.1371018406.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set includes the Linux bus abstraction for FMC (ANSI/VITA 57).

I posted it on Feb 21 2013 as an RFC, and I only got an Acked-by
about documentation by Rob Landley; I include that Acked-by in this patch
set, even if there are some minor changes in the docs -- typos and
new capabilities for the fmc-fakedev carrier module.

I fixed the device release bug noted by Greg-KH (yes, I deserved being
ridiculed for that). There are no other serious changes, and we are now
running this in production as a backport to 2.6.24-rt.

The whole patch-set is sent to lkml, Greg K H (for drivers/), Rob Landley
and the linux-doc list (both for Documentation/).

The code I'm submitting is currently maintained outside of the kernel
proper. See http://www.ohwr.org/projects/fmc-bus/ . The public
repository is at git://ohwr.org/fmc-projects/fmc-bus.git and the
current manual is at
http://www.ohwr.org/attachments/download/2124/fmc-bus-2013-05.1-release.pdf

The following text is an almost verbatim copy of parts of our
documentation, as included in the fmc-bus package.



FMC (FPGA Mezzanine Card) is the standard we use for our I/O devices,
in the context of White Rabbit and related hardware.

In our I/O environments we need to write drivers for each mezzanine
card, and such drivers must work independent of the carrier being used.
To achieve this, we abstract the FMC interface.

We have a carrier for PCI-E called SPEC and one for VME called SVEC,
but more are planned.  Also, we support stand-alone devices (usually
plugged on a SPEC card), controlled through Etherbone, developed by GSI.

FMC is a standard developed by the VME consortium called VITA (VMEbus
International Trade Association and ratified by ANSI, the American
National Standard Institute.  The official documentation is called
"ANSI-VITA 57.1".

The FMC card is an almost square PCB, around 70x75 millimeters, that
is called mezzanine in code and documentation under drivers/fmc.  It
usually lives plugged into into another PCB for power supply and
control; such bigger circuit board is called carrier from now on, and
a single carrier may host more than one mezzanine.

In the typical application the mezzanine is mostly analog while the
carrier is mostly digital, and hosts an FPGA that must be programmed to
match the specific mezzanine and the desired application. Thus, you may
need to load different FPGA images to drive different instances of the
same mezzanine.

FMC, as such, is not a bus in the usual meaning of the term, because
most carriers have only one connector, and carriers with several
connectors have completely separate electrical connections to them.
This package, however, implements a bus as a software abstraction.


SDB (Self Describing Bus) is a set of data structures that we use for
enumerating the internal structure of an FPGA image. We also use it as
a filesystem inside the FMC EEPROM.

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
 Documentation/fmc/API.txt              |   47 +++++
 Documentation/fmc/FMC-and-SDB.txt      |   88 ++++++++
 Documentation/fmc/carrier.txt          |  311 ++++++++++++++++++++++++++++
 Documentation/fmc/fmc-chardev.txt      |   64 ++++++
 Documentation/fmc/fmc-fakedev.txt      |   36 ++++
 Documentation/fmc/fmc-trivial.txt      |   17 ++
 Documentation/fmc/fmc-write-eeprom.txt |  125 ++++++++++++
 Documentation/fmc/identifiers.txt      |  168 +++++++++++++++
 Documentation/fmc/mezzanine.txt        |  123 +++++++++++
 Documentation/fmc/parameters.txt       |   56 +++++
 MAINTAINERS                            |    9 +
 drivers/Kconfig                        |    2 +
 drivers/Makefile                       |    1 +
 drivers/fmc/Kconfig                    |   51 +++++
 drivers/fmc/Makefile                   |   13 ++
 drivers/fmc/fmc-chardev.c              |  197 ++++++++++++++++++
 drivers/fmc/fmc-core.c                 |  296 +++++++++++++++++++++++++++
 drivers/fmc/fmc-dump.c                 |  100 +++++++++
 drivers/fmc/fmc-fakedev.c              |  349 ++++++++++++++++++++++++++++++++
 drivers/fmc/fmc-match.c                |  114 +++++++++++
 drivers/fmc/fmc-sdb.c                  |  265 ++++++++++++++++++++++++
 drivers/fmc/fmc-trivial.c              |  101 +++++++++
 drivers/fmc/fmc-write-eeprom.c         |  176 ++++++++++++++++
 drivers/fmc/fru-parse.c                |   82 ++++++++
 include/linux/fmc-sdb.h                |   36 ++++
 include/linux/fmc.h                    |  237 ++++++++++++++++++++++
 include/linux/ipmi-fru.h               |  135 ++++++++++++
 include/linux/sdb.h                    |  159 +++++++++++++++
 30 files changed, 3398 insertions(+), 0 deletions(-)
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
