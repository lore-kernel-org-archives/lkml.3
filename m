Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab3KEAvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 19:51:50 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:45850 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab3KEAvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 19:51:49 -0500
MIME-Version: 1.0
Date: Mon, 4 Nov 2013 16:51:48 -0800
Message-ID: <CAF+KLxuutGDHxzLLaWL-wXsDRyM=4syJcm7wDdEgNxNCpg2TWQ@mail.gmail.com>
Subject: [PATCH] trace-cmd: Make read nonblocking in find_time_stamp().
From: Aaron Fabbri <ajfabbri@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-rt-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        yoshihiro.yunomae.ez@hitachi.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This only affects the tsc -> time of day correlation when doing
`trace-cmd record --date`.

get_date_to_ts() writes a dummy event to trace_marker and then reads it back.
Reading it back is done by looping over all per-cpu raw trace pipes and trying
to read.  This read should be non-blocking, because the dummy event can end up
on any CPU.

Signed-off-by: Aaron Fabbri <ajfabbri@gmail.com>
---
 trace-record.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/trace-record.c b/trace-record.c
index 1b1d293..dca8a92 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -2092,7 +2092,7 @@ static unsigned long long find_time_stamp(struct
pevent *pevent)
                        continue;

                sprintf(file, "%s/%s/trace_pipe_raw", path, name);
-               fd = open(file, O_RDONLY);
+               fd = open(file, O_RDONLY | O_NONBLOCK);
                if (fd < 0)
                        continue;
                do {
-- 
1.8.1.2
