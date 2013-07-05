Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025Ab3GEATI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 20:19:08 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:35688 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756979Ab3GEATG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 20:19:06 -0400
From: Mike Pagano <mpagano@gentoo.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Modification of the diffconfig script to support python 3.x and 2.7
Date: Thu, 04 Jul 2013 20:19:03 -0400
Message-ID: <10816010.V3ekNYfWHj@comanche>
User-Agent: KMail/4.10.4 (Linux/3.10.0-gentoo; KDE/4.10.4; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modification of the diffconfig script to support both python 2.7 and 3.2. 
Added a small change to gracefully exit if the default config files are not 
present. (.config and .config.old)

Diffconfig is a utility script for comparing kernel configuration files.

Signed-off-by: Mike Pagano <mpagano@gentoo.org>
---
 scripts/diffconfig | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/scripts/diffconfig b/scripts/diffconfig
index b91f3e3..45a4ba4 100755
--- a/scripts/diffconfig
+++ b/scripts/diffconfig
@@ -10,7 +10,7 @@
 import sys, os
 
 def usage():
-    print """Usage: diffconfig [-h] [-m] [<config1> <config2>]
+    print ("""Usage: diffconfig [-h] [-m] [<config1> <config2>]
 
 Diffconfig is a simple utility for comparing two .config files.
 Using standard diff to compare .config files often includes extraneous and
@@ -33,7 +33,7 @@ Example usage:
  EXT2_FS  y -> n
  LOG_BUF_SHIFT  14 -> 16
  PRINTK_TIME  n -> y
-"""
+""")
     sys.exit(0)
 
 # returns a dictionary of name/value pairs for config items in the file
@@ -54,23 +54,26 @@ def print_config(op, config, value, new_value):
     if merge_style:
         if new_value:
             if new_value=="n":
-                print "# CONFIG_%s is not set" % config
+                print ("# CONFIG_%s is not set" % config)
             else:
-                print "CONFIG_%s=%s" % (config, new_value)
+                print ("CONFIG_%s=%s" % (config, new_value))
     else:
         if op=="-":
-            print "-%s %s" % (config, value)
+            print ("-%s %s" % (config, value))
         elif op=="+":
-            print "+%s %s" % (config, new_value)
+            print ("+%s %s" % (config, new_value))
         else:
-            print " %s %s -> %s" % (config, value, new_value)
+            print (" %s %s -> %s" % (config, value, new_value))
 
 def main():
     global merge_style
 
+    a = {}
+    b = {}
+
     # parse command line args
     if ("-h" in sys.argv or "--help" in sys.argv):
-	usage()
+        usage()
 
     merge_style = 0
     if "-m" in sys.argv:
@@ -79,13 +82,13 @@ def main():
 
     argc = len(sys.argv)
     if not (argc==1 or argc == 3):
-        print "Error: incorrect number of arguments or unrecognized option"
+        print ("Error: incorrect number of arguments or unrecognized option")
         usage()
 
     if argc == 1:
         # if no filenames given, assume .config and .config.old
         build_dir=""
-        if os.environ.has_key("KBUILD_OUTPUT"):
+        if "KBUILD_OUTPUT" in os.environ:
             build_dir = os.environ["KBUILD_OUTPUT"]+"/"
 
         configa_filename = build_dir + ".config.old"
@@ -94,8 +97,11 @@ def main():
         configa_filename = sys.argv[1]
         configb_filename = sys.argv[2]
 
-    a = readconfig(file(configa_filename))
-    b = readconfig(file(configb_filename))
+    try:
+        a = readconfig(open(configa_filename))
+        b = readconfig(open(configb_filename))
+    except IOError:
+        usage()
 
     # print items in a but not b (accumulate, sort and print)
     old = []
@@ -121,7 +127,7 @@ def main():
 
     # now print items in b but not in a
     # (items from b that were in a were removed above)
-    new = b.keys()
+    new = list(b.keys())
     new.sort()
     for config in new:
         print_config("+", config, None, b[config])
-- 
1.8.1.5
