Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbbA2BYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:24:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557AbbA2BYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:24:05 -0500
Message-ID: <54C8B6AF.3050100@suse.cz>
Date: Wed, 28 Jan 2015 11:15:11 +0100
From: =?windows-1252?Q?Martin_Li=9Aka?= <mliska@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] perf: introduce local DSO path lookup.
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Following simple patch introduces support for a local DSO lookup operation.
Motivation is that if I have a perf.data file which is created on a different
machine (perf record $very_long_path), using perf report with --symfs=$workdir
expects a DSO to be located at: $workdir/$very_long_path.

I think it would be much easier to copy a binary file to the $workdir and
let perf lookup the working directory: $workdir/binary_filename.

Thanks,
Martin

Signed-off-by: Martin Liska <m.liska@suse.cz>

---
  tools/perf/util/dso.c    | 5 +++++
  tools/perf/util/dso.h    | 1 +
  tools/perf/util/symbol.c | 2 ++
  3 files changed, 8 insertions(+)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 45be944..4dc6ea3 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -20,6 +20,7 @@ char dso__symtab_origin(const struct dso *dso)
  		[DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO]	= 'o',
  		[DSO_BINARY_TYPE__BUILDID_DEBUGINFO]		= 'b',
  		[DSO_BINARY_TYPE__SYSTEM_PATH_DSO]		= 'd',
+		[DSO_BINARY_TYPE__LOCAL_PATH_DSO]		= 'c',
  		[DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE]		= 'K',
  		[DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE_COMP]	= 'm',
  		[DSO_BINARY_TYPE__GUEST_KALLSYMS]		= 'g',
@@ -113,6 +114,10 @@ int dso__read_binary_type_filename(const struct dso *dso,
  		__symbol__join_symfs(filename, size, dso->long_name);
  		break;
  
+	case DSO_BINARY_TYPE__LOCAL_PATH_DSO:
+		__symbol__join_symfs(filename, size, dso->short_name);
+		break;
+
  	case DSO_BINARY_TYPE__GUEST_KMODULE:
  	case DSO_BINARY_TYPE__GUEST_KMODULE_COMP:
  		path__join3(filename, size, symbol_conf.symfs,
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 3782c82..2e3b37b 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -21,6 +21,7 @@ enum dso_binary_type {
  	DSO_BINARY_TYPE__UBUNTU_DEBUGINFO,
  	DSO_BINARY_TYPE__BUILDID_DEBUGINFO,
  	DSO_BINARY_TYPE__SYSTEM_PATH_DSO,
+	DSO_BINARY_TYPE__LOCAL_PATH_DSO,
  	DSO_BINARY_TYPE__GUEST_KMODULE,
  	DSO_BINARY_TYPE__GUEST_KMODULE_COMP,
  	DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE,
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index c24c5b8..cb71d3d 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -50,6 +50,7 @@ static enum dso_binary_type binary_type_symtab[] = {
  	DSO_BINARY_TYPE__UBUNTU_DEBUGINFO,
  	DSO_BINARY_TYPE__BUILDID_DEBUGINFO,
  	DSO_BINARY_TYPE__SYSTEM_PATH_DSO,
+	DSO_BINARY_TYPE__LOCAL_PATH_DSO,
  	DSO_BINARY_TYPE__GUEST_KMODULE,
  	DSO_BINARY_TYPE__GUEST_KMODULE_COMP,
  	DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE,
@@ -1285,6 +1286,7 @@ static bool dso__is_compatible_symtab_type(struct dso *dso, bool kmod,
  	case DSO_BINARY_TYPE__JAVA_JIT:
  	case DSO_BINARY_TYPE__DEBUGLINK:
  	case DSO_BINARY_TYPE__SYSTEM_PATH_DSO:
+	case DSO_BINARY_TYPE__LOCAL_PATH_DSO:
  	case DSO_BINARY_TYPE__FEDORA_DEBUGINFO:
  	case DSO_BINARY_TYPE__UBUNTU_DEBUGINFO:
  	case DSO_BINARY_TYPE__BUILDID_DEBUGINFO:
-- 
2.1.2

