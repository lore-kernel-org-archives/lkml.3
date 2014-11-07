Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaKGKvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 05:51:55 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:33644 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaKGKvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 05:51:53 -0500
Message-ID: <545CA436.8030306@linux.vnet.ibm.com>
Date: Fri, 07 Nov 2014 16:21:34 +0530
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, systemtap@sourceware.org,
        aravinda@linux.vnet.ibm.com, penberg@iki.fi, brendan.d.gregg@gmail.com,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [RFC] perf-cache command interface design
References: <20141102105006.21708.28734.stgit@hemant-fedora> <20141102105557.21708.19032.stgit@hemant-fedora> <87lhnr5sbl.fsf@sejong.aot.lge.com> <54588905.7040002@linux.vnet.ibm.com> <5458CD15.4010101@hitachi.com> <874muew2hk.fsf@sejong.aot.lge.com> <5459E865.6050207@hitachi.com> <545B1DDE.9000202@linux.vnet.ibm.com> <545C80F4.4020905@hitachi.com>
In-Reply-To: <545C80F4.4020905@hitachi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110710-0021-0000-0000-0000021576EE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/07/2014 01:51 PM, Masami Hiramatsu wrote:
> Hello,
>
> Here, I've tried to describe my idea of perf-cache subcommand interface.
> It is just a design review, not implemented yet :)
> Please give me your comments/ideas!

Thanks, I have some comments below.

> Command-line Synopsis
> =====================
>
> Current "perf buildid-cache [options]" are directly mapped to
> "perf cache --buildid [options]".
>
> And adding --sdt for managing SDT caches as below.
>
>   Add or update SDT events in <FILES>
>     perf cache --sdt --add|--update <FILES>
>   Remove all SDT events for <FILES>
>     perf cache --sdt --remove <FILES>
>
>   List all SDT events
>     perf cache --sdt --list
>
> And --probes for managing probe-caches as below.
>
>   Add new probe-cache entries for kernel, <PATH> or <MOD>.
>     perf cache --probe [--exec <PATH>|--module <MOD>] --add <SPEC>
>
>   Delete existing probe-cache entries for kernel, <PATH> or/and <BUILDID>.
>     perf cache --probe --del [<GROUP>:]<EVENT>[@<PATH>][#<BUILDID>]
>
>   Or remove all entires for given FILES
>     perf cache --probe --remove <FILES>
>
>   List the probe caches(including SDT) for kernel, <PATH>, or/and <BUILDID>.
>     perf cache --probe --list [@<PATH>][#<BUILDID>]
>
>   Query the probe definitions.
>     perf cache --probe --query [<GROUP>:]<EVENT>[@<PATH>][#<BUILDID>]
>
> Note that --probes also can be used for managing SDT events, which has % prefix
> e.g.
>   Add all SDT events for <PATH>
>     perf cache --probe --exec <PATH> --add '%*:*'
>
>   Remove some SDT events for <PATH>
>     perf cache --probe --del '%some:events@<PATH>'
>
>   Or remove all SDT events for <BUILDID>
>     perf cache --probe --del '%*:*#<BUILDID>'

Looks nice to me :)

>
> File Format
> ===========
> All the cache files are placed under ~/.debug/ by default.
> The paths of buildid cache of binary/symbols are not changed.
>
> The SDT/probe caches are placed under the ~/.debug/.probes/path/to/bin/bu/ildid
> and that is linked to ~/.debug/.probes/.buildid/bu/ildid
> # To avoid conflict with files under /probes/*, I picked up .probes/.
>
> This SDT/probe caches contain probe-definitions as following format.
> ----
> #buildid:BUILDID
> #path:PATH
> p:%PROVIDER/EVENT PATH:OFFSET [ARGS]

I think this format isn't accepted by the uprobe_events file (because of
the '%') if we want to cat and grep into uprobe_events file directly.
Although, in case of perf record, we can process it to remove '%' and
then write into uprobe_events file. And, '%' is required as a flag for
the SDT entries.
So, either we can modify the uprobe_events file to ignore '%' in the
event group name (with an additional patch in the SDT series) or we can
leave it to the user to write a script which can do some processing to
remove '%' and then echo it to uprobe_events file.
What would you think?

> p:PROBE/EVENT _text+OFFSET [ARGS]
> ----
>
> Normal probes and SDT cache entries can be mixed in a cache file, we'll
> load all the entries and filter by % prefixes.
>
>
> Thank you,
>

-- 
Thanks,
Hemant Kumar

