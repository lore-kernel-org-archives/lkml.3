Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935128AbaBDVZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:25:18 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62880 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933612AbaBDVZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:25:14 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH v7 3/3] PM / Hibernate: use name_to_dev_t to parse resume
Date: Tue, 04 Feb 2014 22:39:43 +0100
Message-ID: <1498007.FMXxByppC2@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1391546631-7715-4-git-send-email-sebastian.capella@linaro.org>
References: <1391546631-7715-1-git-send-email-sebastian.capella@linaro.org> <1391546631-7715-4-git-send-email-sebastian.capella@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 04, 2014 12:43:51 PM Sebastian Capella wrote:
> Use the name_to_dev_t call to parse the device name echo'd to
> to /sys/power/resume.  This imitates the method used in hibernate.c
> in software_resume, and allows the resume partition to be specified
> using other equivalent device formats as well.  By allowing
> /sys/debug/resume to accept the same syntax as the resume=device
> parameter, we can parse the resume=device in the init script and
> use the resume device directly from the kernel command line.
> 
> Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Len Brown <len.brown@intel.com>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> ---
>  kernel/power/hibernate.c |   33 +++++++++++++++++----------------
>  1 file changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index cd1e30c..3abd192 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -970,26 +970,27 @@ static ssize_t resume_show(struct kobject *kobj, struct kobj_attribute *attr,
>  static ssize_t resume_store(struct kobject *kobj, struct kobj_attribute *attr,
>  			    const char *buf, size_t n)
>  {
> -	unsigned int maj, min;
>  	dev_t res;
> -	int ret = -EINVAL;
> +	char *name = kstrdup_trimnl(buf, GFP_KERNEL);
>  
> -	if (sscanf(buf, "%u:%u", &maj, &min) != 2)
> -		goto out;
> +	if (name == NULL)

What about "if (!name)"?

> +		return -ENOMEM;
>  
> -	res = MKDEV(maj,min);
> -	if (maj != MAJOR(res) || min != MINOR(res))
> -		goto out;
> +	res = name_to_dev_t(name);
>  
> -	lock_system_sleep();
> -	swsusp_resume_device = res;
> -	unlock_system_sleep();
> -	pr_info("PM: Starting manual resume from disk\n");
> -	noresume = 0;
> -	software_resume();
> -	ret = n;
> - out:
> -	return ret;
> +	if (res != 0) {

What about "if (res)"?

> +		lock_system_sleep();
> +		swsusp_resume_device = res;
> +		unlock_system_sleep();
> +		pr_info("PM: Starting manual resume from disk\n");
> +		noresume = 0;
> +		software_resume();
> +	} else {
> +		n = -EINVAL;
> +	}
> +
> +	kfree(name);
> +	return n;
>  }
>  
>  power_attr(resume);
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
