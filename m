Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423276AbaDKRBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 13:01:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45107 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418AbaDKRBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 13:01:44 -0400
Message-ID: <53481FD5.9000405@zytor.com>
Date: Fri, 11 Apr 2014 10:01:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@kernel.org, wdauchy@gmail.com,
        tglx@linutronix.de, tony.luck@intel.com, gong.chen@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, CMCI: Add proper detection of end of CMCI
 storms
References: <tip-27f6c573e0f77f7d1cc907c1494c99a61e48b7d8@git.kernel.org>
In-Reply-To: <tip-27f6c573e0f77f7d1cc907c1494c99a61e48b7d8@git.kernel.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 12:55 AM, tip-bot for Chen, Gong wrote:
> @@ -614,6 +618,8 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
>  		if (!(m.status & MCI_STATUS_VAL))
>  			continue;
>  
> +		v = &get_cpu_var(mce_polled_error);
> +		set_bit(0, v);
>  		/*
>  		 * Uncorrected or signalled events are handled by the exception
>  		 * handler when it is enabled, so don't process those here.
> @@ -1278,10 +1284,18 @@ static unsigned long mce_adjust_timer_default(unsigned long interval)
>  static unsigned long (*mce_adjust_timer)(unsigned long interval) =
>  	mce_adjust_timer_default;
>  
> +static int cmc_error_seen(void)
> +{
> +	unsigned long *v = &__get_cpu_var(mce_polled_error);
> +
> +	return test_and_clear_bit(0, v);
> +}
> +

Please use this_cpu_*() whereever possible instead of __get_cpu_var().
Since this is not actually a bitmask this_cpu_xchg() can be used at the end.

In fact, using set_bit() is completely wasteful.

I'll push this onward since it is a bit late, but please submit a
cleanup patch.

	-hpa


