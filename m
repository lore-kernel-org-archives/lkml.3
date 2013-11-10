Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab3KJW5W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 17:57:22 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:40796 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab3KJW5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 17:57:16 -0500
Message-ID: <52800F42.5060904@linaro.org>
Date: Sun, 10 Nov 2013 17:57:06 -0500
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Dave Martin <dave.martin@linaro.org>
Subject: Re: [PATCH v2 09/13] ARM: Disable jprobe selftests in thumb kernels
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org>  <1381871068-27660-10-git-send-email-dave.long@linaro.org> <1383845166.3401.77.camel@linaro1.home>
In-Reply-To: <1383845166.3401.77.camel@linaro1.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/13 12:26, Jon Medhurst (Tixy) wrote:
> On Tue, 2013-10-15 at 17:04 -0400, David Long wrote:
>> From: "David A. Long" <dave.long@linaro.org>
>>
>> jprobe kernel selftests are not supported for thumb kernels. Conditionally
>> disable them in the kernel kprobes-test module.
>
> I don't think it's fair to say they aren't supported, it's just that the
> implementation of jprobes and/or symbol lookup has bugs on Thumb kernels
> which the test code is finding, see
> http://lists.infradead.org/pipermail/linux-arm-kernel/2011-August/063026.html
>
> Note, the current code works OK if the function being probed is in a
> loadable module (which is why I didn't spot the problem when doing the
> original Thumb kprobes work).
>
> Now I admit that having the tests always bombing out because of this
> hinders testing of kprobes, but simply disabling the test is just
> burying this long standing problem even more. So what do people think
> about something like the change below, to let other tests get run but
> make the overall test still fail...?
>
> --- a/arch/arm/kernel/kprobes-test.c
> +++ b/arch/arm/kernel/kprobes-test.c
> @@ -221,6 +221,7 @@ static int pre_handler_called;
>   static int post_handler_called;
>   static int jprobe_func_called;
>   static int kretprobe_handler_called;
> +static int tests_failed;
>
>   #define FUNC_ARG1 0x12345678
>   #define FUNC_ARG2 0xabcdef
> @@ -457,6 +458,13 @@ static int run_api_tests(long (*func)(long, long))
>
>   	pr_info("    jprobe\n");
>   	ret = test_jprobe(func);
> +#if defined(CONFIG_THUMB2_KERNEL) && !defined(MODULE)
> +	if (ret == -EINVAL) {
> +		pr_err("FAIL: Known longtime bug with jprobe on Thumb kernels");
> +		tests_failed = ret;
> +		ret = 0;
> +	}
> +#endif
>   	if (ret < 0)
>   		return ret;
>
> @@ -1667,6 +1675,8 @@ static int __init run_all_tests(void)
>
>   out:
>   	if (ret == 0)
> +		ret = tests_failed;
> +	if (ret == 0)
>   		pr_info("Finished kprobe tests OK\n");
>   	else
>   		pr_err("kprobe tests failed\n");
>
>
>
>


Thanks for clarifying the problem Tixy.  I agree we should try and allow 
the tests to run for these more typical use cases where they do actually 
work.  I have tested your patch and I will use it in place of mine 
unless there are strong objections.

-dl

