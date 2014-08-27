Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935831AbaH0UQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 16:16:08 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:44896 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935793AbaH0UPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 16:15:51 -0400
Subject: [PATCH v3 0/3] perf/sdt : Support for SDT markers
To: linux-kernel@vger.kernel.org
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Date: Thu, 28 Aug 2014 01:45:32 +0530
Message-ID: <20140827200933.11095.96814.stgit@hemant-fedora>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082720-0260-0000-0000-000000204AB5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset helps in listing dtrace style markers(SDT) present in user space
applications through perf.
SDT Notes/markers are placed at important places by the
developers. They have a negligible overhead when not enabled.
We can enable them and probe at these places and find some important information
like the arguments' values, etc.

We have lots of applications which use SDT markers today, like:
Postgresql, MySql, Mozilla, Perl, Python, Java, Ruby, libvirt, QEMU, glib

To add SDT markers into user applications:
We need to have this header sys/sdt.h present.
sys/sdt.h used is version 3.
If not present, install systemtap-sdt-devel package (for fedora-18).

Please refer to the Documentation patch (3rd patch in this series) to see how the
SDT markers are added to a program.

With this patchset,
- Use perf to list the markers in the app:
# perf list sdt ./user_app

./user_app :
%user_app:foo_start
%user_app:fun_start

This link shows an example of marker probing with Systemtap:
https://sourceware.org/systemtap/wiki/AddingUserSpaceProbingToApps

Also, this link provides important info regarding SDT notes:
http://sourceware.org/systemtap/wiki/UserSpaceProbeImplementation

This patchset has undergone a lot of changes since it was first	introduced.
Hence, the patchset has now been subdivided for more simplicity	and ease of
review (thanks to the suggestion from Namhyung Kim). This contains the first 2
of the 4 patches as suggested here:
https://lkml.org/lkml/2014/7/20/284

- Markers in binaries :
These SDT markers are present in the ELF in the section named
".note.stapsdt".
Here, the name of the marker, its provider, type, location, base
address, semaphore address.
We can retrieve these values using the members name_off and desc_off in
Nhdr structure. If these are not enabled, they are present in the ELF as nop.

Changes since last series :
- Subdivided the previous patchset into 4 patches to make it easier to review
  as suggested by Namhyung Kim. (This set includes first two of	    the four patches)
- Made the required changes and	some optimizations suggested by	    Masami,  Namhyung
  and Andi.

TODO:
- Listing SDT events present in most of the binaries present in a system.
- Maintaining a cache of the SDT events for faster lookup.
- Add support to probe these SDT markers and integrate with a previous patch
  (support to perf to probe SDT markers) posted in lkml.
  https://lkml.org/lkml/2013/10/23/10

- Recognizing arguments and support to probe on them.
- Add semaphore support.

---

Hemant Kumar (3):
      Raw SDT parsing functions
      Support perf-list to print SDT events in a single file
      Adds documentation for perf support to SDT events.


 tools/perf/Documentation/SDT-support.txt |   48 ++++++
 tools/perf/Documentation/perf-list.txt   |    4 
 tools/perf/Makefile.perf                 |    1 
 tools/perf/builtin-list.c                |    2 
 tools/perf/util/parse-events.h           |    2 
 tools/perf/util/sdt.c                    |  113 ++++++++++++++
 tools/perf/util/symbol-elf.c             |  244 ++++++++++++++++++++++++++++++
 tools/perf/util/symbol.h                 |   19 ++
 8 files changed, 432 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/Documentation/SDT-support.txt
 create mode 100644 tools/perf/util/sdt.c

-- 

