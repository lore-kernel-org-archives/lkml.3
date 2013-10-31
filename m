Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab3JaDWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 23:22:21 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:35122 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab3JaDWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 23:22:19 -0400
MIME-Version: 1.0
In-Reply-To: <87ob67y3xo.fsf@canonical.com>
References: <87ob67y3xo.fsf@canonical.com>
Date: Thu, 31 Oct 2013 11:22:18 +0800
Message-ID: <CACVXFVMGTtAPfr3urwLe=UJJKxCaNTLKLOGWc7xu=5vrLU+G3g@mail.gmail.com>
Subject: Re: perf confused by modules being loaded in between addresses in /proc/kallsyms
From: Ming Lei <tom.leiming@gmail.com>
To: Michael Hudson-Doyle <michael.hudson@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Will Deacon <will.deacon@arm.com>, Jean Pihet <jean.pihet@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Wed, Oct 30, 2013 at 8:53 AM, Michael Hudson-Doyle
<michael.hudson@linaro.org> wrote:
> Hi,
>
> On arm, probably since "ARM: use linker magic for vectors and vector
> stubs" (although I haven't checked this), perf report tends to allocate
> all kernel time to the module loaded at the highest address.
>
> This turns out to be because the "perf_event__synthesize_modules"
> generates a PERF_RECORD_MMAP for the last module thats runs from its
> start to the end of the address space.
>
> This in turn turns out be because the first symbol in /proc/kallsyms is
> now at 0:
>
> # head -n 2 /proc/kallsyms
> 00000000 t __vectors_start

I think it is the root cause, so I posted the below patch to
remove these symbols from /proc/kallsyms days ago:

         http://marc.info/?l=linux-kernel&m=138297540711321&w=2

On ARM, this symbol of zero address is only for generating code, and
won't be run really by CPU, so it shouldn't be in /proc/kallsyms.

> c00081c0 T asm_do_IRQ
>
> /This/ means that the kallsyms entry in machine->kmaps[MAP__FUNCTION] is
> now the first entry rather than the last in the map, so the last module
> is the last in the map and so its "end" stays as ~0ULL.
>
> I'm told that there is no particularly good reason for __vectors_start
> to be in kallsyms at 0, but in any case this seems like a bug in the
> user space tool.  I notice that there is code to split the kallsyms

I am wondering if it is bug in perf utility, since perf may use /proc/kallsyms
to figure out the start address of symbols in kernel address space, but with
the zero address, looks not easy to figure out the real start address of
symbols inside kernel if vmlinux file is missed, then can't parse kernel
IP any more.


Thanks,
-- 
Ming Lei
