Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab3FANsj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 09:48:39 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:53541 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab3FANs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 09:48:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAHp75VeR3m=QJnJW3K=K_R5WQ+dKchJJsNAVB929a0KKUnVdGw@mail.gmail.com>
References: <1369817109-4277-1-git-send-email-benjamin.tissoires@redhat.com>
	<1369858343-681-1-git-send-email-andy.shevchenko@gmail.com>
	<CAN+gG=G6yXwrPONwO9C04ZB6d4peW=0O7XbgMC3+qwjqPU-R2Q@mail.gmail.com>
	<CAHp75VeR3m=QJnJW3K=K_R5WQ+dKchJJsNAVB929a0KKUnVdGw@mail.gmail.com>
Date: Sat, 1 Jun 2013 15:48:27 +0200
Message-ID: <CAN+gG=EmH51rre_O=oFL9Fin2Z7Z+pev6WdFACaYJs5NfZbDPg@mail.gmail.com>
Subject: Re: [PATCH] HID: multitouch: prevent memleak with the allocated name
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-input <linux-input@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 1, 2013 at 1:33 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Thu, May 30, 2013 at 4:28 PM, Benjamin Tissoires
> <benjamin.tissoires@gmail.com> wrote:
>> On Wed, May 29, 2013 at 10:12 PM, Andy Shevchenko
>> <andy.shevchenko@gmail.com> wrote:
>>> mt_free_input_name() was never called during .remove(): hid_hw_stop()
>>> removes the hid_input items in hdev->inputs, and so the list is
>>> therefore empty after the call. In the end, we never free the special
>>> names that has been allocated during .probe().
>>>
>>> We switch to devm_kzalloc that manages resources when driver is removed.
>
> Thanks for review. See my answers below.
>
>>> --- a/drivers/hid/hid-multitouch.c
>>> +++ b/drivers/hid/hid-multitouch.c
>
>>> @@ -412,10 +404,12 @@ static void mt_pen_report(struct hid_device *hid, struct hid_report *report)
>>>  static void mt_pen_input_configured(struct hid_device *hdev,
>>>                                         struct hid_input *hi)
>>>  {
>>> -       char *name = kzalloc(strlen(hi->input->name) + 5, GFP_KERNEL);
>>> -       if (name) {
>>> -               sprintf(name, "%s Pen", hi->input->name);
>>> -               mt_free_input_name(hi);
>>> +       char *name;
>>> +
>>> +       if (hdev->name) {
>>
>> hdev->name is always not null, so no need to check this (hint: it
>> contains hid->name when allocated).
>
> Okay, I'll fix it.

thanks. And sorry, I thought the test was against hi->input->name,
thus my "hint" which was exactly the same as what you tested.
Anyway, hdev->name is still never null, so the remark still applies.
>
>>> +               name = devm_kzalloc(&hdev->dev, strlen(hdev->name) + 5,
>>> +                                                       GFP_KERNEL);
>>
>> Does devm_kzalloc always return a valid pointer? If not, you should
>> just use devm_kzalloc instead of kzalloc and keep the old ordering of
>> allocation, test, and snprintf.
>
> Good point, will fix.
>
>>> @@ -925,16 +919,18 @@ static void mt_post_parse(struct mt_device *td)
>>>  static void mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
>>>  {
>>>         struct mt_device *td = hid_get_drvdata(hdev);
>>> -       char *name = kstrdup(hdev->name, GFP_KERNEL);
>>> -
>>> -       if (name)
>>> -               hi->input->name = name;
>>>
>>>         if (hi->report->id == td->mt_report_id)
>>>                 mt_touch_input_configured(hdev, hi);
>>>
>>>         if (hi->report->id == td->pen_report_id)
>>>                 mt_pen_input_configured(hdev, hi);
>>> +
>>> +       if (!hi->input->name) {
>>
>> will never happen, so can be dropped.
>
> Why not? As far as I understood this logic the input->name is assigned
> accordingly to what device is configured. Like input->name =
> hdev->name, except for pen it equals to hdev->name + " Pen". The last
> one is assigned in the mt_pen_input_configure. Otherwise input->name
> is NULL. Am I correct?

No. When the hid_input struct is allocated in hid-input.c, the field
hi->input->name is set to hdev->name (my previous "hint" should be
here).

The whole dirty part of the patch when I included the "Pen" in the
name was because of that: hi->input->name is never null, and it was
difficult to change this in hid-core.c without any side effects in the
other hid drivers.

Cheers,
Benjamin
