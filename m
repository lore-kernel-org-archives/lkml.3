Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab3DVXid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 19:38:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53828 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab3DVXic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 19:38:32 -0400
Date: Mon, 22 Apr 2013 16:38:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 3/3] rtc: rtc-hid-sensor-time; add option hctosys to set
 time at boot
Message-Id: <20130422163830.4aaaef240b1572dc778dd620@linux-foundation.org>
In-Reply-To: <1366384452-14367-4-git-send-email-holler@ahsoftware.de>
References: <1366384452-14367-1-git-send-email-holler@ahsoftware.de>
	<1366384452-14367-4-git-send-email-holler@ahsoftware.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Apr 2013 17:14:12 +0200 Alexander Holler <holler@ahsoftware.de> wrote:

> drivers/rtc/hctosys (CONFIG_RTC_HCTOSYS) doesn't work for
> rtc-hid-sensor-time because it will be called in late_init, and thus before
> rtc-hid-sensor-time gets loaded.

Isn't that true of all RTC drivers which are built as modules?  There's
nothing special about hid-sensor-time here?

I assume the standard answer here is "your RTC driver should be built
into vmlinux".  If we wish to make things work for modular RTC drivers
then we should find a solution which addresses *all* RTC drivers?

> To set the time through rtc-hid-sensor-time
> at startup, the module now checks by default if the system time is before
> 1970-01-02 and sets the system time (once) if this is the case.
> 
> To disable this behaviour, set the module option hctosys to zero, e.g. by
> using rtc-hid-sensor-time.hctosys=0 at the kernel command line if the
> driver is statically linked into the kernel.

Is a bit hacky, no?

> @@ -237,6 +279,22 @@ static const struct rtc_class_ops hid_time_rtc_ops = {
>  	.read_time = hid_rtc_read_time,
>  };
>  
> +struct hid_time_work_time_state {
> +	struct work_struct work;
> +	struct hid_time_state *time_state;
> +};
> +
> +static void hid_time_request_report_work(struct work_struct *work)
> +{
> +	struct hid_time_state *time_state =
> +		((struct hid_time_work_time_state *)work)->time_state;

Yikes.  Use container_of() here.

Also, you don't *have* to initialise things at their definition site.  So

	struct hid_time_state *time_state =
		some-ginormous-expression-which-overflows-80-columns;

becomes

	struct hid_time_state *time_state;
	time_state = some-ginormous-expression-which-no-longer-overflows-80-columns;

Simple, no?

> +	/* get a report with all values through requesting one value */
> +	sensor_hub_input_attr_get_raw_value(
> +		time_state->common_attributes.hsdev, HID_USAGE_SENSOR_TIME,
> +		hid_time_addresses[0], time_state->info[0].report_id);
> +	kfree(work);
> +}
> +
>  static int hid_time_probe(struct platform_device *pdev)
>  {
>  	int ret = 0;
> @@ -287,6 +345,20 @@ static int hid_time_probe(struct platform_device *pdev)
>  		return PTR_ERR(time_state->rtc);
>  	}
>  
> +	if (!hid_time_time_set_once && hid_time_hctosys_enabled) {
> +		/*
> +		 * Request a HID report to set the time.
> +		 * Calling sensor_hub_..._get_raw_value() here directly
> +		 * doesn't work, therefor we have to use a work.
> +		 */
> +		struct hid_time_work_time_state *hdwork =
> +			kmalloc(sizeof(struct hid_time_work_time_state),
> +				GFP_KERNEL);

looky:

		struct hid_time_work_time_state *hdwork;

		hdwork = kmalloc(sizeof(*hdwork), GFP_KERNEL);

> +		hdwork->time_state = time_state;

Forgot to check for kmalloc() failure.

> +		INIT_WORK(&hdwork->work, hid_time_request_report_work);
> +		schedule_work(&hdwork->work);

The patch adds a schedule_work() but no flush_scheduled_work(), etc. 
So if the driver is shut down or rmmodded while the work is still
pending, the kernel will go kapow.

> +	}
> +
>  	return ret;
>  }

