Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533AbaDXS1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 14:27:18 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:53601 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753171AbaDXS1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 14:27:17 -0400
X-Greylist: delayed 661 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Apr 2014 14:27:17 EDT
From: Roman Gushchin <klamm@yandex-team.ru>
To: LKML <linux-kernel@vger.kernel.org>, mingo@redhat.com,
        peterz@infradead.org, tkhai@yandex.ru
Subject: Real-time scheduling policies and hyper-threading
MIME-Version: 1.0
Message-Id: <36851398363372@webcorp2g.yandex-team.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Thu, 24 Apr 2014 22:16:12 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!


I spend some time investigating why switching runtime* tasks to real-time scheduling policies increases
response time dispersion, while the opposite is expected.

The main reason is hyper-threading. rt-scheduler tries only to load all logical CPUs, selecting topologically
closest when the current is busy. If hyper-threading is enabled, this strategy is counter-productive:
tasks are suffering on busy HT-threads when there is a plenty of idle physical cores.

Also, rt-scheduler doesn't try to balance rt load between physical CPUs. It's significant because of
turbo-boost and frequency scaling technologies: per-core performance depends on the number of
idle cores in the same physical cpu.


Are there any known solutions of this problem except disabling hyper-threading and frequency scaling at all?

Are there any common plans to enhance the load balancing algorithm in the rt-scheduler?

Does anyone use rt-scheduler for runtime-like cpu-bound tasks?


Why just don't use CFS? :-)
Rt-scheduler with modified load balancing shows much better results.
I have a prototype (still incomplete and with many dirty hacks), that shows 10-15% 
performance increase in our production.


(*) A simplified model can be described as following:
there is one process per machine, with one thread, that receives request from network and puts them into queue;
n (n ~ NCPU + 1) worker threads, that get requests from the queue and handle them.
Load is cpu-bound, tens of milliseconds per request. Typical CPU load is between 40% and 70%.
A typical system has two physical x86-64 cpus with 8-16 physical cores each (x2 with hyper-threading).


Thanks,
Roman
