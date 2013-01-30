Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab3A3SHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 13:07:37 -0500
Received: from relay3.sgi.com ([192.48.152.1]:45210 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755171Ab3A3SHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 13:07:34 -0500
Date: Wed, 30 Jan 2013 12:07:32 -0600
From: Nathan Zimmer <nzimmer@sgi.com>
To: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: cpufreq: cpufreq_driver_lock is quite hot on 512p systems
Message-ID: <20130130180731.GA9449@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I am noticing the cpufreq_driver_lock is quite hot.
Currently on an idle 512 system perf shows me most of the system time is 
spent on this lock.

-  84.18%  [kernel]                 [k] _raw_spin_lock_irqsave
   - _raw_spin_lock_irqsave
      - 99.97% __cpufreq_cpu_get
           cpufreq_cpu_get
           __cpufreq_driver_getavg
           dbs_check_cpu
           od_dbs_timer
           process_one_work
           worker_thread
           kthread
           ret_from_fork
 
The data this lock protects is used in a read mostly situation.
While exprimenting I found turning the lock to a rwlock fixed the problem.
It seems like this might be amenable to using the RCU.

Any other ideas on how to properly resolve the issue?

Thanks,
Nate

