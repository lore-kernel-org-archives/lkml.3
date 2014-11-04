Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaKDIqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:46:31 -0500
Received: from mail-bn1bbn0109.outbound.protection.outlook.com ([157.56.111.109]:5082
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752062AbaKDIq1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:46:27 -0500
X-WSS-ID: 0NEIAAN-08-WEG-02
X-M-MSG: 
Message-ID: <54588230.1080601@amd.com>
Date: Tue, 4 Nov 2014 15:37:20 +0800
From: Vincent Wan <vincent.wan@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ray" <Ray.Huang@amd.com>, Wan Zongshun <mcuos.com@gmail.com>,
        Arindam Nath <arindam.nath@amd.com>
Subject: Re: [PATCH] mmc: Add a quirk for AMD SDHC transfer mode register
 need to be cleared for cmd without data
References: <541A7F3D.70909@amd.com>	<5451B943.3060104@amd.com>
 <CAPDyKFoaN3WoYhsMoA1LRmOoyBpMdmX+ShzdD4ObKcFVTBbkFw@mail.gmail.com>
In-Reply-To: <CAPDyKFoaN3WoYhsMoA1LRmOoyBpMdmX+ShzdD4ObKcFVTBbkFw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-Originating-IP: [10.237.74.192]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(51704005)(71364002)(24454002)(199003)(41574002)(4396001)(110136001)(106466001)(97736003)(23676002)(99396003)(84676001)(102836001)(50466002)(68736004)(83506001)(95666004)(105586002)(62966003)(120916001)(107046002)(64126003)(77156002)(117636001)(59896002)(87936001)(64706001)(44976005)(47776003)(20776003)(65956001)(19580395003)(31966008)(92726001)(46102003)(36756003)(86362001)(50986999)(99136001)(65816999)(101416001)(87266999)(19580405001)(92566001)(54356999)(21056001)(76176999)(62816006)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB206;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB206;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03853D523D
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Vincent.Wan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年11月04日 15:51, Ulf Hansson wrote:
> On 30 October 2014 05:06, Vincent Wan <vincent.wan@amd.com> wrote:
>> SDHC controller in AMD chipsets require SDHC transfer mode
>> register to be cleared for commands without data. The issue was
>> uncovered during testing eMMC cards on KB/ML based platforms.
>>
>> Signed-off-by: Vincent Wan <vincent.wan@amd.com>
>> Signed-off-by: Arindam Nath <arindam.nath@amd.com>
>> Tested-by: Vikram B <vikram.b@amd.com>
>> Tested-by: Raghavendra Swamy <raghavendra.swamy@amd.com>
>
> Hi Vincent,
>
> This looks good to me, but the patch has checkpatch errors.
>
> Could you check at your side and re-send?
>
> Kind regards
> Uffe
>

Hi Ulf,

My email tool causes this issue, so I have already sent patch v2 to you.

Thanks!
Vincent Wan.
>>
>> ---
>>   drivers/mmc/host/sdhci-pci.c | 27 +++++++++++++++++++++++++++
>>   drivers/mmc/host/sdhci.c     | 11 ++++++++---
>>   include/linux/mmc/sdhci.h    |  2 ++
>>   3 files changed, 37 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
>> index 6119297..8f5c998 100644
>> --- a/drivers/mmc/host/sdhci-pci.c
>> +++ b/drivers/mmc/host/sdhci-pci.c
>> @@ -645,6 +645,23 @@ static const struct sdhci_pci_fixes sdhci_rtsx = {
>>          .probe_slot     = rtsx_probe_slot,
>>   };
>>
>> +static int amd_probe(struct sdhci_pci_chip *chip)
>> +{
>> +       struct pci_dev  *smbus_dev;
>> +
>> +       smbus_dev = pci_get_device(PCI_VENDOR_ID_AMD,
>> +                       PCI_DEVICE_ID_AMD_HUDSON2_SMBUS, NULL);
>> +
>> +       if (smbus_dev && (smbus_dev->revision < 0x51))
>> +               chip->quirks2 |=
>> SDHCI_QUIRK2_CLEAR_TRANSFERMODE_REG_BEFORE_CMD;
>> +
>> +       return 0;
>> +}
>> +
>> +static const struct sdhci_pci_fixes sdhci_amd = {
>> +       .probe          = amd_probe,
>> +};
>> +
>>   static const struct pci_device_id pci_ids[] = {
>>          {
>>                  .vendor         = PCI_VENDOR_ID_RICOH,
>> @@ -1045,6 +1062,16 @@ static const struct pci_device_id pci_ids[] = {
>>                  .driver_data    = (kernel_ulong_t)&sdhci_o2,
>>          },
>>
>> +       {
>> +               .vendor         = PCI_VENDOR_ID_AMD,
>> +               .device         = PCI_ANY_ID,
>> +               .class          = PCI_CLASS_SYSTEM_SDHCI << 8,
>> +               .class_mask     = 0xFFFF00,
>> +               .subvendor      = PCI_ANY_ID,
>> +               .subdevice      = PCI_ANY_ID,
>> +               .driver_data    = (kernel_ulong_t)&sdhci_amd,
>> +       },
>> +
>>          {       /* Generic SD host controller */
>>                  PCI_DEVICE_CLASS((PCI_CLASS_SYSTEM_SDHCI << 8), 0xFFFF00)
>>          },
>> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
>> index ada1a3e..8085f26 100644
>> --- a/drivers/mmc/host/sdhci.c
>> +++ b/drivers/mmc/host/sdhci.c
>> @@ -889,10 +889,15 @@ static void sdhci_set_transfer_mode(struct sdhci_host
>> *host,
>>          struct mmc_data *data = cmd->data;
>>
>>          if (data == NULL) {
>> -               /* clear Auto CMD settings for no data CMDs */
>> -               mode = sdhci_readw(host, SDHCI_TRANSFER_MODE);
>> -               sdhci_writew(host, mode & ~(SDHCI_TRNS_AUTO_CMD12 |
>> +               if (host->quirks2 &
>> +                       SDHCI_QUIRK2_CLEAR_TRANSFERMODE_REG_BEFORE_CMD) {
>> +                       sdhci_writew(host, 0x0, SDHCI_TRANSFER_MODE);
>> +               } else {
>> +                       /* clear Auto CMD settings for no data CMDs */
>> +                       mode = sdhci_readw(host, SDHCI_TRANSFER_MODE);
>> +                       sdhci_writew(host, mode & ~(SDHCI_TRNS_AUTO_CMD12 |
>>                                  SDHCI_TRNS_AUTO_CMD23),
>> SDHCI_TRANSFER_MODE);
>> +               }
>>                  return;
>>          }
>>
>> diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
>> index dba793e..0a287aa 100644
>> --- a/include/linux/mmc/sdhci.h
>> +++ b/include/linux/mmc/sdhci.h
>> @@ -100,6 +100,8 @@ struct sdhci_host {
>>   #define SDHCI_QUIRK2_BROKEN_DDR50                      (1<<7)
>>   /* Stop command (CMD12) can set Transfer Complete when not using
>> MMC_RSP_BUSY */
>>   #define SDHCI_QUIRK2_STOP_WITH_TC                      (1<<8)
>> +/* need clear transfer mode register before send cmd */
>> +#define SDHCI_QUIRK2_CLEAR_TRANSFERMODE_REG_BEFORE_CMD (1<<9)
>>
>>          int irq;                /* Device IRQ */
>>          void __iomem *ioaddr;   /* Mapped address */
>> --
>> 1.8.1.2
>>

