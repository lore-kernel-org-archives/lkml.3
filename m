Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab3A2Min (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:38:43 -0500
Received: from thoth.sbs.de ([192.35.17.2]:23157 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756609Ab3A2Mij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:38:39 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v5 02/20] scripts/gdb: Add cache for type objects
Date: Tue, 29 Jan 2013 13:37:45 +0100
Message-Id: <464529fe760334f693f88e25084b54a92f2be9fc.1359463075.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1359463075.git.jan.kiszka@siemens.com>
References: <cover.1359463075.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1359463075.git.jan.kiszka@siemens.com>
References: <cover.1359463075.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Type lookups are very slow in gdb-python which is often noticeable when
iterating over a number of objects. Introduce the helper class
CachedType that keeps a reference to a gdb.Type object but also
refreshes it after an object file has been loaded.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/utils.py |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/scripts/gdb/utils.py b/scripts/gdb/utils.py
index f75eae6..fdff85e 100644
--- a/scripts/gdb/utils.py
+++ b/scripts/gdb/utils.py
@@ -15,3 +15,24 @@ import gdb
 import re
 
 gdb_version = re.sub("^[^0-9]*", "", gdb.VERSION)
+
+
+class CachedType:
+	_type = None
+
+	def _new_objfile_handler(self, event):
+		self._type = None
+		gdb.events.new_objfile.disconnect(self._new_objfile_handler)
+
+	def __init__(self, name):
+		self._name = name
+
+	def get_type(self):
+		if self._type == None:
+			self._type = gdb.lookup_type(self._name)
+			if self._type == None:
+				raise gdb.GdbError("cannot resolve " \
+						   "type '%s'" % self._name)
+			gdb.events.new_objfile.connect(
+				self._new_objfile_handler)
+		return self._type
-- 
1.7.3.4

