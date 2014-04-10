Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145AbaDJULd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 16:11:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581AbaDJULb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 16:11:31 -0400
From: Don Zickus <dzickus@redhat.com>
To: acme@kernel.org, namhyung@kernel.org, jolsa@redhat.com
Cc: eranian@google.com, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: [RFC 0/5] perf: Create hist_entry groups
Date: Thu, 10 Apr 2014 16:10:56 -0400
Message-Id: <1397160661-33395-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset creates a new layer of hist entry objects called
hist_entry_groups.  The purpose is to help organize the hist_entries
into groups before sorting them.  As a result you can gain a
new perspective on the data by organizing the groups into cpu, pid
or cacheline.  See patch 5 for sample output.

The main driver for this patchset is to find a way to sort and display
cacheline data in a way that is useful.  My previous attempts seemed
hackish until I realized cacheline sorting is really just a collection
of hist_entries.  Anyway that was my focus for doing this.

The overall idea looks like:

evlist
  evsel
    hists
        hist_entry_group  <<< new object
          hist_entry


Implementing this was not pretty.  I tried to seperate the patches the
best I could.  But in order for each patch to compile, patch 4 turned into
a 1400 line diff that is mostly noise.

Also, this patchset breaks most tools (mainly because I don't understand
all the interactions), hence the RFC.  I mostly tested with 'perf report
 --stdio' and 'perf mem report --stdio'.

Please let me know if this is an interesting idea to go forward with or not.

Don Zickus (5):
  perf: Wrap __hists__add_entry to prep for group entry change
  perf: Use macros to walk hist entries
  perf: Add in stub hist_entry_group code
  perf:  Switch to using hist_entry_group
  perf: Enable multiple hist_entry_group output

 tools/perf/builtin-annotate.c  |  13 +-
 tools/perf/builtin-diff.c      | 127 +++++-----
 tools/perf/builtin-report.c    |  14 +-
 tools/perf/builtin-top.c       |  22 +-
 tools/perf/tests/hists_link.c  | 124 ++++------
 tools/perf/ui/browsers/hists.c |  40 +++-
 tools/perf/ui/gtk/hists.c      |  80 ++++---
 tools/perf/ui/hist.c           |  29 ++-
 tools/perf/ui/stdio/hist.c     |  97 ++++++--
 tools/perf/util/evsel.c        |   7 +-
 tools/perf/util/hist.c         | 512 +++++++++++++++++++++++++++++------------
 tools/perf/util/hist.h         |  29 ++-
 tools/perf/util/sort.c         | 183 ++++++++++++++-
 tools/perf/util/sort.h         | 138 ++++++++++-
 14 files changed, 1017 insertions(+), 398 deletions(-)

-- 
1.7.11.7

