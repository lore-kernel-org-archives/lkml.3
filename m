Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab3GXQoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 12:44:00 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:61842 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab3GXQn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 12:43:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAHp75VeuLi=_jN7xfjNvJgpxGgHRw+tg=qV+kkEbPtR72hPj5g@mail.gmail.com>
References: <1374679746-12566-1-git-send-email-benjamin.tissoires@redhat.com>
	<1374679746-12566-3-git-send-email-benjamin.tissoires@redhat.com>
	<CAHp75VeuLi=_jN7xfjNvJgpxGgHRw+tg=qV+kkEbPtR72hPj5g@mail.gmail.com>
Date: Wed, 24 Jul 2013 18:43:57 +0200
Message-ID: <CAN+gG=FVZQPsbncg8ZsPDLQq9NURPKs3N5XeK89crQ4V5cwEJw@mail.gmail.com>
Subject: Re: [PATCH 2/2] HID: multitouch: devm conversion
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 5:44 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Wed, Jul 24, 2013 at 6:29 PM, Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
>> HID special drivers can use safely the devres API.
>> Use it to remove 25 lines of code and to clean up a little the error paths.
>>
>> Besides the pur kzalloc -> devm_kzalloc conversions, I changed the
>
> Typo 'pur' -> 'put'

oops, sorry. I'll use "basic" in the next version.

>
>> place of the allocation of the new name. Doing this right in
>> mt_input_configured() removes the kstrdup call which was not very helpful
>> and the new way is simpler to understand (and to debug).
>
> Thanks for the patch! I'm sorry I didn't find time to do this by myself.
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

Thanks!

Cheers,
Benjamin

