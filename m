Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbaDXPDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:03:35 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:41998 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757903AbaDXPDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:03:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140424144458.GG26661@saruman.home>
References: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
	<1398342897-23670-3-git-send-email-cw00.choi@samsung.com>
	<20140424144458.GG26661@saruman.home>
Date: Fri, 25 Apr 2014 00:03:31 +0900
Message-ID: <CAGTfZH3bZk1_Yrhig_uWDtF5+6u+ePfuqJa9rDCWBJ1GH+AmkQ@mail.gmail.com>
Subject: Re: [PATCHv3 2/9] extcon: Add devm_extcon_dev_allocate/free to manage
 the resource of extcon device
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

On Thu, Apr 24, 2014 at 11:44 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Thu, Apr 24, 2014 at 09:34:50PM +0900, Chanwoo Choi wrote:
>> This patch add device managed devm_extcon_dev_{allocate,free} to automatically
>> free the memory of extcon_dev structure without handling free operation.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>>  drivers/extcon/extcon-class.c | 70 +++++++++++++++++++++++++++++++++++--------
>>  include/linux/extcon.h        | 11 +++++++
>>  2 files changed, 69 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
>> index bec66d4..f369168 100644
>> --- a/drivers/extcon/extcon-class.c
>> +++ b/drivers/extcon/extcon-class.c
>> @@ -604,6 +604,64 @@ void extcon_dev_free(struct extcon_dev *edev)
>>  }
>>  EXPORT_SYMBOL_GPL(extcon_dev_free);
>>
>> +static int devm_extcon_dev_match(struct device *dev, void *res, void *data)
>> +{
>> +     struct extcon_dev **r = res;
>> +
>> +     if (!r || !*r) {
>> +             WARN_ON(!r || !*r);
>> +             return 0;
>> +     }
>> +
>> +     return *r == data;
>> +}
>> +
>> +static void devm_extcon_dev_release(struct device *dev, void *res)
>> +{
>> +     extcon_dev_free(*(struct extcon_dev **)res);
>> +}
>> +
>> +/**
>> + * devm_extcon_dev_allocate - Allocate managed extcon device
>> + * @dev:             device owning the extcon device being created
>> + * @supported_cable: Array of supported cable names ending with NULL.
>> + *                   If supported_cable is NULL, cable name related APIs
>> + *                   are disabled.
>> + *
>> + * This function manages automatically the memory of extcon device using device
>> + * resource management and simplify the control of freeing the memory of extcon
>> + * device.
>> + *
>> + * Returns the pointer memory of allocated extcon_dev if success or NULL if fail
>> + */
>> +struct extcon_dev *devm_extcon_dev_allocate(struct device *dev,
>> +                                         const char **supported_cable)
>> +{
>> +     struct extcon_dev **ptr, *edev;
>> +
>> +     ptr = devres_alloc(devm_extcon_dev_release, sizeof(*ptr), GFP_KERNEL);
>> +     if (!ptr)
>> +             return NULL;
>
> if this fails you return NULL;
>
>> +
>> +     edev = extcon_dev_allocate(supported_cable);
>
> if this fails, you return -ENOMEM. Not very nice, if you ask me.

I'll fix it as following:

If  both extcon_dev_allocate() and devm_excon_dev_allocate() failed to
allocate memory,
two functions would return NULL pointer instead of  ERR_PTR(-ENOMEM).

Thanks,
Chanwoo Choi
