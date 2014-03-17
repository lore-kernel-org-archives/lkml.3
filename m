Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaCQVdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 17:33:04 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:50241 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbaCQVdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 17:33:02 -0400
X-Nat-Received: from [202.181.97.72]:63576 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1395091980.30022
To: akpm@linux-foundation.org, joseph.salisbury@canonical.com
Cc: oleg@redhat.com, rientjes@google.com, torvalds@linux-foundation.org,
        tj@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: Re: [v3.13][v3.14][Regression] kthread: make kthread_create()killable
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <53236AA2.7030105@canonical.com>
	<20140317130241.7e4fde86d75d417628da6f1a@linux-foundation.org>
In-Reply-To: <20140317130241.7e4fde86d75d417628da6f1a@linux-foundation.org>
Message-Id: <201403180632.CAG81246.JLQOFSFMVOOFHt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 18 Mar 2014 06:32:56 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 17032014 #7536806, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> What process is running here?  Presumably modprobe.

Yes. It is a worker systemd-udevd process who is acting like modprobe .

> A possible explanation is that modprobe has genuinely received a
> SIGKILL.  Can you identify anything in this setup which might send a
> SIGKILL to the modprobe process?

It is the systemd-udevd process who is sending SIGKILL to worker
systemd-udevd processes. It uses hard coded 30 seconds timeout.

> kthread_create_on_node() thinks that SIGKILL came from the oom-killer
> and it cheerfully returns -ENOMEM, which is incorrect if that signal
> came from userspace.  And I don't _think_ we prevent
> userspace-originated signals from unblocking
> wait_for_completion_killable()?

I prefer processes being killed upon SIGKILL as soon as possible.
I expect any unkillable operations should be replaced with killable
operations, or the OOM killer may fail to solve no memory state by
choosing a process in unkillable sleep.
