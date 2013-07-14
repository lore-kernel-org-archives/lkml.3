Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383Ab3GNFzy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 01:55:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64425 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3GNFzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 01:55:53 -0400
Message-ID: <1373781316.7242.34.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: Add logic to handle parallel try_to_wake_up() of
 the same task
From: Mike Galbraith <bitbucket@online.de>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Date: Sun, 14 Jul 2013 07:55:16 +0200
In-Reply-To: <1517081373730349@web23d.yandex.ru>
References: <1517081373730349@web23d.yandex.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:iApsxWkXvQFVSrgHtC7knpbFuBixsgdcaay6Sni6pao
 eor8zjB/zWM9SKMKBf2toYfyYggq6n8fD3HxGzkZodXxoEVgR7
 9yXaiUS1KnwtZsLcd1YR89386XQejU3vYtSVkn1e0xJfvPGCya
 RVM8B8OLEM/4p4f+k07omXmLcK3wUqK06msX8cXG3ePNJhjh1i
 WZGq21jXul6lQV5GOq3Tv0B4N/HbgdZuVid61/zH75oQgjAPGV
 zuixEZEUOPUkYBGsELMt4qTqcXx7F4c24SNMO5Mc36u7Or9j1W
 +jPxk0QoOZmSj195TKgJgxwrG/O77avKaNRunWfg4sakyH9Z75
 rY7OAjCqaScNKKJq5ScF/TYCVqBESlmvxq0/D31F8BAiS5hHkH
 +po9hbBtb0ETA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-07-13 at 19:45 +0400, Kirill Tkhai wrote: 
> This patch adds optimization of try_to_wake_up() function
> for cases when the system is doing parallel wake_up
> of the same task on the different cpus. Also it adds
> accounting the statistics of these situations.
> 
> We check the status of the task we want to wake up.
> If it is TASK_WAKING then the task is manipulated
> by try_to_wake_up() on another cpu. And after this
> check it will be a moment when the task is queued
> and his status is TASK_RUNNING. We just return
> earlier when we are sure the task will be TASK_RUNNING
> in the future (maybe right after the check). The profit is
> we don't loop while we are waiting the spinlock.

Hm, you're adding cycles to the common case to shave spin cycles in the
very rare case, then spending some to note that a collision happened.
What makes recording worth even 1 cycle?  What am I gonna do with the
knowledge that $dinkynum wakeups intersected at a some random task?

-Mike


