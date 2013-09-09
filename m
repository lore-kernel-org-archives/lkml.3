Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab3IIJXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 05:23:47 -0400
Received: from service87.mimecast.com ([91.220.42.44]:53840 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab3IIJXp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 05:23:45 -0400
Message-ID: <522D93D7.4010307@arm.com>
Date: Mon, 09 Sep 2013 10:24:39 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Shawn Guo <shawn.guo@linaro.org>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
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
References: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376991021-12160-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376991021-12160-13-git-send-email-Sudeep.KarkadaNagesha@arm.com> <Pine.LNX.4.64.1309061539310.11068@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1309061539310.11068@axis700.grange>
X-OriginalArrivalTime: 09 Sep 2013 09:23:41.0329 (UTC) FILETIME=[45F08010:01CEAD3E]
X-MC-Unique: 113090910234302401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/13 14:44, Guennadi Liakhovetski wrote:
> Hi
> 
> On Tue, 20 Aug 2013, Sudeep KarkadaNagesha wrote:
> 
>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>
>> Now that the cpu device registration initialises the of_node(if available)
>> appropriately for all the cpus, parsing here is redundant.
>>
>> This patch removes all DT parsing and uses cpu->of_node instead.
>>
>> Acked-by: Shawn Guo <shawn.guo@linaro.org>
>> Acked-by: Rob Herring <rob.herring@calxeda.com>
>> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>> ---
>>  drivers/cpufreq/cpufreq-cpu0.c | 23 ++++-------------------
>>  1 file changed, 4 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.=
>> c
>> index ad1fde2..5b05c26 100644
>> --- a/drivers/cpufreq/cpufreq-cpu0.c
>> +++ b/drivers/cpufreq/cpufreq-cpu0.c
>> @@ -174,29 +174,17 @@ static struct cpufreq_driver cpu0_cpufreq_driver =3D =
>> {
>> =20
>>  static int cpu0_cpufreq_probe(struct platform_device *pdev)
>>  {
>> -=09struct device_node *np, *parent;
>> +=09struct device_node *np;
>>  =09int ret;
>> =20
>> -=09parent =3D of_find_node_by_path("/cpus");
>> -=09if (!parent) {
>> -=09=09pr_err("failed to find OF /cpus\n");
>> -=09=09return -ENOENT;
>> -=09}
>> -
>> -=09for_each_child_of_node(parent, np) {
>> -=09=09if (of_get_property(np, "operating-points", NULL))
>> -=09=09=09break;
>> -=09}
>> +=09cpu_dev =3D &pdev->dev;
>> =20
>> +=09np =3D of_node_get(cpu_dev->of_node);
> 
> Has this actually been tested? This seems to break cpufreq-cpu0. The 
> reason is, that this probe function is called not for the DT CPU node, but 
> for a special virtual cpufreq-cpu0 platform device, typically created by 
> platforms, using
> 
> 	platform_device_register_simple("cpufreq-cpu0", -1, NULL, 0);
> 
> which then of course doesn't have on .of_node associated with it.
> 

Hi Guennadi,

Based on my understanding of the original code:
        cpu_dev = &pdev->dev;
	...
	ret = of_init_opp_table(cpu_dev);

of_init_opp_table needs cpu_dev to be get_cpu_device(0). My
understanding was that platform using cpufreq-cpu0 sets &pdev->dev to
get_cpu_device(0). But looks like that's not the case.

Hi Shawn,

Can you please clarify ? The fix would be as below but I would like to
know if setting cpu_dev to get_cpu_device(0) instead of &pdev->dev has
any impact on other parts of code using cpu_dev ?

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index cbfffa9..871c336 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -177,7 +177,7 @@ static int cpu0_cpufreq_probe(struct platform_device
*pdev)
        struct device_node *np;
        int ret;

-       cpu_dev = &pdev->dev;
+       cpu_dev = get_cpu_device(0);

        np = of_node_get(cpu_dev->of_node);
        if (!np) {


Regards,
Sudeep



