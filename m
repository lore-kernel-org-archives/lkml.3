Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab3FDNoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 09:44:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46481 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab3FDNob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 09:44:31 -0400
MIME-Version: 1.0
In-Reply-To: <1563703.RysIHVehbx@wuerfel>
References: <1563703.RysIHVehbx@wuerfel>
Date: Tue, 4 Jun 2013 21:44:29 +0800
Message-ID: <CACVXFVMcVfec7tTLsxFDCav-cB7cc74s-XkN=4a1toDBJC_e0w@mail.gmail.com>
Subject: Re: [PATCH] driver core: firmware loader: fix build error
From: Ming Lei <ming.lei@canonical.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Thanks for the fix.

On Tue, Jun 4, 2013 at 7:53 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> Patch af5bc11e9 "driver core: firmware loader: kill FW_ACTION_NOHOTPLUG
> requests before suspend" caused a regression for the case where
> CONFIG_FW_LOADER_USER_HELPER is not enabled, because it adds
> references to code that is not available in that configuration:
>
> drivers/base/firmware_class.c: In function 'kill_requests_without_uevent':
> drivers/base/firmware_class.c:1424:49: error: 'struct firmware_buf' has no member named 'pending_list'
>   list_for_each_entry_safe(buf, next, &pending_fw_head, pending_list) {
> drivers/base/firmware_class.c:1426:5: error: implicit declaration of function 'fw_load_abort' [-Werror=implicit-function-declaration]
>
> This fixes the build error by making the new code conditional
> as well. Found using ARM ape6evm_defconfig on today's linux-next.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Ming Lei <ming.lei@canonical.com>
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index c415043..6cca468 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -1417,6 +1417,7 @@ static void __device_uncache_fw_images(void)
>  /* kill pending requests without uevent to avoid blocking suspend */
>  static void kill_requests_without_uevent(void)
>  {
> +#ifdef CONFIG_FW_LOADER_USER_HELPER
>         struct firmware_buf *buf;
>         struct firmware_buf *next;
>
> @@ -1426,6 +1427,7 @@ static void kill_requests_without_uevent(void)
>                          fw_load_abort(buf);
>         }
>         mutex_unlock(&fw_lock);
> +#endif

Fenggang's kbuild robot captured the build failure, and a similar fix patch
has been posted out:

      http://marc.info/?l=linux-kernel&m=137031139632564&w=2

Thanks,
--
Ming Lei
