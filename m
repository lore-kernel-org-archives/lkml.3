Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbaFCS4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:56:19 -0400
Received: from mail.kernel.org ([198.145.19.201]:53057 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274AbaFCS4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:56:17 -0400
Date: Tue, 3 Jun 2014 15:56:13 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -tip ] [BUGFIX] perf/probe: Fix perf probe to find
 correct variable DIE
Message-ID: <20140603185613.GE3696@kernel.org>
References: <20140529105232.28251.30447.stgit@ltc230.yrl.intra.hitachi.co.jp>
 <20140529121930.30879.87092.stgit@ltc230.yrl.intra.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529121930.30879.87092.stgit@ltc230.yrl.intra.hitachi.co.jp>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 29, 2014 at 09:19:30PM +0900, Masami Hiramatsu escreveu:
> Fix perf probe to find correct variable DIE which has location or
> external instance by tracking down the lexical blocks.
> 
> Current die_find_variable() expects that the all variable DIEs
> which has DW_TAG_variable have a location. However, since recent
> dwarf information may have declaration variable DIEs at the
> entry of function (subprogram), die_find_variable() returns it.
> 
> To solve this problem, it must track down the DIE tree to find
> a DIE which has an actual location or a reference for external
> instance.

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Before:

[root@zoo ~]# perf probe --del probe:vfs_getname
Removed event: probe:vfs_getname
[root@zoo ~]# perf probe 'vfs_getname=getname_flags:65 pathname=result->name:string'
Added new event:
Segmentation fault (core dumped)

After:

[root@zoo ~]# perf probe 'vfs_getname=getname_flags:65 pathname=result->name:string'
Added new event:
  probe:vfs_getname    (on getname_flags:65 with pathname=result->name:string)

You can now use it in all perf tools, such as:

	perf record -e probe:vfs_getname -aR sleep 1

[root@zoo ~]# perf record -e probe:vfs_getname -a sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.550 MB perf.data (~24022 samples) ]
[root@zoo ~]# perf script | head -5
            perf 27758 [001] 12022.551584: probe:vfs_getname: (ffffffff811c2e43) pathname="/home/acme/libexec/perf-core/sleep"
            perf 27758 [001] 12022.551616: probe:vfs_getname: (ffffffff811c2e43) pathname="/usr/lib64/ccache/sleep"
            perf 27758 [001] 12022.551628: probe:vfs_getname: (ffffffff811c2e43) pathname="/usr/local/sbin/sleep"
            perf 27758 [001] 12022.551636: probe:vfs_getname: (ffffffff811c2e43) pathname="/usr/local/bin/sleep"
            perf 27758 [001] 12022.551644: probe:vfs_getname: (ffffffff811c2e43) pathname="/sbin/sleep"
[root@zoo ~]#

- Arnaldo
