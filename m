Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaCZHVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 03:21:23 -0400
Received: from senator.holtmann.net ([87.106.208.187]:43663 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaCZHVW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 03:21:22 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH] drivers:bluetooth:ath3k.c Fixed sparse warning for cast to restricted __le32
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1395815788-24666-1-git-send-email-surendra.tux@gmail.com>
Date: Wed, 26 Mar 2014 00:21:22 -0700
Cc: "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>, Joe Perches <joe@perches.com>,
        bt <linux-bluetooth@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <0154F030-52BE-4935-8150-1A96737E7413@holtmann.org>
References: <1395815788-24666-1-git-send-email-surendra.tux@gmail.com>
To: Surendra Patil <surendra.tux@gmail.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Surendra,

> To fix the sparse warning "cast to restricted __le32" marked
> "rom_version"  to __le32 instead of unsigned int in "struct ath3k_version"
> and added cpu_to_le32() for the expression assigning int value to "rom_version".
> Successfully built the module without warnings and errors on x86 machine with sparse.
> 
> Signed-off-by: Surendra Patil <surendra.tux@gmail.com>
> ---
> drivers/bluetooth/ath3k.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
> index be571fe..5564207 100644
> --- a/drivers/bluetooth/ath3k.c
> +++ b/drivers/bluetooth/ath3k.c
> @@ -50,7 +50,7 @@
> #define ATH3K_NAME_LEN				0xFF
> 
> struct ath3k_version {
> -	unsigned int	rom_version;
> +	__le32		rom_version;
> 	unsigned int	build_version;
> 	unsigned int	ram_version;
> 	unsigned char	ref_clock;

so I think this struct should be __packed in the first place and use strictly typed variables.

Seems like all fields have an endian issue.

> @@ -375,7 +375,7 @@ static int ath3k_load_patch(struct usb_device *udev)
> 		return ret;
> 	}
> 
> -	pt_version.rom_version = *(int *)(firmware->data + firmware->size - 8);
> +	pt_version.rom_version = cpu_to_le32(*(int *)(firmware->data + firmware->size - 8));
> 	pt_version.build_version = *(int *)
> 		(firmware->data + firmware->size - 4);

I have no idea what this code is doing since that is just crazy. The variables are unsigned int and are now casted into int and not to mention that it is unaligned access. Has this code every been run on anything other than x86 at all. Does it happen to just work by pure luck.

Regards

Marcel

