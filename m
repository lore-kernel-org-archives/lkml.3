Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbbALRC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 12:02:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbbALRCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 12:02:54 -0500
Date: Mon, 12 Jan 2015 12:02:49 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH] scripts/bloat-o-meter: include .rodata section comparison
Message-ID: <20150112170249.GC10329@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds section .rodata comparison in order to detect string
constant changes.

Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

diff --git a/scripts/bloat-o-meter b/scripts/bloat-o-meter
index 23e78dc..cee812a 100755
--- a/scripts/bloat-o-meter
+++ b/scripts/bloat-o-meter
@@ -26,40 +26,66 @@ def getsizes(file):
             # statics and some other optimizations adds random .NUMBER
             name = re.sub(r'\.[0-9]+', '', name)
             sym[name] = sym.get(name, 0) + int(size, 16)
-    return sym
 
-old = getsizes(sys.argv[1])
-new = getsizes(sys.argv[2])
-grow, shrink, add, remove, up, down = 0, 0, 0, 0, 0, 0
-delta, common = [], {}
+    sections = {}
+    exp = re.compile('[\ ]*[0-9]+[\ ]+([^\ ]+)[\ ]+([0-9a-f]+).*')
+    wanted_sections = ['.rodata']
+    for l in os.popen("objdump -h -w " + file).readlines():
+        match = exp.match(l)
+        if not match:
+            continue
+        name = match.group(1)
+        if name not in wanted_sections:
+            continue
+        size = int(match.group(2), 16)
+        sections[name] = size
 
-for a in old:
-    if a in new:
-        common[a] = 1
+    return (sym, sections)
 
-for name in old:
-    if name not in common:
-        remove += 1
-        down += old[name]
-        delta.append((-old[name], name))
+def process_results(old, new):
+    grow, shrink, add, remove, up, down = 0, 0, 0, 0, 0, 0
+    delta, common = [], {}
+    for a in old:
+        if a in new:
+            common[a] = 1
 
-for name in new:
-    if name not in common:
-        add += 1
-        up += new[name]
-        delta.append((new[name], name))
+    for name in old:
+        if name not in common:
+            remove += 1
+            down += old[name]
+            delta.append((-old[name], name))
 
-for name in common:
-        d = new.get(name, 0) - old.get(name, 0)
-        if d>0: grow, up = grow+1, up+d
-        if d<0: shrink, down = shrink+1, down-d
-        delta.append((d, name))
+    for name in new:
+        if name not in common:
+            add += 1
+            up += new[name]
+            delta.append((new[name], name))
 
-delta.sort()
-delta.reverse()
+    for name in common:
+            d = new.get(name, 0) - old.get(name, 0)
+            if d>0: grow, up = grow+1, up+d
+            if d<0: shrink, down = shrink+1, down-d
+            delta.append((d, name))
 
-print "add/remove: %s/%s grow/shrink: %s/%s up/down: %s/%s (%s)" % \
-      (add, remove, grow, shrink, up, -down, up-down)
-print "%-40s %7s %7s %+7s" % ("function", "old", "new", "delta")
-for d, n in delta:
-    if d: print "%-40s %7s %7s %+7d" % (n, old.get(n,"-"), new.get(n,"-"), d)
+    delta.sort()
+    delta.reverse()
+
+    return (add, remove, up, down, grow, shrink, delta)
+
+def print_results(title, add, remove, up, down, grow, shrink, delta, old, new):
+    print "add/remove: %s/%s grow/shrink: %s/%s up/down: %s/%s (%s)" % \
+          (add, remove, grow, shrink, up, -down, up-down)
+    print "%-40s %7s %7s %+7s" % (title, "old", "new", "delta")
+    for d, n in delta:
+        if d: print "%-40s %7s %7s %+7d" % (n, old.get(n,"-"), new.get(n,"-"), d)
+
+old, old_sections = getsizes(sys.argv[1])
+new, new_sections = getsizes(sys.argv[2])
+
+(add, remove, up, down, grow, shrink, delta) = process_results(old, new)
+print "Symbols changes"
+print_results("function", add, remove, up, down, grow, shrink, delta, old, new)
+
+(add, remove, up, down, grow, shrink, delta) = process_results(old_sections, new_sections)
+print "\nSection changes"
+print_results("section", add, remove, up, down, grow, shrink, delta, old_sections, new_sections)
