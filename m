Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab3GDKXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 06:23:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:40323 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab3GDKXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 06:23:41 -0400
Date: Thu, 4 Jul 2013 12:23:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alex Shi <alex.shi@intel.com>
cc: hpa@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, andi.kleen@intel.com,
        a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: Re: [PATCH 2/3] clockesource: set override clocksource
In-Reply-To: <1372916056-24301-3-git-send-email-alex.shi@intel.com>
Message-ID: <alpine.DEB.2.02.1307041159330.11637@ionos.tec.linutronix.de>
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com> <1372916056-24301-3-git-send-email-alex.shi@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jul 2013, Alex Shi wrote:

> Shrink the mutex region. And save a clocksource_select action if set
> clocksource is same as current clocksource.

Again, how is that related to the issue described in 0/3 ?

That's an optimization and not a regression fix. And it's wrong as
well.
 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/time/clocksource.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index 021c159..9d6c333 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -885,13 +885,15 @@ static ssize_t sysfs_override_clocksource(struct device *dev,
>  {
>  	size_t ret;
>  
> -	mutex_lock(&clocksource_mutex);
> -
>  	ret = sysfs_get_uname(buf, override_name, count);
> -	if (ret >= 0)
> -		clocksource_select();
> +	if (ret >= 0) {
> +		if (!strcmp(curr_clocksource->name, override_name))

What if you get preempted in the middle of sysfs_get_uname() or in the
middle of strcmp() and some other code triggers a clocksource_select()
while you are off the CPU?

That might end up in a half filled override_name buffer or accessing
memory which might have been freed already because curr_clocksource
changed and the old driver was unloaded.

Not pretty.

If at all we can do:

-	mutex_lock(&clocksource_mutex);
-
-  	ret = sysfs_get_uname(buf, override_name, count);
+  	ret = sysfs_get_uname(buf, tmp_buf, count);
+	if (ret < 0)
+	   	return ret;

+	mutex_lock(&clocksource_mutex);
+	if (strcmp(override_name, tmp_buf) != 0) {
+	   	memcpy(override_name, tmp_buf, sizeof(tmp_buf));		  
+		clocksource_select();
+	}	

	mutex_unlock(&clocksource_mutex);
  	return ret;
}

Thanks,

	tglx
