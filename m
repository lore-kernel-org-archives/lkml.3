Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbaLWXKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 18:10:07 -0500
Received: from ozlabs.org ([103.22.144.67]:47419 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbaLWXKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 18:10:05 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Oded Gabbay <oded.gabbay@amd.com>, Andi Kleen <ak@linux.intel.com>,
        Alex Deucher <alexdeucher@gmail.com>
Cc: Dana Elifaz <Dana.Elifaz@amd.com>, LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        Alexander Deucher <Alexander.Deucher@amd.com>, LKP ML <lkp@01.org>
Subject: Re: [LKP] [PATCH] drm/radeon: Try to init amdkfd only if 64 bit kernel
In-Reply-To: <54986EA2.106@amd.com>
References: <1419246673-7222-1-git-send-email-oded.gabbay@amd.com> <CADnq5_MY3+4BdWzUYffTnRWF3J4Z7nb6zyrGZK4RNwVU3axvuw@mail.gmail.com> <20141222184940.GB17192@tassilo.jf.intel.com> <20141222190041.GC17192@tassilo.jf.intel.com> <54986EA2.106@amd.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 24 Dec 2014 09:31:13 +1030
Message-ID: <874msmt1hi.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oded Gabbay <oded.gabbay@amd.com> writes:
> I didn't say it doesn't always work.
> The actual thing that doesn't work is the define symbol_get and only in a
> specific case of 32bit kernel AND CONFIG_MODULES is unset AND
> CONFIG_RANDOMIZE_BASE is set.
> The define in that case is:
> #define symbol_get(x) ({ extern typeof(x) x __attribute__((weak)); &(x); })
>
> Why it doesn't work (doesn't return NULL when symbol doesn't exists) ?

Hmm, I'd guess CONFIG_RANDOMIZE_BASE is relocating NULL symbols...

No, I can't reproduce this.  Please send your .config privately.

Here's my test case:

diff --git a/init/main.c b/init/main.c
index 61b993767db5..a3ee1ec97ec3 100644
--- a/init/main.c
+++ b/init/main.c
@@ -683,6 +683,12 @@ asmlinkage __visible void __init start_kernel(void)
 
 	ftrace_init();
 
+	{
+		extern void nonexistent_fn(void);
+		printk("symbol_get(nonexistent_fn) = %p\n",
+		       symbol_get(nonexistent_fn));
+	}
+
 	/* Do the rest non-__init'ed, we're now alive */
 	rest_init();
 }

Thanks,
Rusty.
