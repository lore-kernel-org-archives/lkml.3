Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbaATS2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 13:28:44 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:40958 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaATS2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 13:28:37 -0500
Message-ID: <1390242438.587.16.camel@localhost>
Subject: Re: [BUG] at drivers/md/raid5.c:291! kernel 3.13-rc8
From: Ian Kumlien <ian.kumlien@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Date: Mon, 20 Jan 2014 19:27:18 +0100
In-Reply-To: <20140120143748.33bb52d2@notabene.brown>
References: <1390168823.587.1.camel@localhost>
	 <20140120113851.3b476ed8@notabene.brown> <1390178957.587.9.camel@localhost>
	 <20140120143748.33bb52d2@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On mån, 2014-01-20 at 14:37 +1100, NeilBrown wrote:
> 
> Thanks - that extra info is quite useful.  Knowing that nothing else unusual
> is happening can be quite valuable (and I don't like to assume).
> 
> I haven't found anything that would clearly cause your crash, but I have
> found something that looks wrong and conceivably could.
> 
> Could you please try this patch on top of what you are currently using?  By
> the look of it you get a crash at least every day, often more often.  So if
> this produces a day with no crashes, that would be promising.
> 
> The important aspect of the patch is that it moves the "atomic_inc" of
> "sh->count" back under the protection of ->device_lock in the case when some
> other thread might be using the same 'sh'.

I have been unable to trip this up, so this was it!

Tested-by: Ian Kumlien <ian.kumlien@gmail.com>

I hope this hits stable ASAP ;)

> Thanks,
> NeilBrown
> 
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 3088d3af5a89..03f82ab87d9e 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -675,8 +675,10 @@ get_active_stripe(struct r5conf *conf, sector_t sector,
>  					 || !conf->inactive_blocked),
>  					*(conf->hash_locks + hash));
>  				conf->inactive_blocked = 0;
> -			} else
> +			} else {
>  				init_stripe(sh, sector, previous);
> +				atomic_inc(&sh->count);
> +			}
>  		} else {
>  			spin_lock(&conf->device_lock);
>  			if (atomic_read(&sh->count)) {
> @@ -695,13 +697,11 @@ get_active_stripe(struct r5conf *conf, sector_t sector,
>  					sh->group = NULL;
>  				}
>  			}
> +			atomic_inc(&sh->count);
>  			spin_unlock(&conf->device_lock);
>  		}
>  	} while (sh == NULL);
>  
> -	if (sh)
> -		atomic_inc(&sh->count);
> -
>  	spin_unlock_irq(conf->hash_locks + hash);
>  	return sh;
>  }


