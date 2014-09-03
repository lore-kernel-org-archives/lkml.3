Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbaICJLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:11:19 -0400
Received: from forward18.mail.yandex.net ([95.108.253.143]:44270 "EHLO
	forward18.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbaICJLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:11:17 -0400
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Sep 2014 05:11:17 EDT
From: Kirill Tkhai <tkhai@yandex.ru>
To: Oleg Nesterov <oleg@redhat.com>, Kautuk Consul <consul.kautuk@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        David Rientjes <rientjes@google.com>,
        Ionut Alexa <ionut.m.alexa@gmail.com>,
        Guillaume Morin <guillaume@morinfr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20140825155738.GA5944@redhat.com>
References: <1408964064-21447-1-git-send-email-consul.kautuk@gmail.com> <20140825155738.GA5944@redhat.com>
Subject: Re: [PATCH 1/1] do_exit(): Solve possibility of BUG() due to race with try_to_wake_up()
MIME-Version: 1.0
Message-Id: <3702911409735076@web26g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 03 Sep 2014 13:04:36 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

25.08.2014, 20:01, "Oleg Nesterov" <oleg@redhat.com>:
> Peter, do you remember another problem with TASK_DEAD we discussed recently?
> (prev_state == TASK_DEAD detection in finish_task_switch() still looks racy).

One more problem with task_dead just to mention it here.

Below is racy with the change of sched_class:

        if (prev->sched_class->task_dead)
                prev->sched_class->task_dead(prev);

switched_from_dl() does not cancel running timers.

So, if dl_task_timer() is slow (it is unhappy with rq->lock acquiring),
the timer is executing when tasks is already dead.

Kirill
