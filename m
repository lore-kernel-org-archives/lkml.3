Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162528AbaDCIAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 04:00:32 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:56381 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162430AbaDCIAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 04:00:30 -0400
Message-ID: <533D151A.9070808@suse.cz>
Date: Thu, 03 Apr 2014 10:00:26 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Samo Pogacnik <samo_pogacnik@t-2.net>, Jean Delvare <jdelvare@suse.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Struan Bartlett <struan.bartlett@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>, gnomes@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ttyprintk: Fix wrong tty_unregister_driver() call
 in the error path
References: <1396434582-30799-1-git-send-email-tiwai@suse.de>	<1396441473.10789.23.camel@chaos.site> <s5hbnwjdjtf.wl%tiwai@suse.de>
In-Reply-To: <s5hbnwjdjtf.wl%tiwai@suse.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 08:10 AM, Takashi Iwai wrote:
> At Wed, 02 Apr 2014 14:24:33 +0200,
> Jean Delvare wrote:
>>
>> Le Wednesday 02 April 2014 à 12:29 +0200, Takashi Iwai a écrit :
>>> ttyprintk driver calls tty_unregister_driver() wrongly in the error
>>> path of tty_register_driver().  Also, setting ttyprintk_driver to NULL
>>> is utterly superfluous, so let's get rid of it, too.
>>>
>>> Reported-by: Jean Delvare <jdelvare@suse.de>
>>> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>>> ---
>>>  drivers/char/ttyprintk.c | 2 --
>>>  1 file changed, 2 deletions(-)
>>>
>>> diff --git a/drivers/char/ttyprintk.c b/drivers/char/ttyprintk.c
>>> index daea84c41743..2a39c5790364 100644
>>> --- a/drivers/char/ttyprintk.c
>>> +++ b/drivers/char/ttyprintk.c
>>> @@ -210,10 +210,8 @@ static int __init ttyprintk_init(void)
>>>  	return 0;
>>>  
>>>  error:
>>> -	tty_unregister_driver(ttyprintk_driver);
>>>  	put_tty_driver(ttyprintk_driver);
>>>  	tty_port_destroy(&tpk_port.port);
>>> -	ttyprintk_driver = NULL;
>>>  	return ret;
>>>  }
>>>  device_initcall(ttyprintk_init);
>>
>> Reviewed-by: Jean Delvare <jdelvare@suse.de>
> 
> Meanwhile, I found that tty_unregister_driver() was added
> intentionally in the commit f06fb543c1d0,
>     TTY: ttyprintk, unregister tty driver on failure
>     
>     When the tty_printk driver fails to create a node in sysfs, the
>     system
>     crashes. It is because the driver registers a tty driver and frees
>     it
>     without deregistering it first. The fix is easy: add a call to
>     tty_unregister_driver to the fail path.
> 
> But, I failed to see why this is needed in the current code.
> 
> Jiri, is your fix still valid at all?

The code was different. There was also device_create after
tty_register_driver. I must admit that I don't know why I didn't change
'goto error' in the tty_register_driver fail path.

        ret = tty_register_driver(ttyprintk_driver);
        if (ret < 0) {
                printk(KERN_ERR "Couldn't register ttyprintk driver\n");
                goto error;
        }

        /* create our unnumbered device */
        rp = device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 3), NULL,
                                ttyprintk_driver->name);
        if (IS_ERR(rp)) {
                printk(KERN_ERR "Couldn't create ttyprintk device\n");
                ret = PTR_ERR(rp);
                goto error;
        }



So yes, there should be no tty_unregister_driver in the fail path when
device_create is gone now.

thanks,
-- 
js
suse labs
