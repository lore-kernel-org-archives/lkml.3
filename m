Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759765Ab3GSRD5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 13:03:57 -0400
Received: from mail.sysmocom.de ([144.76.43.93]:12011 "EHLO mail.sysmocom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562Ab3GSRD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 13:03:56 -0400
Date: Fri, 19 Jul 2013 19:03:54 +0200
From: Holger Hans Peter Freyther <holger@freyther.de>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: /proc/timer_list and weird behavior with dropbear
Message-ID: <20130719170354.GE5902@xiaoyu.lan>
References: <20130719152800.GA20792@xiaoyu.lan>
 <51E95F0B.6080703@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E95F0B.6080703@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 10:45:15AM -0500, Nathan Zimmer wrote:

> I hadn't noticed anything.
> Let me try your program and see what I may have missed.

Hi,

I neither know the semantics of the timer_list nor how to use
seq_file correctly. What happens is that timer_list_next will only
be called once. This means that iter->cpu will never be increased.

This just moves to the next CPU when stop is called (e.g. nothing
was added once the print_tickdevice was printed). Do you think
this could be correct?



diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 3bdf283..8d36a3d 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -327,8 +327,10 @@ static void *timer_list_next(struct seq_file *file, void *v, loff_t *offset)
 	return timer_list_start(file, offset);
 }
 
-static void timer_list_stop(struct seq_file *seq, void *v)
+static void timer_list_stop(struct seq_file *file, void *v)
 {
+	struct timer_list_iter *iter = file->private;
+	iter->cpu = cpumask_next(iter->cpu, cpu_online_mask);
 }
 
 static const struct seq_operations timer_list_sops = {
