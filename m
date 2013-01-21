Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab3AURXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:23:51 -0500
Received: from david.siemens.de ([192.35.17.14]:21668 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab3AURXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:23:16 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>
Subject: [PATCH v4 02/13] scripts/gdb: Add container_of helper and convenience function
Date: Mon, 21 Jan 2013 18:06:09 +0100
Message-Id: <7482c40b6e73fb67e69b0a5b9205f22ebae1cdac.1358787929.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1358787929.git.jan.kiszka@siemens.com>
References: <cover.1358787929.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1358787929.git.jan.kiszka@siemens.com>
References: <cover.1358787929.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide an internal helper with container_of semantics. As type lookups
are very slow in gdb-python and we need a type "long" for this, cache
the reference to this type object. Then export the helper also as a
convenience function form use at the gdb command line.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/utils.py       |   41 +++++++++++++++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py |    2 ++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/scripts/gdb/utils.py b/scripts/gdb/utils.py
index 65a2e91..2f6eafb 100644
--- a/scripts/gdb/utils.py
+++ b/scripts/gdb/utils.py
@@ -15,3 +15,44 @@ import gdb
 import re
 
 gdb_version = re.sub("^[^0-9]*", "", gdb.VERSION)
+
+long_type = None
+
+def get_type(type_name):
+	t = gdb.lookup_type(type_name)
+	if t == None:
+		raise gdb.GdbError("cannot resolve type '%s'" % type_name)
+	return t
+
+def get_long_type():
+	global long_type
+	if long_type == None:
+		long_type = get_type("long")
+	return long_type
+
+
+def offset_of(typeobj, field):
+	element = gdb.Value(0).cast(typeobj)
+	return int(str(element[field].address).split()[0], 16)
+
+def container_of(ptr, typeobj, member):
+	return (ptr.cast(get_long_type()) -
+		offset_of(typeobj, member)).cast(typeobj)
+
+
+class ContainerOf(gdb.Function):
+	__doc__ = "Return pointer to containing data structure.\n" \
+		  "\n" \
+		  "$container_of(PTR, \"TYPE\", \"ELEMENT\"): Given PTR, return a pointer to the\n" \
+		  "data structure of the type TYPE in which PTR is the address of ELEMENT.\n" \
+		  "Note that TYPE and ELEMENT have to be quoted as strings."
+
+	def __init__(self):
+		super(ContainerOf, self).__init__("container_of")
+
+	def invoke(self, ptr, typename, elementname):
+		return container_of(ptr,
+				    gdb.lookup_type(typename.string()).pointer(),
+				    elementname.string())
+
+ContainerOf()
diff --git a/scripts/gdb/vmlinux-gdb.py b/scripts/gdb/vmlinux-gdb.py
index bcb45cc..8ef76c9 100644
--- a/scripts/gdb/vmlinux-gdb.py
+++ b/scripts/gdb/vmlinux-gdb.py
@@ -20,3 +20,5 @@ from utils import gdb_version
 if gdb_version < "7.1":
 	print "NOTE: gdb 7.1 or later required for Linux helper scripts " \
 	      "to work."
+else:
+	import utils
-- 
1.7.3.4

