Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab3IORCl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 13:02:41 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:58321 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177Ab3IORCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 13:02:40 -0400
X-Nat-Received: from [202.181.97.72]:54088 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1379264548.10333
To: oleg@redhat.com
Cc: viro@zeniv.linux.org.uk, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmod: Check for NULL at call_usermodehelper_exec().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201309141632.GHD86439.VLOOOFQFJtSMFH@I-love.SAKURA.ne.jp>
	<20130914154144.GA7884@redhat.com>
	<201309150910.CCE73459.VMOFtJFLSHOQFO@I-love.SAKURA.ne.jp>
	<201309152323.GDG73435.VLOQFHOJtOFFSM@I-love.SAKURA.ne.jp>
	<20130915163157.GB13344@redhat.com>
In-Reply-To: <20130915163157.GB13344@redhat.com>
Message-Id: <201309160202.FBC60981.FQOHSLFMFtOJVO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 16 Sep 2013 02:02:27 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 15092013 #11084683, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> It looks a bit ugly to check ->path under helper_lock(), just add
> 
> 	if (!sub_info->path)
> 		retval = -ENOENT;
> 
> at the start. Otherwise the code looks as if there is a subtle
> reason to take the lock before this check.

Did you mean this?

 	DECLARE_COMPLETION_ONSTACK(done);
 	int retval = 0;
 
+	if (!sub_info->path) {
+		call_usermodehelper_freeinfo(sub_info);
+		return -ENOENT;
+	}
 	helper_lock();
 	if (!khelper_wq || usermodehelper_disabled) {
 		retval = -EBUSY;
 		goto out;
 	}
