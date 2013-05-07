Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636Ab3EGAFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 20:05:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54221 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758772Ab3EGAFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 20:05:35 -0400
Message-ID: <5188454A.4070700@gmail.com>
Date: Mon, 06 May 2013 18:05:30 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] perf record: handle death by SIGTERM
References: <1367864663-1309-1-git-send-email-dsahern@gmail.com> <CABPqkBTj6Jt82mvVJKJxXaGnbD5GbW5mo4L71StOZuA=8MwDdw@mail.gmail.com>
In-Reply-To: <CABPqkBTj6Jt82mvVJKJxXaGnbD5GbW5mo4L71StOZuA=8MwDdw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/6/13 4:40 PM, Stephane Eranian wrote:
> This is a good fix. I have run into this infinite loop in perf report
> many times.

The perf_file_header could use an 'I am sane' bit which is only set when 
the file is closed properly. Perhaps we could overload the magic field 
like this:

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 326068a..cd9fad6 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2364,7 +2364,6 @@ out_err_write:
     }

     f_header = (struct perf_file_header){
-       .magic     = PERF_MAGIC,
         .size      = sizeof(f_header),
         .attr_size = sizeof(f_attr),
         .attrs = {
@@ -2382,6 +2381,8 @@ out_err_write:
     };

     memcpy(&f_header.adds_features, &header->adds_features, 
sizeof(header->adds_features));
+   if (at_exit)
+       f_header.magic     = PERF_MAGIC,

     lseek(fd, 0, SEEK_SET);
     err = do_write(fd, &f_header, sizeof(f_header));

The perf magic is only written when the file is closed properly. In 
Mike's case you end up with the message (which can be enhanced)

   magic/endian check failed
   incompatible file format (rerun with -v to learn more)

which is better than an infinite loop.

David

