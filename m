Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089Ab3D2VqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:46:07 -0400
Received: from mail-vc0-f202.google.com ([209.85.220.202]:52784 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759458Ab3D2Vpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:45:55 -0400
From: Colin Cross <ccross@android.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, Colin Cross <ccross@android.com>
Subject: [PATCH 00/10] optimize freezing tasks by reducing task wakeups
Date: Mon, 29 Apr 2013 14:45:36 -0700
Message-Id: <1367271946-7239-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On slow cpus the large number of task wakeups and context switches
triggered by freezing and thawing tasks can take a significant amount
of cpu time.  This patch series reduces the amount of work done during
freezing tasks by avoiding waking up tasks that are already in a freezable
state.

The first patch reduces the wasted time in try_to_freeze_tasks() by
starting with a 1 ms sleep during the first loop and backing off
up to an 8 ms sleep if all tasks are not frozen.

The second patch modifies the try_to_freeze_tasks() loop to skip tasks
that have set the PF_FREEZER_SKIP flag by calling freezer_do_not_count().
These tasks will not enter the refrigerator during the suspend/resume
cycle unless they woken up by something else, in which case they will
enter the refrigerator in freezer_count() before they access any
resources that would not be available in suspend or deadlock with
another freezing/frozen task.

The rest of the series adds a few more freezable helpers and converts the
top call sites that userspace tasks are usually blocked at to freezable
helpers.  The list of call sites was collected on a Nexus 10 (ARM Exynos
5250 SoC), but all the top call sites other than binder show up at the
top of the list on Ubuntu x86-64 as well.

This series cuts the time for freezing tasks from 50 ms to 5 ms when
the cpu speed is locked at its lowest setting (200MHz), and reduces
the number of context switches and restarted syscalls from 1000 to
25.
