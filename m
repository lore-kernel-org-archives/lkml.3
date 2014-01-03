Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751012AbaACFic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 00:38:32 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:46963 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaACFia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 00:38:30 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1312111938580.23022@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1312111751180.9686@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1312111937570.23022@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1312111938370.23022@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1312111938580.23022@file01.intranet.prod.int.rdu2.redhat.com>
Date: Fri, 3 Jan 2014 11:08:29 +0530
Message-ID: <CAKohpomBC4f9y4=Hs0hoxHH7n5UAZFj9eSGDUbxA4b-+_2OYPw@mail.gmail.com>
Subject: Re: [PATCH 3/3] powernow-k6: reorder frequencies
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 December 2013 06:09, Mikulas Patocka <mpatocka@redhat.com> wrote:
> This patch reorders reported frequencies from the highest to the lowest,
> just like in other frequency drivers.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@kernel.org
>
> ---
>  drivers/cpufreq/powernow-k6.c |   17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
>
> Index: linux-3.12.3/drivers/cpufreq/powernow-k6.c
> ===================================================================
> --- linux-3.12.3.orig/drivers/cpufreq/powernow-k6.c     2013-12-06 22:08:27.000000000 +0100
> +++ linux-3.12.3/drivers/cpufreq/powernow-k6.c  2013-12-06 22:17:44.000000000 +0100
> @@ -37,17 +37,20 @@ MODULE_PARM_DESC(bus_frequency, "Bus fre
>
>  /* Clock ratio multiplied by 10 - see table 27 in AMD#23446 */
>  static struct cpufreq_frequency_table clock_ratio[] = {
> -       {45,  /* 000 -> 4.5x */ 0},
> +       {60,  /* 110 -> 6.0x */ 0},
> +       {55,  /* 011 -> 5.5x */ 0},
>         {50,  /* 001 -> 5.0x */ 0},
> +       {45,  /* 000 -> 4.5x */ 0},
>         {40,  /* 010 -> 4.0x */ 0},
> -       {55,  /* 011 -> 5.5x */ 0},
> -       {20,  /* 100 -> 2.0x */ 0},
> -       {30,  /* 101 -> 3.0x */ 0},
> -       {60,  /* 110 -> 6.0x */ 0},
>         {35,  /* 111 -> 3.5x */ 0},
> +       {30,  /* 101 -> 3.0x */ 0},
> +       {20,  /* 100 -> 2.0x */ 0},
>         {0, CPUFREQ_TABLE_END}
>  };
>
> +static const u8 index_to_register[8] = { 6, 3, 1, 0, 2, 7, 5, 4 };
> +static const u8 register_to_index[8] = { 3, 2, 4, 1, 7, 6, 0, 5 };
> +
>  static const struct {
>         unsigned freq;
>         unsigned mult;
> @@ -91,7 +94,7 @@ static int powernow_k6_get_cpu_multiplie
>
>         local_irq_enable();
>
> -       return clock_ratio[(invalue >> 5)&7].driver_data;
> +       return clock_ratio[register_to_index[(invalue >> 5)&7]].driver_data;
>  }
>
>  static void powernow_k6_set_cpu_multiplier(unsigned int best_i)
> @@ -111,7 +114,7 @@ static void powernow_k6_set_cpu_multipli
>         write_cr0(cr0 | X86_CR0_CD);
>         wbinvd();
>
> -       outvalue = (1<<12) | (1<<10) | (1<<9) | (best_i<<5);
> +       outvalue = (1<<12) | (1<<10) | (1<<9) | (index_to_register[best_i]<<5);
>
>         msrval = POWERNOW_IOPORT + 0x1;
>         wrmsr(MSR_K6_EPMR, msrval, 0); /* enable the PowerNow port */

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
