Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964991Ab3BNM6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 07:58:00 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:38398 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934270Ab3BNM5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 07:57:55 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v2 0/3] perf stat: add per-core count aggregation
Date: Thu, 14 Feb 2013 13:57:26 +0100
Message-Id: <1360846649-6411-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains improvement to the aggregation support
in perf stat.

First, the aggregation code is refactored and a aggr_mode enum
is defined. There is also an important bug fix for the existing
per-socket aggregation.

Second, the option --aggr-socket is renamed --per-socket.

Third, the patch adds a new --per-core option to perf stat.
It aggregates counts per physical core and becomes useful on
systems with hyper-threading. The cores are presented per
socket: S0-C1, means socket 0 core 1. Note that the core number
represents its physical core id. As such, numbers may not always
be contiguous. All of this is based on topology information available
in sysfs.

Per-core aggregation can be combined with interval printing:

 # perf stat -a --per-core -I 1000 -e cycles sleep 100
 #           time core         cpus             counts events
      1.000101160 S0-C0           2      6,051,254,899 cycles                   
      1.000101160 S0-C1           2      6,379,230,776 cycles                   
      1.000101160 S0-C2           2      6,480,268,471 cycles                   
      1.000101160 S0-C3           2      6,110,514,321 cycles                   
      2.000663750 S0-C0           2      6,572,533,016 cycles                   
      2.000663750 S0-C1           2      6,378,623,674 cycles                   
      2.000663750 S0-C2           2      6,264,127,589 cycles                   
      2.000663750 S0-C3           2      6,305,346,613 cycles                   

For instance here on this SNB machine, we can see that the load
is evenly balanced across all 4 physical core (HT is on).

In v2, we print events across all cores or socket and we renamed
--aggr-socket to --per-socket and renamed --aggr-core to --per-core

Signed-off-by: Stephane Eranian <eranian@google.com>

Stephane Eranian (3):
  perf stat: refactor aggregation code
  perf stat: rename --aggr-socket to --per-socket
  perf stat: add per-core aggregation

 tools/perf/Documentation/perf-stat.txt |   10 +-
 tools/perf/builtin-stat.c              |  237 ++++++++++++++++++++------------
 tools/perf/util/cpumap.c               |   86 ++++++++++--
 tools/perf/util/cpumap.h               |   12 ++
 4 files changed, 241 insertions(+), 104 deletions(-)

-- 
1.7.9.5

