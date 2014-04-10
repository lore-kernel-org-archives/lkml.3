Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030497AbaDJRs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 13:48:28 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41837 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbaDJRsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 13:48:25 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: cocci@systeme.lip6.fr
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
        Johannes Berg <johannes.berg@intel.com>, backports@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] coccinelle: add pycocci wrapper for multithreaded support
Date: Thu, 10 Apr 2014 10:48:17 -0700
Message-Id: <1397152097-315-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This is a wrapper for folks which by work on git trees, specifically
the linux kernel with lots of files and with random task Cocci files.
The assumption all you need is multithreaded support and currently only
a shell script is lying around, but that isn't easily extensible, nor
is it dynamic. This uses Python to add Coccinelle's mechanisms for
multithreaded support but also enables all sorts of defaults which
you'd expect to be enabled when using Coccinelle for Linux kernel
development.

You just pass it a cocci file, a target dir, and in git environments
you always want --in-place enabled. Experiments and profiling random
cocci files with the Linux kernel show that using just using number of
CPUs doesn't scale well given that lots of buckets of files don't require
work, as such this uses 10 * number of CPUs for its number of threads.
For work that define more general ruler 3 * number of CPUs works better,
but for smaller cocci files 3 * number of CPUs performs best right now.
To experiment more with what's going on with the multithreading one can enable
htop while kicking off a cocci task on the kernel, we want to keep
these CPUs busy as much as possible. You can override the number of
threads with pycocci with -j or --jobs. The problem with jobless threads
can be seen here:

http://drvbp1.linux-foundation.org/~mcgrof/images/coccinelle-backports/cocci-jobless-processes.png

A healthy run would keep all the CPUs busy as in here:

http://drvbp1.linux-foundation.org/~mcgrof/images/coccinelle-backports/after-threaded-cocci.png

This is heavily based on the multithreading implementation completed
on the Linux backports project, this just generalizes it and takes it
out of there in case others can make use of it -- I did as I wanted to
make upstream changes with Coccinelle. Note that multithreading implementation
for Coccinelle is currently being discussed to make CPU usage more efficient,
so this currently is only a helper.

Since its just a helper I toss it into the python directory but don't
install it. Hope is that we can evolve it there instead of carrying this
helper within backports.

Sample run:

mcgrof@garbanzo ~/linux-next (git::master)$ time ./pycocci
0001-netdev_ops.cocci ./

real    24m13.402s
user    72m27.072s
sys     22m38.812s

With this Coccinelle SmPL rule:

@@
struct net_device *dev;
struct net_device_ops ops;
@@
-dev->netdev_ops = &ops;
+netdev_attach_ops(dev, &ops);

Cc: Johannes Berg <johannes.berg@intel.com>
Cc: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: cocci@systeme.lip6.fr
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 python/pycocci | 193 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 193 insertions(+)
 create mode 100755 python/pycocci

