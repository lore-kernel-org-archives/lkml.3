Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760300Ab3GaR2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 13:28:48 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:61651 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760149Ab3GaR2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 13:28:45 -0400
Date: Wed, 31 Jul 2013 14:28:33 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V2 1/9] perf tools: add test for reading object code
Message-ID: <20130731172833.GH3614@ghostprotocols.net>
References: <1375218838-31042-1-git-send-email-adrian.hunter@intel.com>
 <1375218838-31042-2-git-send-email-adrian.hunter@intel.com>
 <20130731145820.GF3614@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <20130731145820.GF3614@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Em Wed, Jul 31, 2013 at 11:58:20AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Wed, Jul 31, 2013 at 12:13:50AM +0300, Adrian Hunter escreveu:
> > Using the information in mmap events, perf tools can read object
> > code associated with sampled addresses.  A test is added that
> > compares bytes read by perf with the same bytes read using
> > objdump.
> 
> investigating...
> 
> (gdb) run test 21
> Starting program: /root/bin/perf test 21
> [Thread debugging using libthread_db enabled]
> Using host libthread_db library "/lib64/libthread_db.so.1".
> 21: Test object code reading                               :
> Program received signal SIGSEGV, Segmentation fault.
> 0x000000000045a2d3 in xyarray__entry (xy=0x0, x=0, y=0) at util/xyarray.h:17
> 17		return &xy->contents[x * xy->row_size + y * xy->entry_size];


Still investigating, but the attached patch is needed to handle such
failure cases:

[root@zoo ~]# perf test 21
21: Test object code reading                               : FAILED!
[root@zoo ~]# perf test -v 21
21: Test object code reading                               :
--- start ---
Looking at the vmlinux_path (6 entries long)
symsrc__init: cannot get elf header.
Using /lib/modules/3.11.0-rc2+/build/vmlinux for symbols
Parsing event 'cycles'
Parsing event 'cycles:u'
perf_evlist__open failed
---- end ----
Test object code reading: FAILED!
[root@zoo ~]# 

- Arnaldo

--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="error_path.patch"

diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index 7c9437d..9d9b6b5 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -357,7 +357,7 @@ static int do_test_code_reading(void)
 	ret = machine__create_kernel_maps(machine);
 	if (ret < 0) {
 		pr_debug("machine__create_kernel_maps failed\n");
-		goto out_err;
+		goto out_machine_exit;
 	}
 
 	/* Load kernel map */
@@ -365,7 +365,7 @@ static int do_test_code_reading(void)
 	ret = map__load(map, NULL);
 	if (ret < 0) {
 		pr_debug("map__load failed\n");
-		goto out_err;
+		goto out_destroy_kernel_maps;
 	}
 	have_vmlinux = map->dso->symtab_type == DSO_BINARY_TYPE__VMLINUX;
 	/* No point getting kernel events if there is no vmlinux */
@@ -375,26 +375,26 @@ static int do_test_code_reading(void)
 	threads = thread_map__new_by_tid(pid);
 	if (!threads) {
 		pr_debug("thread_map__new_by_tid failed\n");
-		goto out_err;
+		goto out_destroy_kernel_maps;
 	}
 
 	ret = perf_event__synthesize_thread_map(NULL, threads,
 						perf_event__process, machine);
 	if (ret < 0) {
 		pr_debug("perf_event__synthesize_thread_map failed\n");
-		goto out_err;
+		goto out_thread_map_delete;
 	}
 
 	thread = machine__findnew_thread(machine, pid);
 	if (!thread) {
 		pr_debug("machine__findnew_thread failed\n");
-		goto out_err;
+		goto out_thread_map_delete;
 	}
 
 	cpus = cpu_map__new(NULL);
 	if (!cpus) {
 		pr_debug("cpu_map__new failed\n");
-		goto out_err;
+		goto out_thread_map_delete;
 	}
 
 	while (1) {
@@ -403,7 +403,7 @@ static int do_test_code_reading(void)
 		evlist = perf_evlist__new();
 		if (!evlist) {
 			pr_debug("perf_evlist__new failed\n");
-			goto out_err;
+			goto out_cpu_map_delete;
 		}
 
 		perf_evlist__set_maps(evlist, cpus, threads);
@@ -416,7 +416,7 @@ static int do_test_code_reading(void)
 		ret = parse_events(evlist, str);
 		if (ret < 0) {
 			pr_debug("parse_events failed\n");
-			goto out_err;
+			goto out_evlist_delete;
 		}
 
 		perf_evlist__config(evlist, &opts);
@@ -435,7 +435,7 @@ static int do_test_code_reading(void)
 				continue;
 			}
 			pr_debug("perf_evlist__open failed\n");
-			goto out_err;
+			goto out_evlist_delete;
 		}
 		break;
 	}
@@ -443,7 +443,7 @@ static int do_test_code_reading(void)
 	ret = perf_evlist__mmap(evlist, UINT_MAX, false);
 	if (ret < 0) {
 		pr_debug("perf_evlist__mmap failed\n");
-		goto out_err;
+		goto out_evlist_close;
 	}
 
 	perf_evlist__enable(evlist);
@@ -454,7 +454,7 @@ static int do_test_code_reading(void)
 
 	ret = process_events(machine, evlist);
 	if (ret < 0)
-		goto out_err;
+		goto out_evlist_munmap;
 
 	if (!have_vmlinux)
 		err = TEST_CODE_READING_NO_VMLINUX;
@@ -462,19 +462,21 @@ static int do_test_code_reading(void)
 		err = TEST_CODE_READING_NO_ACCESS;
 	else
 		err = TEST_CODE_READING_OK;
-out_err:
-	if (evlist) {
-		perf_evlist__disable(evlist);
-		perf_evlist__munmap(evlist);
-		perf_evlist__close(evlist);
-		perf_evlist__delete(evlist);
-	}
-	if (cpus)
-		cpu_map__delete(cpus);
-	if (threads)
-		thread_map__delete(threads);
+
+out_evlist_munmap:
+	perf_evlist__munmap(evlist);
+out_evlist_close:
+	perf_evlist__close(evlist);
+out_evlist_delete:
+	perf_evlist__delete(evlist);
+out_cpu_map_delete:
+	cpu_map__delete(cpus);
+out_thread_map_delete:
+	thread_map__delete(threads);
+out_destroy_kernel_maps:
 	machines__destroy_kernel_maps(&machines);
 	machine__delete_threads(machine);
+out_machine_exit:
 	machines__exit(&machines);
 
 	return err;

--mP3DRpeJDSE+ciuQ--
