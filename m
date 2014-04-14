Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118AbaDNQU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:20:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47678 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887AbaDNQUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:20:19 -0400
Message-ID: <534C0AB8.7050209@zytor.com>
Date: Mon, 14 Apr 2014 09:20:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Chen, Gong" <gong.chen@linux.intel.com>, tony.luck@intel.com
CC: tglx@linutronix.de, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH 2/2] x86, MCE: Cleanup macro __get_cpu_var
References: <tip-27f6c573e0f77f7d1cc907c1494c99a61e48b7d8@git.kernel.org> <1397464777-25451-1-git-send-email-gong.chen@linux.intel.com> <1397464777-25451-2-git-send-email-gong.chen@linux.intel.com>
In-Reply-To: <1397464777-25451-2-git-send-email-gong.chen@linux.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2014 01:39 AM, Chen, Gong wrote:
> @@ -1287,14 +1287,14 @@ static unsigned long (*mce_adjust_timer)(unsigned long interval) =
>  
>  static int cmc_error_seen(void)
>  {
> -	unsigned long *v = &__get_cpu_var(mce_polled_error);
> +	unsigned long *v = this_cpu_ptr(&mce_polled_error);
>  
> -	return test_and_clear_bit(0, v);
> +	return this_cpu_xchg(*v, 0);
>  }
>  

Here you produce a pointer and *then* passing it through a this_cpu_
function... this is actively wrong.

It should simply be:

	return this_cpu_xchg(mce_polled_error, 0);

	-hpa

