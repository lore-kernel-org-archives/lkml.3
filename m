Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760791AbaEMNlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:41:47 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40597 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947AbaEMNlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:41:46 -0400
Message-ID: <5372210E.4060305@ti.com>
Date: Tue, 13 May 2014 08:41:34 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Chander Kashyap <chander.kashyap@linaro.org>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        "Brown, Len" <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>
Subject: Re: [PATCH] PM / OPP: discard duplicate OPP additions
References: <1399966890-22926-1-git-send-email-k.chander@samsung.com> <CAKohpo=6qXer+RRS-F6x=O1VLzbWq+_a-b29MaUzZBvt7XzDwQ@mail.gmail.com>
In-Reply-To: <CAKohpo=6qXer+RRS-F6x=O1VLzbWq+_a-b29MaUzZBvt7XzDwQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 03:22 AM, Viresh Kumar wrote:
> On 13 May 2014 13:11, [Chander Kashyap <chander.kashyap@linaro.org> wrote:
> 
> What happened to your name ? "["
> 
>> From: Chander Kashyap <k.chander@samsung.com>
>>
>> It may be possible to unregister and re-register the cpufreq driver.
>> One such example is arm big-little IKS cpufreq driver. While
>> re-registering the driver, same OPPs may get added again.
>>
>> This patch detects the duplicacy and discards them.
>>
>> Signed-off-by: Chander Kashyap <k.chander@samsung.com>
>> Signed-off-by: Inderpal Singh <inderpal.s@samsung.com>
>> ---
>>  drivers/base/power/opp.c |   28 +++++++++++++++++++---------
>>  1 file changed, 19 insertions(+), 9 deletions(-)
> 
> I wouldn't say that this approach is particularly bad or wrong, but what
> about this instead?
> 
> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> index 2553867..7efdaf3 100644
> --- a/drivers/base/power/opp.c
> +++ b/drivers/base/power/opp.c
> @@ -713,6 +713,11 @@ int of_init_opp_table(struct device *dev)
>         const __be32 *val;
>         int nr;
> 
> +       if (!IS_ERR(find_device_opp(dev))) {
> +               dev_warn("%s: opp table already exists\n", __func__);
> +               return -EEXIST;
> +       }
> +
>         prop = of_find_property(dev->of_node, "operating-points", NULL);
>         if (!prop)
>                 return -ENODEV;

yes - this is good but should be an additional patch IMHO, since it
solves a different issue:"prevent opp table re-creation attempt". the
$subject patch addresses an issue where dev_pm_opp_add can be invoked
independently as well -> So, we seem to have have three issues to solve:
a) do we continue to ensure that OPP table is created one time?
b) while creating OPP table, duplicate entries should be rejected
($subject)
c) prevent recreation of OPP table once created (if we decide not to
have a cleanup logic as part of (a)) - this is what you propose.

Now, considering that OPP table definition is an SoC behavior, that
behavior is NOT going to change just because we are reinserting driver
modules - so if cpufreq drivers are resulting in that behavior, then
we should fix that. and consider OPP tables are created one time (at
boot) and do the necessary changes for the same.

just my 2 cents.

-- 
Regards,
Nishanth Menon
