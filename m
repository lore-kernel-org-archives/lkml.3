Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbaGKOgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:36:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:44993 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008AbaGKOgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:36:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,643,1400050800"; 
   d="scan'208";a="542046876"
Message-ID: <53BFF679.2030006@intel.com>
Date: Fri, 11 Jul 2014 17:36:41 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: acme@kernel.org, Jiri Olsa <jolsa@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Shishkin, Alexander" <alexander.shishkin@intel.com>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: perf tools: Call graph from Intel BTS
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Alexander Shishkin is working on the Intel PT driver for perf
and has included a driver for Intel BTS.  I have taken that and
extended perf tools to enable the creation of context-sensitive
call graphs.  A screen shot from an example call graph from
tracing "ls" is shown here:

	http://git.infradead.org/~ahunter/call-graph-bts-ls.png

The patches are here:

	http://git.infradead.org/users/ahunter/linux-perf.git

There are many perf tools patches and it would be helpful to start
considering how to get them into mainline.  Many need to wait for
the driver, but others could be taken sooner.

The perf tools python API has been extended to facilitate exporting
to databases, a script is provided to export to PostgreSQL, and
another script reads the database and displays the call graph.

The Intel BTS data provides branches (address from / to) but to
create the call graph the type of instruction (call, return etc)
is needed.  That is found by reading the object code, but for the
kernel that requires an accurate image.  A copy of /proc/kcore
is needed but it must be made under the same conditions as the
trace.  That has proven sufficiently awkward to warrant creating
a script to do it.

Here is how the "ls" call graph was created:


$ sudo bash -c 'echo 0 > /proc/sys/kernel/kptr_restrict'
$ sudo bash -c 'echo -1 > /proc/sys/kernel/perf_event_paranoid'
$ sudo bash -c 'chmod go+rx /sys/kernel/debug'
$ ~/libexec/perf-core/perf-with-kcore record bts_ls  --per-thread -e intel_bts// -- ls
Recording
Using /home/ahunter/bin/perf
perf version 3.16.rc2.linux.local.gaabf
/home/ahunter/bin/perf record -o bts_ls/perf.data --per-thread -e intel_bts//  -- ls
CREDITS    drivers               ipc            MAINTAINERS   modules.order   REPORTING-BUGS  signing_key.priv  tools             vmlinux.o
arch       crypto                firmware       Kconfig       Makefile        Module.symvers  samples           signing_key.x509  usr             x509.genkey
block      fs                    include        kernel        mm              net             scripts           sound             virt
bts_ls     COPYING               Documentation  init          Kbuild          lib             modules.builtin   README            security        System.map        vmlinux
[ perf record: Woken up 100 times to write data ]
[ perf record: Captured and wrote 6.945 MB bts_ls/perf.data ]
Copying kcore
Done
$ ~/libexec/perf-core/perf-with-kcore script bts_ls -s ~/libexec/perf-core/scripts/python/export-to-postgresql.py bts_ls branches calls
Using /home/ahunter/bin/perf
perf version 3.16.rc2.linux.local.gaabf
/home/ahunter/bin/perf script -i bts_ls/perf.data --kallsyms=bts_ls/kcore_dir/kallsyms -s ~/libexec/perf-core/scripts/python/export-to-postgresql.py bts_ls branches calls
2014-07-11 15:13:38.313702 Creating database...
2014-07-11 15:13:39.150277 Writing to intermediate files...
2014-07-11 15:13:40.182816 Copying to database...
2014-07-11 15:13:41.776815 Removing intermediate files...
2014-07-11 15:13:41.783443 Adding primary keys
2014-07-11 15:13:44.290786 Adding foreign keys
2014-07-11 15:13:44.974865 Done
$ ~/libexec/perf-core/scripts/python/call-graph-from-postgresql.py bts_ls
$


Regards
Adrian

