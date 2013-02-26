Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772Ab3BZO3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 09:29:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297Ab3BZO3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 09:29:39 -0500
Date: Tue, 26 Feb 2013 15:28:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lianwei Wang <lianwei.wang@gmail.com>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: PATCH: freezer: add fake signal clearing back when thaw task
Message-ID: <20130226142804.GC28940@redhat.com>
References: <CAJFUiJhxqWeQ9PiinpRYCUF8U_3dpaAdvsEKHW2i-QqZ=vkYsQ@mail.gmail.com> <20130225235313.GE2679@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130225235313.GE2679@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah, I just noticed that the changelog mentions wait_event_freezable() too,

On 02/25, Tejun Heo wrote:
>
> > Subject: [PATCH] freezer: add fake signal clearing back when thaw task
> >
> > The fake TIF_SIGPENDING is set during freeze userspace process, but it
> > is not cleared when thaw tasks after below commit:
> >   34b087e freezer: kill unused set_freezable_with_signal()
> >
> > This will cause the userspace task that wait_event_freezable

But there is no userspace users?

I guess wait_event_freezable() is only used to avoid the contribution
to load_avg. So we can simplify it, __wait_event_freezable() can simply
do freezable_schedule() or wait_event_freezable() can do
freezer_do_not_count + wait_event_interruptible. Or we are going to add
more users?

As for current users, I think they do not need this interface. Something
like below. I was going to try to convert khugepaged/ksm_scan_thread
yesterday but I was distracted, will try to do tomorrow.

Oleg.

--- x/mm/huge_memory.c
+++ x/mm/huge_memory.c
@@ -2616,7 +2616,7 @@ static int khugepaged_has_work(void)
 static int khugepaged_wait_event(void)
 {
 	return !list_empty(&khugepaged_scan.mm_head) ||
-		kthread_should_stop();
+		kthread_should_stop_or_freeze();
 }
 
 static void khugepaged_do_scan(void)
@@ -2655,20 +2655,18 @@ static void khugepaged_do_scan(void)
 
 static void khugepaged_wait_work(void)
 {
-	try_to_freeze();
-
 	if (khugepaged_has_work()) {
 		if (!khugepaged_scan_sleep_millisecs)
 			return;
 
-		wait_event_freezable_timeout(khugepaged_wait,
-					     kthread_should_stop(),
+		wait_event_interruptible_timeout(khugepaged_wait,
+					     kthread_should_stop_or_freeze(),
 			msecs_to_jiffies(khugepaged_scan_sleep_millisecs));
 		return;
 	}
 
 	if (khugepaged_enabled())
-		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
+		wait_event_interruptible(khugepaged_wait, khugepaged_wait_event());
 }
 
 static int khugepaged(void *none)
@@ -2678,7 +2676,7 @@ static int khugepaged(void *none)
 	set_freezable();
 	set_user_nice(current, 19);
 
-	while (!kthread_should_stop()) {
+	while (!kthread_freezable_should_stop(NULL)) {
 		khugepaged_do_scan();
 		khugepaged_wait_work();
 	}

