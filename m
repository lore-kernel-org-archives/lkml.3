Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab3FTJo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:44:56 -0400
Received: from 12.mo3.mail-out.ovh.net ([188.165.41.191]:59043 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751484Ab3FTJoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:44:54 -0400
X-Greylist: delayed 142012 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Jun 2013 05:44:54 EDT
Message-ID: <51C2CF0B.1010007@overkiz.com>
Date: Thu, 20 Jun 2013 11:44:43 +0200
From: =?ISO-8859-1?Q?Ga=EBl_PORTAY?= <g.portay@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Rob Landley <rob@landley.net>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        "Milo(Woogyom) Kim" <milo.kim@ti.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [RFC PATCH] led: add Cycle LED trigger.
References: <1371572663-10846-1-git-send-email-g.portay@overkiz.com> <1371593140.2038.8.camel@joe-AO722>
In-Reply-To: <1371593140.2038.8.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 14932247516096752630
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/06/2013 00:05, Joe Perches wrote:
> On Tue, 2013-06-18 at 18:24 +0200, Gaël PORTAY wrote:
>> Currently, none of available triggers supports playing with the LED brightness
>> level.  The cycle trigger provides a way to define custom brightness cycle.
>> For example, it is easy to customize the cycle to mock up the rhythm of human
>> breathing which is a nice cycle to tell the user the system is doing something.
> I think maybe this is a userspace thing, but here's a
> trivial comment or two
>
>
>> +static int cycle_start(struct cycle_trig_data *data)
>> +{
>> +	unsigned long flags;
>> +
>> +	if (hrtimer_active(&data->timer))
>> +		return -EINVAL;
>> +
>> +	spin_lock_irqsave(&data->lock, flags);
>> +	data->plot_index = 0;
>> +	data->cycle_count = 0;
>> +	hrtimer_start(&data->timer, ktime_get(), HRTIMER_MODE_ABS);
>> +	spin_unlock_irqrestore(&data->lock, flags);
>> +
>> +	return 1;
> Maybe return 0 on success
>
>> +static ssize_t cycle_control_store(struct device *dev,
>> +				    struct device_attribute *attr,
>> +				    const char *buf, size_t size)
>> +{
>> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
>> +	struct cycle_trig_data *data = led_cdev->trigger_data;
>> +
>> +	if (strncmp(buf, "start", sizeof("start") - 1) == 0)
>> +		cycle_start(data);
>> +	else if (strncmp(buf, "stop", sizeof("stop") - 1) == 0)
>> +		cycle_stop(data);
>> +	else if (strncmp(buf, "reset", sizeof("reset") - 1) == 0)
>> +		cycle_reset(data);
>> +	else if (strncmp(buf, "pause", sizeof("stop") - 1) == 0)
>> +		cycle_pause(data);
>> +	else if (strncmp(buf, "resume", sizeof("resume") - 1) == 0)
>> +		cycle_resume(data);
>> +	else
>> +		return -EINVAL;
> I think strcasecmp better than strncmp
>
>> +static ssize_t cycle_rawplot_store(struct device *dev,
>> +                                  struct device_attribute *attr,
>> +                                  const char *buf, size_t size)
>> +{
> []
> +       plot = kzalloc(size, GFP_KERNEL);
> +       if (plot) {
> +               hrtimer_cancel(&data->timer);
>
> Ick.
>
> 	if (!plot)
> 		return -ENOMEM;
>
> 	etc...
>
Hello,

Thanks a lot for your review. I took your remarks into consideration and 
fixed the mistakes.

About the kernel/user space discussion, I'd rather keep the cycle 
trigger implementation in the kernel space,
because it implies brightness change every 10-100ms or less. This leads 
to lots of context switches, and I'm not
even sure the user space can handle such timings accurately.

Could you detail your concerns about adding this driver in the kernel?

Best Regards,
Gaël
