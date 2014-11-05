Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbaKEOyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:54:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328AbaKEOyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:54:13 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: robert.schoene@tu-dresden.de, sboyd@codeaurora.org,
        Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 0/5] cpufreq, fix locking and data issues
Date: Wed,  5 Nov 2014 09:53:54 -0500
Message-Id: <1415199239-19019-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several issues that are fixed with this patchset.  Patch 1/5
fixes an issue where reads of sysfs data return incorrect data values during
writes of the scaling_governor.  Patch 2/5 resolves a known issue with
the locking around governor _EXIT calls by restoring the locking based on
the patch 1/5.  Patches 3/5 and 4/5 fix concurrent accesses to
dbs_data->usage_count and policy->initialized by switching them to atomic_t
and protecting them with a lock, and the last patch, 5/5 adds some additional
BUG() debugging information.

Testing:

I tested this with

i=0
while [ True ]; do
        i=$((i+1))
        echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor &
        echo "performance" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor &
        echo "ondemand" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor & 
        echo "performance" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor &
        if [ $((i % 100)) = 0 ]; then
                echo $i
        fi
done

exit 0

which now succeeds with this patchset.  It previously would fail, typically
within 100 events.  With this patchset I have run 24 hours without seeing
any issues.

I also testing this by modifying the acpi_cpufreq driver with CPUFREQ_HAVE_GOVERNOR_PER_POLICY, and confirmed the previously reported locking situation would
not deadlock by doing

# write then read
echo ondemand > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor
echo 10500 > /sys/devices/system/cpu/cpu$i/cpufreq/ondemand/sampling_min_rate
echo conservative > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor
cat /sys/devices/system/cpu/cpu$i/cpufreq/conservative/*

# read then write
echo ondemand > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor
cat /sys/devices/system/cpu/cpu$i/cpufreq/ondemand/*
echo conservative > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor

which previously would spit out a LOCKDEP warning on a LOCKDEP enabled kernel,
and confirmed (via additional printks) that the governor did not deadlock.

Unfortunately, even with these fixes in place (which does shore up the
locking quite a bit), I still hit an panic with this test from Robert Schone:

crash_governor.sh:
sysctl -w kernel.printk=8
for I in `seq 1000`
do
    echo ondemand | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
    echo userspace | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
done

runme.sh:
    for I in `seq 8`
    do
            ./crash_governor.sh &
    done

At this point I believe I'm "peeling the onion" in terms of the bugs I'm
exposing.  I'm chasing what appears to be a "new" bug with Robert's test.
Additionally, with my changes in place it takes much longer to hit panics
in the code so I'm going to move forward and push these five patches.

Prarit Bhargava (5):
  cpufreq, do not return stale data to userspace
  cpufreq, fix locking around CPUFREQ_GOV_POLICY_EXIT calls
  cpufreq, dbs_data->usage count must be atomic
  cpufreq, policy->initialized count must be atomic
  cpufreq, add BUG() messages in critical paths to aid debugging
    failures

 drivers/cpufreq/cpufreq.c          |   19 +++++++------
 drivers/cpufreq/cpufreq_governor.c |   52 ++++++++++++++++++++++++++++--------
 drivers/cpufreq/cpufreq_governor.h |    3 ++-
 include/linux/cpufreq.h            |    7 ++---
 4 files changed, 56 insertions(+), 25 deletions(-)

-- 
1.7.9.3

