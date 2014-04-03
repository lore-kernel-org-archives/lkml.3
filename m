Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933726AbaDCGXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 02:23:03 -0400
Received: from mail.precitec.de ([85.115.17.50]:24684 "EHLO mail.precitec.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933478AbaDCGXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 02:23:00 -0400
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Apr 2014 02:23:00 EDT
From: Bockholdt Arne <a.bockholdt@precitec-optronik.de>
To: Jiri Slaby <jslaby@suse.cz>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 3.12 03/40] intel_idle: Support Intel Atom Processor
 C2000 Product Family
Thread-Topic: [PATCH 3.12 03/40] intel_idle: Support Intel Atom Processor
 C2000 Product Family
Thread-Index: AQHPTrEURMvgH6EjZUmbkz6Vpr+wPJr/SZAA
Date: Thu, 3 Apr 2014 06:16:25 +0000
Message-ID: <1396505784.5619.2.camel@po-d-abo-ubu>
References: <cover.1396469191.git.jslaby@suse.cz>
	 <2aa86e03cdb2567a97d3f8a4d931208ae177b0f7.1396469191.git.jslaby@suse.cz>
In-Reply-To: <2aa86e03cdb2567a97d3f8a4d931208ae177b0f7.1396469191.git.jslaby@suse.cz>
Accept-Language: en-US, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.201.50]
Content-Type: text/plain; charset="utf-8"
Content-ID: <0393FD418F6808408E649943A682402F@precitecgroup.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s336Nic8015731

> From: Len Brown <len.brown@intel.com>
> 
> 3.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ===============
> 
> commit fab04b2208dd1d4121319f0096c5a5f4b70abc54 upstream.
> 
> Support the "Intel(R) Atom(TM) Processor C2000 Product Family",
> formerly code-named Avoton.  It is based on the next generation
> Intel Atom processor architecture, formerly code-named Silvermont.
> 
> Signed-off-by: Len Brown <len.brown@intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> ---
>  drivers/idle/intel_idle.c | 24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index d47bb0f267f7..000d370519d9 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -1,7 +1,7 @@
>  /*
>   * intel_idle.c - native hardware idle loop for modern Intel processors
>   *
> - * Copyright (c) 2010, Intel Corporation.
> + * Copyright (c) 2013, Intel Corporation.
>   * Len Brown <len.brown@intel.com>
>   *
>   * This program is free software; you can redistribute it and/or modify it
> @@ -329,6 +329,22 @@ static struct cpuidle_state atom_cstates[CPUIDLE_STATE_MAX] = {
>  	{
>  		.enter = NULL }
>  };
> +static struct cpuidle_state avn_cstates[CPUIDLE_STATE_MAX] = {
> +	{
> +		.name = "C1-AVN",
> +		.desc = "MWAIT 0x00",
> +		.flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
> +		.exit_latency = 2,
> +		.target_residency = 2,
> +		.enter = &intel_idle },
> +	{
> +		.name = "C6-AVN",
> +		.desc = "MWAIT 0x51",
> +		.flags = MWAIT2flg(0x58) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +		.exit_latency = 15,
> +		.target_residency = 45,
> +		.enter = &intel_idle },
> +};
>  
>  /**
>   * intel_idle
> @@ -465,6 +481,11 @@ static const struct idle_cpu idle_cpu_hsw = {
>  	.disable_promotion_to_c1e = true,
>  };
>  
> +static const struct idle_cpu idle_cpu_avn = {
> +	.state_table = avn_cstates,
> +	.disable_promotion_to_c1e = true,
> +};
> +
>  #define ICPU(model, cpu) \
>  	{ X86_VENDOR_INTEL, 6, model, X86_FEATURE_MWAIT, (unsigned long)&cpu }
>  
> @@ -486,6 +507,7 @@ static const struct x86_cpu_id intel_idle_ids[] = {
>  	ICPU(0x3f, idle_cpu_hsw),
>  	ICPU(0x45, idle_cpu_hsw),
>  	ICPU(0x46, idle_cpu_hsw),
> +	ICPU(0x4D, idle_cpu_avn),
>  	{}
>  };
>  MODULE_DEVICE_TABLE(x86cpu, intel_idle_ids);


Ahoj !

For this one you also need the upstream patch
22e580d07f6529a395c129575127ea6d860aed3a to make the C-States  work on
C2000 series.

  Arne


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
