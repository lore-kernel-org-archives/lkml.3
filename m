Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbbA2PF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:05:59 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:54321 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbbA2PF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:05:57 -0500
Message-ID: <1422543953.7832.29.camel@mochrul>
Subject: Odd heuristic in load average calculation when many processes start
 in a small window
From: SZALAY Attila <sasa@balabit.com>
To: linux-kernel@vger.kernel.org
Date: Thu, 29 Jan 2015 16:05:53 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found a strange spike in one of my machine's load average.

The machine does nothing (right now). The normal load average is nearly
zero, the user and system usage is not more than 5 per cent. But once in
a while the load average go to more than one, some times even much
higher (5-20).

The problem with this is that I want to do an alert based on the load of
the machine but this amount of false positive alerts cause some trouble.

I checked the overall status of the machine with the
dstat -tcdngslyip

command and found no running process and no blocked process either.

But the number of the new processes was high in every occurrence.

So I created a small script to mimic this behavior and I can reproduce
the problem with a labor environment. I tested it in an ubuntu trusty,
with kernel version 3.13.0 and 3.18.0. The production system is an
ubuntu precise with kernel version 3.2.0.

In the test system I could not create really big load average, but it is
a virtual machine with 4 core and the production system is a bare metal
with 16 core.

So, my question is:
- Can I do something to mitigate this problem (the load of processes is
  started by the munin and I could not eliminate it from the system)

- Is this can be treated as a bug in the load average calculation? Or
  it is a known issue/design fact?

Of course I searched the web for the answers but found nothing related
to this issue. In every place I found there were processes in D state or
at least high iowait, but not here.

Thanks you for your help

A simplified output sample of the test machine is the following:
----system---- ----total-cpu-usage---- ---load-avg--- ---procs---
     time     |usr sys idl wai hiq siq| 1m   5m  15m |run blk new
29-01 14:52:46|  0   0 100   0   0   0|   0 0.12 0.30|  0   0   0
29-01 14:52:47|  0   0 100   0   0   0|   0 0.12 0.30|  0   0   0
29-01 14:52:48|  0   0 100   0   0   0|   0 0.12 0.30|  0   0   0
29-01 14:52:49|  0   0 100   0   0   0|   0 0.12 0.30|  0   0   0
29-01 14:52:50|  0   0 100   0   0   0|   0 0.11 0.30|  0   0   0
29-01 14:52:51|  0   0 100   0   0   0|   0 0.11 0.30|  0   0   0
29-01 14:52:52|  0   0 100   0   0   0|   0 0.11 0.30|  0   0   0
29-01 14:52:53|  0   0 100   0   0   0|   0 0.11 0.30|  0   0   0
29-01 14:52:54|  0   0 100   0   0   0|   0 0.11 0.30|  0   0   0
29-01 14:52:55|  6  12  81   0   0   0|   0 0.11 0.30|  0   0 504
29-01 14:52:56|  0   0 100   0   0   0|   0 0.11 0.30|  0   0   0
29-01 14:52:57|  0   0 100   0   0   0|   0 0.11 0.30|  0   0   0
29-01 14:52:58|  0   0 100   0   0   0|   0 0.11 0.30|  0   0   0
29-01 14:52:59|  0   0 100   0   0   0|   0 0.11 0.30|  0   0   0
29-01 14:53:00|  0   0 100   0   0   0|   0 0.11 0.30|  0   0   0
29-01 14:53:01|  0   0 100   0   0   0|   0 0.11 0.30|  0   0   0
29-01 14:53:02|  0   0 100   0   0   0|   0 0.11 0.30|  0   0   0
29-01 14:53:03|  0   0 100   0   0   0|   0 0.11 0.30|  0   0   0
29-01 14:53:04|  0   0 100   0   0   0|   0 0.11 0.30|  0   0   0
29-01 14:53:05|  6  12  83   0   0   0|0.32 0.17 0.32|  0   0 503
29-01 14:53:06|  0   0 100   0   0   0|0.32 0.17 0.32|  0   0   0

And the test script is the following:
#!/bin/sh

while `/bin/true`
do
  for i in `seq 1 500`
  do
    /bin/echo -en "" &
  done
  sleep 10
done


