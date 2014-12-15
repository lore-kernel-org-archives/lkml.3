Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751103AbaLOLNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:13:25 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:50928 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaLOLNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:13:21 -0500
MIME-Version: 1.0
In-Reply-To: <20141214230628.85EB7660D3D@gitolite.kernel.org>
References: <20141214230628.85EB7660D3D@gitolite.kernel.org>
Date: Mon, 15 Dec 2014 12:13:19 +0100
X-Google-Sender-Auth: n4yKOXYbiaS0zkrsduRe2wM6cvo
Message-ID: <CAMuHMdWYqCDpceft22AT0dFkuw877JiHA1NkToFzehARu+fL6Q@mail.gmail.com>
Subject: Re: usb: gadget: hid: add configfs support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Felipe Balbi <balbi@ti.com>
Cc: USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 12:06 AM, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/;a=commit;h=21a9476a7ba847e413bf1c144d7c614532aed6dd
> Commit:     21a9476a7ba847e413bf1c144d7c614532aed6dd
> Parent:     5ca8d3ec9970f4798e68bd21a9d44db3d0ff4da7
> Refname:    refs/heads/master
> Author:     Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> AuthorDate: Thu Nov 6 11:12:03 2014 +0100
> Committer:  Felipe Balbi <balbi@ti.com>
> CommitDate: Thu Nov 6 16:18:19 2014 -0600
>
>     usb: gadget: hid: add configfs support
>
>     Make the hid function available for gadgets composed with configfs.
>

> --- a/drivers/usb/gadget/function/f_hid.c
> +++ b/drivers/usb/gadget/function/f_hid.c

> +
> +#define F_HID_OPT(name, prec, limit)                                   \
> +static ssize_t f_hid_opts_##name##_show(struct f_hid_opts *opts, char *page)\
> +{                                                                      \
> +       int result;                                                     \
> +                                                                       \
> +       mutex_lock(&opts->lock);                                        \
> +       result = sprintf(page, "%d\n", opts->name);                     \
> +       mutex_unlock(&opts->lock);                                      \
> +                                                                       \
> +       return result;                                                  \
> +}                                                                      \
> +                                                                       \
> +static ssize_t f_hid_opts_##name##_store(struct f_hid_opts *opts,      \
> +                                        const char *page, size_t len)  \
> +{                                                                      \
> +       int ret;                                                        \
> +       u##prec num;                                                    \
> +                                                                       \
> +       mutex_lock(&opts->lock);                                        \
> +       if (opts->refcnt) {                                             \
> +               ret = -EBUSY;                                           \
> +               goto end;                                               \
> +       }                                                               \
> +                                                                       \
> +       ret = kstrtou##prec(page, 0, &num);                             \
> +       if (ret)                                                        \
> +               goto end;                                               \
> +                                                                       \
> +       if (num > limit) {                                              \
> +               ret = -EINVAL;                                          \
> +               goto end;                                               \
> +       }                                                               \
> +       opts->name = num;                                               \
> +       ret = len;                                                      \
> +                                                                       \
> +end:                                                                   \
> +       mutex_unlock(&opts->lock);                                      \
> +       return ret;                                                     \
> +}                                                                      \
> +                                                                       \
> +static struct f_hid_opts_attribute f_hid_opts_##name =                 \
> +       __CONFIGFS_ATTR(name, S_IRUGO | S_IWUSR, f_hid_opts_##name##_show,\
> +                       f_hid_opts_##name##_store)
> +
> +F_HID_OPT(subclass, 8, 255);
> +F_HID_OPT(protocol, 8, 255);
> +F_HID_OPT(report_length, 16, 65536);

While all three of the above lines trigger a (false positive) compiler warning:

warning: comparison is always false due to limited range of data type

it's a bit sloppy to use "2^8-1" for the first two limits, and "2^16"
(without -1) for
the third limit.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
