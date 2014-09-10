Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbaIJUDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 16:03:45 -0400
Received: from [207.46.100.130] ([207.46.100.130]:24655 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753172AbaIJUDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 16:03:43 -0400
X-Greylist: delayed 87646 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Sep 2014 16:03:43 EDT
X-WSS-ID: 0NBPBMN-08-9UP-02
X-M-MSG: 
Message-ID: <5410AE20.4080205@amd.com>
Date: Wed, 10 Sep 2014 15:01:36 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: <herrmann.der.user@googlemail.com>, <jdelvare@suse.de>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon, fam15h_power: Add support for two more processors
References: <1410368528-4738-1-git-send-email-aravind.gopalakrishnan@amd.com>
 <20140910175312.GA7079@roeck-us.net>
In-Reply-To: <20140910175312.GA7079@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019019)(6009001)(428002)(199003)(189002)(51704005)(24454002)(377454003)(479174003)(86362001)(101416001)(74502001)(76176999)(65816999)(85306004)(80316001)(44976005)(97736003)(87266999)(31966008)(74662001)(54356999)(102836001)(76482001)(46102001)(77982001)(79102001)(87936001)(83322001)(64126003)(85852003)(19580405001)(92566001)(19580395003)(92726001)(21056001)(68736004)(23756003)(50466002)(83072002)(81542001)(99396002)(81342001)(95666004)(64706001)(80022001)(65806001)(47776003)(20776003)(4396001)(90102001)(65956001)(50986999)(83506001)(84676001)(36756003)(110136001)(107046002)(105586002)(106466001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB040;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033054F29A
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/10/2014 12:53 PM, Guenter Roeck wrote:
> On Wed, Sep 10, 2014 at 12:02:08PM -0500, Aravind Gopalakrishnan wrote:
>> Fam16h,M30h(Mullins) and Fam15hM30h(Kaveri) processors can
>> report 'power_crit' value. So, adding their respective device ids.
>>
>> Also, according to BKDGs, the 'TdpRunAvgAccCap' that show_power()
>> uses is valid only on Fam15h, Models 0x0-0xF. On all other processors
>> the field is 'Reserved'. So, return error if we are on any other family/model.
>>
>> Impact on lm-sensors is minimal. On such families, instead of reporting
>> Current power value as '0', we now have:
>> power1:           N/A
>>
> It will result in people complaining to us about it.
>
> It would be more appropriate to not create the attribute the first place
> if it is not supported. Sure, that is a bit more code, but it isn't that bad.
> You can simply return -ENODEV for unsupported CPUs from the probe function.
>
>
>> Signed-off-by: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
>> ---
>>   drivers/hwmon/fam15h_power.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
>> index 4a7cbfa..b69bf7d 100644
>> --- a/drivers/hwmon/fam15h_power.c
>> +++ b/drivers/hwmon/fam15h_power.c
>> @@ -57,6 +57,10 @@ static ssize_t show_power(struct device *dev,
>>   	struct fam15h_power_data *data = dev_get_drvdata(dev);
>>   	struct pci_dev *f4 = data->pdev;
>>   
>> +	/* The value TdpRunAvgAccCap is valid only on F15h, Models 0x0-0xF */
>> +	if (boot_cpu_data.x86 != 0x15 || boot_cpu_data.x86_model > 0x0)
> The comment does not match the code. The comment talks about accepting models
> F15h, models 0x0-0xF, but the code rejects anything but F15h model 0x0.

Ah. Yes, The condition should have been (..boot_cpu_data.x86_model > 0xf)

> Now it may well be that the above describes identifies all F15h and F16h CPUs,
> but this is not clear from the comment. It rather looks as if anything but F15h,
> model 0x0 is rejected, including all F16h CPUs. But then why accept F16h CPUs
> in the first place ?

Yes, we want to reject anything but F15h, Models 00h-0fh.
The reason I included the newer processor IDs, (and let 
PCI_DEVICE_ID_AMD_16H_NB_F4) remain
is because we can still obtain 'critical power value'. It is only the 
'current power' that is not exposed.

If we return -ENODEV in the probe function (or we can just remove the 
listed PCI_DEVICE_ID), then we'd not get the critical power values too.

- Aravind.

>> +		return -ENOSYS;
>> +
>>   	pci_bus_read_config_dword(f4->bus, PCI_DEVFN(PCI_SLOT(f4->devfn), 5),
>>   				  REG_TDP_RUNNING_AVERAGE, &val);
>>   	running_avg_capture = (val >> 4) & 0x3fffff;
>> @@ -216,7 +220,9 @@ static int fam15h_power_probe(struct pci_dev *pdev,
>>   
>>   static const struct pci_device_id fam15h_power_id_table[] = {
>>   	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
>> +	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F4) },
>>   	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_NB_F4) },
>> +	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_M30H_NB_F3) },
>>   	{}
>>   };
>>   MODULE_DEVICE_TABLE(pci, fam15h_power_id_table);
>> -- 
>> 2.0.3
>>

