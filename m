Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab3E3N2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 09:28:40 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:53871 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab3E3N2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 09:28:19 -0400
MIME-Version: 1.0
In-Reply-To: <1369858343-681-1-git-send-email-andy.shevchenko@gmail.com>
References: <1369817109-4277-1-git-send-email-benjamin.tissoires@redhat.com>
	<1369858343-681-1-git-send-email-andy.shevchenko@gmail.com>
Date: Thu, 30 May 2013 15:28:17 +0200
Message-ID: <CAN+gG=G6yXwrPONwO9C04ZB6d4peW=0O7XbgMC3+qwjqPU-R2Q@mail.gmail.com>
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

Hi Andy,

On Wed, May 29, 2013 at 10:12 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> mt_free_input_name() was never called during .remove(): hid_hw_stop()
> removes the hid_input items in hdev->inputs, and so the list is
> therefore empty after the call. In the end, we never free the special
> names that has been allocated during .probe().
>
> We switch to devm_kzalloc that manages resources when driver is removed.
>
> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Reported-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  drivers/hid/hid-multitouch.c |   37 +++++++++++++------------------------
>  1 files changed, 13 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index d99b959..1f5876e 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -261,14 +261,6 @@ static struct mt_class mt_classes[] = {
>         { }
>  };
>
> -static void mt_free_input_name(struct hid_input *hi)
> -{
> -       struct hid_device *hdev = hi->report->device;
> -
> -       if (hi->input->name != hdev->name)
> -               kfree(hi->input->name);
> -}
> -
>  static ssize_t mt_show_quirks(struct device *dev,
>                            struct device_attribute *attr,
>                            char *buf)
> @@ -412,10 +404,12 @@ static void mt_pen_report(struct hid_device *hid, struct hid_report *report)
>  static void mt_pen_input_configured(struct hid_device *hdev,
>                                         struct hid_input *hi)
>  {
> -       char *name = kzalloc(strlen(hi->input->name) + 5, GFP_KERNEL);
> -       if (name) {
> -               sprintf(name, "%s Pen", hi->input->name);
> -               mt_free_input_name(hi);
> +       char *name;
> +
> +       if (hdev->name) {

hdev->name is always not null, so no need to check this (hint: it
contains hid->name when allocated).

> +               name = devm_kzalloc(&hdev->dev, strlen(hdev->name) + 5,
> +                                                       GFP_KERNEL);

Does devm_kzalloc always return a valid pointer? If not, you should
just use devm_kzalloc instead of kzalloc and keep the old ordering of
allocation, test, and snprintf.

> +               sprintf(name, "%s Pen", hdev->name);
>                 hi->input->name = name;
>         }
>
> @@ -925,16 +919,18 @@ static void mt_post_parse(struct mt_device *td)
>  static void mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
>  {
>         struct mt_device *td = hid_get_drvdata(hdev);
> -       char *name = kstrdup(hdev->name, GFP_KERNEL);
> -
> -       if (name)
> -               hi->input->name = name;
>
>         if (hi->report->id == td->mt_report_id)
>                 mt_touch_input_configured(hdev, hi);
>
>         if (hi->report->id == td->pen_report_id)
>                 mt_pen_input_configured(hdev, hi);
> +
> +       if (!hi->input->name) {

will never happen, so can be dropped.

> +               hi->input->name = devm_kzalloc(&hdev->dev,
> +                                       strlen(hdev->name) + 1, GFP_KERNEL);
> +               strcpy(hi->input->name, hdev->name);
> +       }
>  }
>
>  static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
> @@ -993,7 +989,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
>
>         ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
>         if (ret)
> -               goto hid_fail;
> +               goto fail;
>
>         ret = sysfs_create_group(&hdev->dev.kobj, &mt_attribute_group);
>
> @@ -1005,9 +1001,6 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
>
>         return 0;
>
> -hid_fail:
> -       list_for_each_entry(hi, &hdev->inputs, list)
> -               mt_free_input_name(hi);
>  fail:
>         kfree(td->fields);
>         kfree(td);
> @@ -1037,14 +1030,10 @@ static int mt_resume(struct hid_device *hdev)
>  static void mt_remove(struct hid_device *hdev)
>  {
>         struct mt_device *td = hid_get_drvdata(hdev);
> -       struct hid_input *hi;
>
>         sysfs_remove_group(&hdev->dev.kobj, &mt_attribute_group);
>         hid_hw_stop(hdev);
>
> -       list_for_each_entry(hi, &hdev->inputs, list)
> -               mt_free_input_name(hi);
> -
>         kfree(td);
>         hid_set_drvdata(hdev, NULL);
>  }
> --
> 1.7.7.6
>

Cheers,
Benjamin
