Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab3CSPAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:00:40 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:62944 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab3CSPAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:00:35 -0400
MIME-Version: 1.0
In-Reply-To: <1363557399-11822-1-git-send-email-dlaurie@chromium.org>
References: <1363557399-11822-1-git-send-email-dlaurie@chromium.org>
From: Kent Yoder <shpedoikal@gmail.com>
Date: Tue, 19 Mar 2013 10:00:02 -0500
Message-ID: <CAM0nabGd1kPJaEOUNS9A1GOYP757F2SezgqYjK1p3N4AvX0PsA@mail.gmail.com>
Subject: Re: [PATCH] TPM: Retry SaveState command in suspend path
To: Duncan Laurie <dlaurie@chromium.org>
Cc: Kent Yoder <key@linux.vnet.ibm.com>,
        Luigi Semenzato <semenzato@chromium.org>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Duncan,

On Sun, Mar 17, 2013 at 4:56 PM, Duncan Laurie <dlaurie@chromium.org> wrote:
> If the TPM has already been sent a SaveState command before the driver
> is loaded it may have problems sending that same command again later.
>
> This issue is seen with the Chromebook Pixel due to a firmware bug in
> the legacy mode boot path which is sending the SaveState command
> before booting the kernel.  More information is available at
> http://crbug.com/203524
>
> This change introduces a retry of the SaveState command in the suspend
> path in order to work around this issue.  A future firmware update
> should fix this but this is also a trivial workaround in the driver
> that has no effect on systems that do not show this problem.

  I'm not convinced that this needs to be upstream.  The simplest
route would seem to be to carry this out of tree until your firmware
is fixed.

Kent

> When this does happen the TPM responds with a non-fatal TPM_RETRY code
> that is defined in the specification:
>
>   The TPM is too busy to respond to the command immediately, but the
>   command could be resubmitted at a later time.  The TPM MAY return
>   TPM_RETRY for any command at any time.
>
> It can take several seconds before the TPM will respond again.  I
> measured a typical time between 3 and 4 seconds and the timeout is set
> at a safe 5 seconds.
>
> It is also possible to reproduce this with commands via /dev/tpm0.
> The bug linked above has a python script attached which can be used to
> test for this problem.  I tested a variety of TPMs from Infineon,
> Nuvoton, Atmel, and STMicro but was only able to reproduce this with
> LPC and I2C TPMs from Infineon.
>
> The TPM specification only loosely defines this behavior:
>
>   TPM Main Level 2 Part 3 v1.2 r116, section 3.3. TPM_SaveState:
>   The TPM MAY declare all preserved values invalid in response to any
>   command other than TPM_Init.
>
>   TCG PC Client BIOS Spec 1.21 section 8.3.1.
>   After issuing a TPM_SaveState command, the OS SHOULD NOT issue TPM
>   commands before transitioning to S3 without issuing another
>   TPM_SaveState command.
>
>   TCG PC Client TIS 1.21, section 4. Power Management:
>   The TPM_SaveState command allows a Static OS to indicate to the TPM
>   that the platform may enter a low power state where the TPM will be
>   required to enter into the D3 power state.  The use of the term "may"
>   is significant in that there is no requirement for the platform to
>   actually enter the low power state after sending the TPM_SaveState
>   command.  The software may, in fact, send subsequent commands after
>   sending the TPM_SaveState command.
>
> Change-Id: I52b41e826412688e5b6c8ddd3bb16409939704e9
> Signed-off-by: Duncan Laurie <dlaurie@chromium.org>
> ---
>  drivers/char/tpm/tpm.c | 31 +++++++++++++++++++++++++++----
>  drivers/char/tpm/tpm.h |  3 +++
>  2 files changed, 30 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index 0d2e82f..7c3b3dc 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -1337,7 +1337,7 @@ int tpm_pm_suspend(struct device *dev)
>  {
>         struct tpm_chip *chip = dev_get_drvdata(dev);
>         struct tpm_cmd_t cmd;
> -       int rc;
> +       int rc, try;
>
>         u8 dummy_hash[TPM_DIGEST_SIZE] = { 0 };
>
> @@ -1355,9 +1355,32 @@ int tpm_pm_suspend(struct device *dev)
>         }
>
>         /* now do the actual savestate */
> -       cmd.header.in = savestate_header;
> -       rc = transmit_cmd(chip, &cmd, SAVESTATE_RESULT_SIZE,
> -                         "sending savestate before suspend");
> +       for (try = 0; try < TPM_RETRY; try++) {
> +               cmd.header.in = savestate_header;
> +               rc = transmit_cmd(chip, &cmd, SAVESTATE_RESULT_SIZE, NULL);
> +
> +               /*
> +                * If the TPM indicates that it is too busy to respond to
> +                * this command then retry before giving up.  It can take
> +                * several seconds for this TPM to be ready.
> +                *
> +                * This can happen if the TPM has already been sent the
> +                * SaveState command before the driver has loaded.  TCG 1.2
> +                * specification states that any communication after SaveState
> +                * may cause the TPM to invalidate previously saved state.
> +                */
> +               if (rc != TPM_WARN_RETRY)
> +                       break;
> +               msleep(TPM_TIMEOUT_RETRY);
> +       }
> +
> +       if (rc)
> +               dev_err(chip->dev,
> +                       "Error (%d) sending savestate before suspend\n", rc);
> +       else if (try > 0)
> +               dev_warn(chip->dev, "TPM savestate took %dms\n",
> +                        try * TPM_TIMEOUT_RETRY);
> +
>         return rc;
>  }
>  EXPORT_SYMBOL_GPL(tpm_pm_suspend);
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 81b5201..0770d1d 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -32,10 +32,12 @@ enum tpm_const {
>         TPM_MINOR = 224,        /* officially assigned */
>         TPM_BUFSIZE = 4096,
>         TPM_NUM_DEVICES = 256,
> +       TPM_RETRY = 50,         /* 5 seconds */
>  };
>
>  enum tpm_timeout {
>         TPM_TIMEOUT = 5,        /* msecs */
> +       TPM_TIMEOUT_RETRY = 100 /* msecs */
>  };
>
>  /* TPM addresses */
> @@ -44,6 +46,7 @@ enum tpm_addr {
>         TPM_ADDR = 0x4E,
>  };
>
> +#define TPM_WARN_RETRY          0x800
>  #define TPM_WARN_DOING_SELFTEST 0x802
>  #define TPM_ERR_DEACTIVATED     0x6
>  #define TPM_ERR_DISABLED        0x7
> --
> 1.8.1.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
