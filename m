Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbaDXO6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:58:32 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:40791 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757656AbaDXO63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:58:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140424144257.GF26661@saruman.home>
References: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
	<1398342897-23670-2-git-send-email-cw00.choi@samsung.com>
	<20140424144257.GF26661@saruman.home>
Date: Thu, 24 Apr 2014 23:58:29 +0900
Message-ID: <CAGTfZH0+VCvr=JNbq8kbtC2CDN63k28+oSd__6sb+Qy2tQ4_ng@mail.gmail.com>
Subject: Re: [PATCHv3 1/9] extcon: Add extcon_dev_allocate/free() to control
 the memory of extcon device
From: Chanwoo Choi <cwchoi00@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        gg@slimlogic.co.uk, Kishon Vijay Abraham I <kishon@ti.com>,
        ckeepax@opensource.wolfsonmicro.com, Mark Brown <broonie@kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Apr 24, 2014 at 11:42 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Thu, Apr 24, 2014 at 09:34:49PM +0900, Chanwoo Choi wrote:
>> This patch add APIs to control the extcon device on extcon provider driver.
>> The extcon_dev_allocate() allocates the memory of extcon device and initializes
>> supported cables. And then extcon_dev_free() decrement the reference of the
>> device of extcon device and free the memory of the extcon device. This APIs
>> must need to implement devm_extcon_dev_allocate()/free() APIs.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>>  drivers/extcon/extcon-class.c | 39 +++++++++++++++++++++++++++++++++++++++
>>  include/linux/extcon.h        | 13 +++++++++++++
>>  2 files changed, 52 insertions(+)
>>
>> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
>> index f6df689..bec66d4 100644
>> --- a/drivers/extcon/extcon-class.c
>> +++ b/drivers/extcon/extcon-class.c
>> @@ -565,6 +565,45 @@ static void dummy_sysfs_dev_release(struct device *dev)
>>  {
>>  }
>>
>> +/*
>> + * extcon_dev_allocate() - Allocate the memory of extcon device.
>> + * @supported_cable: Array of supported cable names ending with NULL.
>> + *                   If supported_cable is NULL, cable name related APIs
>> + *                   are disabled.
>> + *
>> + * This function allocates the memory for extcon device without allocating
>> + * memory in each extcon provider driver and initialize default setting for
>> + * extcon device.
>> + *
>> + * Return the pointer of extcon device if success or ERR_PTR(err) if fail
>> + */
>> +struct extcon_dev *extcon_dev_allocate(const char **supported_cable)
>> +{
>> +     struct extcon_dev *edev;
>> +
>> +     edev = kzalloc(sizeof(*edev), GFP_KERNEL);
>> +     if (!edev) {
>> +             pr_err("Failed to allocate the memory for extcon device\n");
>> +             return ERR_PTR(-ENOMEM);
>> +     }
>> +
>> +     edev->max_supported = 0;
>> +     edev->supported_cable = supported_cable;
>> +
>> +     return edev;
>> +}
>> +
>> +/*
>> + * extcon_dev_free() - Free the memory of extcon device.
>> + * @edev:    the extcon device to free
>> + */
>> +void extcon_dev_free(struct extcon_dev *edev)
>> +{
>> +     if (edev)
>> +             kfree(edev);
>
> kfree(NULL) is safe

I don't understand about meaning 'kfree(NULL)'.
Why do I free 'NULL' pointer' instead of 'edev' pointer?
