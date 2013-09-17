Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab3IQTJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 15:09:29 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:46199 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753789Ab3IQTJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 15:09:28 -0400
Message-ID: <5238A8E6.4000506@hurleysoftware.com>
Date: Tue, 17 Sep 2013 15:09:26 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: johnflux <johnflux@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Deadlock in fb and tty
References: <CAHQ6N+pQpfmG-b_9iv0Ajg5EYPjfEK0=KYcQa0DLVmyN8VKZrQ@mail.gmail.com> <52308D47.409@hurleysoftware.com> <1378992144394-718779.post@n7.nabble.com>
In-Reply-To: <1378992144394-718779.post@n7.nabble.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 09:22 AM, johnflux wrote:
> The following seems to be better:
>
>  From d93c1e9761ff66365d658da7d8d0d33823aa946f Mon Sep 17 00:00:00 2001
> From: John Tapsell<johnflux@gmail.com>
> Date: Thu, 12 Sep 2013 09:16:12 +0100
> Subject: [PATCH] Fix deadlock between fb_info and console.  Do not lock
>   fb_info when calling sending the FB_EVENT_CONBLANK
>
> In fbmem.c, the semantics are that we acquire the lock_fb_info first,
> and then console_lock.  However when fbcon.c fbcon_generic_blank() is
> called, the console lock could already be held.  Locking fb_info can
> thus cause a deadlock.
>
> fbmem.c sends the FB_EVENT_BLANK without locking lock_fb_info first, so
> this change introduces similar behaviour.
> ---
>   drivers/video/console/fbcon.c | 4 ----
>   1 file changed, 4 deletions(-)
>
> diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
> index 6b4fb5c..8546441 100644
> --- a/drivers/video/console/fbcon.c
> +++ b/drivers/video/console/fbcon.c
> @@ -2333,13 +2333,9 @@ static void fbcon_generic_blank(struct vc_data *vc,
> struct fb_info *info,
>                  vc->vc_video_erase_char = oldc;
>          }
>
> -
> -       if (!lock_fb_info(info))
> -               return;
>          event.info = info;
>          event.data = &blank;
>          fb_notifier_call_chain(FB_EVENT_CONBLANK, &event);
> -       unlock_fb_info(info);
>   }
>
>   static int fbcon_blank(struct vc_data *vc, int blank, int mode_switch)
> -- 1.8.1.2

> How can I get this reviewed/acked please?

The get_maintainer.pl script can help to discover to whom to
address patches. For example,

peter@thor:~/src/kernels/next$ ./scripts/get_maintainer.pl -f drivers/video/console/fbcon.c
Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com> (maintainer:FRAMEBUFFER LAYER)
Tomi Valkeinen <tomi.valkeinen@ti.com> (maintainer:FRAMEBUFFER LAYER)
Dave Airlie <airlied@redhat.com> (commit_signer:5/11=45%)
Greg Kroah-Hartman <gregkh@linuxfoundation.org> (commit_signer:4/11=36%)
Wang YanQing <udknight@gmail.com> (commit_signer:4/11=36%)
Andrew Morton <akpm@linux-foundation.org> (commit_signer:3/11=27%)
Kamal Mostafa <kamal@whence.com> (commit_signer:1/11=9%)
linux-fbdev@vger.kernel.org (open list:FRAMEBUFFER LAYER)
linux-kernel@vger.kernel.org (open list)

In this case, you'll want to send this patch addressed to the two maintainers
and cc linux-fbdev and linux-kernel. You can cc me if you want.

This is covered in Documentation/SubmittingPatches, which also covers the
required subject line format <hint: too long, needs subsystem identifier>.

Also, if you have the lockdep report of the deadlock, it's customary to
include it in the commit message.

Regards,
Peter Hurley

PS - Don't put stuff after the '--' tag at the end of the patch. Many
mailers treat that as don't care. I missed your question first time around
because Thunderbird grays that text :(

