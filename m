Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbaGVNbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:31:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:37955 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbaGVNbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:31:39 -0400
Message-ID: <53CE67B0.7020406@linutronix.de>
Date: Tue, 22 Jul 2014 15:31:28 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, acme@kernel.org,
        namhyung.kim@lge.com, tzanussi@gmail.com
Subject: Re: [RFC] perf to ctf converter
References: <20140603163640.GA16279@linutronix.de> <20140714141533.GD17761@krava.redhat.com> <20140721171151.GA12969@linutronix.de> <20140721183530.GA28673@krava.redhat.com> <53CE0B89.7030400@linutronix.de> <20140722112535.GA29750@krava.redhat.com> <53CE4BAF.2010906@linutronix.de>
In-Reply-To: <53CE4BAF.2010906@linutronix.de>
X-Enigmail-Version: 1.6+git0.20140323
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 01:31 PM, Sebastian Andrzej Siewior wrote:
>> [jolsa@krava perf]$ LD_LIBRARY_PATH=/opt/libbabeltrace/lib /opt/libbabeltrace/bin/babeltrace ./ctf-data/
>>
>> [04:41:11.445378840] (+?.?????????) sched:sched_switch: { }, { pid = 5782, comm = "ls", prev_comm = [ [0] = "ls", [1] = "s", [2] = "", [3] = "f", [4] = "", [5] = "", [6] = "-x86_64-l", [7] = "x86_64-l", [8] = "86_64-l", [9] = "6_64-l", [10] = "_64-l", [11] = "64-l", [12] = "4-l", [13] = "-l", [14] = "l", [15] = "" ], prev_pid = 5782, prev_prio = 120, prev_state = 0x1, next_comm = [ [0] = "kworker/0:0", [1] = "worker/0:0", [2] = "orker/0:0", [3] = "rker/0:0", [4] = "ker/0:0", [5] = "er/0:0", [6] = "r/0:0", [7] = "/0:0", [8] = "0:0", [9] = ":0", [10] = "0", [11] = "", [12] = "", [13] = "", [14] = "", [15] = "" ], next_pid = 2376, next_prio = 120 }
>> [04:41:11.445390175] (+0.000011335) sched:sched_switch: { }, { pid = 5782, comm = "ls", prev_comm = [ [0] = "ls", [1] = "s", [2] = "", [3] = "f", [4] = "", [5] = "", [6] = "-x86_64-l", [7] = "x86_64-l", [8] = "86_64-l", [9] = "6_64-l", [10] = "_64-l", [11] = "64-l", [12] = "4-l", [13] = "-l", [14] = "l", [15] = "" ], prev_pid = 5782, prev_prio = 120, prev_state = 0x1, next_comm = [ [0] = "kworker/0:0", [1] = "worker/0:0", [2] = "orker/0:0", [3] = "rker/0:0", [4] = "ker/0:0", [5] = "er/0:0", [6] = "r/0:0", [7] = "/0:0", [8] = "0:0", [9] = ":0", [10] = "0", [11] = "", [12] = "", [13] = "", [14] = "", [15] = "" ], next_pid = 2376, next_prio = 120 }
>>
>> ...
>>
>> looks like we need some better string arg handling,
>> but we'll get there soon or later
> 
> I'm looking at how python gets it nicer…

Okay, fixed. The problem was that a string has the STRING and the
ARRAY bit set. So I used the length of the array and made an array of
strings. Not really what was expected :) I removed this nonsense. Now I
get:

[06:37:09.867844231] (+0.000005597) sched:sched_switch: { cpu_id = 0 },
{ common_pid = 14068, common_tid = 14068, common_comm = "ls", prev_comm
= "ls", prev_pid = 14068, prev_prio = 120, prev_state = 2, next_comm =
"swapper/5", next_pid = 0, next_prio = 120 }

So the strings look good now. I also renamed "pid" to "common_pid" because

[06:37:09.885385418] (+0.017541187) sched:sched_wakeup: { cpu_id = 0 },
{ common_pid = 179, common_tid = 179, common_comm = ":179", comm = "ls",
pid = 14068, prio = 120, success = 1, target_cpu = 5 }

that thing brings its own pid & comm.

And while looking at the data types and dropped that & LONG since it is
not set for 64bit data types as I assumed. I do now consider ->size and
the result is

[06:37:09.867838634] (+0.000253941) sched:sched_stat_runtime: { cpu_id =
0 }, { common_pid = 14068, common_tid = 14068, common_comm = "ls", comm
= "ls", pid = 14068, runtime = 2020750, vruntime = 76395575003 }

that means vruntime is 64bit as it should and decimal might be nice.
\o/

Sebastian
