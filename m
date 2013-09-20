Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab3ITPU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 11:20:28 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:39163 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab3ITPU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 11:20:27 -0400
Message-ID: <523C66C5.9040008@linux.vnet.ibm.com>
Date: Fri, 20 Sep 2013 20:46:21 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Regression on cpufreq in v3.12-rc1
References: <CACRpkdYo24DO7ra7cgc54BUN-1SGfmbdhacOT41n2=KknyEtLw@mail.gmail.com> <45987104.t6r4hvPgQn@vostro.rjw.lan>	<523AF22F.1010909@linux.vnet.ibm.com> <CACRpkdYxiDA25Yb+csWWgXMmJuKMMTNVbdF+2JUnsSrXQpYysQ@mail.gmail.com> <CACRpkdYBYdMJ6mTGUropOypx0ZVNn8eQMzV+eKocCSBZAu6xTA@mail.gmail.com> <CAKohpokQO82XMGwcTjVmNTbBVESyFqV4DAxMMU_RHEtN+LqUgg@mail.gmail.com> <CACRpkdYoNkgno24dtJAwOq2T9yoKQYgKQ+adfkSN8affYNePjQ@mail.gmail.com> <CAKohpokdOXrGVxEA89yrAq2T8MiqZNHrrXNagqqggo67rEmKYg@mail.gmail.com> <CAKohpomXsZ+BsE7j-J4qU+x9f+JPsNEMi3d=CmfMByzPw_wvtw@mail.gmail.com>
In-Reply-To: <CAKohpomXsZ+BsE7j-J4qU+x9f+JPsNEMi3d=CmfMByzPw_wvtw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092015-8256-0000-0000-0000094F12FF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2013 03:05 PM, Viresh Kumar wrote:
> On 20 September 2013 14:19, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> Hmm... Remember I told you last time that I have another way of fixing
>> it up, probably we need that now..
>>
>> I wanted to add another variable to reflect if a cpufreq_driver is registered
>> or not, and if not then return early from these routines..
>>
>> I will get that in now, please see if you can give it a try..
>>
>> But I am still surprised how are we reaching this place before your cpufreq
>> driver gets registered..
> 
> Once we know what's going on in your system, please test attached patch
> (Will send it separately once you have tested it):
> 
> commit 389fbc3c8ad7c339cd2d9572d73c355b7b967823
> Author: Viresh Kumar <viresh.kumar@linaro.org>
> Date:   Fri Sep 20 14:55:31 2013 +0530
> 
>     cpufreq: check cpufreq driver is valid and cpufreq isn't disabled
> in cpufreq_get()
> 
>     cpufreq_get() can be called from external drivers which might not
> be aware if
>     cpufreq driver is registered or not. And so we should actually
> check if cpufreq
>     driver is registered or not and also if cpufreq is active or
> disabled, at the
>     beginning of cpufreq_get().
> 
>     Otherwise call to lock_policy_rwsem_read() might hit BUG_ON(!policy).
> 
>     Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

The patch looks reasonable to me. Earlier cpufreq_cpu_get() used to do the
necessary checks, but commit 6eed9404 removed the call to that function in
cpufreq_get(). So adding those checks back seem like the right fix to me.
Also, looking at commit 6eed9404, I think show() and store() also suffer
from a similar fate. So do you think we need to add these checks there as well?
I'm not sure, since I can't think of a situation in which show() or store()
can be invoked before the cpufreq-driver is registered.. or, is such a
situation possible with cpufreq_disabled()?

Regards,
Srivatsa S. Bhat

> ---
>  drivers/cpufreq/cpufreq.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 82ecbe3..db004a8 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1460,6 +1460,9 @@ unsigned int cpufreq_get(unsigned int cpu)
>  {
>         unsigned int ret_freq = 0;
> 
> +       if (cpufreq_disabled() || !cpufreq_driver)
> +               return -ENOENT;
> +
>         if (!down_read_trylock(&cpufreq_rwsem))
>                 return 0;
> 

