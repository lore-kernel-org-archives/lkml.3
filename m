Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbaDAH23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 03:28:29 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:55816 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbaDAH21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 03:28:27 -0400
MIME-Version: 1.0
In-Reply-To: <53397B18.1020004@fb.com>
References: <1395293806-25847-1-git-send-email-namhyung@kernel.org> <53397B18.1020004@fb.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Tue, 1 Apr 2014 07:28:06 +0000
X-Google-Sender-Auth: QRtFC872pXIT5NmXF7oPud2_F6g
Message-ID: <CAM9d7cjjaj-yeHMOb=8b=iMsBZuEgZhh6x-vTpFA67CQ1Xp=bA@mail.gmail.com>
Subject: Re: [PATCHSET 00/21] perf tools: Add support to accumulate hist
 periods (v9)
To: Arun Sharma <asharma@fb.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Rodrigo Campos <rodrigo@sdfg.com.ar>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arun,

On Mon, Mar 31, 2014 at 2:26 PM, Arun Sharma <asharma@fb.com> wrote:
> On 3/20/14, 11:06 AM, Namhyung Kim wrote:
>>
>> Hello,
>>
>> This is a new attempt to implement cumulative hist period report.
>> This work begins from Arun's SORT_INCLUSIVE patch [1] but I completely
>> rewrote it from scratch.
>
>
> While testing this patch series, we found error messages which look like
> this:
>
> Out of bounds address found:
>
> Addr:   10370
> DSO:    /usr/local/lib/libgcc_s.so.1 d
> Map:    7f1b0c953000-7f1b0c968000
> Symbol: 102d0-102e9 g _Unwind_DeleteException
> Arch:   x86_64
> Kernel: 3.10.23+
> Tools:  3.13.rc1.g374a4d
>
> Not all samples will be on the annotation output.
>
> Please report to linux-kernel@vger.kernel.org

Hmm.. interesting.  is it perf top right?

>
> I first suspected it to be caused by this patch series, but I'm able to
> reproduce without these patches as of this commit:
>
> a51e87c perf tools: Remove unused simple_strtoul() function

Ah, it's good to know :)

>
> gdb attributes 0x10370 to a different/known symbol.
>
> (gdb) x /i 0x10370
>    0x10370 <get_cie_encoding+160>:      cmp    $0x4c,%dl
>
> Is this known? Could this possibly be caused by stale histogram entries from
> unmapped/remapped shared libs?

Possibly.

Anyway the addr which perf reported is a mapped address so that it's
pointless to use the addr directly - it's 7f1b0c963370 in fact.

What was the exact command line though - did you use any filter
(--comms, --dsos, --symbols) or event modifiers?  Those are another
possible culprits since map searching code touched by recent changes.

I'm not able to reproduce the problem on my machine.  It'd be great if
you could bisect or let me know how to reproduce it easily.

Thanks,
Namhyung
