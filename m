Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab3GQFAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 01:00:50 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:53187 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab3GQFAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 01:00:48 -0400
Message-ID: <51E6242B.2050101@linux.vnet.ibm.com>
Date: Wed, 17 Jul 2013 10:27:15 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soeren.brinkmann@gmail.com>
CC: Willy Tarreau <w@1wt.eu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION 3.10.1] System does not wake up from suspend
References: <20130715043625.GA2162@skorgonTP.att.net> <20130715045400.GU32054@1wt.eu> <51E39BAB.4060308@linux.vnet.ibm.com> <20130717025720.GA1267@skorgonTP.att.net>
In-Reply-To: <20130717025720.GA1267@skorgonTP.att.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071704-1618-0000-0000-00000448C6E9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 08:27 AM, Sören Brinkmann wrote:
> On Mon, Jul 15, 2013 at 12:20:19PM +0530, Srivatsa S. Bhat wrote:
>> On 07/15/2013 10:24 AM, Willy Tarreau wrote:
>>> On Sun, Jul 14, 2013 at 09:36:25PM -0700, Sören Brinkmann wrote:
>>>> Hi Greg,
>>>>
>>>> since upgrading to 3.10.1 I find my system not waking up from suspend
>>>> from time to time. Unfortunately, I couldn't figure out how to reliably
>>>> reproduce the issue. Sometimes it works just fine.
>>>>
>>>> All I know so far:
>>>> On 3.10 I had my system completely freezing a few times. But that did
>>>> not seem to be related to suspend/resume. I never experienced the
>>>> behavior described below on 3.10.
>>>>
>>>> On 3.10.1 I hit this bug a few times, that my system did not wake up.
>>>> I.e. the screen stayed black and the power LED kept flashing. But
>>>> nothing brought the system back up and I had to longpress power to reset
>>>> the system.
>>>> I had none of the system freezes like the ones described above anymore.
>>>
>>> Fortunately, 3.10.1 is very small. The only patch it contains which is
>>> related to suspend is 18/19 (cpufreq ondemand governor). Maybe you're
>>> having a problem with cpufreq on this machine in fact.
>>>
>>> You may want to try to force it to performance mode or powersave mode
>>> and try for a while, it is possible that both 3.10 and 3.10.1 will work
>>> fine.
>>>
>>
>> Or, you could try applying the patch shown below on top of 3.10.1 and
>> see if it fixes the suspend/resume regression for you.
>>
>> https://lkml.org/lkml/2013/7/11/661
>>
>> (Just apply patch 1, not the entire patchset).
> So, this didn't end well. With that patch applied I end up in a kernel
> panic on suspend, reproducible - well two out of two is a small test set,
> but anyway. Unfortunately too late to get any information about it
> and my logs don't show anything either. But it's seems worse than the
> rather occasional hangs on resume on the vanilla 3.10.1 kernel.
> 

Kernel panic? Weird.. I suspect something _else_ is wrong. I suggest trying
out the following:

1. My patches only touch cpufreq. So completely turn off cpufreq by setting
   CONFIG_CPU_FREQ=n. Then try suspend/resume and see how it goes. If it
   fails, that shows that something _else_ is wrong and you can try a git
   bisect for that.

   However, if suspend/resume succeeds with CONFIG_CPU_FREQ=n, then try out
   step 2 below.

2. Apply patch 1 (not the entire patchset)
   https://lkml.org/lkml/2013/7/11/661

   On top of that, apply this patch:
   https://patchwork.kernel.org/patch/2827512/

   And then try suspend/resume with cpufreq turned on CONFIG_CPU_FREQ=y
   (and turning on other cpufreq Kconfig options which are of interest to
    you).


That should help us narrow down whether the suspend/resume issue is really
related to cpufreq or not.
 
Regards,
Srivatsa S. Bhat

