Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161664AbaJaDKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 23:10:21 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:43244 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbaJaDKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 23:10:20 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Anton Blanchard <anton@au1.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 01/32] perf tools powerpc: Cache the DWARF debug info
References: <1414503146-22789-1-git-send-email-acme@kernel.org>
	<1414503146-22789-2-git-send-email-acme@kernel.org>
	<87egtr751p.fsf@sejong.aot.lge.com>
	<20141029212620.GC17916@us.ibm.com>
Date: Fri, 31 Oct 2014 12:10:17 +0900
In-Reply-To: <20141029212620.GC17916@us.ibm.com> (Sukadev Bhattiprolu's
	message of "Wed, 29 Oct 2014 14:26:20 -0700")
Message-ID: <87a94d6ijq.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sukadev,

On Wed, 29 Oct 2014 14:26:20 -0700, Sukadev Bhattiprolu wrote:
> Namhyung Kim [namhyung@kernel.org] wrote:
> | I don't know how dwfl_report_offline() can make it to find out a mod
> | from pc as it's an (loaded) virtual address.  Maybe I miss something or
> | is your dso's are prelinked?
>
> Scratching my head on this and a related issue.
>
> The code seems to work consistently on Fedora20 and we recently noticed
> that it does not work on RHEL7. Maybe related to the issue you point out.
>
> On Fedora20 objdump -D /usr/lib64/libc-2.18.so shows something like this:
>
> 00000080a7be3bf0 <.__random>:
>   80a7be3bf0:   7c 08 02 a6     mflr    r0
>   80a7be3bf4:   fb e1 ff f8     std     r31,-8(r1)
>   80a7be3bf8:   60 00 00 00     nop
>   80a7be3bfc:   39 00 00 01     li      r8,1
>   80a7be3c00:   3b e2 9a f0     addi    r31,r2,-25872
>   80a7be3c04:   39 40 00 00     li      r10,0
>   80a7be3c08:   f8 01 00 10     std     r0,16(r1)
>   80a7be3c0c:   f8 21 ff 71     stdu    r1,-144(r1)
>   80a7be3c10:   7d 20 f8 29     lwarx   r9,0,r31,1
>   80a7be3c14:   7c 09 50 00     cmpw    r9,r10
>   80a7be3c18:   40 82 00 0c     bne     80a7be3c24 <.__random+0x34>
>
> and my small test program (and perf) can use the addresses to correctly
> say if LR is relevant or not.

Looks like it's prelink'ed.


>
> But on RHEL7, objdump shows addresses differently:
>
> 0000000000063870 <.__random>:
>    63870:       7c 08 02 a6     mflr    r0
>    63874:       fb e1 ff f8     std     r31,-8(r1)
>    63878:       60 00 00 00     nop
>    6387c:       3b e2 9a e0     addi    r31,r2,-25888
>    63880:       39 00 00 01     li      r8,1
>    63884:       39 40 00 00     li      r10,0
>    63888:       f8 01 00 10     std     r0,16(r1)
>    6388c:       f8 21 ff 71     stdu    r1,-144(r1)
>    63890:       7d 20 f8 29     lwarx   r9,0,r31,1
>
> and perf and my test program fail. Not sure if this is something related
> to the way it is built.

Then I think struct dso might not be a proper place to cache since a dso
can be mapped to different locations/addresses and it has no idea about
the location.

Maybe it's worth move the caching logic to a different place like struct
thread as libunwind does now, and make it generic so that the arch's
can also get the benefit when unwinding.  A problem I can expect is that
it will have thread x dso number of cache entries which can consume a
lot of memory and fd IMHO.

Thanks,
Namhyung
