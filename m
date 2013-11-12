Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab3KLBkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 20:40:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58011 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab3KLBk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 20:40:26 -0500
MIME-Version: 1.0
In-Reply-To: <1384183278-19787-4-git-send-email-tiwai@suse.de>
References: <1384183278-19787-1-git-send-email-tiwai@suse.de>
	<1384183278-19787-4-git-send-email-tiwai@suse.de>
Date: Tue, 12 Nov 2013 09:40:24 +0800
Message-ID: <CACVXFVOuDSRsDLJ3kvQcXgscVDtgkEhpsLxGvdRBscZd_Hmyzw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] firmware: Avoid bogus fallback warning
From: Ming Lei <ming.lei@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        amd64-microcode <amd64-microcode@amd64.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 11:21 PM, Takashi Iwai <tiwai@suse.de> wrote:
> The commit [3e358ac2bb5b: firmware: Be a bit more verbose about direct
> firmware loading failure] introduced a new warning message about
> falling back to user helper, but this isn't true when
> CONFIG_FW_LOADER_USER_HELPER isn't set.
>
> For avoiding the confusion, add a proper ifdef.  And now we can remove
> the dummy fw_load_from_user_helper(), too, since it's no longer called
> with CONFIG_FW_LOADER_USER_HELPER=n.
>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/base/firmware_class.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 7f48a6ffb0df..bb03c71bd94d 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -940,14 +940,6 @@ static void kill_requests_without_uevent(void)
>  #endif
>
>  #else /* CONFIG_FW_LOADER_USER_HELPER */
> -static inline int
> -fw_load_from_user_helper(struct firmware *firmware, const char *name,
> -                        struct device *device, bool uevent, bool nowait,
> -                        long timeout)
> -{
> -       return -ENOENT;
> -}
> -
>  /* No abort during direct loading */
>  #define is_fw_load_aborted(buf) false
>
> @@ -1097,11 +1089,13 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
>         if (ret) {
>                 dev_warn(device, "Direct firmware load failed with error %d\n",
>                          ret);
> +#ifdef CONFIG_FW_LOADER_USER_HELPER
>                 if (fallback) {
>                         dev_warn(device, "Falling back to user helper\n");

I think it is simpler to put above line at the entry of
fw_load_from_user_helper()
since we always do direct-loading first, and code should be cleaner.

Thanks,
--
Ming Lei
