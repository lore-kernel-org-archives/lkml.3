Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab3J3Axr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 20:53:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33172 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3J3Axq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 20:53:46 -0400
From: Michael Hudson-Doyle <michael.hudson@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Will Deacon <will.deacon@arm.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: perf confused by modules being loaded in between addresses in /proc/kallsyms
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/24.3.50.2 (x86_64-pc-linux-gnu)
Date: Tue, 29 Oct 2013 17:53:39 -0700
Message-ID: <87ob67y3xo.fsf@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On arm, probably since "ARM: use linker magic for vectors and vector
stubs" (although I haven't checked this), perf report tends to allocate
all kernel time to the module loaded at the highest address.

This turns out to be because the "perf_event__synthesize_modules"
generates a PERF_RECORD_MMAP for the last module thats runs from its
start to the end of the address space.

This in turn turns out be because the first symbol in /proc/kallsyms is
now at 0:

# head -n 2 /proc/kallsyms
00000000 t __vectors_start
c00081c0 T asm_do_IRQ

/This/ means that the kallsyms entry in machine->kmaps[MAP__FUNCTION] is
now the first entry rather than the last in the map, so the last module
is the last in the map and so its "end" stays as ~0ULL.

I'm told that there is no particularly good reason for __vectors_start
to be in kallsyms at 0, but in any case this seems like a bug in the
user space tool.  I notice that there is code to split the kallsyms
symbols around symbols from modules (dso__split_kallsyms) but this
doesn't seem to be called for record, only report.  Is the fix as simple
as making sure this happens for record as well?  I don't feel qualified
to answer that.

Cheers,
mwh
