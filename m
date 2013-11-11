Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab3KKPez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:34:55 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56831 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493Ab3KKPeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:34:50 -0500
Date: Mon, 11 Nov 2013 16:34:26 +0100
From: Borislav Petkov <bp@alien8.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        amd64-microcode@amd64.org
Subject: Re: [PATCH v2 1/3] firmware: Introduce request_firmware_direct()
Message-ID: <20131111153426.GA6630@pd.tnic>
References: <1384183278-19787-1-git-send-email-tiwai@suse.de>
 <1384183278-19787-2-git-send-email-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1384183278-19787-2-git-send-email-tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 04:21:16PM +0100, Takashi Iwai wrote:
> When CONFIG_FW_LOADER_USER_HELPER is set, request_firmware() falls
> back to the usermode helper for loading via udev when the direct
> loading fails.  But the recent udev takes way too long timeout (60
> seconds) for non-existing firmware.  This is unacceptable for the
> drivers like microcode loader where they load firmwares optionally,
> i.e. it's no error even if no requested file exists.
> 
> This patch provides a new helper function, request_firmware_direct().
> It behaves as same as request_firmware() except for that it doesn't
> fall back to usermode helper but returns an error immediately if the
> f/w can't be loaded directly in kernel.
> 
> Without CONFIG_FW_LOADER_USER_HELPER=y, request_firmware_direct() is
> just an alias of request_firmware(), due to obvious reason.
> 
> Tested-by: Prarit Bhargava <prarit@redhat.com>
> Acked-by: Ming Lei <ming.lei@canonical.com>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/base/firmware_class.c | 36 +++++++++++++++++++++++++++++++-----
>  include/linux/firmware.h      |  7 +++++++
>  2 files changed, 38 insertions(+), 5 deletions(-)

I like it, the 60 seconds thing has been a senseless PITA for no good
reason. I have always wondered what might change in 60 seconds wrt to us
being able to load the firmware...

> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index eb8fb94ae2c5..7f48a6ffb0df 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -1061,7 +1061,7 @@ static int assign_firmware_buf(struct firmware *fw, struct device *device,
>  /* called from request_firmware() and request_firmware_work_func() */
>  static int
>  _request_firmware(const struct firmware **firmware_p, const char *name,
> -		  struct device *device, bool uevent, bool nowait)
> +		  struct device *device, bool uevent, bool nowait, bool fallback)

Just a nitpick: three boolean args in a row starts to slowly look like a
function from the windoze API. Can we do:

_request_firmware(..., unsigned long flags)

instead and have nice bit flags for that?

That could be a nice cleanup ontop though. Other than that:

Acked-by: Borislav Petkov <bp@suse.de>

for all three.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
