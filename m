Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbaDHGgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 02:36:42 -0400
Received: from 10.mo4.mail-out.ovh.net ([188.165.33.109]:37339 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756036AbaDHGgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 02:36:40 -0400
X-Greylist: delayed 7800 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Apr 2014 02:36:40 EDT
Message-ID: <53436D9D.2070103@metascale.org>
Date: Tue, 08 Apr 2014 12:31:41 +0900
From: Adrien BAK <adrien.bak@metascale.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net
CC: linux-kernel@vger.kernel.org,
        Mathias Gaunard <mathias.gaunard@metascale.org>
Subject: [PATCH] extends perf-script to native scripts
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 7899876697399899264
X-Ovh-Remote: 14.3.167.216 (ae167216.dynamic.ppp.asahi-net.or.jp)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddriedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddriedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As it is perf-script allows one to use perl or python scripts to parse 
perf events.
The following proposal aimed to introduce support of .so files as scripts.
This support allows for better performance when parsing perf's data 
files and
a complete access to the raw data.

This support is implemented analogously to the one in place for 
perl/python script.
More precisely, when passing a .so file as a script argument, the 
following symbols
are loaded :
     - start_script
     - stop_script
     - process_event
These symbols will be called instead of the corresponding :
     - default_start_script
     - default_stop_script
     - process_event

There currently is a limitation regarding the generate_script function 
which cannot
be generalized to native scripts. Is it better to leave things as they 
are (die gracefully
when the user asks for native_generate_script) or to do one of the 
following :
     - print a usage message specifying the symbols a .so script should 
expose
     - create a .c file complying with said interface

Regarding style compliance, the following issues remains :
     - 3 'fprintf' lines slightly over 80 chars in trace-event-native.
      Is it better to introduce a line break than to have a 83-chars 
long line?
     - in trace-event-scripting.c a struct is declared as extern. Here, 
I followed
     what was already done for perl/python scripting.

Thank you for your time and valued input.

Signed-off-by: Adrien BAK <adrien.bak@metascale.org>
---



diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 50d875d..1eeb29b 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -543,6 +543,10 @@ ifndef NO_LIBPYTHON
    LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
  endif

+ifndef NO_NATIVE_SCRIPTING
+  LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-native.o
+endif
+
  ifeq ($(NO_PERF_REGS),0)
    ifeq ($(ARCH),x86)
      LIB_H += arch/x86/include/perf_regs.h
@@ -715,6 +719,9 @@ 
$(OUTPUT)util/scripting-engines/trace-event-python.o: 
util/scripting-engines/tra
  $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o: 
scripts/python/Perf-Trace-Util/Context.c $(OUTPUT)PERF-CFLAGS
      $(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PYTHON_EMBED_CCOPTS) 
-Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter 
-Wno-nested-externs $<

+$(OUTPUT)util/scripting-engines/trace-event-native.o: 
util/scripting-engines/trace-event-native.c $(OUTPUT)PERF-CFLAGS
+    $(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-redundant-decls 
-Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs $<
+
  $(OUTPUT)perf-%: %.o $(PERFLIBS)
      $(QUIET_LINK)$(CC) $(CFLAGS) -o $@ $(LDFLAGS) $(filter %.o,$^) $(LIBS)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 9e9c91f..7241e30 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -522,6 +522,7 @@ static void setup_scripting(void)
  {
      setup_perl_scripting();
      setup_python_scripting();
+    setup_native_scripting();

      scripting_ops = &default_scripting_ops;
  }
diff --git a/tools/perf/util/scripting-engines/trace-event-native.c 
b/tools/perf/util/scripting-engines/trace-event-native.c
new file mode 100644
index 0000000..54ea57a
--- /dev/null
+++ b/tools/perf/util/scripting-engines/trace-event-native.c
@@ -0,0 +1,125 @@
+#include <dlfcn.h>
+#include <stdio.h>
+
+#include "../../perf.h"
+#include "../evsel.h"
+#include "../util.h"
+#include "../event.h"
+#include "../thread.h"
+#include "../trace-event.h"
+
+static void *handle;
+
+enum syms {
+START_SCRIPT = 0,
+STOP_SCRIPT,
+PROCESS_EVENT,
+GENERATE_SCRIPT,
+};
+
+const char *sym_names[4] = {"start_script",
+                "stop_script",
+                "process_event",
+                "generate_script"};
+
+int  (*so_start_script)(const char*, int, const char**);
+int  (*so_stop_script)(void);
+void (*so_process_event)(union perf_event *, struct perf_sample *,
+             struct perf_evsel *, struct thread *,
+             struct addr_location *);
+
+static void native_process_event(union perf_event *event __maybe_unused,
+                 struct perf_sample *sample,
+                 struct perf_evsel *evsel,
+                 struct thread *thread,
+                 struct addr_location *al)
+{
+    (so_process_event)(event, sample, evsel, thread, al);
+}
+
+static int native_start_script(const char *script, int argc, const char 
**argv)
+{
+    int err = 0;
+
+    char *error;
+
+    handle = dlopen(script, RTLD_NOW);
+
+    if (!handle) {
+        fprintf(stderr, "an error occurred while loading the .so file\n");
+        fprintf(stderr, "%s\n", dlerror());
+        return -1;
+    }
+
+    *(void **)(&so_start_script) = dlsym(handle, sym_names[START_SCRIPT]);
+
+    error = dlerror();
+    if (error) {
+        fprintf(stderr, "an error occured while loading start_script\n");
+        fprintf(stderr, "%s\n", error);
+        goto cleanup;
+    }
+
+    *(void **)(&so_process_event) = dlsym(handle, 
sym_names[PROCESS_EVENT]);
+
+    error = dlerror();
+    if (error) {
+        fprintf(stderr, "an error occured while loading process_event\n");
+        fprintf(stderr, "%s\n", error);
+        goto cleanup;
+    }
+
+    *(void **)(&so_stop_script) = dlsym(handle, sym_names[STOP_SCRIPT]);
+
+    error = dlerror();
+    if (error) {
+        fprintf(stderr, "an error occured while loading stop_script\n");
+        fprintf(stderr, "%s\n", error);
+        goto cleanup;
+    }
+
+
+    err = (so_start_script)(script, argc, argv);
+    return err;
+
+cleanup:
+    dlclose(handle);
+    return -1;
+
+}
+
+static int native_stop_script(void)
+{
+    int err = 0;
+
+    err = (so_stop_script)();
+
+    if (err)
+        fprintf(stderr,
+            "an error occurred during the execution of stop_script");
+
+    if (handle)
+        err = dlclose(handle);
+
+    if (err) {
+        fprintf(stderr, "an error occurred while closing the .so file");
+        fprintf(stderr, "%s\n", dlerror());
+    }
+
+    return err;
+}
+
+static int native_generate_script(struct pevent *pevent, const char 
*outfile)
+{
+    fprintf(stderr, "unsupported operation : native script generation");
+
+    return -1;
+}
+
+struct scripting_ops native_scripting_ops = {
+    .name = "Native",
+    .start_script = native_start_script,
+    .stop_script = native_stop_script,
+    .process_event = native_process_event,
+    .generate_script = native_generate_script,
+};
diff --git a/tools/perf/util/trace-event-scripting.c 
b/tools/perf/util/trace-event-scripting.c
index 57aaccc..c6fa13f 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -169,3 +169,25 @@ void setup_perl_scripting(void)
      register_perl_scripting(&perl_scripting_ops);
  }
  #endif
+
+
+
+extern struct scripting_ops native_scripting_ops;
+
+void setup_native_scripting(void)
+{
+    int err;
+    err = script_spec_register("Native", &native_scripting_ops);
+    if (err)
+        die("error registering Native script extension");
+
+    err = script_spec_register("so", &native_scripting_ops);
+    if (err)
+        die("error registering so script extension");
+
+    scripting_context = malloc(sizeof(struct scripting_context));
+}
+
+
+
+
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 7b6d686..e0b524a 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -77,6 +77,7 @@ int script_spec_register(const char *spec, struct 
scripting_ops *ops);

  void setup_perl_scripting(void);
  void setup_python_scripting(void);
+void setup_native_scripting(void);

  struct scripting_context {
      struct pevent *pevent;

