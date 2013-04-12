Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab3DLNi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 09:38:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57431 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808Ab3DLNiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 09:38:52 -0400
Date: Fri, 12 Apr 2013 15:38:46 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>, John Kacur <jkacur@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH RT v2] x86/mce: Defer mce wakeups to threads for
 PREEMPT_RT
Message-ID: <20130412133846.GD2368@pd.tnic>
References: <1365705214.9609.58.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1365705214.9609.58.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 02:33:34PM -0400, Steven Rostedt wrote:
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index e8d8ad0..060e473 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -18,6 +18,7 @@
>  #include <linux/rcupdate.h>
>  #include <linux/kobject.h>
>  #include <linux/uaccess.h>
> +#include <linux/kthread.h>
>  #include <linux/kdebug.h>
>  #include <linux/kernel.h>
>  #include <linux/percpu.h>
> @@ -1308,6 +1309,61 @@ static void mce_do_trigger(struct work_struct *work)
>  
>  static DECLARE_WORK(mce_trigger_work, mce_do_trigger);
>  
> +static void __mce_notify_work(void)
> +{
> +	/* Not more than two messages every minute */
> +	static DEFINE_RATELIMIT_STATE(ratelimit, 60*HZ, 2);
> +
> +	/* wake processes polling /dev/mcelog */
> +	wake_up_interruptible(&mce_chrdev_wait);
> +
> +	/*
> +	 * There is no risk of missing notifications because
> +	 * work_pending is always cleared before the function is
> +	 * executed.
> +	 */

You must be using some tree != mainline because this comment is gone
upstream and that whole second hunk below which moves it here doesn't
apply.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
