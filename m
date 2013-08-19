Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203Ab3HSQUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:20:20 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:64738 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab3HSQUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:20:17 -0400
MIME-Version: 1.0
In-Reply-To: <1376928619-3775-5-git-send-email-matthew.garrett@nebula.com>
References: <1376928619-3775-1-git-send-email-matthew.garrett@nebula.com>
	<1376928619-3775-5-git-send-email-matthew.garrett@nebula.com>
Date: Mon, 19 Aug 2013 09:20:17 -0700
X-Google-Sender-Auth: sPT5muUgmVOrSaVDrihDxWByHiM
Message-ID: <CAGXu5jJtvVx76ZZrk+s4KwopT-ocZcMbwWNM1ELxH4crm=QGLw@mail.gmail.com>
Subject: Re: [PATCH 05/10] asus-wmi: Restrict debugfs interface when module
 loading is restricted
From: Kees Cook <keescook@chromium.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 9:10 AM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> We have no way of validating what all of the Asus WMI methods do on a
> given machine, and there's a risk that some will allow hardware state to
> be manipulated in such a way that arbitrary code can be executed in the
> kernel, circumventing module loading restrictions. Prevent that if any of
> these features are enabled.
>
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> ---
>  drivers/platform/x86/asus-wmi.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
> index 19c313b..8105530 100644
> --- a/drivers/platform/x86/asus-wmi.c
> +++ b/drivers/platform/x86/asus-wmi.c
> @@ -1618,6 +1618,9 @@ static int show_dsts(struct seq_file *m, void *data)
>         int err;
>         u32 retval = -1;
>
> +       if (secure_modules())
> +               return -EPERM;
> +
>         err = asus_wmi_get_devstate(asus, asus->debug.dev_id, &retval);
>
>         if (err < 0)
> @@ -1634,6 +1637,9 @@ static int show_devs(struct seq_file *m, void *data)
>         int err;
>         u32 retval = -1;
>
> +       if (!capable(CAP_COMPROMISE_KERNEL))

Looks like this and the next chunk weren't changed to the
secure_modules() API...

-Kees

> +               return -EPERM;
> +
>         err = asus_wmi_set_devstate(asus->debug.dev_id, asus->debug.ctrl_param,
>                                     &retval);
>
> @@ -1658,6 +1664,9 @@ static int show_call(struct seq_file *m, void *data)
>         union acpi_object *obj;
>         acpi_status status;
>
> +       if (!capable(CAP_COMPROMISE_KERNEL))
> +               return -EPERM;
> +
>         status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID,
>                                      1, asus->debug.method_id,
>                                      &input, &output);
> --
> 1.8.3.1
>



-- 
Kees Cook
Chrome OS Security
