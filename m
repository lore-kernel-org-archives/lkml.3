Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbaILOGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:06:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52777 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754793AbaILOGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:06:04 -0400
Date: Fri, 12 Sep 2014 10:06:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Petr Mladek <pmladek@suse.cz>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
        Joe Lawrence <joe.lawrence@stratus.com>, Jiri Kosina <jkosina@suse.cz>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: hub: wrong order of putting interfaces when processing
 hub events
In-Reply-To: <1410524421-15191-1-git-send-email-pmladek@suse.cz>
Message-ID: <Pine.LNX.4.44L0.1409121000590.1180-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014, Petr Mladek wrote:

> usb_autopm_put_interface() must be called only when usb_autopm_get_interface()
> succeeded before. There was wrong ordering of the goto targets.

No, you are wrong.  The code is correct as it stands.

> The funny thing is that the names of the goto targets and the related comments
> were correct.

That's because the whole thing is correct.  Go back and read the 
comments more carefully -- especially the comment following the "loop:" 
label.

> Signed-off-by: Petr Mladek <pmladek@suse.cz>
> ---
>  drivers/usb/core/hub.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index d481c99a20d7..6afd79ee3340 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -5132,12 +5132,12 @@ static void hub_events(void)
>  
>   loop_autopm:
>  		/* Balance the usb_autopm_get_interface() above */
> -		usb_autopm_put_interface_no_suspend(intf);
> +		usb_autopm_put_interface(intf);

There's no point to this change.  Now this call will decrement the
usage counter and try to suspend -- but the suspend is bound to fail
because the usage counter is still > 0.

>   loop:
>  		/* Balance the usb_autopm_get_interface_no_resume() in
>  		 * kick_khubd() and allow autosuspend.
>  		 */
> -		usb_autopm_put_interface(intf);
> +		usb_autopm_put_interface_no_suspend(intf);

And now this call will decrement the usage counter down to 0, but won't 
try to suspend -- so the hub won't autosuspend at all!

>   loop_disconnected:
>  		usb_unlock_device(hdev);
>  		usb_put_dev(hdev);

Alan Stern

