Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaKJK7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:59:33 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36729 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaKJK7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:59:32 -0500
Message-ID: <54609A8C.4050308@hitachi.com>
Date: Mon, 10 Nov 2014 19:59:24 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, systemtap@sourceware.org,
        aravinda@linux.vnet.ibm.com, penberg@iki.fi, brendan.d.gregg@gmail.com,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [RFC] perf-cache command interface design
References: <20141102105006.21708.28734.stgit@hemant-fedora> <20141102105557.21708.19032.stgit@hemant-fedora> <87lhnr5sbl.fsf@sejong.aot.lge.com> <54588905.7040002@linux.vnet.ibm.com> <5458CD15.4010101@hitachi.com> <874muew2hk.fsf@sejong.aot.lge.com> <5459E865.6050207@hitachi.com> <545B1DDE.9000202@linux.vnet.ibm.com> <545C80F4.4020905@hitachi.com>
In-Reply-To: <545C80F4.4020905@hitachi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Here is the second try for the probe-cache. This version simplifies
the synopsis, and unifies the SDT and probe caches.
Please give me your comments/ideas!

Command-line Synopsis
=====================

Add elf(or symbols) and probe-caches of SDT if exists in <FILES>
 perf cache --add <FILES> [--probe <SPEC>] # for user programs

 perf cache --kcore <FILE> [--probe <SPEC>] # for kcore ?

 perf cache --probe <SPEC>  # for the current kernel

Remove caches related to <FILES> or <BUILDIDS>
 perf cache --remove <FILES>|<BUILDIDS>

Show all probe caches(including SDT) or buildids
 perf cache --list [probe|buildid]

Delete existing probe-cache entries for kernel, <PATH> or/and <BUILDID>.
 perf cache　--probe-del [<GROUP>:]<EVENT>[@<PATH>][#<BUILDID>]

Query the probe definitions.
 perf cache --query [<GROUP>:]<EVENT>[@<PATH>][#<BUILDID>]


File Format
===========
All the cache files are placed under ~/.debug/ by default.
Elf caches are ~/.debug/path/to/file/bu/ildid/elf
Symbols caches are ~/.debug/path/to/file/bu/ildid/syms
Probes(and SDT) are ~/.debug/path/to/file/bu/ildid/probes
And ~/.debug/path/to/file/bu/ildid/ is linked to ~/.debug/.buildid/bu/ildid
Optionally, we can gzip the probes file.

This probe caches contain probe-definitions as following format.
----
#buildid:BUILDID
#spec:SDT
p:sdt_<PROVIDER>/<EVENT> PATH:OFFSET [ARGS]
...
#spec:* $params
p:probe_<GROUP>/<EVENT> _text+OFFSET [ARGS]
...
----
So the #spec: line gives the information what probe spec has been given.
This will be used for updating.

And all the "probe_" and "sdt_" prefix will be replaced by % in the command line,
e.g.

 perf record -e %<PROVIDER>/<EVENT> -> this records sdt_PROVIDER/EVENT

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


