Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbaHSXE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 19:04:26 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:53231 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaHSXEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 19:04:25 -0400
Message-ID: <53F3D7F3.3080900@gmail.com>
Date: Wed, 20 Aug 2014 09:04:19 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sanjeev Sharma <sanjeev_sharma@mentor.com>, cpw@sgi.com,
        robinmholt@gmail.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sgi-xp: Do not use BUG_ON(!spin_is_locked())
References: <1407828913-7461-1-git-send-email-sanjeev_sharma@mentor.com>
In-Reply-To: <1407828913-7461-1-git-send-email-sanjeev_sharma@mentor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/14 17:35, Sanjeev Sharma wrote:
> on some architecture spin_is_locked() always return false in
> uniprocessor configuration and can therefore not be used
> with BUG_ON.it would be advise to replace with
> lockdep_assert_held().
> 
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
> ---
>  drivers/misc/sgi-xp/xpc_channel.c | 6 +++---
>  drivers/misc/sgi-xp/xpc_sn2.c     | 2 +-
>  drivers/misc/sgi-xp/xpc_uv.c      | 2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/misc/sgi-xp/xpc_channel.c b/drivers/misc/sgi-xp/xpc_channel.c
> index 128d561..240fe5a 100644
> --- a/drivers/misc/sgi-xp/xpc_channel.c
> +++ b/drivers/misc/sgi-xp/xpc_channel.c
> @@ -28,7 +28,7 @@ xpc_process_connect(struct xpc_channel *ch, unsigned long *irq_flags)
>  {
>  	enum xp_retval ret;
>  
> -	DBUG_ON(!spin_is_locked(&ch->lock));
> +	lockdep_assert_held(!spin_is_locked(&ch->lock));

This is incorrect, and will break the build with CONFIG_LOCKDEP enabled.
You actually want:

	lockdep_assert_held(&ch->lock);

Same for the other instances.

~Ryan
