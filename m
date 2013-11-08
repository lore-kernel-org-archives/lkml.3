Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab3KHOlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 09:41:32 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:55941 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab3KHOla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 09:41:30 -0500
Message-ID: <527CF7FF.7060001@gmail.com>
Date: Fri, 08 Nov 2013 07:41:03 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf tool: Round mmap pages to power 2
References: <1383885392-31082-1-git-send-email-dsahern@gmail.com> <527CAAAB.3000900@intel.com>
In-Reply-To: <527CAAAB.3000900@intel.com>
Content-Type: multipart/mixed;
 boundary="------------040201090007020100010108"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040201090007020100010108
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 11/8/13, 2:11 AM, Adrian Hunter wrote:
> This prevents:
>
>      --out-pages=0
>
> from working e.g.
>
>      tools/perf/perf record -vv --out-pages=0 uname
>      rounding mmap pages size to 4096 (1 pages)
>
> Although without this patch:
>
>      tools/perf/perf record -vv --out-pages=0 uname
>      --mmap_pages/-m value must be a power of two.
>       usage: perf record [<options>] [<command>]
>          or: perf record [<options>] -- <command> [<options>]
>
>              --out-pages <pages>
>                            Number of pages or size with units to use for
> output (default 64M)
>
> Also there is:
>
>      tools/perf/perf record -vv --no-out-pages uname
>      Segmentation fault (core dumped)

This is problem with perf_evlist__parse_mmap_pages(); same thing happens 
with --no-map-pages.

With the attached both round a 0 up to 1 page:

[daahern@nxos-vdc-dev3 perf]$ perf record --out-pages 0 uname
rounding mmap pages size to 4096 (1 pages)
Linux
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.008 MB perf.data (~339 samples) ]

[daahern@nxos-vdc-dev3 perf]$ perf record --mmap-pages 0 uname
rounding mmap pages size to 4096 (1 pages)
Linux
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.008 MB perf.data (~339 samples) ]

[daahern@nxos-vdc-dev3 perf]$ perf record --no-mmap-pages uname

  usage: perf record [<options>] [<command>]
     or: perf record [<options>] -- <command> [<options>]

     -m, --mmap-pages <pages>
                           number of mmap data pages
David


--------------040201090007020100010108
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="0001-perf-record-Fix-segfault-with-no-mmap-pages.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-perf-record-Fix-segfault-with-no-mmap-pages.patch"

>From fc7c5a6b2b47a2e7a04613b4e82e478a0dcabf42 Mon Sep 17 00:00:00 2001
From: David Ahern <dsahern@gmail.com>
Date: Fri, 8 Nov 2013 07:37:43 -0700
Subject: [PATCH] perf record: Fix segfault with --no-mmap-pages

Adrian reported a segfault when using --no-out-pages
$ tools/perf/perf record -vv --no-out-pages uname
Segmentation fault (core dumped)

The same occurs with --no-mmap-pages. Fix by checking that str is non-NULL
before parsing it.

Reported-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/evlist.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 9ec3a5a45f22..1f103616d906 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -718,6 +718,9 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
 		{ .tag  = 0 },
 	};
 
+	if (str == NULL)
+		return -1;
+
 	val = parse_tag_value(str, tags);
 	if (val != (unsigned long) -1) {
 		/* we got file size value */
-- 
1.8.3.4 (Apple Git-47)


--------------040201090007020100010108--
