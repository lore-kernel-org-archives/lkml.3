Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbaILNfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:35:40 -0400
Received: from shelob.surriel.com ([74.92.59.67]:59600 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734AbaILNfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:35:39 -0400
From: riel@redhat.com
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, prarit@redhat.com,
        oleg@redhat.com, sgruszka@redhat.com
Subject: [PATCH -tip 0/2] fix lock inversion in lockless sys_times()
Date: Fri, 12 Sep 2014 09:12:13 -0400
Message-Id: <1410527535-9814-1-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sig->stats_lock nests inside the tasklist_lock and the
sighand->siglock in __exit_signal and wait_task_zombie.

However, both of those locks can be taken from irq context,
which means we need to use the interrupt safe variant of
read_seqbegin_or_lock. This blocks interrupts when the "lock"
branch is taken (seq is odd), preventing the lock inversion.

On the first (lockless) pass through the loop, irqs are not
blocked.

This fixes the lockdep complaints that Stanislaw reported.