>
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>> ---
>>  drivers/hid/hid-multitouch.c | 71 ++++++++++++++------------------------------
>>  1 file changed, 23 insertions(+), 48 deletions(-)
>>
>> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
>> index cb0e361..0fe00e2 100644
>> --- a/drivers/hid/hid-multitouch.c
>> +++ b/drivers/hid/hid-multitouch.c
>> @@ -261,17 +261,6 @@ static struct mt_class mt_classes[] = {
>>         { }
>>  };
>>
>> -static void mt_free_input_name(struct hid_input *hi)
>> -{
>> -       struct hid_device *hdev = hi->report->device;
>> -       const char *name = hi->input->name;
>> -
>> -       if (name != hdev->name) {
>> -               hi->input->name = hdev->name;
>> -               kfree(name);
>> -       }
>> -}
>> -
>>  static ssize_t mt_show_quirks(struct device *dev,
>>                            struct device_attribute *attr,
>>                            char *buf)
>> @@ -415,13 +404,6 @@ static void mt_pen_report(struct hid_device *hid, struct hid_report *report)
>>  static void mt_pen_input_configured(struct hid_device *hdev,
>>                                         struct hid_input *hi)
>>  {
>> -       char *name = kzalloc(strlen(hi->input->name) + 5, GFP_KERNEL);
>> -       if (name) {
>> -               sprintf(name, "%s Pen", hi->input->name);
>> -               mt_free_input_name(hi);
>> -               hi->input->name = name;
>> -       }
>> -
>>         /* force BTN_STYLUS to allow tablet matching in udev */
>>         __set_bit(BTN_STYLUS, hi->input->keybit);
>>  }
>> @@ -928,16 +910,26 @@ static void mt_post_parse(struct mt_device *td)
>>  static void mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
>>  {
>>         struct mt_device *td = hid_get_drvdata(hdev);
>> -       char *name = kstrdup(hdev->name, GFP_KERNEL);
>> -
>> -       if (name)
>> -               hi->input->name = name;
>> +       char *name;
>> +       const char *suffix = NULL;
>>
>>         if (hi->report->id == td->mt_report_id)
>>                 mt_touch_input_configured(hdev, hi);
>>
>> -       if (hi->report->id == td->pen_report_id)
>> +       if (hi->report->field[0]->physical == HID_DG_STYLUS) {
>> +               suffix = "Pen";
>>                 mt_pen_input_configured(hdev, hi);
>> +       }
>> +
>> +       if (suffix) {
>> +               name = devm_kzalloc(&hi->input->dev,
>> +                                   strlen(hdev->name) + strlen(suffix) + 2,
>> +                                   GFP_KERNEL);
>> +               if (name) {
>> +                       sprintf(name, "%s %s", hdev->name, suffix);
>> +                       hi->input->name = name;
>> +               }
>> +       }
>>  }
>>
>>  static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
>> @@ -945,7 +937,6 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
>>         int ret, i;
>>         struct mt_device *td;
>>         struct mt_class *mtclass = mt_classes; /* MT_CLS_DEFAULT */
>> -       struct hid_input *hi;
>>
>>         for (i = 0; mt_classes[i].name ; i++) {
>>                 if (id->driver_data == mt_classes[i].name) {
>> @@ -967,7 +958,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
>>         hdev->quirks |= HID_QUIRK_MULTI_INPUT;
>>         hdev->quirks |= HID_QUIRK_NO_EMPTY_INPUT;
>>
>> -       td = kzalloc(sizeof(struct mt_device), GFP_KERNEL);
>> +       td = devm_kzalloc(&hdev->dev, sizeof(struct mt_device), GFP_KERNEL);
>>         if (!td) {
>>                 dev_err(&hdev->dev, "cannot allocate multitouch data\n");
>>                 return -ENOMEM;
>> @@ -980,11 +971,11 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
>>         td->pen_report_id = -1;
>>         hid_set_drvdata(hdev, td);
>>
>> -       td->fields = kzalloc(sizeof(struct mt_fields), GFP_KERNEL);
>> +       td->fields = devm_kzalloc(&hdev->dev, sizeof(struct mt_fields),
>> +                                 GFP_KERNEL);
>>         if (!td->fields) {
>>                 dev_err(&hdev->dev, "cannot allocate multitouch fields data\n");
>> -               ret = -ENOMEM;
>> -               goto fail;
>> +               return -ENOMEM;
>>         }
>>
>>         if (id->vendor == HID_ANY_ID && id->product == HID_ANY_ID)
>> @@ -992,29 +983,22 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
>>
>>         ret = hid_parse(hdev);
>>         if (ret != 0)
>> -               goto fail;
>> +               return ret;
>>
>>         ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
>>         if (ret)
>> -               goto hid_fail;
>> +               return ret;
>>
>>         ret = sysfs_create_group(&hdev->dev.kobj, &mt_attribute_group);
>>
>>         mt_set_maxcontacts(hdev);
>>         mt_set_input_mode(hdev);
>>
>> -       kfree(td->fields);
>> +       /* release .fields memory as it is not used anymore */
>> +       devm_kfree(&hdev->dev, td->fields);
>>         td->fields = NULL;
>>
>>         return 0;
>> -
>> -hid_fail:
>> -       list_for_each_entry(hi, &hdev->inputs, list)
>> -               mt_free_input_name(hi);
>> -fail:
>> -       kfree(td->fields);
>> -       kfree(td);
>> -       return ret;
>>  }
>>
>>  #ifdef CONFIG_PM
>> @@ -1039,17 +1023,8 @@ static int mt_resume(struct hid_device *hdev)
>>
>>  static void mt_remove(struct hid_device *hdev)
>>  {
>> -       struct mt_device *td = hid_get_drvdata(hdev);
>> -       struct hid_input *hi;
>> -
>>         sysfs_remove_group(&hdev->dev.kobj, &mt_attribute_group);
>> -       list_for_each_entry(hi, &hdev->inputs, list)
>> -               mt_free_input_name(hi);
>> -
>>         hid_hw_stop(hdev);
>> -
>> -       kfree(td);
>> -       hid_set_drvdata(hdev, NULL);
>>  }
>>
>>  static const struct hid_device_id mt_devices[] = {
>> --
>> 1.8.3.1
>>
>
>
>
> --
> With Best Regards,
> Andy Shevchenko
