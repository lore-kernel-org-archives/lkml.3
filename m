Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab3AXUKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:10:13 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54075
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755891Ab3AXUIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:44 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 06/74] perf tests: Adjust some message log levels to help diagnosing problems in attr tests
Date: Thu, 24 Jan 2013 17:07:15 -0300
Message-Id: <1359058103-31645-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Now we'll see the command being run and if it fails, the fields that had
unexpected values and the expected values, example testing a problem in the
next patch:

  # perf test -v 13
  13: struct perf_event_attr setup                           :
  --- start ---
  SNIP
    running 'PERF_TEST_ATTR=/tmp/tmpDNIE6M /home/acme/bin/perf record -o /tmp/tmpDNIE6M/perf.data --group -e cycles,instructions kill >/dev/null 2>&1' ret 0
    running 'PERF_TEST_ATTR=/tmp/tmpV5lKro /home/acme/bin/perf stat -o /tmp/tmpV5lKro/perf.data -dd kill >/dev/null 2>&1' ret 1
  expected config=3, got 65540
  expected exclude_guest=1, got 0
  FAILED '/home/acme/libexec/perf-core/tests/attr/test-stat-detailed-2' - match failure
  ---- end ----
  struct perf_event_attr setup: FAILED!
  #

While in the past we would see at the '-v' level many more messages for the
fields that matched, something we may want to see only in the '-vv' log level.

Keeping the 'running' messages so that we can see the tools tests that
succeeded so that we can compare it to the one that failed, helping pinpointing
the command line switch combo that leads to the problem.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-9avmwxv5ipxyafwqxbk52ylg@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr.py | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/tools/perf/tests/attr.py b/tools/perf/tests/attr.py
index e702b82..2f629ca 100644
--- a/tools/perf/tests/attr.py
+++ b/tools/perf/tests/attr.py
@@ -68,7 +68,7 @@ class Event(dict):
             self[key] = val
 
     def __init__(self, name, data, base):
-        log.info("    Event %s" % name);
+        log.debug("    Event %s" % name);
         self.name  = name;
         self.group = ''
         self.add(base)
@@ -97,6 +97,14 @@ class Event(dict):
                 return False
         return True
 
+    def diff(self, other):
+        for t in Event.terms:
+            if not self.has_key(t) or not other.has_key(t):
+                continue
+            if not self.compare_data(self[t], other[t]):
+		log.warning("expected %s=%s, got %s" % (t, self[t], other[t]))
+                
+
 # Test file description needs to have following sections:
 # [config]
 #   - just single instance in file
@@ -113,7 +121,7 @@ class Test(object):
         parser = ConfigParser.SafeConfigParser()
         parser.read(path)
 
-        log.warning("running '%s'" % path)
+        log.debug("running '%s'" % path)
 
         self.path     = path
         self.test_dir = options.test_dir
@@ -128,7 +136,7 @@ class Test(object):
 
         self.expect   = {}
         self.result   = {}
-        log.info("  loading expected events");
+        log.debug("  loading expected events");
         self.load_events(path, self.expect)
 
     def is_event(self, name):
@@ -164,7 +172,7 @@ class Test(object):
               self.perf, self.command, tempdir, self.args)
         ret = os.WEXITSTATUS(os.system(cmd))
 
-        log.info("  running '%s' ret %d " % (cmd, ret))
+        log.warning("  running '%s' ret %d " % (cmd, ret))
 
         if ret != int(self.ret):
             raise Unsup(self)
@@ -172,7 +180,7 @@ class Test(object):
     def compare(self, expect, result):
         match = {}
 
-        log.info("  compare");
+        log.debug("  compare");
 
         # For each expected event find all matching
         # events in result. Fail if there's not any.
@@ -187,10 +195,11 @@ class Test(object):
                 else:
                     log.debug("    ->FAIL");
 
-            log.info("    match: [%s] matches %s" % (exp_name, str(exp_list)))
+            log.debug("    match: [%s] matches %s" % (exp_name, str(exp_list)))
 
             # we did not any matching event - fail
             if (not exp_list):
+		exp_event.diff(res_event)
                 raise Fail(self, 'match failure');
 
             match[exp_name] = exp_list
@@ -208,10 +217,10 @@ class Test(object):
                 if res_group not in match[group]:
                     raise Fail(self, 'group failure')
 
-                log.info("    group: [%s] matches group leader %s" %
+                log.debug("    group: [%s] matches group leader %s" %
                          (exp_name, str(match[group])))
 
-        log.info("  matched")
+        log.debug("  matched")
 
     def resolve_groups(self, events):
         for name, event in events.items():
@@ -233,7 +242,7 @@ class Test(object):
             self.run_cmd(tempdir);
 
             # load events expectation for the test
-            log.info("  loading result events");
+            log.debug("  loading result events");
             for f in glob.glob(tempdir + '/event*'):
                 self.load_events(f, self.result);
 
-- 
1.8.1.1.361.gec3ae6e

