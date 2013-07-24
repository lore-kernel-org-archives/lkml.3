Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab3GXPhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:37:47 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:57970 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab3GXPhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:37:45 -0400
MIME-Version: 1.0
In-Reply-To: <1374679746-12566-2-git-send-email-benjamin.tissoires@redhat.com>
References: <1374679746-12566-1-git-send-email-benjamin.tissoires@redhat.com>
	<1374679746-12566-2-git-send-email-benjamin.tissoires@redhat.com>
Date: Wed, 24 Jul 2013 18:37:45 +0300
Message-ID: <CAHp75Vcr1MP7eeKHK3pwh49R5Yy0-guQHBJjZ+WXyiR5MT+ZBg@mail.gmail.com>
Subject: Re: [PATCH 1/2] HID: trivial devm conversion for special hid drivers
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 6:29 PM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> It is safe to use devres allocation within the hid subsystem:
> - the devres release is called _after_ the call to .remove(), meaning
>   that no freed pointers will exists while removing the device
> - if a .probe() fails, devres releases all the allocated ressources
>   before going to the next driver: there will not be ghost ressources
>   attached to a hid device if several drivers are probed.
>
> Given that, we can clean up a little some of the HID drivers. These ones
> are trivial:
> - there is only one kzalloc in the driver
> - the .remove() callback contains only one kfree on top of hid_hw_stop()
> - the error path in the probe is easy enough to be manually checked

Thanks for the patch! I'm sorry I didn't find time to do what I was
talking about last time.

Few comments below.

> --- a/drivers/hid/hid-a4tech.c
> +++ b/drivers/hid/hid-a4tech.c

> @@ -104,29 +103,16 @@ static int a4_probe(struct hid_device *hdev, const struct hid_device_id *id)
>         ret = hid_parse(hdev);
>         if (ret) {
>                 hid_err(hdev, "parse failed\n");
> -               goto err_free;
> +               return ret;
>         }
>
>         ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
> -       if (ret) {
> +       if (ret)
>                 hid_err(hdev, "hw start failed\n");
> -               goto err_free;
> -       }
>
> -       return 0;

Isn't it better to leave explicit return 0? I think it would be fool
proof in case someone wants to add anything in the middle.

> -err_free:
> -       kfree(a4);
>         return ret;
>  }

> -static void a4_remove(struct hid_device *hdev)
> -{
> -       struct a4tech_sc *a4 = hid_get_drvdata(hdev);
> -
> -       hid_hw_stop(hdev);

Is it safe to remove this call?
This question is the same for all patched drivers.

-- 
With Best Regards,
Andy Shevchenko
