Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab3DAULT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 16:11:19 -0400
Received: from relay3.sgi.com ([192.48.152.1]:52012 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751182Ab3DAULQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 16:11:16 -0400
From: Nathan Zimmer <nzimmer@sgi.com>
To: viresh.kumar@linaro.org, rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nathan Zimmer <nzimmer@sgi.com>
Subject: [PATCH v6 0/2] cpufreq: cpufreq_driver_lock is hot on large systems
Date: Mon,  1 Apr 2013 15:11:07 -0500
Message-Id: <1364847069-2887-1-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <5159C147.70800@sgi.com>
References: <5159C147.70800@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am noticing the cpufreq_driver_lock is quite hot.
On an idle 512 system perf shows me most of the system time is spent on this
lock.  This is quite significant as top shows 5% of time in system time.
My solution was to first split the lock into two parts, cpu_driver_lock and 
cpu_data_lock, with the cpufreq_driver also being protected by the RCU.
There was measurable heat left on the cpufreq_data_lock in __cpufreq_cpu_get.
So in the second part I converted the cpufreq_data_lock to be a rw lock since
an rcu solution was not apparent, at least to me.

v5: Go a different way and split up the lock and use the rcu
v6: use bools instead of checking function pointers
    covert the cpufreq_data_lock to a rwlock

Nathan Zimmer (2):
  cpufreq: split the cpufreq_driver_lock and use the rcu
  cpufreq: covert the cpufreq_data_lock to a spinlock

 drivers/cpufreq/cpufreq.c | 302 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 219 insertions(+), 83 deletions(-)

-- 
1.8.1.2

