Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab3JQMUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 08:20:18 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:35744 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287Ab3JQMUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 08:20:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAE=NcrZ=9Tyc24PgiB+Hkk7DNwH3AMB_EqwWPEuzmcLMjTK7ig@mail.gmail.com>
References: <CAE=NcrYhrs7U9MzQSEt_oi_qU56sWydTdnv1FX0ijbYgAZCfOg@mail.gmail.com>
	<CAE=NcrZ=9Tyc24PgiB+Hkk7DNwH3AMB_EqwWPEuzmcLMjTK7ig@mail.gmail.com>
Date: Thu, 17 Oct 2013 15:20:15 +0300
Message-ID: <CAE=NcrYi2c8XaswXJOGENm7QLgps+OvYMVgz5-OTWud3f3a+Mg@mail.gmail.com>
Subject: Re: 3.12.0-rc5+ reproducible crash at kernel/timer.c:1117
From: Janne Karhunen <janne.karhunen@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 10:41 AM, Janne Karhunen
<janne.karhunen@gmail.com> wrote:

>> call_timer_fn 0x73/0x160 <--- EIP hits 0
>
> Use after free.. with CONFIG_DEBUG_PAGEALLOC &&
> CONFIG_DEBUG_OBJECTS_TIMERS we get :
>
> call_timer_fn 0x73/0x160
> destroy_timer_on_stack 0x20/0x20
> ftrace_raw_event_hrtimer_expire_entry 0x3b/0xc0
> run_timer_softirq 0x1f2/0x230

Sadly no time to hunt the free at the moment, so working around temporarily by

diff --git a/kernel/timer.c b/kernel/timer.c
index 4296d13..fc7ef44 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1094,6 +1094,9 @@ static void call_timer_fn(struct timer_list
*timer, void (*fn)(unsigned long),
 {
        int preempt_count = preempt_count();

+       if (fn == NULL)
+               return;
+

Hoping someone wiser catches the real fix at some point.


-- 
Janne