diff --git a/python/pycocci b/python/pycocci
new file mode 100755
index 0000000..4b3ef38
--- /dev/null
+++ b/python/pycocci
@@ -0,0 +1,193 @@
+#!/usr/bin/env python
+#
+# Copyright (c) 2014 Luis R. Rodriguez  <mcgrof@suse.com>
+# Copyright (c) 2013 Johannes Berg <johannes.berg@intel.com>
+#
+# This file is released under the GPLv2.
+#
+# Python wrapper for Coccinelle for multithreaded support,
+# designed to be used for working on a git tree, and with sensible
+# defaults, specifically for kernel developers.
+
+from multiprocessing import Process, cpu_count, Queue
+import argparse, subprocess, os, sys
+import tempfile, shutil
+
+# simple tempdir wrapper object for 'with' statement
+#
+# Usage:
+# with tempdir.tempdir() as tmpdir:
+#     os.chdir(tmpdir)
+#     do something
+class tempdir(object):
+    def __init__(self, suffix='', prefix='', dir=None, nodelete=False):
+        self.suffix = ''
+        self.prefix = ''
+        self.dir = dir
+        self.nodelete = nodelete
+
+    def __enter__(self):
+        self._name = tempfile.mkdtemp(suffix=self.suffix,
+                                      prefix=self.prefix,
+                                      dir=self.dir)
+        return self._name
+
+    def __exit__(self, type, value, traceback):
+        if self.nodelete:
+            print('not deleting directory %s!' % self._name)
+        else:
+            shutil.rmtree(self._name)
+
+class CoccinelleError(Exception):
+    pass
+class ExecutionError(CoccinelleError):
+    def __init__(self, cmd, errcode):
+        self.error_code = errcode
+        print('Failed command:')
+        print(' '.join(cmd))
+
+class ExecutionErrorThread(CoccinelleError):
+    def __init__(self, errcode, fn, cocci_file, threads, t, logwrite, print_name):
+        self.error_code = errcode
+        logwrite("Failed to apply changes from %s" % print_name)
+
+        logwrite("Specific log output from change that failed using %s" % print_name)
+        tf = open(fn, 'r')
+        for line in tf.read():
+            logwrite('> %s' % line)
+        tf.close()
+
+        logwrite("Full log using %s" % print_name)
+        for num in range(threads):
+            fn = os.path.join(t, '.tmp_spatch_worker.' + str(num))
+            if (not os.path.isfile(fn)):
+                continue
+            tf = open(fn, 'r')
+            for line in tf.read():
+                logwrite('> %s' % line)
+            tf.close()
+            os.unlink(fn)
+
+def spatch(cocci_file, outdir,
+           max_threads, thread_id, temp_dir, ret_q, extra_args=[]):
+    cmd = ['spatch', '--sp-file', cocci_file, '--in-place',
+            '--recursive-includes',
+            '--backup-suffix', '.cocci_backup', '--dir', outdir]
+
+    if (max_threads > 1):
+        cmd.extend(['-max', str(max_threads), '-index', str(thread_id)])
+
+    cmd.extend(extra_args)
+
+    fn = os.path.join(temp_dir, '.tmp_spatch_worker.' + str(thread_id))
+    outfile = open(fn, 'w')
+
+    sprocess = subprocess.Popen(cmd,
+                               stdout=outfile, stderr=subprocess.STDOUT,
+                               close_fds=True, universal_newlines=True)
+    sprocess.wait()
+    if sprocess.returncode != 0:
+        raise ExecutionError(cmd, sprocess.returncode)
+    outfile.close()
+    ret_q.put((sprocess.returncode, fn))
+
+def threaded_spatch(cocci_file, outdir, logwrite, num_jobs,
+                    print_name, extra_args=[]):
+    num_cpus = cpu_count()
+    # A lengthy comment is worthy here. As of spatch version 1.0.0-rc20
+    # Coccinelle will break out target files into buckets and a thread
+    # will work on each bucket. Turns out that after inspection while
+    # leaving htop running and reading results after profiling we know
+    # that CPUs are left idle after tasks which have no work to do finish
+    # fast. This leaves CPUs jobless and hungry. Experiments with *really* long
+    # cocci files (all of the Linux backports cocci files in one file is an
+    # example) show that currently num_cpus * 3 provides reasonable completion
+    # time, while smaller rules can use more threads, currently we set this
+    # to 10. You however are more than welcomed to experiment and override
+    # this. Note that its currently being discussed how to best optimize
+    # things even further for Coccinelle.
+    #
+    # Images available of htop before multithreading:
+    # http://drvbp1.linux-foundation.org/~mcgrof/images/coccinelle-backports/before-threaded-cocci.png
+    # The jobless issue on threads if its just num_cpus after a period of time:
+    # http://drvbp1.linux-foundation.org/~mcgrof/images/coccinelle-backports/cocci-jobless-processes.png
+    # A happy healthy run should look like over most of the run:
+    # http://drvbp1.linux-foundation.org/~mcgrof/images/coccinelle-backports/after-threaded-cocci.png
+    if num_jobs:
+        threads = num_jobs
+    else:
+        threads = num_cpus * 10
+    jobs = list()
+    output = ""
+    ret_q = Queue()
+    with tempdir() as t:
+        for num in range(threads):
+            p = Process(target=spatch, args=(cocci_file, outdir,
+                                             threads, num, t, ret_q,
+                                             extra_args))
+            jobs.append(p)
+        for p in jobs:
+            p.start()
+
+        for num in range(threads):
+            ret, fn = ret_q.get()
+            if ret != 0:
+                raise ExecutionErrorThread(ret, fn, cocci_file, threads, t,
+                                           logwrite, print_name)
+        for job in jobs:
+            p.join()
+
+        for num in range(threads):
+            fn = os.path.join(t, '.tmp_spatch_worker.' + str(num))
+            tf = open(fn, 'r')
+            output = output + tf.read()
+            tf.close()
+            os.unlink(fn)
+        return output
+
+def logwrite(msg):
+    sys.stdout.write(msg)
+    sys.stdout.flush()
+
+def _main():
+    parser = argparse.ArgumentParser(description='Multithreaded Python wrapper for Coccinelle ' +
+                                     'with sensible defaults, targetted specifically ' +
+                                     'for git development environments')
+    parser.add_argument('cocci_file', metavar='<Coccinelle SmPL rules file>', type=str,
+                        help='This is the Coccinelle file you want to use')
+    parser.add_argument('target_dir', metavar='<target directory>', type=str,
+                        help='Target source directory to modify')
+    parser.add_argument('-p', '--profile-cocci', const=True, default=False, action="store_const",
+                        help='Enable profile, this will pass --profile  to Coccinelle.')
+    parser.add_argument('-j', '--jobs', metavar='<jobs>', type=str, default=None,
+                        help='Only use the cocci file passed for Coccinelle, don\'t do anything else, ' +
+                        'also creates a git repo on the target directory for easy inspection ' +
+                        'of changes done by Coccinelle.')
+    parser.add_argument('-v', '--verbose', const=True, default=False, action="store_const",
+                        help='Enable output from Coccinelle')
+    args = parser.parse_args()
+
+    if not os.path.isfile(args.cocci_file):
+        return -2
+
+    extra_spatch_args = []
+    if args.profile_cocci:
+        extra_spatch_args.append('--profile')
+    jobs = 0
+    if args.jobs > 0:
+        jobs = args.jobs
+
+    output = threaded_spatch(args.cocci_file,
+                             args.target_dir,
+                             logwrite,
+                             jobs,
+                             os.path.basename(args.cocci_file),
+                             extra_args=extra_spatch_args)
+    if args.verbose:
+        logwrite(output)
+    return 0
+
+if __name__ == '__main__':
+    ret = _main()
+    if ret:
+        sys.exit(ret)
-- 
1.9.0

