Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab3HYPiO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 11:38:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36836 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab3HYPiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 11:38:12 -0400
Date: Sun, 25 Aug 2013 17:38:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, linaro-dev@lists.linaro.org,
        len.brown@intel.com, rjw@sisk.pl
Subject: Re: [PATCH RFC 1/2] PM / Hibernate: use name_to_dev_t to parse
 resume
Message-ID: <20130825153811.GA4795@amd.pavel.ucw.cz>
References: <1377114413-8521-1-git-send-email-sebastian.capella@linaro.org>
 <1377114413-8521-2-git-send-email-sebastian.capella@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377114413-8521-2-git-send-email-sebastian.capella@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Use the name_to_dev_t call to parse the device name echo'd to
> to /sys/power/resume.  This imitates the method used in hibernate.c
> in software_resume, and allows the resume partition to be specified
> using other equivalent device formats as well.  By allowing
> /sys/debug/resume to accept the same syntax as the resume=device
> parameter, we can parse the resume=device in the init script and
> use the resume device directly from the kernel command line.
> 
> Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>
> ---
>  kernel/power/hibernate.c |   14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index b26f5f1..51d4c29 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -971,15 +971,19 @@ static ssize_t resume_show(struct kobject *kobj, struct kobj_attribute *attr,
>  static ssize_t resume_store(struct kobject *kobj, struct kobj_attribute *attr,
>  			    const char *buf, size_t n)
>  {
> -	unsigned int maj, min;
>  	dev_t res;
>  	int ret = -EINVAL;
> +	int len = n;
> +	char *devcpy;
>  
> -	if (sscanf(buf, "%u:%u", &maj, &min) != 2)
> -		goto out;
> +	if (buf[len-1] == '\n')
> +		len--;
> +
> +	devcpy = kstrndup(buf, len, GFP_KERNEL);
> +	res = name_to_dev_t(devcpy);
> +	kfree(devcpy);

Is the allocation actually neccessary? At the very least this should
test for NULL...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
