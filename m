Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbaBLOcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 09:32:19 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:37286 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaBLOcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 09:32:18 -0500
MIME-Version: 1.0
Date: Wed, 12 Feb 2014 15:32:16 +0100
Message-ID: <CABPqkBSzttXoe3f_jC=Fv+ieN7_TNxLMDs4CH1C0TLYRq+Oz7g@mail.gmail.com>
Subject: [BUG] perf report/annotate: consuming too many file descriptors
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I was testing 3.14-rc2 (tip.git) perf and ran into a serious problem
with report/annotate on a collection with lots of shared libraries (500).

Perf ran out of file descriptors (ulimit set to 1024). It did not print
an error message, but simply refused to proceed to objdump.

I ran strace and discovered it was running out of descriptors to
my big surprise! I narrowed it down with strace -etrace=open.
I saw an appalling result.

My .so files were opened at least 4 times each, each
allocated an fd that was kept open, each open incur a read of the ELF
headers. So each dso was consuming 4 fd.

Why?

Because of what's going on in dso__load() when perf iterates
over the binary_type_symtab[]. It tries a bunch of types. For
each match, symsrc_init() is invoked to read the ELF image.
The fd opened there is kept open (for later loading).

The first problem is why is dso__read_binary_type_filename()
blindly returning success on many types. For my files, I got matches
on DEBUGLINK, SYSTEM_DSO_PATH, GUEST_KMODULE,
SYSTEM_PATH_KMODULE.

I have a tendency to believe that the dso__read_binary_type_filename()
meaning has been abused to stash things that do not really
belong there.

Furthermore, I believe many of the type matches do NOT need an ELF
read and certainly not one that keeps a descriptor opened.

This problem is not just about consuming too many fd, it is also about
execution overhead. Why read the ELF headers 4 times?

The current situation makes reporting on large collection impossible for
regular users. I don't quite know how to best address this issue. One way
I found would be for  dso__read_binary_type_filename() to return a value
meaning success but no ELF read. Not sure would be correct, though.

Any ideas on how to fix this?

Thanks.
