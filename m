Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaG1IcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:32:05 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:62764 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbaG1Ib7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:31:59 -0400
MIME-Version: 1.0
In-Reply-To: <1406393198-5306-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1406393198-5306-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Mon, 28 Jul 2014 10:31:58 +0200
Message-ID: <CANq1E4RudWAmim_xsuhrtVE_OSLn6fTON+oUT3u-r3JL4LhtjA@mail.gmail.com>
Subject: Re: [PATCH] hid: uhid.c: Cleaning up missing null-terminate in
 conjunction with strncpy
From: David Herrmann <dh.herrmann@gmail.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: David Herrmann <dh.herrmann@googlemail.com>, Jiri Kosina <jkosina@suse.cz>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sat, Jul 26, 2014 at 6:46 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
> And removed unnecessary magic numbers.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/hid/uhid.c |   18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
> index 0cb92e3..b72ab0c 100644
> --- a/drivers/hid/uhid.c
> +++ b/drivers/hid/uhid.c
> @@ -392,12 +392,9 @@ static int uhid_dev_create(struct uhid_device *uhid,
>                 goto err_free;
>         }
>
> -       strncpy(hid->name, ev->u.create.name, 127);
> -       hid->name[127] = 0;
> -       strncpy(hid->phys, ev->u.create.phys, 63);
> -       hid->phys[63] = 0;
> -       strncpy(hid->uniq, ev->u.create.uniq, 63);
> -       hid->uniq[63] = 0;
> +       strlcpy(hid->name, ev->u.create.name, sizeof(hid->name));
> +       strlcpy(hid->phys, ev->u.create.phys, sizeof(hid->phys));
> +       strlcpy(hid->uniq, ev->u.create.uniq, sizeof(hid->uniq));

NAK, this patch is wrong. strlcpy() is *not* a replacement for
strncpy(). Please see lib/string.c or the man-page of strlcpy(3). It
calls strlen() on the source, which strncpy() does not. "ev" was
copied unmodified from user-space and might not be NULL-terminated,
therefore, strncpy() is the right choice.

Btw., please avoid commit-messages that sound like bug-fixes, which
this definitely is not. hid_allocate_device() cleans the object to
ZERO, therefore, you're guaranteed that there's a proper
NULL-terminator, independent of the contents of ev->u.xyz.

Thanks
David

>         hid->ll_driver = &uhid_hid_driver;
>         hid->bus = ev->u.create.bus;
> @@ -452,12 +449,9 @@ static int uhid_dev_create2(struct uhid_device *uhid,
>                 goto err_free;
>         }
>
> -       strncpy(hid->name, ev->u.create2.name, 127);
> -       hid->name[127] = 0;
> -       strncpy(hid->phys, ev->u.create2.phys, 63);
> -       hid->phys[63] = 0;
> -       strncpy(hid->uniq, ev->u.create2.uniq, 63);
> -       hid->uniq[63] = 0;
> +       strlcpy(hid->name, ev->u.create2.name, sizeof(hid->name));
> +       strlcpy(hid->phys, ev->u.create2.phys, sizeof(hid->phys));
> +       strlcpy(hid->uniq, ev->u.create2.uniq, sizeof(hid->uniq));
>
>         hid->ll_driver = &uhid_hid_driver;
>         hid->bus = ev->u.create2.bus;
> --
> 1.7.10.4
>
