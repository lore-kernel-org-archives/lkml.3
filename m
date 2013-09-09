Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751113Ab3IIPX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:23:27 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46636 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3IIPXZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:23:25 -0400
Message-ID: <522DE822.3030907@arm.com>
Date: Mon, 09 Sep 2013 16:24:18 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jonas Bonn <jonas@southpole.se>, Michal Simek <monstr@monstr.eu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH v4 12/19] cpufreq: cpufreq-cpu0: remove device tree parsing
 for cpu nodes
References: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376991021-12160-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376991021-12160-13-git-send-email-Sudeep.KarkadaNagesha@arm.com> <Pine.LNX.4.64.1309061539310.11068@axis700.grange> <522D93D7.4010307@arm.com> <20130909143253.GD4624@S2101-09.ap.freescale.net>
In-Reply-To: <20130909143253.GD4624@S2101-09.ap.freescale.net>
X-OriginalArrivalTime: 09 Sep 2013 15:23:19.0683 (UTC) FILETIME=[83A40530:01CEAD70]
X-MC-Unique: 113090916232206401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/13 15:32, Shawn Guo wrote:
> Hi Sudeep,
> 
> On Mon, Sep 09, 2013 at 10:24:39AM +0100, Sudeep KarkadaNagesha wrote:
>> Hi Shawn,
>>
>> Can you please clarify ? The fix would be as below but I would like to
>> know if setting cpu_dev to get_cpu_device(0) instead of &pdev->dev has
>> any impact on other parts of code using cpu_dev ?
> 
> I'm sorry.  I should have given it a test on hardware before ACKing the
> changes.
> 
> The fix below should not have other impact except the prefix of dev_err
> [info, dbg] message output ('cpufreq-cpu0:' to 'cpu cpu0:'), which
> shouldn't be a problem.
>
Hi Shawn,

Ok. But I am bit suspicious about devm_clk_get(cpu_dev, NULL).
I don't understand completely as how the clock are registered(whether
with dev_id or with connection_id).

A quick grep revealed that i.mx and shmobile is using conection id while
registering. If the clock is registered with connection id and retrieved
with cpu_dev(now dev_id is cpu0 and not cpufreq-cpu0), IIUC that would
break. If we pass pdev->dev for clk_get, it should be fine but again
IIUC it breaks highbank which gets all the information from DT.

So only solution I can think of is to continue to have the code
assigning (&pdev->dev)->of_node with cpu device node which is not clean
and arguable as incorrect since there is no DT node for cpufreq-cpu0.
I don't have a strong opinion though.

Let me know how would you like to fix this.

>>
>> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
>> index cbfffa9..871c336 100644
>> --- a/drivers/cpufreq/cpufreq-cpu0.c
>> +++ b/drivers/cpufreq/cpufreq-cpu0.c
>> @@ -177,7 +177,7 @@ static int cpu0_cpufreq_probe(struct platform_device
>> *pdev)
>>         struct device_node *np;
>>         int ret;
>>
>> -       cpu_dev = &pdev->dev;
>> +       cpu_dev = get_cpu_device(0);
>>
>>         np = of_node_get(cpu_dev->of_node);
>>         if (!np) {
>>
> 
> The imx6q-cpufreq driver needs a similar fixing.  Please include the
> following changes into your fixing patches.  Thanks.
> 
Ok no problem I can post the fix based on response for the above question.

Regard,
Sudeep


