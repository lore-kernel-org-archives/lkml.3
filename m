Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559Ab3EGU4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 16:56:23 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:54423 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758876Ab3EGU4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 16:56:22 -0400
Message-ID: <51896A71.8010007@gmail.com>
Date: Tue, 07 May 2013 14:56:17 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] perf record: handle death by SIGTERM
References: <1367864663-1309-1-git-send-email-dsahern@gmail.com> <CABPqkBTj6Jt82mvVJKJxXaGnbD5GbW5mo4L71StOZuA=8MwDdw@mail.gmail.com> <20130507062947.GB17705@gmail.com>
In-Reply-To: <20130507062947.GB17705@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/13 12:29 AM, Ingo Molnar wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>> This is a good fix. I have run into this infinite loop in perf report
>> many times.
>
> Hm, perf record should really not assume much about the perf.data and
> should avoid infinite loops ...
>
> So while making perf.data more consistent on SIGTERM is a nice fix, perf
> report should be fixed as well to detect loops and such.
>
> Thanks,
>
> 	Ingo
>

This seems to do the trick:

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 326068a..e82646f 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2802,6 +2802,17 @@ int perf_session__read_header(struct perf_session 
*session, int fd)
     if (perf_file_header__read(&f_header, header, fd) < 0)
         return -EINVAL;

+   /*
+    * sanity check that perf.data was written cleanly: data size
+    * is initialized to 0 and updated only if the on_exit function
+    * is run. If data size is still 0 then the file cannot be
+    * processed.
+    */
+   if (f_header.data.size == 0) {
+       pr_err("data size is 0. Was record properly terminated?\n");
+       return -1;
+   }
+
     nr_attrs = f_header.attrs.size / f_header.attr_size;
     lseek(fd, f_header.attrs.offset, SEEK_SET);

