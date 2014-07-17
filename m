Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761388AbaGRKSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:18:01 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:46859 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761055AbaGRKR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:17:58 -0400
Subject: [PATCH v2 0/3] perf/sdt : Support for SDT markers
To: linux-kernel@vger.kernel.org
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Date: Thu, 17 Jul 2014 11:23:36 +0530
Message-ID: <20140717054826.19995.61782.stgit@hemant-fedora>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071810-4790-0000-0000-000002BE3ACF
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
If not present, install systemtap-sdt-devel package (for fedora-18).

Please refer to the Documentation patch to see how the SDT markers are added into
a program.

With this patchset,
- Use perf to list the markers in the app:
# perf list sdt ./user_app

./user_app :
%user_app:foo_start
%user_app:fun_start

- Also, we can see the SDT markers present in our system in the usual binaries.
These usual binaries are libraries (dsos) listed by ldconfig --print-cache and some
binaries present in PATH environment variable.

First, scan the binaries using :
# perf list sdt --scan

Creating a cache of SDT markers...
perf sdt cache created!
 Use : "perf list sdt"
 to see the SDT markers

After the sdt cache file is created, use perf list to view the markers :
# perf list sdt

%rtld : init_start
%rtld : init_complete
%rtld : map_failed
%rtld : map_start
%rtld : lll_futex_wake
...
...
%libgcc : unwind
%libvirt : rpc_server_client_auth_allow
%libvirt : rpc_server_client_auth_fail
%libvirt : rpc_server_client_auth_deny

Also, by using "perf list", we can view all the SDT markers as events along with all
the other events present in the system.
Alternatively, one can view the /var/cache/perf/perf-sdt.cache directly.

This link shows an example of marker probing with Systemtap:
https://sourceware.org/systemtap/wiki/AddingUserSpaceProbingToApps

Also, this link provides important info regarding SDT notes:
http://sourceware.org/systemtap/wiki/UserSpaceProbeImplementation

- Markers in binaries :
These SDT markers are present in the ELF in the section named
".note.stapsdt".
Here, the name of the marker, its provider, type, location, base
address, semaphore address.
We can retrieve these values using the members name_off and desc_off in
Nhdr structure. If these are not enabled, they are present in the ELF as nop.

Changes since last series :
- Made the changes as discussed with Masami and Namhyung.
- Now, "perf list" will also display the SDT markers as events along with other events.
- Made some optimazations.

TODO:
- Add support to probe these SDT markers as if they are events.
- Recognizing arguments and support to probe on them.
---

Hemant Kumar (3):
      This patch enables perf to list the SDT markers present in a system. It looks
      This patch enables perf to look for SDT markers in a single file.
      This patch adds the required documentation for perf support to SDT markers.


 tools/perf/Documentation/SDT-markers.txt |  123 +++++
 tools/perf/Documentation/perf-list.txt   |    7 
 tools/perf/Makefile.perf                 |    1 
 tools/perf/builtin-list.c                |    6 
 tools/perf/util/parse-events.h           |    3 
 tools/perf/util/sdt.c                    |  778 ++++++++++++++++++++++++++++++
 tools/perf/util/symbol-elf.c             |  229 +++++++++
 tools/perf/util/symbol.h                 |   19 +
 8 files changed, 1164 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/Documentation/SDT-markers.txt
 create mode 100644 tools/perf/util/sdt.c

-- 

