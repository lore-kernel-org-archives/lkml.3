Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab3IITrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 15:47:52 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:49185 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab3IITrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 15:47:51 -0400
Date: Mon, 9 Sep 2013 16:47:45 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, jolsa@redhat.com, namhyung.kim@lge.com,
        dsahern@gmail.com
Subject: Re: [PATCH v2 2/2] perf tools: add attr->mmap2 support
Message-ID: <20130909192810.GA3825@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377079825-19057-3-git-send-email-eranian@google.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 21, 2013 at 12:10:25PM +0200, Stephane Eranian escreveu:
> This patch adds support for the new PERF_RECORD_MMAP2
> record type exposed by the kernel. This is an extended
> PERF_RECORD_MMAP record. It adds for each file-backed
> mapping the device major, minor number and the inode
> number and generation. This triplet uniquely identifies
> the source of a file-backed mapping. It can be used to
> detect identical virtual mappings between processes, for
> instance.
> 
> The patch will prefer MMAP2 over MMAP.

I noticed the kernel part is in, and I'm going to use MMAP2 on that new
tool, so tried merging it, but:

I fixed it up wrt another patch that makes machine__find_thread receive pid/tid
but then 'perf test' complains about it, see below, trying to fix...

- Arnaldo


[root@sandy ~]# perf test -v 7
 7: Validate PERF_RECORD_* events & perf_sample fields     :
--- start ---
57503587100282 0 PERF_RECORD_SAMPLE
57503587104415 0 PERF_RECORD_SAMPLE
57503587106039 0 PERF_RECORD_SAMPLE
57503587107362 0 PERF_RECORD_SAMPLE
57503588263263 0 PERF_RECORD_COMM: sleep:1439
6180457940383 -1728826693 PERF_RECORD_MMAP2 1439/1439: [0x400000(0x7000) @ 0 00:1d 311442 9016]: /usr/bin/sleep
MMAP2 going backwards in time, prev=57503588263263, curr=6180457940383
MMAP2 with unexpected cpu, expected 0, got -1728826693
MMAP2 with unexpected pid, expected 1439, got 1701606191
MMAP2 with unexpected tid, expected 1439, got 28773
Unexpected perf_event->header.type 10!
6180457940383 -1728754371 PERF_RECORD_MMAP2 1439/1439: [0x3b7e000000(0x223000) @ 0 00:1d 309186 9016]: /usr/lib64/ld-2.16.so
MMAP2 with unexpected cpu, expected 0, got -1728754371
MMAP2 with unexpected pid, expected 1439, got 1932408369
MMAP2 with unexpected tid, expected 1439, got 111
Unexpected perf_event->header.type 10!
6180457940383 -1728699354 PERF_RECORD_MMAP2 1439/1439: [0x7fff2bdff000(0x1000) @ 0x7fff2bdff000 00:00 0 0]: [vdso]
MMAP2 with unexpected cpu, expected 0, got -1728699354
MMAP2 with unexpected pid, expected 1439, got 1935963739
MMAP2 with unexpected tid, expected 1439, got 23919
Unexpected perf_event->header.type 10!
6180457940383 -1728433298 PERF_RECORD_MMAP2 1439/1439: [0x3b7e400000(0x3b8000) @ 0 00:1d 309187 9016]: /usr/lib64/libc-2.16.so
MMAP2 with unexpected cpu, expected 0, got -1728433298
MMAP2 with unexpected pid, expected 1439, got 909192754
MMAP2 with unexpected tid, expected 1439, got 7303982
Unexpected perf_event->header.type 10!
57504589856948 0 PERF_RECORD_EXIT(1439:1439):(1439:1439)
PERF_RECORD_MMAP for sleep missing!
PERF_RECORD_MMAP for libc missing!
PERF_RECORD_MMAP for ld missing!
PERF_RECORD_MMAP for [vdso] missing!
---- end ----
Validate PERF_RECORD_* events & perf_sample fields: FAILED!
[root@sandy ~]#
