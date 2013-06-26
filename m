Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab3FZNje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:39:34 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:52349 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab3FZNjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:39:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAAfg0W5BoDLN_O9PwGTQC-0uFp+ZEgqAH2A9sSbbvOHsHutPkQ@mail.gmail.com>
References: <CAAfg0W5BoDLN_O9PwGTQC-0uFp+ZEgqAH2A9sSbbvOHsHutPkQ@mail.gmail.com>
Date: Wed, 26 Jun 2013 19:09:32 +0530
Message-ID: <CAJ_BOiBHZ=nXD+dHnbAwSexHkd=zfDWePK0WjEr=dvzmhu1bPw@mail.gmail.com>
Subject: Re: 3.10-rc6 "perf test" seems unhappy
From: Prabhat Kumar Ravi <prabhatravi09@gmail.com>
To: Andy Green <andy.green@linaro.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 26, 2013 at 4:39 PM, Andy Green <andy.green@linaro.org> wrote:
> Hi -
>
> Running perf test on 3.10-rc6 gives some unexpected behaviours.
>
> This is on a dual Cortex A9 board with perf userland cross-built from
> same tree as the kernel.
>
> root@aa9-eb:~# perf test
>  1: vmlinux symtab matches kallsyms                        : FAILED!

> I started tracing the first failure... it stops because it can't find
> "_stext" in /proc/kallsyms.  But it is there
>
> root@aa9-eb:~# cat /proc/kallsyms | grep _stext
> 800081c0 T _stext
>

>
> The others may be due to missing some config somewhere.
>
> Any ideas what I am (or perf is) doing wrong?
>

I Think your Perf test is failing at dso__find_symbol_by_name
where in perf test we have something like:

        kallsyms_map = machine__kernel_map(&kallsyms, type);

        sym = map__find_symbol_by_name(kallsyms_map, ref_reloc_sym.name, NULL);
        if (sym == NULL) {
                pr_debug("dso__find_symbol_by_name ");
                goto out;
        }

Here sym is search for "_stext" which is NULL here so perf test fails here only,

Here _stext having same address as some other, like

c00081c0 T asm_do_IRQ
c00081c0 T _stext
c00081c0 T __exception_text_start

Function call is like this:
machine__load_kallsyms
--> dso__load_kallsyms
    --> symbols__fixup_duplicate

So, it getting deleted, I think we should disable symbols__fixup_duplicate.

- Prabhat
