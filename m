Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640AbaDWU4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 16:56:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59351 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422655AbaDWU4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 16:56:08 -0400
Date: Wed, 23 Apr 2014 13:56:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, pmladek@suse.cz,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/8] printk: Release lockbuf_lock before calling
 console_trylock_for_printk()
Message-Id: <20140423135606.d727fe5eb38bd8805ad3a5c3@linux-foundation.org>
In-Reply-To: <1395770101-24534-3-git-send-email-jack@suse.cz>
References: <1395770101-24534-1-git-send-email-jack@suse.cz>
	<1395770101-24534-3-git-send-email-jack@suse.cz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2014 18:54:55 +0100 Jan Kara <jack@suse.cz> wrote:

> There's no reason to hold lockbuf_lock when entering
> console_trylock_for_printk(). The first thing this function does is
> calling down_trylock(console_sem) and if that fails it immediately
> unlocks lockbuf_lock. So lockbuf_lock isn't needed for that branch.
> When down_trylock() succeeds, the rest of console_trylock() is OK
> without lockbuf_lock (it is called without it from other places), and
> the only remaining thing in console_trylock_for_printk() is
> can_use_console() call. For that call console_sem is enough (it
> iterates all consoles and checks CON_ANYTIME flag).
> 
> So we drop logbuf_lock before entering console_trylock_for_printk()
> which simplifies the code.
> 

I suppose we should document have_callable_console()'s locking
requirements, and I don't think that "early in boot" part is true?

--- a/kernel/printk/printk.c~printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix
+++ a/kernel/printk/printk.c
@@ -1377,7 +1377,9 @@ static void zap_locks(void)
 	sema_init(&console_sem, 1);
 }
 
-/* Check if we have any console registered that can be called early in boot. */
+/*
+ * Check if we have any console registered.  Requires console_sem.
+ */
 static int have_callable_console(void)
 {
 	struct console *con;
_

