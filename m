Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaIJVXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 17:23:44 -0400
Received: from mail-by2on0114.outbound.protection.outlook.com ([207.46.100.114]:24256
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753902AbaIJVXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 17:23:42 -0400
X-WSS-ID: 0NBPFFC-07-0O3-02
X-M-MSG: 
Message-ID: <5410C157.4050103@amd.com>
Date: Wed, 10 Sep 2014 16:23:35 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: <herrmann.der.user@googlemail.com>, <jdelvare@suse.de>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>
Subject: Re: [PATCH] hwmon, fam15h_power: Add support for two more processors
References: <1410368528-4738-1-git-send-email-aravind.gopalakrishnan@amd.com>
 <20140910175312.GA7079@roeck-us.net> <5410AE20.4080205@amd.com>
 <20140910203719.GA31216@roeck-us.net>
In-Reply-To: <20140910203719.GA31216@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019019)(6009001)(428002)(24454002)(51704005)(164054003)(377454003)(479174003)(199003)(189002)(87266999)(54356999)(50986999)(76176999)(65816999)(81342001)(81542001)(76482001)(21056001)(4396001)(79102001)(77982001)(46102001)(99396002)(86362001)(87936001)(101416001)(31966008)(19580405001)(74502001)(80316001)(83322001)(19580395003)(74662001)(44976005)(68736004)(47776003)(20776003)(36756003)(64706001)(83072002)(85852003)(83506001)(50466002)(92726001)(92566001)(80022001)(65806001)(65956001)(97736003)(95666004)(102836001)(84676001)(105586002)(90102001)(64126003)(23756003)(107046002)(85306004)(93886004)(106466001)(110136001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB045;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033054F29A
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/10/2014 3:37 PM, Guenter Roeck wrote:
> On Wed, Sep 10, 2014 at 03:01:36PM -0500, Aravind Gopalakrishnan wrote:
>> On 9/10/2014 12:53 PM, Guenter Roeck wrote:
>>> On Wed, Sep 10, 2014 at 12:02:08PM -0500, Aravind Gopalakrishnan wrote:
>>>> Fam16h,M30h(Mullins) and Fam15hM30h(Kaveri) processors can
>>>> report 'power_crit' value. So, adding their respective device ids.
>>>>
>>>> Also, according to BKDGs, the 'TdpRunAvgAccCap' that show_power()
>>>> uses is valid only on Fam15h, Models 0x0-0xF. On all other processors
>>>> the field is 'Reserved'. So, return error if we are on any other family/model.
>>>>
>>>> Impact on lm-sensors is minimal. On such families, instead of reporting
>>>> Current power value as '0', we now have:
>>>> power1:           N/A
>>>>
>>> It will result in people complaining to us about it.
>>>
>>> It would be more appropriate to not create the attribute the first place
>>> if it is not supported. Sure, that is a bit more code, but it isn't that bad.
>>> You can simply return -ENODEV for unsupported CPUs from the probe function.
>>>
>>>
>>>> Signed-off-by: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
>>>> ---
>>>>   drivers/hwmon/fam15h_power.c | 6 ++++++
>>>>   1 file changed, 6 insertions(+)
>>>>
>>>> diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
>>>> index 4a7cbfa..b69bf7d 100644
>>>> --- a/drivers/hwmon/fam15h_power.c
>>>> +++ b/drivers/hwmon/fam15h_power.c
>>>> @@ -57,6 +57,10 @@ static ssize_t show_power(struct device *dev,
>>>>   	struct fam15h_power_data *data = dev_get_drvdata(dev);
>>>>   	struct pci_dev *f4 = data->pdev;
>>>> +	/* The value TdpRunAvgAccCap is valid only on F15h, Models 0x0-0xF */
>>>> +	if (boot_cpu_data.x86 != 0x15 || boot_cpu_data.x86_model > 0x0)
>>> The comment does not match the code. The comment talks about accepting models
>>> F15h, models 0x0-0xF, but the code rejects anything but F15h model 0x0.
>> Ah. Yes, The condition should have been (..boot_cpu_data.x86_model > 0xf)
>>
>>> Now it may well be that the above describes identifies all F15h and F16h CPUs,
>>> but this is not clear from the comment. It rather looks as if anything but F15h,
>>> model 0x0 is rejected, including all F16h CPUs. But then why accept F16h CPUs
>>> in the first place ?
>> Yes, we want to reject anything but F15h, Models 00h-0fh.
>> The reason I included the newer processor IDs, (and let
>> PCI_DEVICE_ID_AMD_16H_NB_F4) remain
>> is because we can still obtain 'critical power value'. It is only
>> the 'current power' that is not exposed.
>>
> That is a behavioral change, though; previously the current power was
> reported for F16h chips with PCI ID PCI_DEVICE_ID_AMD_16H_NB_F4.
> Is this a bug, ie should the power value not have been reported
> for the F16h chips ?

That's right.

>> If we return -ENODEV in the probe function (or we can just remove
>> the listed PCI_DEVICE_ID), then we'd not get the critical power
>> values too.
>>
> If you want to make the actual power reporting conditional, you should
> introduce an is_visible function to the attribute group to ensure that
> power1_input is only reported if/when supported. If the actual power
> value is not really supported for F16h chips, you should actually provide
> two separate patches: One to make power1_input optional, to be reported for
> supported chips only, and another to add more chips. One is a bug fix,
> the other a functionality extension.
>

Ok, I'll do that and resend.

Thanks,
-Aravind.

>
>>>> +		return -ENOSYS;
>>>> +
>>>>   	pci_bus_read_config_dword(f4->bus, PCI_DEVFN(PCI_SLOT(f4->devfn), 5),
>>>>   				  REG_TDP_RUNNING_AVERAGE, &val);
>>>>   	running_avg_capture = (val >> 4) & 0x3fffff;
>>>> @@ -216,7 +220,9 @@ static int fam15h_power_probe(struct pci_dev *pdev,
>>>>   static const struct pci_device_id fam15h_power_id_table[] = {
>>>>   	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
>>>> +	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F4) },
>>>>   	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_NB_F4) },
>>>> +	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_M30H_NB_F3) },
>>>>   	{}
>>>>   };
>>>>   MODULE_DEVICE_TABLE(pci, fam15h_power_id_table);
>>>> -- 
>>>> 2.0.3
>>>>

