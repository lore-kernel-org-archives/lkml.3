Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab3IWVa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 17:30:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3IWVa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 17:30:58 -0400
Date: Mon, 23 Sep 2013 14:30:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: oleg@redhat.com, viro@zeniv.linux.org.uk, rostedt@goodmis.org,
        fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmod: Check for NULL at call_usermodehelper_exec().
Message-Id: <20130923143057.a6a7ac7d524f890bfef92b72@linux-foundation.org>
In-Reply-To: <201309240612.ADE82877.MSFHVtOOFLFOQJ@I-love.SAKURA.ne.jp>
References: <201309152323.GDG73435.VLOQFHOJtOFFSM@I-love.SAKURA.ne.jp>
	<20130915163157.GB13344@redhat.com>
	<201309160202.FBC60981.FQOHSLFMFtOJVO@I-love.SAKURA.ne.jp>
	<20130915171549.GA15346@redhat.com>
	<201309160226.DGH90134.QLSFtOJOOMFHVF@I-love.SAKURA.ne.jp>
	<201309240612.ADE82877.MSFHVtOOFLFOQJ@I-love.SAKURA.ne.jp>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Sep 2013 06:12:34 +0900 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:

> Andrew, would you pick up this patch?
> 
> Regards.
> ----------
> >From d6ff218545060c5f8b75b15d5b34bffcf625508f Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Mon, 16 Sep 2013 02:19:10 +0900
> Subject: [PATCH] kmod: Check for NULL at call_usermodehelper_exec().
> 
> If /proc/sys/kernel/core_pattern contains only "|", NULL pointer dereference
> happens upon core dump because argv_split("") returns argv[0] == NULL.
> 
> This bug was once fixed by commit 264b83c0 "usermodehelper: check
> subprocess_info->path != NULL" but was by error reintroduced by commit
> 7f57cfa4 "usermodehelper: kill the sub_info->path[0] check".
> 
> This bug seems to exist since 2.6.19 (the version which core dump to pipe was
> added). Depending on kernel version and config, some side effect might happen
> immediately after this oops (e.g. kernel panic with 2.6.32-358.18.1.el6).
> 
> ...
>
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -571,6 +571,10 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
>  	DECLARE_COMPLETION_ONSTACK(done);
>  	int retval = 0;
>  
> +	if (!sub_info->path) {
> +		call_usermodehelper_freeinfo(sub_info);
> +		return -ENOENT;
> +	}
>  	helper_lock();
>  	if (!khelper_wq || usermodehelper_disabled) {
>  		retval = -EBUSY;

The error is that the user put a bare "|" into
/proc/sys/kernel/core_pattern.  Is ENOENT ("No such file or directory")
the most appropriate error code here?  I think EINVAL ("Invalid
argument")?

