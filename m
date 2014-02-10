Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaBJTP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:15:26 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:40856 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbaBJTPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:15:23 -0500
Message-ID: <52F92524.3080402@ti.com>
Date: Mon, 10 Feb 2014 13:14:44 -0600
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Bjorn Andersson <bjorn@kryo.se>, Ohad Ben-Cohen <ohad@wizery.com>
CC: Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv4 4/7] hwspinlock/core: add common OF helpers
References: <1389658764-39199-1-git-send-email-s-anna@ti.com>	<1389658764-39199-5-git-send-email-s-anna@ti.com> <CAJAp7Oi7wD+VsMAd37gT04yZ4TH4ygXFmheDhvmWuanUjpBmVQ@mail.gmail.com>
In-Reply-To: <CAJAp7Oi7wD+VsMAd37gT04yZ4TH4ygXFmheDhvmWuanUjpBmVQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn,

On 02/07/2014 04:49 PM, Bjorn Andersson wrote:
> On Mon, Jan 13, 2014 at 4:19 PM, Suman Anna <s-anna@ti.com> wrote:
>> This patch adds three new OF helper functions to use/request
>> locks from a hwspinlock device instantiated through a
>> device-tree blob.
>
> Nice, I ran in to the problem of needing a probe deferral on a
> hwspinlock earlier this week so I implemented this yesterday...then I
> got a pointer to your series.
>
> [snip]
>>   /**
>> + * of_hwspin_lock_request_specific() - request a OF phandle-based specific lock
>> + * @np: device node from which to request the specific hwlock
>> + * @propname: property name containing hwlock specifier(s)
>> + * @index: index of the hwlock
>> + *
>> + * This function is the OF equivalent of hwspin_lock_request_specific(). This
>> + * function provides a means for users of the hwspinlock module to request a
>> + * specific hwspinlock using the phandle of the hwspinlock device. The requested
>> + * lock number is indexed relative to the hwspinlock device, unlike the
>> + * hwspin_lock_request_specific() which is an absolute lock number.
>> + *
>> + * Returns the address of the assigned hwspinlock, or NULL on error
>> + */
>> +struct hwspinlock *of_hwspin_lock_request_specific(struct device_node *np,
>> +                                       const char *propname, int index)
>> +{
>> +       struct hwspinlock_device *bank;
>> +       struct of_phandle_args args;
>> +       int id;
>> +       int ret;
>> +
>> +       ret = of_parse_phandle_with_args(np, propname, "#hwlock-cells", index,
>> +                                        &args);
>> +       if (ret) {
>> +               pr_warn("%s: can't parse hwlocks property of node '%s[%d]' ret = %d\n",
>> +                       __func__, np->full_name, index, ret);
>> +               return NULL;
>> +       }
>
> of_parse_phandle_with_args() already does pr_err if it can't find the
> phandle and on some of the issues related to arguments. So please
> remove this pr_warn().

Yes, I will clean this up.

>
> It seems to be standard practice to pass the error value back to the
> consumer, so you should
> return ERR_PTR(ret); here instead of the NULL...

I have modelled the return values in this function based on the return 
values in the existing hwspin_lock_request interfaces. I would need to
change those functions as well.

Ohad,
Do you have any objections to the return code convention change? I agree 
with Bjorn on the changes. If you are ok, then I will add a separate 
patch for the existing functions and revise this patch as well.

>
>> +
>> +       mutex_lock(&hwspinlock_tree_lock);
>> +       list_for_each_entry(bank, &hwspinlock_devices, list)
>> +               if (bank->dev->of_node == args.np)
>> +                       break;
>> +       mutex_unlock(&hwspinlock_tree_lock);
>> +       if (&bank->list == &hwspinlock_devices) {
>> +               pr_warn("%s: requested hwspinlock device %s is not registered\n",
>> +                       __func__, args.np->full_name);
>> +               return NULL;
>
> ...especially since you want the consumer to have the ability to
> identify this error. Here you should
> return ERR_PTR(-EPROBE_DEFER); so that the consumer knows that this
> lock is not _yet_ registered, but will be in the future.
>
> You should remove this pr_warn as well. The standard use of this
> function would be in a probe() and just returning this error value
> from that probe will give you a line in the log indicating that this
> was in fact the issue.

OK.

>
>> +       }
>> +
>> +       id = bank->ops->of_xlate(bank, &args);
>> +       if (id < 0 || id >= bank->num_locks) {
>> +               pr_warn("%s: requested lock %d is either out of range [0, %d] or failed translation\n",
>> +                       __func__, id, bank->num_locks - 1);
>> +               return NULL;
>
> Please return ERR_PTR(-EINVAL); here.

OK, will change this based on Ohad's ack/nack.

>
> Looking forward to your next spin, as I will actually use this interface :)

Thanks for your comments. I will wait to see if there are any additional 
comments before I refresh the series later this week.

regards
Suman
