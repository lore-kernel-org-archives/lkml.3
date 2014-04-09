Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965038AbaDIWHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 18:07:17 -0400
Received: from smtp04.udag.de ([62.146.106.30]:36798 "EHLO smtp04.udag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933776AbaDIWHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 18:07:13 -0400
Message-ID: <5345C48B.9060600@cevel.net>
Date: Thu, 10 Apr 2014 00:07:07 +0200
From: Tolga Cakir <tolga@cevel.net>
Reply-To: tolga@cevel.net
Organization: Cevel Network
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
CC: Derya <derya.kiran@yahoo.de>, Jiri Kosina <jkosina@suse.cz>,
        Reyad Attiyat <reyad.attiyat@gmail.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] HID: microsoft: moving quirks to struct
References: <1396631173-11668-1-git-send-email-tolga@cevel.net> <CAN+gG=FFnK7NwiGN1oLsBA6euyDHOxrY6s7-yRo553jcLbzuYQ@mail.gmail.com>
In-Reply-To: <CAN+gG=FFnK7NwiGN1oLsBA6euyDHOxrY6s7-yRo553jcLbzuYQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.04.2014 22:40, schrieb Benjamin Tissoires:
> On Fri, Apr 4, 2014 at 1:06 PM, Tolga Cakir <tolga@cevel.net> wrote:
>> This will give us the opportunity to easily implement extra features
>> for new devices.
>>
>> Signed-off-by: Tolga Cakir <tolga@cevel.net>
>> ---
>>   drivers/hid/hid-microsoft.c | 44 ++++++++++++++++++++++++++++----------------
>>   1 file changed, 28 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
>> index 6fd5817..0a61403 100644
>> --- a/drivers/hid/hid-microsoft.c
>> +++ b/drivers/hid/hid-microsoft.c
>> @@ -30,23 +30,28 @@
>>   #define MS_DUPLICATE_USAGES    0x20
>>   #define MS_RDESC_3K            0x40
>>
>> +struct ms_data {
>> +       unsigned long quirks;
>> +       void *extra;
> I do not like having a void * pointer in this kind of struct,
> especially when it is not used in the current patch.
> Please remove it in v2
Hi Benjamin, thank you for the review!

Yes you're right, I will change that in v2.
>> +};
>> +
>>   static __u8 *ms_report_fixup(struct hid_device *hdev, __u8 *rdesc,
>>                  unsigned int *rsize)
>>   {
>> -       unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
>> +       struct ms_data *sc = hid_get_drvdata(hdev);
>>
>>          /*
>>           * Microsoft Wireless Desktop Receiver (Model 1028) has
>>           * 'Usage Min/Max' where it ought to have 'Physical Min/Max'
>>           */
>> -       if ((quirks & MS_RDESC) && *rsize == 571 && rdesc[557] == 0x19 &&
>> +       if ((sc->quirks & MS_RDESC) && *rsize == 571 && rdesc[557] == 0x19 &&
>>                          rdesc[559] == 0x29) {
>>                  hid_info(hdev, "fixing up Microsoft Wireless Receiver Model 1028 report descriptor\n");
>>                  rdesc[557] = 0x35;
>>                  rdesc[559] = 0x45;
>>          }
>>          /* the same as above (s/usage/physical/) */
>> -       if ((quirks & MS_RDESC_3K) && *rsize == 106 && rdesc[94] == 0x19 &&
>> +       if ((sc->quirks & MS_RDESC_3K) && *rsize == 106 && rdesc[94] == 0x19 &&
>>                          rdesc[95] == 0x00 && rdesc[96] == 0x29 &&
>>                          rdesc[97] == 0xff) {
>>                  rdesc[94] = 0x35;
>> @@ -142,15 +147,15 @@ static int ms_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>>                  struct hid_field *field, struct hid_usage *usage,
>>                  unsigned long **bit, int *max)
>>   {
>> -       unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
>> +       struct ms_data *sc = hid_get_drvdata(hdev);
>>
>> -       if (quirks & MS_ERGONOMY) {
>> +       if (sc->quirks & MS_ERGONOMY) {
>>                  int ret = ms_ergonomy_kb_quirk(hi, usage, bit, max);
>>                  if (ret)
>>                          return ret;
>>          }
>>
>> -       if ((quirks & MS_PRESENTER) &&
>> +       if ((sc->quirks & MS_PRESENTER) &&
>>                          ms_presenter_8k_quirk(hi, usage, bit, max))
>>                  return 1;
>>
>> @@ -161,9 +166,9 @@ static int ms_input_mapped(struct hid_device *hdev, struct hid_input *hi,
>>                  struct hid_field *field, struct hid_usage *usage,
>>                  unsigned long **bit, int *max)
>>   {
>> -       unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
>> +       struct ms_data *sc = hid_get_drvdata(hdev);
>>
>> -       if (quirks & MS_DUPLICATE_USAGES)
>> +       if (sc->quirks & MS_DUPLICATE_USAGES)
>>                  clear_bit(usage->code, *bit);
>>
>>          return 0;
>> @@ -172,7 +177,7 @@ static int ms_input_mapped(struct hid_device *hdev, struct hid_input *hi,
>>   static int ms_event(struct hid_device *hdev, struct hid_field *field,
>>                  struct hid_usage *usage, __s32 value)
>>   {
>> -       unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
>> +       struct ms_data *sc = hid_get_drvdata(hdev);
>>          struct input_dev *input;
>>
>>          if (!(hdev->claimed & HID_CLAIMED_INPUT) || !field->hidinput ||
>> @@ -182,7 +187,7 @@ static int ms_event(struct hid_device *hdev, struct hid_field *field,
>>          input = field->hidinput->input;
>>
>>          /* Handling MS keyboards special buttons */
>> -       if (quirks & MS_ERGONOMY && usage->hid == (HID_UP_MSVENDOR | 0xff00)) {
>> +       if (sc->quirks & MS_ERGONOMY && usage->hid == (HID_UP_MSVENDOR | 0xff00)) {
>>                  /* Special keypad keys */
>>                  input_report_key(input, KEY_KPEQUAL, value & 0x01);
>>                  input_report_key(input, KEY_KPLEFTPAREN, value & 0x02);
>> @@ -190,7 +195,7 @@ static int ms_event(struct hid_device *hdev, struct hid_field *field,
>>                  return 1;
>>          }
>>
>> -       if (quirks & MS_ERGONOMY && usage->hid == (HID_UP_MSVENDOR | 0xff01)) {
>> +       if (sc->quirks & MS_ERGONOMY && usage->hid == (HID_UP_MSVENDOR | 0xff01)) {
>>                  /* Scroll wheel */
>>                  int step = ((value & 0x60) >> 5) + 1;
>>
>> @@ -205,7 +210,7 @@ static int ms_event(struct hid_device *hdev, struct hid_field *field,
>>                  return 1;
>>          }
>>
>> -       if (quirks & MS_ERGONOMY && usage->hid == (HID_UP_MSVENDOR | 0xff05)) {
>> +       if (sc->quirks & MS_ERGONOMY && usage->hid == (HID_UP_MSVENDOR | 0xff05)) {
>>                  static unsigned int last_key = 0;
>>                  unsigned int key = 0;
>>                  switch (value) {
>> @@ -229,12 +234,19 @@ static int ms_event(struct hid_device *hdev, struct hid_field *field,
>>
>>   static int ms_probe(struct hid_device *hdev, const struct hid_device_id *id)
>>   {
>> -       unsigned long quirks = id->driver_data;
>> +       struct ms_data *sc;
>>          int ret;
>>
>> -       hid_set_drvdata(hdev, (void *)quirks);
>> +       sc = devm_kzalloc(&hdev->dev, sizeof(struct ms_data), GFP_KERNEL);
>> +       if (!sc) {
>> +               hid_err(hdev, "can't alloc microsoft descriptor\n");
> How about: "Can not allocate microsoft data"?
>
> I have no idea where this "descriptor" comes from.
>
> Besides these two nitpicks, the rest of the patch is:
> Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> Cheers,
> Benjamin
That sounds better, yeah :)! It was quite some time ago, when I came up 
with "descriptor".

I remember, that it was due to the "sc" I chose for ms_data. 
Unfortunately, I don't remember what "sc" is standing for, but it's also 
used in hid-sony. But I'm fine using your suggestion ;)!
>> +               return -ENOMEM;
>> +       }
>> +
>> +       sc->quirks = id->driver_data;
>> +       hid_set_drvdata(hdev, sc);
>>
>> -       if (quirks & MS_NOGET)
>> +       if (sc->quirks & MS_NOGET)
>>                  hdev->quirks |= HID_QUIRK_NOGET;
>>
>>          ret = hid_parse(hdev);
>> @@ -243,7 +255,7 @@ static int ms_probe(struct hid_device *hdev, const struct hid_device_id *id)
>>                  goto err_free;
>>          }
>>
>> -       ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT | ((quirks & MS_HIDINPUT) ?
>> +       ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT | ((sc->quirks & MS_HIDINPUT) ?
>>                                  HID_CONNECT_HIDINPUT_FORCE : 0));
>>          if (ret) {
>>                  hid_err(hdev, "hw start failed\n");
>> --
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

