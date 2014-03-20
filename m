Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbaCTJjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:39:17 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:39547 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191AbaCTJjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:39:14 -0400
Subject: [PATCH 00/33] [RFC] Non disruptive application core dump
 infrastructure
To: linux-kernel@vger.kernel.org
From: Janani Venkataraman <jananive@linux.vnet.ibm.com>
Cc: amwang@redhat.com, procps@freelists.org, rdunlap@xenotime.net,
        james.hogan@imgtec.com, aravinda@linux.vnet.ibm.com, hch@lst.de,
        mhiramat@redhat.com, jeremy.fitzhardinge@citrix.com,
        xemul@parallels.com, d.hatayama@jp.fujitsu.com, coreutils@gnu.org,
        kosaki.motohiro@jp.fujitsu.com, adobriyan@gmail.com,
        util-linux@vger.kernel.org, tarundsk@linux.vnet.ibm.com,
        vapier@gentoo.org, roland@hack.frob.com, ananth@linux.vnet.ibm.com,
        gorcunov@openvz.org, avagin@openvz.org, oleg@redhat.com,
        eparis@redhat.com, suzuki@linux.vnet.ibm.com, andi@firstfloor.org,
        tj@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Date: Thu, 20 Mar 2014 15:09:03 +0530
Message-ID: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-4790-0000-0000-0000003F23E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The following series implements an infrastructure for capturing the core of an
application without disrupting its process.

Kernel Space Approach:

1) Posted an RFD to LKML explaining the various kernel-methods being analysed.

https://lkml.org/lkml/2013/9/3/122

2) Went ahead to implement the same using the task_work_add approach and posted an
RFC to LKML.

http://lwn.net/Articles/569534/

Based on the responses, the present approach implements the same in User-Space.

User Space Approach:

We didn't adopt the CRIU approach because our method would give us a head
start, as all that the distro would need is the PTRACE_functionality and nothing
more which is available from kernel versions 3.4 and above.

Basic Idea of User Space:

1) The threads are held using PTRACE_SEIZE and PTRACE_INTERRUPT.

2) The dump is then taken using the following:
    1) The register sets namely general purpose, floating point and the arch
    specific register sets are collected through PTRACE_GETREGSET calls by
    passing the appropriate register type as parameter.
    2) The virtual memory maps are collected from /proc/pid/maps.
    3) The auxiliary vector is collected from /proc/pid/auxv.
    4) Process state information for filling the notes such as PRSTATUS and
    PRPSINFO are collected from /proc/pid/stat and /proc/pid/status.
    5) The actual memory is read through process_vm_readv syscall as suggested
    by Andi Kleen.
    6) Command line arguments are collected from /proc/pid/cmdline

3) The threads are then released using PTRACE_DETACH.

Self Dump:

A self dump is implemented with the following approach which was adapted
from CRIU:

Gencore Daemon

The programs can request a dump using gencore() API, provided through
libgencore. This is implemented through a daemon which listens on a UNIX File
socket. The daemon is started immediately post installation.

We have provided service scripts for integration with systemd.

NOTE:

On systems with systemd, we could make use of socket option, which will avoid
the need for running the gencore daemon always. The systemd can wait on the
socket for requests and trigger the daemon as and when required. However, since
the systemd socket APIs are not exported yet, we have disabled the supporting
code for this feature.

libgencore:

1) The client interface is a standard library call. All that the dump requester
does is open the library and call the gencore() API and the dump will be
generated in the path specified(relative/absolute).

To Do:

1) Presently we wait indefinitely for the all the threads to seize. We can add
a time-out to decide how much time we need to wait for the threads to be
seized. This can be passed as command line argument in the case of a third
party dump and in the case of the self-dump through the library call. We need
to work on how much time to wait.

2) Like mentioned before, the systemd socket APIs are not exported yet and
hence this option is disabled now. Once these API's are available we can enable
the socket option.

We would like to push this to one of the following packages:
a) util-linux
b) coreutils
c) procps-ng

We are not sure which one would suit this application the best.
Please let us know your views on the same.

Patches 1 - 16 implements the dump generation.

Patches 17 - 24 implements the daemon approach.

Patch 25 implements the systemd socket approach.

Patches 26-27 implements the client-interface library.

Patches 28-33 handles the building and other packaging aspects.

Please let us know your reviews and comments.

Thanks.

Janani Venkataraman (33):
      Configure and Make files
      Validity of arguments
      Process Status
      Hold threads
      Fetching Memory maps
      Check ELF class
      Do elf_coredump
      Fills elf header
      Adding notes infrastructure
      Populates PRPS info
      Populate AUXV
      Fetch File maps
      Fetching thread specific Notes
      Populating Program Headers
      Updating Offset
      Writing to core file
      Daemonizing the Process
      Socket operations
      Block till request
      Handling Requests
      Get Clients PID
      Dump the task
      Handling SIG TERM of the daemon
      Handling SIG TERM of the child
      Systemd Socket ID retrieval
      [libgencore] Setting up Connection
      [libgencore] Request for dump
      Man pages
      Automake files for the doc folder
      README, COPYING, Changelog
      Spec file
      Socket and Service files.
      Support check


 COPYING            |   24 ++
 COPYING.LIBGENCORE |   24 ++
 Changelog          |    7 
 Makefile.am        |   22 +
 README             |  108 +++++++
 configure.ac       |    8 +
 doc/Makefile.am    |    2 
 doc/gencore.1      |   31 ++
 doc/gencore.3      |   28 ++
 gencore.service    |    9 +
 gencore.socket     |   10 +
 gencore.spec.in    |   88 ++++++
 gencore@.service   |    9 +
 libgencore.pc.in   |    8 +
 src/Makefile.am    |   13 +
 src/client.c       |  121 ++++++++
 src/coredump.c     |  764 ++++++++++++++++++++++++++++++++++++++++++++++++
 src/coredump.h     |   74 +++++
 src/elf-compat.h   |  124 ++++++++
 src/elf.c          |  827 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/elf32.c        |   43 +++
 src/elf64.c        |   44 +++
 src/gencore.h      |    1 
 src/proc.c         |  278 +++++++++++++++++
 24 files changed, 2667 insertions(+)
 create mode 100644 COPYING
 create mode 100644 COPYING.LIBGENCORE
 create mode 100644 Changelog
 create mode 100644 README
 create mode 100644 doc/Makefile.am
 create mode 100644 doc/gencore.1
 create mode 100644 doc/gencore.3
 create mode 100644 gencore.service
 create mode 100644 gencore.socket
 create mode 100644 gencore.spec.in
 create mode 100644 gencore@.service
 create mode 100644 libgencore.pc.in
 create mode 100644 src/Makefile.am
 create mode 100644 src/client.c
 create mode 100644 src/coredump.c
 create mode 100644 src/coredump.h
 create mode 100644 src/elf-compat.h
 create mode 100644 src/elf.c
 create mode 100644 src/elf32.c
 create mode 100644 src/elf64.c
 create mode 100644 src/gencore.h
 create mode 100644 src/proc.c

-- 
Janani

