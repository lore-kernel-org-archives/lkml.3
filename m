Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624AbaGOJK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:10:29 -0400
Received: from g5t1626.atlanta.hp.com ([15.192.137.9]:57568 "EHLO
	g5t1626.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512AbaGOJKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:10:25 -0400
X-Greylist: delayed 98081 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jul 2014 05:10:25 EDT
Message-ID: <53C4EFA8.3080308@hp.com>
Date: Tue, 15 Jul 2014 17:08:56 +0800
From: "Li, ZhenHua" <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] driver/tty: Fix a warning in check_tty_count
References: <1405317257-5491-1-git-send-email-zhen-hual@hp.com> <53C3CC4E.9010000@hurleysoftware.com>
In-Reply-To: <53C3CC4E.9010000@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

This bug  was founded in RHEL 6, kernel version 2.6.32.

But I also checked the file tty_io.c in  latest kernel, not all the code 
protected by tty_lock(tty).

For example,  in function tty_del_file,

     if (--tty->count < 0) {
     }
and
     tty_del_file(filp);
are not surrounded by tty_lock(tty).

So I think the new lock is necessary.

Thanks
Zhenhua

On 07/14/2014 08:25 PM, Peter Hurley wrote:
> Hi Zhen-Hua,
>
> On 07/14/2014 01:54 AM, Li, Zhen-Hua wrote:
>> When there are to many open/close on a tty device in the same time,
>> there may be a warning like:
>>    Warning: dev (ttyS0) tty->count(4) != #fd's(3) in tty_release_dev
>>
>> That's because tty->count and files in tty->tty_files are not 
>> synchronized
>> in time.
>> So I add a lock to avoid this.
>
> Every place you added the count_lock spinlock is already protected
> by tty_lock(tty), so the count is out of sync for some other reason.
>
> What kernel version are you having this problem on and what are the
> circumstances?
>
> Regards,
> Peter Hurley
>
>
>> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
>> ---
>>   drivers/tty/tty_io.c | 13 +++++++++----
>>   include/linux/tty.h  |  1 +
>>   2 files changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
>> index 3411071..9283fc2 100644
>> --- a/drivers/tty/tty_io.c
>> +++ b/drivers/tty/tty_io.c
>> @@ -297,6 +297,7 @@ static int check_tty_count(struct tty_struct 
>> *tty, const char *routine)
>>       struct list_head *p;
>>       int count = 0;
>>
>> +    spin_lock(&tty->count_lock);
>>       spin_lock(&tty_files_lock);
>>       list_for_each(p, &tty->tty_files) {
>>           count++;
>> @@ -310,8 +311,10 @@ static int check_tty_count(struct tty_struct 
>> *tty, const char *routine)
>>           printk(KERN_WARNING "Warning: dev (%s) tty->count(%d) "
>>                       "!= #fd's(%d) in %s\n",
>>                  tty->name, tty->count, count, routine);
>> +        spin_unlock(&tty->count_lock);
>>           return count;
>>       }
>> +    spin_unlock(&tty->count_lock);
>>   #endif
>>       return 0;
>>   }
>> @@ -1337,7 +1340,6 @@ int tty_standard_install(struct tty_driver 
>> *driver, struct tty_struct *tty)
>>           return ret;
>>
>>       tty_driver_kref_get(driver);
>> -    tty->count++;
>>       driver->ttys[tty->index] = tty;
>>       return 0;
>>   }
>> @@ -1408,7 +1410,6 @@ static int tty_reopen(struct tty_struct *tty)
>>
>>           tty->link->count++;
>>       }
>> -    tty->count++;
>>
>>       WARN_ON(!tty->ldisc);
>>
>> @@ -1796,6 +1797,7 @@ int tty_release(struct inode *inode, struct 
>> file *filp)
>>        * We must *not* drop the tty_mutex until we ensure that a further
>>        * entry into tty_open can not pick up this tty.
>>        */
>> +    spin_lock(&tty->count_lock);
>>       if (pty_master) {
>>           if (--o_tty->count < 0) {
>>               printk(KERN_WARNING "%s: bad pty slave count (%d) for 
>> %s\n",
>> @@ -1819,7 +1821,7 @@ int tty_release(struct inode *inode, struct 
>> file *filp)
>>        *    something that needs to be handled for hangups.
>>        */
>>       tty_del_file(filp);
>> -
>> +    spin_unlock(&tty->count_lock);
>>       /*
>>        * Perform some housekeeping before deciding whether to return.
>>        *
>> @@ -2046,8 +2048,10 @@ retry_open:
>>           retval = PTR_ERR(tty);
>>           goto err_file;
>>       }
>> -
>> +    spin_lock(&tty->count_lock);
>> +    tty->count++;
>>       tty_add_file(tty, filp);
>> +    spin_unlock(&tty->count_lock);
>>
>>       check_tty_count(tty, __func__);
>>       if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
>> @@ -3031,6 +3035,7 @@ void initialize_tty_struct(struct tty_struct *tty,
>>       INIT_WORK(&tty->hangup_work, do_tty_hangup);
>>       mutex_init(&tty->atomic_write_lock);
>>       spin_lock_init(&tty->ctrl_lock);
>> +    spin_lock_init(&tty->count_lock);
>>       INIT_LIST_HEAD(&tty->tty_files);
>>       INIT_WORK(&tty->SAK_work, do_SAK_work);
>>
>> diff --git a/include/linux/tty.h b/include/linux/tty.h
>> index 1c3316a..2959300 100644
>> --- a/include/linux/tty.h
>> +++ b/include/linux/tty.h
>> @@ -284,6 +284,7 @@ struct tty_struct {
>>       /* If the tty has a pending do_SAK, queue it here - akpm */
>>       struct work_struct SAK_work;
>>       struct tty_port *port;
>> +    spinlock_t count_lock;
>>   };
>>
>>   /* Each of a tty's open files has private_data pointing to 
>> tty_file_private */
>>
>

