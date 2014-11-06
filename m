Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212AbaKFCjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 21:39:23 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:40924 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750905AbaKFCjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 21:39:18 -0500
Message-ID: <545ADF52.9030401@hurleysoftware.com>
Date: Wed, 05 Nov 2014 21:39:14 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH -next v2 10/26] tty: Don't take tty_mutex for tty count
 changes
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com> <1415207589-15967-1-git-send-email-peter@hurleysoftware.com> <1415207589-15967-11-git-send-email-peter@hurleysoftware.com> <20141106023310.GA5035@kroah.com>
In-Reply-To: <20141106023310.GA5035@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2014 09:33 PM, Greg Kroah-Hartman wrote:
> On Wed, Nov 05, 2014 at 12:12:53PM -0500, Peter Hurley wrote:
>> Holding tty_mutex is no longer required to serialize changes to
>> the tty_count or to prevent concurrent opens of closing ttys;
>> tty_lock() is sufficient.
>>
>> Reviewed-by: Alan Cox <alan@linux.intel.com>
>> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
>> ---
>>  drivers/tty/tty_io.c | 6 ------
>>  1 file changed, 6 deletions(-)
>>
>> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
>> index ea8c6cae8d12..e59de81c39a9 100644
>> --- a/drivers/tty/tty_io.c
>> +++ b/drivers/tty/tty_io.c
>> @@ -1804,10 +1804,6 @@ int tty_release(struct inode *inode, struct file *filp)
>>  	 * each iteration we avoid any problems.
>>  	 */
>>  	while (1) {
>> -		/* Guard against races with tty->count changes elsewhere and
>> -		   opens on /dev/tty */
>> -
>> -		mutex_lock(&tty_mutex);
>>  		tty_lock_pair(tty, o_tty);
>>  		tty_closing = tty->count <= 1;
>>  		o_tty_closing = o_tty &&
>> @@ -1840,7 +1836,6 @@ int tty_release(struct inode *inode, struct file *filp)
>>  		printk(KERN_WARNING "%s: %s: read/write wait queue active!\n",
>>  				__func__, tty_name(tty, buf));
>>  		tty_unlock_pair(tty, o_tty);
>> -		mutex_unlock(&tty_mutex);
>>  		schedule();
>>  	}
>>  
> 
> The code in my tree in this section of tty_release() looks a bit
> different, so I had to hand-apply this patch.

Although there's nothing wrong with your version, I'm wondering why this
didn't apply cleanly.

While I go look at your tree, can you check that these patches are
sitting on top of the earlier two patches you applied to your tty-linus
branch; specifically 'tty: Fix high cpu load if tty is unreleasable' and
'tty: Prevent "read/write wait queue active!" log flooding'?

Regards,
Peter

> I've included the version
> I used below, please verify I didn't mess it up.
> 
> thanks,
> 
> greg k-h
> 
> 
> 
> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> index ea8c6cae8d12..e59de81c39a9 100644
> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -1804,10 +1804,6 @@ int tty_release(struct inode *inode, struct file *filp)
>  	 * each iteration we avoid any problems.
>  	 */
>  	while (1) {
> -		/* Guard against races with tty->count changes elsewhere and
> -		   opens on /dev/tty */
> -
> -		mutex_lock(&tty_mutex);
>  		tty_lock_pair(tty, o_tty);
>  		tty_closing = tty->count <= 1;
>  		o_tty_closing = o_tty &&
> @@ -1840,7 +1836,6 @@ int tty_release(struct inode *inode, struct file *filp)
>  		printk(KERN_WARNING "%s: %s: read/write wait queue active!\n",
>  				__func__, tty_name(tty, buf));
>  		tty_unlock_pair(tty, o_tty);
> -		mutex_unlock(&tty_mutex);
>  		schedule();
>  	}
>  
> @@ -1891,7 +1886,6 @@ int tty_release(struct inode *inode, struct file *filp)
>  		read_unlock(&tasklist_lock);
>  	}
>  
> -	mutex_unlock(&tty_mutex);
>  	tty_unlock_pair(tty, o_tty);
>  	/* At this point, the tty->count == 0 should ensure a dead tty
>  	   cannot be re-opened by a racing opener */
> 

