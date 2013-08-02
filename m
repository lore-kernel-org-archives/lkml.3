Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab3HBXhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 19:37:41 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:52789 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187Ab3HBXhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 19:37:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Felipe Contreras <felipe.contreras@gmail.com>,
        Aaron Lu <aaron.lwe@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH] acpi: video: improve quirk check
Date: Sat, 03 Aug 2013 01:47:52 +0200
Message-ID: <3682340.ddGL4l7l22@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1375472229-1563-1-git-send-email-felipe.contreras@gmail.com>
References: <1375472229-1563-1-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 02, 2013 02:37:09 PM Felipe Contreras wrote:
> If the _BCL package is descending, the first level (br->levels[2]) will
> be 0, and if the number of levels matches the number of steps, we might
> confuse a returned level to mean the index.
> 
> For example:
> 
>   current_level = max_level = 100
>   test_level = 0
>   returned level = 100
> 
> In this case 100 means the level, not the index, and _BCM failed. But if
> the _BCL package is descending, the index of level 0 is also 100, so we
> assume _BQC is indexed, when it's not.
> 
> This causes all _BQC calls to return bogus values causing weird behavior
> from the user's perspective. For example: xbacklight -set 10; xbacklight
> -set 20; would flash to 90% and then slowly down to the desired level
> (20).
> 
> The solution is simple; test anything other than the first level (e.g.
> 1).
> 
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>

Looks reasonable.

Aaron, what do you think?

Rafael


> ---
> 
> On top of this we might want to test yet another value, because br->levels[3]
> might be the current value (although very unlikely).
> 
>  drivers/acpi/video.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index 0ec434d..e1284b8 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -689,7 +689,7 @@ static int acpi_video_bqc_quirk(struct acpi_video_device *device,
>  	 * Some systems always report current brightness level as maximum
>  	 * through _BQC, we need to test another value for them.
>  	 */
> -	test_level = current_level == max_level ? br->levels[2] : max_level;
> +	test_level = current_level == max_level ? br->levels[3] : max_level;
>  
>  	result = acpi_video_device_lcd_set_level(device, test_level);
>  	if (result)
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
