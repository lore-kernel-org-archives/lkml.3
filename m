Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646AbaAaPjB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:39:01 -0500
Received: from loki.mindstab.net ([69.164.214.81]:55284 "EHLO loki.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754026AbaAaPic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:38:32 -0500
To: peterz@infradead.org, Lennart Poettering <lennart@poettering.net>,
        kay.sievers@vrfy.org, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minto Joseph <mvaliyav@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Mel Gorman <mgorman@suse.de>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] v2 add StartTimeMonotomic, StartTimeBootTime to per pid  in  /proc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 31 Jan 2014 07:38:26 -0800
From: Dan Ballard <dan@mindstab.net>
Message-ID: <7a44eaa41ee1e784a52924c595942617@mindstab.net>
User-Agent: Roundcube Webmail/0.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

starttime in /proc/$PID/stat is inaccurate by "clock tick" granularity.
The process starttime is useful for a variety of things, like figuring
out creation ordering of processes and it is useful to detect PID
reuses in a somewhat reliable way.

The kernel internally stores finer granularity values and this patch
exports them in the easily usable location /prod/$PID/status
as StartTimeMonotonic and StartTimeBootTime.

Signed-off-by: Dan Ballard <dan@mindstab.net>
---
  Documentation/filesystems/proc.txt |    6 +++++-
  fs/proc/array.c                    |    8 ++++++--
  2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/proc.txt 
b/Documentation/filesystems/proc.txt
index 22d89aa3..6ed8001 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -158,6 +158,8 @@ read the file /proc/PID/status:
    TracerPid:      0                                            (2.4)
    Uid:    501     501     501     501
    Gid:    100     100     100     100
+  StartTimeMonotonic:     3766799643
+  StartTimeBootTime:      3766799643
    FDSize: 256
    Groups: 100 14 16
    VmPeak:     5004 kB
@@ -202,7 +204,7 @@ asynchronous manner and the vaule may not be very 
precise. To see a precise
  snapshot of a moment, you can see /proc/<pid>/smaps file and scan page 
table.
  It's slow but very precise.

-Table 1-2: Contents of the status files (as of 2.6.30-rc7)
+Table 1-2: Contents of the status files (as of 3.13.0-rc3)

..............................................................................
   Field                       Content
   Name                        filename of the executable
@@ -215,6 +217,8 @@ Table 1-2: Contents of the status files (as of 
2.6.30-rc7)
   TracerPid                   PID of process tracing this process (0 if 
not)
   Uid                         Real, effective, saved set, and  file 
system UIDs
   Gid                         Real, effective, saved set, and  file 
system GIDs
+ StartTimeMonotonic          Start time of process in nsec from 
CLOCK_MONOTONIC
+ StartTimeBootTime           Start time of process in nsec from 
CLOCK_BOOTTIME
   FDSize                      number of file descriptor slots currently 
allocated
   Groups                      supplementary group list
   VmPeak                      peak virtual memory size
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 1bd2077..34f4761 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -188,7 +188,9 @@ static inline void task_state(struct seq_file *m, 
struct pid_namespace *ns,
                 "PPid:\t%d\n"
                 "TracerPid:\t%d\n"
                 "Uid:\t%d\t%d\t%d\t%d\n"
-               "Gid:\t%d\t%d\t%d\t%d\n",
+               "Gid:\t%d\t%d\t%d\t%d\n"
+               "StartTimeMonotonic:\t%lld\n"
+               "StartTimeBootTime:\t%lld\n",
                 get_task_state(p),
                 task_tgid_nr_ns(p, ns),
                 task_numa_group_id(p),
@@ -201,7 +203,9 @@ static inline void task_state(struct seq_file *m, 
struct pid_namespace *ns,
                 from_kgid_munged(user_ns, cred->gid),
                 from_kgid_munged(user_ns, cred->egid),
                 from_kgid_munged(user_ns, cred->sgid),
-               from_kgid_munged(user_ns, cred->fsgid));
+               from_kgid_munged(user_ns, cred->fsgid),
+               timespec_to_ns(&p->start_time),
+               timespec_to_ns(&p->real_start_time));

         task_lock(p);
         if (p->files)
-- 
1.7.10.4
