Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbaCWGdk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 02:33:40 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:53358 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaCWGdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 02:33:39 -0400
Date: Sun, 23 Mar 2014 01:33:06 -0500
From: David Fries <David@Fries.net>
To: Richard Weinberger <richard@nod.at>
Cc: zbr@ioremap.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1: Fix refcount leak in netlink connector
Message-ID: <20140323063306.GA5096@spacedout.fries.net>
References: <1394320128-26505-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394320128-26505-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Sun, 23 Mar 2014 01:33:07 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been doing an overhaul of the w1 netlink system and have a patch
outstanding to address this issue.  It requires patches already
accepted in gregkh char-misc-next.

w1: fix netlink refcnt leak on error path

I avoided the issue by checking the length before taking any
references to avoid adding another goto target.  Actually the changes
in char-misc-next removed one goto target so with my patch series that
routine only has one jump target, much easier to track what's going on
than having three.

Accepted patches (still need to apply the refcnt patch)
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git char-misc-next

Here's my current set of patches on top of char-misc-next.
7cf8baf26cdc2c27bcff562e9b2328ac891dc3a5
https://github.com/dfries/linux.git w1_rework

For my setup I have 14 ds18b20 one wire temperature sensors inside and
outside of my house connected to the ds2490 USB dongle that I have a
program talking over netlink to read every 30 seconds.  I'm curious
what's your setup?  I would appreciate it if I could get some testers
on the w1_rework branch and verify it doesn't break anything with
other programs.

The biggest user visible changes from the w1_rework branch are.
w1: new netlink commands, add/remove/list slaves
w1: process w1 netlink commands in w1_process thread
w1: reply only to the requester portid
ds2490 hardware search, much faster search in general, 23 seconds to .3 seconds
w1: fix netlink refcnt leak on error path
w1: optional bundling of netlink kernel replies

With all these changes the program is no longer blocked when issuing
commands because the w1_process thread now executes them.  That's a
pretty big deal if your program has something else to do while waiting
for a reply.  Then there's the optional bundling, so I can now send
one netlink packet which will request a conversion or read a previous
conversion for all temperature sensors and the kernel will reply with
one netlink packet with all the status or results, instead of
something like 56 individual packets.

On Sun, Mar 09, 2014 at 12:08:48AM +0100, Richard Weinberger wrote:
> If userspace sends a w1 message of length 0 we leak
> the refcount.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/w1/w1_netlink.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c
> index 40788c9..7131777 100644
> --- a/drivers/w1/w1_netlink.c
> +++ b/drivers/w1/w1_netlink.c
> @@ -355,7 +355,7 @@ static void w1_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
>  
>  		err = 0;
>  		if (!mlen)
> -			goto out_cont;
> +			goto out_dec;
>  
>  		mutex_lock(&dev->mutex);
>  
> @@ -384,10 +384,11 @@ static void w1_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
>  			mlen -= cmd->len + sizeof(struct w1_netlink_cmd);
>  		}
>  out_up:
> +		mutex_unlock(&dev->mutex);
> +out_dec:
>  		atomic_dec(&dev->refcnt);
>  		if (sl)
>  			atomic_dec(&sl->refcnt);
> -		mutex_unlock(&dev->mutex);
>  out_cont:
>  		if (!cmd || err)
>  			w1_netlink_send_error(msg, m, cmd, err);
> -- 
> 1.8.4.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
David Fries <david@fries.net>    PGP pub CB1EE8F0
http://fries.net/~david/
