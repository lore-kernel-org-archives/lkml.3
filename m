Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbbA2I65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:58:57 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55917 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbbA2I6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:58:55 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-2e-54c9f5bcc90d
Message-id: <54C9F64C.10505@samsung.com>
Date: Thu, 29 Jan 2015 09:58:52 +0100
From: Karol Wrona <k.wrona@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.4.0
MIME-version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>
Subject: Re: [RFC PATCH 1/1] mmc: dw_mmc: Add runtime pm to dw_mmc
References: <1421858639-14737-1-git-send-email-k.wrona@samsung.com>
 <1421858639-14737-2-git-send-email-k.wrona@samsung.com>
 <CAPDyKFpTT3J-D6CqPcUdcTq4d=tMy7dDSn_ZZJGD12qeey4p9A@mail.gmail.com>
In-reply-to: <CAPDyKFpTT3J-D6CqPcUdcTq4d=tMy7dDSn_ZZJGD12qeey4p9A@mail.gmail.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xK7p7vp4MMViyksti44z1rBY3frWx
	WpxtesNucXnXHDaLI//7GS0+3L/IbHF8bbjFnnVbmBw4PHbOusvucefaHjaPvi2rGD0+b5IL
	YInisklJzcksSy3St0vgyri4+yFLwV2BiqtTH7I0MPbydjFyckgImEic+97OBmGLSVy4tx7M
	FhJYyijx8qNoFyMXkP2JUeLJmkNMIAleAQ2JRa9vsoLYLAKqErO7Z4LZbALqEs07FjOD2KIC
	ERLzj71mhqgXlPgx+R4LiC0C1Lvn4XlWkKHMAgeZJM6+7AcrEhZwkviyvYsNYtsRRonrK2Yx
	giQ4BYIlPl9dApTgAOpQl5gyJRckzCwgL7F5zVvmCYwCs5DsmIVQNQtJ1QJG5lWMoqmlyQXF
	Sem5hnrFibnFpXnpesn5uZsYISH+ZQfj4mNWhxgFOBiVeHhnbjoZIsSaWFZcmXuIUYKDWUmE
	V/wNUIg3JbGyKrUoP76oNCe1+BAjEwenVANjJ+/OrjMndp48tUF5VvaimBsLLl/64p1ZuSsl
	qG/a/9zN7nz/tZ1adsS9nbReYDv75yaJTb0CgrFBXksX6G7aH/i9YOvC4MSdK4MuBXZtsm3c
	eP3za79IHkmf/wHes7vYsqRu9V/be/ypV7G63sQJrl29JzjPvZs3/1Pms8XMzdEn/zHa7xZb
	psRSnJFoqMVcVJwIAGXTgMJPAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2015 10:02 AM, Ulf Hansson wrote:
> On 21 January 2015 at 17:43, Karol Wrona <k.wrona@samsung.com> wrote:
>> This patch adds runtime pm handling to dw_mmc and enables it for dw_mmc-exynos.
>> It mainly uses mci_request/mci_request_end for mmc host state information.
>>
>> Signed-off-by: Karol Wrona <k.wrona@samsung.com>
>> ---
>>  drivers/mmc/host/dw_mmc-exynos.c |   69 ++++++++++++++++++++++++++++++++++++--
>>  drivers/mmc/host/dw_mmc.c        |   65 +++++++++++++++++++++++++++++++++--
>>  2 files changed, 130 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
>> index 12a5eaa..7281c6f 100644
>> --- a/drivers/mmc/host/dw_mmc-exynos.c
>> +++ b/drivers/mmc/host/dw_mmc-exynos.c
>> @@ -17,12 +17,15 @@
[...]
>>
>> +#define DWMMC_AUTOSUSPEND_DELAY 200
> 
> Normally we use 50 as default. Any reason to why you can't use that?
> 
Thanks for looking at that.
No special reason. I will check lower delay value.

> Hmm, maybe we should have such a default defined in a common mmc host
> header file!?
Will do.
> 
>> +
>>  /* Variations in Exynos specific dw-mshc controller */
>>  enum dw_mci_exynos_type {
>>         DW_MCI_TYPE_EXYNOS4210,
>> @@ -97,6 +100,30 @@ static int dw_mci_exynos_setup_clock(struct dw_mci *host)
>>         return 0;
>>  }
>>
>> +#ifdef CONFIG_PM
>> +static int dw_mci_exynos_runtime_suspend(struct device *dev)
>> +{
>> +       struct dw_mci *host = dev_get_drvdata(dev);
>> +
>> +       /* empty for now */
>> +
>> +       return 0;
>> +}
>> +
>> +static int dw_mci_exynos_runtime_resume(struct device *dev)
>> +{
>> +       struct dw_mci *host = dev_get_drvdata(dev);
>> +
>> +       /* empty for now */
>> +
>> +       return 0;
>> +}
>> +#else
>> +#define dw_mci_exynos_runtime_suspend          NULL
>> +#define dw_mci_exynos_runtime_resume           NULL
>> +
>> +#endif /* CONFIG_PM */
> 
> I would suggest you to remove all the above code from this patch. If
> you want to add the callbacks, let's anyway do that from a separate
> patch.
Will do.

Thanks,
Karol
