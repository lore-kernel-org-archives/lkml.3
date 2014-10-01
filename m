Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaJARh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 13:37:26 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:55688 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaJARhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 13:37:24 -0400
Subject: [PATCH v2 0/5] perf/sdt: SDT events listing/probing
To: linux-kernel@vger.kernel.org
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Date: Wed, 01 Oct 2014 08:14:58 +0530
Message-ID: <20141001023723.28985.39736.stgit@hemant-fedora>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100117-5140-0000-0000-0000005A6A9E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset helps in listing dtrace style markers(SDT) present in user space
applications through perf.
Notes/markers are placed at important places by the
developers. They have a negligible overhead when not enabled.
We can enable them and probe at these places and find some important information
like the arguments' values, etc.

We have lots of applications which use SDT markers today, like:
Postgresql, MySql, Mozilla, Perl, Python, Java, Ruby, libvirt, QEMU, glib

To add SDT markers into user applications:
We need to have this header sys/sdt.h present.
sys/sdt.h used is version 3.
If not present, install systemtap-sdt-devel package (for fedora-20).

With this patchset,
- Use perf sdt-cache --add to add SDT events to a cache.
 # perf sdt-cache --add ./user_app

 4 SDT events added for /home/user/user_app!

- Use perf sdt-cache --del to remove SDT events from the cache>
 # perf sdt-cache --del ./user_app

 4 events removed for /home/user/user_app!

- Dump the cache onto stdout using perf sdt-cache --dump:
 # perf sdt-cache --dump
  /home/user/user_app :
  %user_app:foo_start
  %user_app:fun_start

- To probe and trace an SDT event :
  # perf record -e %user_app:foo_start -aR sleep 10

The support for perf to sdt events has undergone a lot of changes since it was
introduced. After a lot of discussions (https://lkml.org/lkml/2014/7/20/284), the
patchset is subdivided for ease of review.
Previously, a patchset supporting "perf list sdt" was posted, but it didn't make
much sense, since only listing SDT events for an ELF won't help.
This patchset aims at adding a sub-command "sdt-cache" to perf to manage a cache
for management of the SDT events.

This link shows an example of marker probing with Systemtap:
https://sourceware.org/systemtap/wiki/AddingUserSpaceProbingToApps

This link provides important info regarding SDT notes:
http://sourceware.org/systemtap/wiki/UserSpaceProbeImplementation

- Markers in binaries :
These SDT markers are present in the ELF in the section named
".note.stapsdt".
Here, the name of the marker, its provider, type, location, base
address, semaphore address.
We can retrieve these values using the members name_off and desc_off in
Nhdr structure.

Changes since v1:
- Rebased it to tip/master

Changes since last series :
 - Changed the entire (linked) list structure to hash lists to manage the SDT events.
 - Added a sub command "sdt-cache" to perf to manage SDT events in the system.
 - Added support to add and remove SDT events onto a cache.
 - Added support to "perf record" to probe and record the SDT events.

 TODO:
 - Add support to add most of the SDT events on a system to the cache.
 - Recognizing arguments and support to probe on them.
---

Hemant Kumar (5):
      perf/sdt: ELF support for SDT
      perf/sdt: Add SDT events into a cache
      perf/sdt: Show SDT cache contents
      perf/sdt: Delete SDT events from cache
      perf/sdt: Add support to perf record to trace SDT events


 tools/perf/Makefile.perf       |    3 
 tools/perf/builtin-record.c    |   21 +
 tools/perf/builtin-sdt-cache.c |  109 +++++
 tools/perf/builtin.h           |    1 
 tools/perf/perf.c              |    1 
 tools/perf/util/parse-events.c |    7 
 tools/perf/util/parse-events.h |    7 
 tools/perf/util/probe-event.c  |  120 ++++-
 tools/perf/util/probe-event.h  |    8 
 tools/perf/util/probe-finder.c |    3 
 tools/perf/util/sdt.c          |  926 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/sdt.h          |   30 +
 tools/perf/util/symbol-elf.c   |  207 +++++++++
 tools/perf/util/symbol.h       |   21 +
 14 files changed, 1442 insertions(+), 22 deletions(-)
 create mode 100644 tools/perf/builtin-sdt-cache.c
 create mode 100644 tools/perf/util/sdt.c
 create mode 100644 tools/perf/util/sdt.h

-- 

