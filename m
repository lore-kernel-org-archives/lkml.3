Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbaFMK4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 06:56:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50956 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbaFMK4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 06:56:13 -0400
Date: Fri, 13 Jun 2014 12:56:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 1/2] hibernate: create "nohibernate" boot parameter
Message-ID: <20140613105610.GC4876@amd.pavel.ucw.cz>
References: <1402606833-9825-1-git-send-email-keescook@chromium.org>
 <1402606833-9825-2-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402606833-9825-2-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-06-12 14:00:32, Kees Cook wrote:
> To support using kernel features that are not compatible with hibernation,
> this creates the "nohibernate" kernel boot parameter to disable both
> hibernation and resume. This allows hibernation support to be a boot-time
> choice instead of only a compile-time choice.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>


> @@ -639,6 +645,11 @@ int hibernate(void)
>  {
>  	int error;
>  
> +	if (!hibernation_available()) {
> +		pr_debug("PM: Hibernation not available.\n");
> +		return -EINVAL;
> +	}
> +
>  	lock_system_sleep();
>  	/* The snapshot device should not be opened while we're running */
>  	if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {
> @@ -931,6 +945,9 @@ static ssize_t disk_store(struct kobject *kobj, struct kobj_attribute *attr,
>  	char *p;
>  	int mode = HIBERNATION_INVALID;
>  
> +	if (!hibernation_available())
> +		return -EINVAL;
> +
>  	p = memchr(buf, '\n', n);
>  	len = p ? p - buf : n;
>  
> diff --git a/kernel/power/user.c b/kernel/power/user.c
> index 98d357584cd6..000b94419182 100644
> --- a/kernel/power/user.c
> +++ b/kernel/power/user.c
> @@ -49,6 +49,9 @@ static int snapshot_open(struct inode *inode, struct file *filp)
>  	struct snapshot_data *data;
>  	int error;
>  
> +	if (!hibernation_available())
> +		return -EINVAL;
> +
>  	lock_system_sleep();
>  
>  	if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {

Is EINVAL right error code for "root disabled that option"?

Otherwise it looks ok, you can add my ack with that fixed.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
