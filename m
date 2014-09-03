Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788AbaICQL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 12:11:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbaICQL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 12:11:26 -0400
Date: Wed, 3 Sep 2014 18:08:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>
Cc: Kautuk Consul <consul.kautuk@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        Ionut Alexa <ionut.m.alexa@gmail.com>,
        Guillaume Morin <guillaume@morinfr.org>, linux-kernel@vger.kernel.org,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: task_numa_fault() && TASK_DEAD
Message-ID: <20140903160819.GA7682@redhat.com>
References: <1408964064-21447-1-git-send-email-consul.kautuk@gmail.com> <20140825155738.GA5944@redhat.com> <20140901153935.GQ27892@worktop.ger.corp.intel.com> <20140901175851.GA15210@redhat.com> <20140901190931.GD5806@worktop.ger.corp.intel.com> <20140902155208.GA28668@redhat.com> <20140902164714.GA17033@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140902164714.GA17033@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02, Oleg Nesterov wrote:
>
> The usage of TASK_DEAD in task_numa_fault() is wrong in any case.

Rik, I can't understand why task_numa_fault() needs this check at all,
but "if (p->state == TASK_DEAD)" looks certainly wrong. You could replace
this check with BUG_ON(p->state == TASK_DEAD). Perhaps you meant PF_EXITING?

And a stupid (really, I don't understand this code) question:

	/* for example, ksmd faulting in a user's mm */
	if (!p->mm)
		return;

OK, but perhaps it make sense to pass "mm" as another argument and do

	/* ksmd faulting in a user's mm, or debugger, or kthread use_mm() caller */
	if (p->mm != mm)
		return;

?

Oleg.

