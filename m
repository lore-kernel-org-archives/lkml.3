Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbaA1JmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 04:42:08 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:8515 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaA1JmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 04:42:03 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-48-52e77b6699a5
Date: Tue, 28 Jan 2014 10:41:52 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH] acpi-cpufreq: De-register cpu notifier and free struct msr
 on error.
Message-id: <20140128104152.502ef069@amdc2363>
In-reply-to: <1390881491-18998-1-git-send-email-konrad.wilk@oracle.com>
References: <1390881491-18998-1-git-send-email-konrad.wilk@oracle.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t9jQd206udBBs+viFtcnN7KYvG06Qe7
	xbLFTxkt/jdeYbO4vGsOm8Xn3iOMFrcbV7BZPF7xlt1i41cPB06PxXteMnlsWtXJ5nHn2h42
	j49Pb7F49G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV8bMc/NZC27yVNw5f4uxgXErVxcjJ4eE
	gIlEw7LHTBC2mMSFe+vZuhi5OIQEpjNKdE7ewAiSEBL4xShxf4sZiM0ioCqx7/wxsAY2AT2J
	z3efgtkiAroS7550sYI0MwusYJI4tmY1O0hCWCBaYu/1LWBFvEANq058AYpzcHAKuEvs+KIH
	Md9N4kJ3B1g5v4CkRPu/H8wQB9lJnPu0gR2iVVDix+R7LCA2s4CWxOZtTawQtrzE5jVvmScw
	Cs5CUjYLSdksJGULGJlXMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRHxjPpHYyrGiwOMQpw
	MCrx8DYmPw8SYk0sK67MPcQowcGsJMIrWAEU4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuw1TpQ
	SCA9sSQ1OzW1ILUIJsvEwSnVwLhA5uoEo4KTpf/t+gwDKx9/N+Q5M2ufXdX8nYrLOJksud68
	b3SpOe6jYcRkml3baXWqq9agTsBhafyZNddZbP9Net3btjHWcbkwe/acvqzJ6Qm/jGfuvHX6
	jsun3X+UavjecMorr/0dmLer6bha5LH7gRMOzkpTLD+qZ9/H+LTYvkxC5uyCH0osxRmJhlrM
	RcWJAJhbdhuIAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konrad,

> If cpufreq_register_driver() fails we would free the acpi driver
> related structures but not free the ones allocated
> by acpi_cpufreq_boost_init() function. This meant that as
> the driver error-ed out and a CPU online/offline event came
> we would crash and burn as one of the CPU notifiers would point
> to garbage.
> 

Thanks for spotting this bug. My bad.

> This fixes a regression that commit
> cfc9c8ed03e4d908f2388af8815f44c87b503aaf "acpi-cpufreq: Adjust the
> code to use the common boost attribute" introduced.
> 
> CC: Lukasz Majewski <l.majewski@samsung.com>
> CC: Myungjoo Ham <myungjoo.ham@samsung.com>
> CC: Viresh Kumar <viresh.kumar@linaro.org>
> CC: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> CC: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/cpufreq/acpi-cpufreq.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpufreq/acpi-cpufreq.c
> b/drivers/cpufreq/acpi-cpufreq.c index 79e5608..3e856d6 100644
> --- a/drivers/cpufreq/acpi-cpufreq.c
> +++ b/drivers/cpufreq/acpi-cpufreq.c
> @@ -969,9 +969,10 @@ static int __init acpi_cpufreq_init(void)
>  	acpi_cpufreq_boost_init();
>  
>  	ret = cpufreq_register_driver(&acpi_cpufreq_driver);
> -	if (ret)
> +	if (ret) {
>  		free_acpi_perf_data();
> -
> +		acpi_cpufreq_boost_exit();
> +	}
>  	return ret;
>  }
>  

Acked-by: Lukasz Majewski <l.majewski@samsung.com>

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
