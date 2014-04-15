Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaDOUE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 16:04:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33971 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaDOUE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 16:04:56 -0400
Date: Tue, 15 Apr 2014 13:04:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Josh Boyer <jwboyer@fedoraproject.org>, Rob Landley <rob@landley.net>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Add initcall_blacklist kernel parameter [v5]
Message-Id: <20140415130454.94306f499f9064a1382b7b5c@linux-foundation.org>
In-Reply-To: <1397574958-7446-1-git-send-email-prarit@redhat.com>
References: <20140414142914.57110976dd96134875b63639@linux-foundation.org>
	<1397574958-7446-1-git-send-email-prarit@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014 11:15:58 -0400 Prarit Bhargava <prarit@redhat.com> wrote:

> When a module is built into the kernel the module_init() function becomes
> an initcall.  Sometimes debugging through dynamic debug can help,
> however, debugging built in kernel modules is typically done by changing
> the .config, recompiling, and booting the new kernel in an effort to
> determine exactly which module caused a problem.
> 
> This patchset can be useful stand-alone or combined with initcall_debug.
> There are cases where some initcalls can hang the machine before the
> console can be flushed, which can make initcall_debug output
> inaccurate.  Having the ability to skip initcalls can help further
> debugging of these scenarios.
> 
> Usage: initcall_blacklist=<list of comma separated initcalls>
> 
> ex) added "initcall_blacklist=sgi_uv_sysfs_init" as a kernel parameter and
> the log contains:
> 
> 	blacklisted initcall sgi_uv_sysfs_init

I think "blacklisting initcall sgi_uv_sysfs_init" makes more sense here.

> 	...
> 	...
> 	function sgi_uv_sysfs_init returning without executing

And this should be "blacklisted sgi_uv_sysfs_init initcall" or
"initcall sgi_uv_sysfs_init blacklisted" (isn't English weird).

I did the below and fixed up the changelog to suit:

--- a/init/main.c~init-mainc-add-initcall_blacklist-kernel-parameter-fix
+++ a/init/main.c
@@ -684,7 +684,7 @@ static int __init initcall_blacklist(cha
 	do {
 		str_entry = strsep(&str, ",");
 		if (str_entry) {
-			pr_debug("initcall blacklisted %s\n", str_entry);
+			pr_debug("blacklisting initcall %s\n", str_entry);
 			entry = alloc_bootmem(sizeof(*entry));
 			entry->buf = alloc_bootmem(strlen(str_entry) + 1);
 			strcpy(entry->buf, str_entry);
_

