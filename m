Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab3A3LsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 06:48:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45475 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab3A3LsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 06:48:18 -0500
MIME-Version: 1.0
In-Reply-To: <s5h8v7brkqe.wl%tiwai@suse.de>
References: <1359470814-7993-1-git-send-email-tiwai@suse.de>
	<1359470814-7993-2-git-send-email-tiwai@suse.de>
	<CACVXFVOf4LZD+qVcqS9yBtvNZCRF=LMpR5BKuXby3Z8dfB+Vzw@mail.gmail.com>
	<s5hpq0nw35i.wl%tiwai@suse.de>
	<CACVXFVN9JNe6US655hh3cNpKyJFdWrLEYOOOdnk97_5bFmZYxw@mail.gmail.com>
	<s5hfw1jrmhn.wl%tiwai@suse.de>
	<CACVXFVNmhpfHgM4BVMDi3tffN4ajinUqnZD7c3fPvTL26EDDRA@mail.gmail.com>
	<s5hd2wnrlgl.wl%tiwai@suse.de>
	<s5h8v7brkqe.wl%tiwai@suse.de>
Date: Wed, 30 Jan 2013 19:48:15 +0800
Message-ID: <CACVXFVMqxrjBKSnRENHYhd5=pfp3L2LchOzo8cLbp4eo1ph6FA@mail.gmail.com>
Subject: Re: [PATCH 1/4] firmware: Refactoring for splitting user-mode helper code
From: Ming Lei <ming.lei@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 7:08 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Wed, 30 Jan 2013 11:53:14 +0100,
> Takashi Iwai wrote:
>>
>> At Wed, 30 Jan 2013 18:50:05 +0800,
>> Ming Lei wrote:
>> >
>> > On Wed, Jan 30, 2013 at 6:31 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> > >
>> > > But it's supposed to be cached, no?
>> >
>> > Generally it will be cached, but some crazy devices might come as new
>> > device during resume, so we still need to handle the situation.
>>
>> In that case, shouldn't we simply return an error instead of
>> usermodehelper lock (at least for direct loading)?
>
> The patch below is what I have in my mind...
>
>
> Takashi
>
> ---
> From: Takashi Iwai <tiwai@suse.de>
> Subject: [PATCH] firmware: Skip usermodehelper_lock for direct loading
>
> We don't need a user mode helper lock for the direct fw loading.
> This also reduces the use of timeout when user mode helper is
> disabled, thus we can move the code into ifdef block, too.
>
> For avoiding the possible call of request_firmware() without caching,
> add a check of suspend state for the direct loading case, and returns
> immediately if it's called during suspend/resume.  Then it proceeds to
> the user mode helper if enabled, or returns the error.
>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/base/firmware_class.c | 97 ++++++++++++++++++++++++-------------------
>  1 file changed, 54 insertions(+), 43 deletions(-)
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index f1caad7..c973bb0 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -88,13 +88,6 @@ enum {
>         FW_STATUS_ABORT,
>  };
>
> -static int loading_timeout = 60;       /* In seconds */
> -
> -static inline long firmware_loading_timeout(void)
> -{
> -       return loading_timeout > 0 ? loading_timeout * HZ : MAX_SCHEDULE_TIMEOUT;
> -}
> -
>  struct firmware_cache {
>         /* firmware_buf instance will be added into the below list */
>         spinlock_t lock;
> @@ -315,6 +308,9 @@ static bool fw_get_filesystem_firmware(struct device *device,
>         bool success = false;
>         char *path = __getname();
>
> +       if (device->power.is_suspended)
> +               return false;

The device which is requesting firmware is resumed  does not mean the
storage device has been resumed, so this check isn't enough.

Thanks,
--
Ming Lei
