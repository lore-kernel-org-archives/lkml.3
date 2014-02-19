Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbaBSJrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 04:47:14 -0500
Received: from emailsecure.uni-linz.ac.at ([140.78.3.66]:24893 "EHLO
	emailsecure.uni-linz.ac.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752826AbaBSJqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 04:46:31 -0500
X-Greylist: delayed 503 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Feb 2014 04:46:31 EST
Date: Wed, 19 Feb 2014 10:38:05 +0100
From: Peter Hofer <peter.hofer@jku.at>
To: linux-kernel@vger.kernel.org
Subject: user/sys ticks for process exceeds overall user/sys ticks
Message-ID: <20140219103805.03095e6b@sunflower.ssw.jku.at>
Organization: Johannes Kepler University Linz
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/Gf9Jskc1EtK24JkI1/qyhqR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/Gf9Jskc1EtK24JkI1/qyhqR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello everyone,

 I am trying to determine what fraction of the whole system's user and
sys time are consumed by a specific process, over a period of time.
Hence, I read the respective tick counts from the first lines
of /proc/stat and /proc/<pid>/stat at the start and end of that period
and compute deltas.

However, on an otherwise idle system, I often see the ticks consumed by
a threaded process exceed those of the whole system. The difference is
not just a few ticks, but can amount to over 10%, regardless of how
long the observed time period is. There is no virtualization involved.
I have been able to reproduce this with the current openSUSE and Ubuntu
releases on different x86_64 machines.

How can this be explained? Intuitively, I would expect that a tick
accounted to a running task is at the same time accounted to the CPU it
is running on, and so a process can never be accounted more ticks than
the whole system, i.e. all CPUs.

I have attached a simple Python script to reproduce this behavior.
Example output:

> ./ticks.py 
delta process: user: 2495 sys: 181
delta all: user: 2283 sys: 258

Thanks,
 Peter
--MP_/Gf9Jskc1EtK24JkI1/qyhqR
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=ticks.py

#!/usr/bin/python
import operator
import hashlib
from threading import Thread

def ticks_all():
  with open('/proc/stat') as f:
    cpu = f.readline().split()
    return (int(cpu[1]), int(cpu[3]))

def ticks_process():
  with open('/proc/self/stat') as f:
    cpu = f.readline().split()
    return (int(cpu[13]), int(cpu[14]))

def do_work():
  d = hashlib.md5()
  d.update('nobody inspects')
  for i in xrange(0, 10000000):
    d.update(' the spammish repetition')

before_all_user, before_all_sys = ticks_all()
before_process_user, before_process_sys = ticks_process()

threads = []
for i in xrange(0, 8):
  t = Thread(target=do_work)
  threads.append(t)
  t.start()
for t in threads:
  t.join()

after_process_user, after_process_sys = ticks_process()
after_all_user, after_all_sys = ticks_all()

print 'delta process: user:', after_process_user - before_process_user, 'sys:', after_process_sys - before_process_sys
print 'delta all: user:', after_all_user - before_all_user, 'sys:', after_all_sys - before_all_sys

--MP_/Gf9Jskc1EtK24JkI1/qyhqR--
