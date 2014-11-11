Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbaKKIQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:16:21 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:60186 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbaKKIQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:16:15 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v3 12/21] backports: make kconfig src_line backport / ConfigTree specific
Date: Tue, 11 Nov 2014 00:15:03 -0800
Message-Id: <1415693712-23743-13-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
References: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

The kconfig source line used on a backport project is very
project specific. For backport packaging the source line simply
should follow the full path of the project but for integration
this will vary depending on the backport prefix directory used.
We'll add support for that next.

$ time /home/mcgrof/backports/devel/ckmake --allyesconfig
1   3.0.101             [  OK  ]
2   3.1.10              [  OK  ]
3   3.2.62              [  OK  ]
4   3.3.8               [  OK  ]
5   3.4.104             [  OK  ]
6   3.5.7               [  OK  ]
7   3.6.11              [  OK  ]
8   3.7.10              [  OK  ]
9   3.8.13              [  OK  ]
10  3.9.11              [  OK  ]
11  3.10.58             [  OK  ]
12  3.11.10             [  OK  ]
13  3.12.31             [  OK  ]
14  3.13.11             [  OK  ]
15  3.14.22             [  OK  ]
16  3.15.10             [  OK  ]
17  3.16.6              [  OK  ]
18  3.17.1              [  OK  ]
19  3.18-rc1            [  OK  ]

real    43m56.439s
user    1187m4.516s
sys     138m53.328s

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 lib/kconfig.py | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/kconfig.py b/lib/kconfig.py
index f348d4a..ac96613 100644
--- a/lib/kconfig.py
+++ b/lib/kconfig.py
@@ -4,7 +4,6 @@
 
 import os, re
 
-src_line = re.compile(r'^\s*source\s+"(?P<src>[^\s"]*)"?\s*$')
 src_line_rel = re.compile(r'^\s*source\s+(?P<src>[^\s"]*)"?\s*$')
 tri_line = re.compile(r'^(?P<spc>\s+)tristate')
 bool_line = re.compile(r'^(?P<spc>\s+)bool')
@@ -16,6 +15,7 @@ class ConfigTree(object):
     def __init__(self, rootfile, bpid):
         self.bpid = bpid
         self.rootfile = os.path.basename(rootfile)
+        self.src_line = re.compile(r'^\s*source\s+"(?P<src>[^\s"]*)"?\s*$')
 
     def _check_relative_source(self, f, l):
     #
@@ -31,7 +31,7 @@ class ConfigTree(object):
     def _walk(self, f):
         yield f
         for l in open(os.path.join(self.bpid.target_dir, f), 'r'):
-            m = src_line.match(l)
+            m = self.src_line.match(l)
             if m and os.path.exists(os.path.join(self.bpid.target_dir, m.group('src'))):
                 for i in self._walk(m.group('src')):
                     yield i
@@ -42,7 +42,7 @@ class ConfigTree(object):
         for nf in self._walk(f):
             out = ''
             for l in open(os.path.join(self.bpid.target_dir, nf), 'r'):
-                m = src_line.match(l)
+                m = self.src_line.match(l)
                 if not m:
                     self._check_relative_source(nf, l)
                     out += l
-- 
2.1.1

