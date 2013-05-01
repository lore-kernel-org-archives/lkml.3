Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761606Ab3EAQd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 12:33:57 -0400
Received: from service87.mimecast.com ([91.220.42.44]:59803 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761570Ab3EAQdu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 12:33:50 -0400
Message-ID: <518143EF.3010900@arm.com>
Date: Wed, 01 May 2013 17:33:51 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Shawn Guo <shawn.guo@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 2/2] PM / OPP: check for existing OPP list when initialising
 from device tree
References: <1367406679-21603-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1367406679-21603-3-git-send-email-Sudeep.KarkadaNagesha@arm.com> <20130501150403.GA20488@kahuna>
In-Reply-To: <20130501150403.GA20488@kahuna>
X-OriginalArrivalTime: 01 May 2013 16:33:47.0722 (UTC) FILETIME=[A7A252A0:01CE4689]
X-MC-Unique: 113050117334801801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/13 16:04, Nishanth Menon wrote:
> On 12:11-20130501, Sudeep.KarkadaNagesha@arm.com wrote:
>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>
>> CPUs are registered as devices and their OPPs can be initialised from
>> the device tree. Whenever CPUs can be hotplugged out, the corresponding
>> cpu devices are not removed. As a result all their OPPs remain intact
>> even when they are offlined.
>>
>> But when they are hotplugged back-in, the cpufreq along with other cpu
>> related subsystem gets re-initialised. Since its almost same as secondary
>> cpu being brought up, no special consideration is taken in the hotplug
>> path. As a result of this the cpufreq will try to initialise the OPPs
>> again though the cpu device already contains the OPPs.
>>
>> This patch checks if there exist an OPP list associated with the device,
>> before attempting to initialise it.
>>
>> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>> ---
>>  drivers/base/power/opp.c |    5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
>> index 4dfdc01..66d52d2 100644
>> --- a/drivers/base/power/opp.c
>> +++ b/drivers/base/power/opp.c
>> @@ -706,6 +706,11 @@ static int of_init_opp_table_from_ofnode(struct device *dev,
>>  	const __be32 *val;
>>  	int nr;
>>  
>> +	/* Check for existing list for 'dev' */
>> +	dev_opp = find_device_opp(dev);
>> +	if (!IS_ERR(dev_opp))
>> +		return 0; /* Device OPP already initialized */
>> +
> It gets a little touchy here -> the normal expectation is for the OPP
> entries to be populated onetime at boot.
> For example - driver bug where same device was attempted twice Vs the
> usecase you mention here - how'd we differentiate between the two?

Do we really need to differentiate ? How about returning -EEXIST ?



