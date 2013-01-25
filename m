Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab3AYKyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:54:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41057 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab3AYKym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:54:42 -0500
Date: Fri, 25 Jan 2013 02:54:18 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-9avmwxv5ipxyafwqxbk52ylg@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests:
  Adjust some message log levels to help diagnosing problems in attr tests
Git-Commit-ID: ce90e3856ba55af4d3d9c9c1168cc624607f6c7c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 02:54:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce90e3856ba55af4d3d9c9c1168cc624607f6c7c
Gitweb:     http://git.kernel.org/tip/ce90e3856ba55af4d3d9c9c1168cc624607f6c7c
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 18 Dec 2012 14:14:24 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:08 -0300

perf tests: Adjust some message log levels to help diagnosing problems in attr tests

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
 
