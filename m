Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761975AbbA2Cas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:30:48 -0500
Received: from smtprelay0124.hostedemail.com ([216.40.44.124]:59267 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758061AbbA2Br5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:47:57 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3873:3874:4385:4605:5007:6261:7875:7903:10004:10400:10848:10967:11026:11232:11233:11658:11914:12043:12438:12517:12519:12740:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cows57_26fdc80babb36
X-Filterd-Recvd-Size: 2074
Date: Wed, 28 Jan 2015 12:31:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Javi Merino <javi.merino@arm.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        punit.agrawal@arm.com, broonie@kernel.org,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v1 5/7] thermal: add trace events to the power allocator
 governor
Message-ID: <20150128123106.05e28afc@gandalf.local.home>
In-Reply-To: <1422464438-16761-6-git-send-email-javi.merino@arm.com>
References: <1422464438-16761-1-git-send-email-javi.merino@arm.com>
	<1422464438-16761-6-git-send-email-javi.merino@arm.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2015 17:00:36 +0000
Javi Merino <javi.merino@arm.com> wrote:

> +	if (trace_thermal_power_cpu_limit_enabled() && load_cpu) {
> +		trace_thermal_power_cpu_get_power(
> +			&cpufreq_device->allowed_cpus,
> +			freq, load_cpu, i, dynamic_power, static_power);
> +
> +		devm_kfree(&cdev->device, load_cpu);

You may want to move the devm_kfree() out of the
trace_thermal_power_cpu_limit_enabled() check. There could be a race
where that gets disabled while this function is running and you just
leaked memory.

	if (load_cpu)
		devm_kfree(&cdev->device, load_cpu);

should be done by itself.

-- Steve

> +	}
>  
>  	*power = static_power + dynamic_power;
>  	return 0;
> @@ -664,6 +689,8 @@ static int cpufreq_power2state(struct thermal_cooling_device *cdev,
>  		return -EINVAL;
>  	}
>  
> +	trace_thermal_power_cpu_limit(&cpufreq_device->allowed_cpus,
> +				      target_freq, *state, power);
>  	return 0;
>  }
>  
