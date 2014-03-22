Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaCVX5E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 19:57:04 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63142 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaCVX5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 19:57:02 -0400
X-Nat-Received: from [202.181.97.72]:51675 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1395532620.3447
To: tglx@linutronix.de, oleg@redhat.com
Cc: joseph.salisbury@canonical.com, JBottomley@parallels.com,
        Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com,
        rientjes@google.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tj@kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com,
        linux-scsi@vger.kernel.org, thenzl@redhat.com
Subject: Re: please fix FUSION (Was:[v3.13][v3.14][Regression]kthread:makekthread_create()killable)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20140321183443.GA3891@redhat.com>
	<201403221525.FJC69759.MSLOtHOJOVFFQF@I-love.SAKURA.ne.jp>
	<20140322192511.GA14811@redhat.com>
	<alpine.DEB.2.02.1403222201300.18573@ionos.tec.linutronix.de>
	<alpine.DEB.2.02.1403222242450.18573@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1403222242450.18573@ionos.tec.linutronix.de>
Message-Id: <201403230857.IGH51500.FOHtQMFVOFOLJS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 23 Mar 2014 08:57:00 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 22032014 #7600319, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> But then systemd/udev mutters:
> 
>    "You migh be able to work around the timeout with udev rules and
>     OPTIONS+="event_timeout=120", but that code was maybe never used
>     or tested, so it might not work correctly." [1]
> 
> AFAICT from the ubuntu bug system [2] nobody bothered even to try that.
> 
> And if the udev/systemd event_timeout option is broken it's way better
> to fix that one instead of hacking random heuristics into the kernel.

I haven't tried the event_timeout= option but I think it will not work.
The timeout is hard coded as shown below and there will be no chance for taking
the event_timeout= option into account.

---------- systemd-204/src/udev/udevd.c start ----------
(...snipped...)
                        /* check for hanging events */
                        udev_list_node_foreach(loop, &worker_list) {
                                struct worker *worker = node_to_worker(loop);

                                if (worker->state != WORKER_RUNNING)
                                        continue;

                                if ((now(CLOCK_MONOTONIC) - worker->event_start_usec) > 30 * 1000 * 1000) {
                                        log_error("worker [%u] %s timeout; kill it\n", worker->pid,
                                            worker->event ? worker->event->devpath : "<idle>");
                                        kill(worker->pid, SIGKILL);
                                        worker->state = WORKER_KILLED;
                                        /* drop reference taken for state 'running' */
                                        worker_unref(worker);
                                        if (worker->event) {
                                                log_error("seq %llu '%s' killed\n",
                                                          udev_device_get_seqnum(worker->event->dev), worker->event->devpath);
                                                worker->event->exitcode = -64;
                                                event_queue_delete(worker->event, true);
                                                worker->event = NULL;
                                        }
                                }
                        }
(...snipped...)
---------- systemd-204/src/udev/udevd.c end ----------
