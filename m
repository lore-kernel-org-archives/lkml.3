Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab3KGWoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 17:44:10 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:36939 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab3KGWny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 17:43:54 -0500
MIME-Version: 1.0
In-Reply-To: <1383860919-1883-4-git-send-email-jack@suse.cz>
References: <1383860919-1883-1-git-send-email-jack@suse.cz>
	<1383860919-1883-4-git-send-email-jack@suse.cz>
Date: Thu, 7 Nov 2013 23:43:52 +0100
Message-ID: <CAFTL4hw6wO+3Y8EpW3_swodfyV9UAaLF-KE6KC+u-5sKjKY7eA@mail.gmail.com>
Subject: Re: [PATCH 3/4] printk: Defer printing to irq work when we printed
 too much
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/7 Jan Kara <jack@suse.cz>:
> A CPU can be caught in console_unlock() for a long time (tens of seconds
> are reported by our customers) when other CPUs are using printk heavily
> and serial console makes printing slow. Despite serial console drivers
> are calling touch_nmi_watchdog() this triggers softlockup warnings
> because interrupts are disabled for the whole time console_unlock() runs
> (e.g. vprintk() calls console_unlock() with interrupts disabled). Thus
> IPIs cannot be processed and other CPUs get stuck spinning in calls like
> smp_call_function_many(). Also RCU eventually starts reporting lockups.
>
> In my artifical testing I can also easily trigger a situation when disk
> disappears from the system apparently because interrupt from it wasn't
> served for too long. This is why just silencing watchdogs isn't a
> reliable solution to the problem and we simply have to avoid spending
> too long in console_unlock() with interrupts disabled.
>
> The solution this patch works toward is to postpone printing to a later
> moment / different CPU when we already printed over X characters in
> current console_unlock() invocation. This is a crude heuristic but
> measuring time we spent printing doesn't seem to be really viable - we
> cannot rely on high resolution time being available and with interrupts
> disabled jiffies are not updated. User can tune the value X via
> printk.offload_chars kernel parameter.
>
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Jan Kara <jack@suse.cz>

When a message takes tens of seconds to be printed, it usually means
we are in trouble somehow :)
I wonder what printk source can trigger such a high volume.

May be cutting some huge message into smaller chunks could help? That
would re enable interrupts between each call.

It's hard to tell without the context, but using other CPUs for
rescuing doesn't look like a good solution. What if the issue happens
in UP to begin with?
