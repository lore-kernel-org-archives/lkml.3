Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933947Ab3GPVva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 17:51:30 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:45541 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933561Ab3GPVv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 17:51:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Igor Gnatenko <i.gnatenko.brain@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Aaron Lu <aaron.lwe@gmail.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "seth.forshee@canonical.com" <seth.forshee@canonical.com>,
        "joeyli.kernel@gmail.com" <joeyli.kernel@gmail.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>
Subject: Re: [Update][PATCH] ACPI / video / i915: Remove ACPI backlight if firmware expects Windows 8
Date: Wed, 17 Jul 2013 00:01:24 +0200
Message-ID: <2132122.eIEvjmIrrj@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1373994495.9314.1.camel@x230>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com> <1373981554.1956.5.camel@ThinkPad-X230.localdomain> <1373994495.9314.1.camel@x230>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 16, 2013 05:08:16 PM Matthew Garrett wrote:
> On Tue, 2013-07-16 at 17:32 +0400, Igor Gnatenko wrote:
> > Hmm. I found regression in user-space. In GNOME (maybe and other DEs) we no longer see switch status of backlight.
> 
> Yeah, I can duplicate that. Rafael, we have to call
> acpi_video_init_brightness() even if we're not going to initialise the
> backlight - Thinkpads seem to use this as the trigger for enabling ACPI
> notifications rather than handling it in firmware. This seems to do the
> job:

Igor, does this additional patch from Matthew help?

Rafael


> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index 01b1a25..71865f7 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -900,6 +900,9 @@ static void acpi_video_device_find_cap(struct
> acpi_video_device *device)
>  		device->cap._DDC = 1;
>  	}
>  
> +	if (acpi_video_init_brightness(device))
> +		return;
> +
>  	if (acpi_video_verify_backlight_support()) {
>  		struct backlight_properties props;
>  		struct pci_dev *pdev;
> @@ -909,9 +912,6 @@ static void acpi_video_device_find_cap(struct
> acpi_video_device *device)
>  		static int count = 0;
>  		char *name;
>  
> -		result = acpi_video_init_brightness(device);
> -		if (result)
> -			return;
>  		name = kasprintf(GFP_KERNEL, "acpi_video%d", count);
>  		if (!name)
>  			return;
> 
> 
> -- 
> Matthew Garrett | mjg59@srcf.ucam.org
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
