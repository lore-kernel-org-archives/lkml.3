Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab3ILNNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 09:13:30 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:37652 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab3ILNN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 09:13:28 -0400
Date: Thu, 12 Sep 2013 15:13:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: hpa@zytor.com, paulus@samba.org, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf symbols: Add support for reading from
 /proc/ kcore
Message-ID: <20130912131324.GB23826@gmail.com>
References: <1375875537-4509-8-git-send-email-adrian.hunter@intel.com>
 <tip-8e0cf965f95edd41df11cca50b92b4cb6ea8d80a@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-8e0cf965f95edd41df11cca50b92b4cb6ea8d80a@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Adrian Hunter <tipbot@zytor.com> wrote:

> Commit-ID:  8e0cf965f95edd41df11cca50b92b4cb6ea8d80a
> Gitweb:     http://git.kernel.org/tip/8e0cf965f95edd41df11cca50b92b4cb6ea8d80a
> Author:     Adrian Hunter <adrian.hunter@intel.com>
> AuthorDate: Wed, 7 Aug 2013 14:38:51 +0300
> Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> CommitDate: Wed, 7 Aug 2013 17:35:33 -0300
> 
> perf symbols: Add support for reading from /proc/kcore
> 
> In the absence of vmlinux, perf tools uses kallsyms for symbols.  If the
> user has access, now also map to /proc/kcore.

> +static int elf_read_maps(Elf *elf, bool exe, mapfn_t mapfn, void *data)
> +{
> +	GElf_Phdr phdr;
> +	size_t i, phdrnum;
> +	int err;
> +	u64 sz;
> +
> +	if (elf_getphdrnum(elf, &phdrnum))
> +		return -1;

This doesn't build on old distros with old libelf.

The wrapper below builds fine, but I've not tested it otherwise. Also, the 
feature detection bits in config/* filling in HAVE_ELF_GETPHDRNUM are 
missing.

Thanks,

	Ingo

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index a7b9ab5..5fb9d61 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -8,6 +8,13 @@
 #include "symbol.h"
 #include "debug.h"
 
+#ifndef HAVE_ELF_GETPHDRNUM
+static int elf_getphdrnum (Elf *__elf __maybe_unused, size_t *__dst __maybe_unused)
+{
+	return 1;
+}
+#endif
+
 #ifndef NT_GNU_BUILD_ID
 #define NT_GNU_BUILD_ID 3
 #endif

