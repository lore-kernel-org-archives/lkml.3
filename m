Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab3LBLXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 06:23:52 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:35737 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257Ab3LBLXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 06:23:46 -0500
Message-ID: <529C6165.3050106@c-s.fr>
Date: Mon, 02 Dec 2013 11:31:01 +0100
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, Wim Van Sebroeck <wim@iguana.be>,
        scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] watchdog: mpc8xxx_wdt convert to watchdog core
References: <20131130153345.3070443E15@localhost.localdomain> <529B9019.9090404@roeck-us.net>
In-Reply-To: <529B9019.9090404@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 01/12/2013 20:38, Guenter Roeck a écrit :
> On 11/30/2013 07:33 AM, Christophe Leroy wrote:
>> Convert mpc8xxx_wdt.c to the new watchdog API.
>>
>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>>
>> diff -ur a/drivers/watchdog/mpc8xxx_wdt.c 
>> b/drivers/watchdog/mpc8xxx_wdt.c
>> --- a/drivers/watchdog/mpc8xxx_wdt.c    2013-05-11 22:57:46.000000000 
>> +0200
>> +++ b/drivers/watchdog/mpc8xxx_wdt.c    2013-11-30 16:14:53.803495472 
>> +0100
>> @@ -72,28 +72,31 @@
>>    * to 0
>>    */
>>   static int prescale = 1;
>> -static unsigned int timeout_sec;
>>
>> -static unsigned long wdt_is_open;
>>   static DEFINE_SPINLOCK(wdt_spinlock);
>>
>> -static void mpc8xxx_wdt_keepalive(void)
>> +static int mpc8xxx_wdt_ping(struct watchdog_device *w)
>>   {
>>       /* Ping the WDT */
>>       spin_lock(&wdt_spinlock);
>>       out_be16(&wd_base->swsrr, 0x556c);
>>       out_be16(&wd_base->swsrr, 0xaa39);
>>       spin_unlock(&wdt_spinlock);
>> +    return 0;
>
> The return code is never checked, so you can make this function void.
watchdog .h expects an int function.
Wouldn't it be an error to make it void, if for instance in the future 
the return code is checked by the core ?
>
>>   }
>>
>> +static struct watchdog_device mpc8xxx_wdt_dev;
>>   static void mpc8xxx_wdt_timer_ping(unsigned long arg);
>> -static DEFINE_TIMER(wdt_timer, mpc8xxx_wdt_timer_ping, 0, 0);
>> +static DEFINE_TIMER(wdt_timer, mpc8xxx_wdt_timer_ping, 0,
>> +        (unsigned long)&mpc8xxx_wdt_dev);
>>
>>   static void mpc8xxx_wdt_timer_ping(unsigned long arg)
>>   {
>> -    mpc8xxx_wdt_keepalive();
>> +    struct watchdog_device *w = (struct watchdog_device *)arg;
>> +
>> +    mpc8xxx_wdt_ping(w);
>>       /* We're pinging it twice faster than needed, just to be sure. */
>> -    mod_timer(&wdt_timer, jiffies + HZ * timeout_sec / 2);
>> +    mod_timer(&wdt_timer, jiffies + HZ * w->timeout / 2);
>>   }
>>
>>   static void mpc8xxx_wdt_pr_warn(const char *msg)
>> @@ -102,19 +105,9 @@
>>           reset ? "reset" : "machine check exception");
>>   }
>>
>> -static ssize_t mpc8xxx_wdt_write(struct file *file, const char 
>> __user *buf,
>> -                 size_t count, loff_t *ppos)
>> -{
>> -    if (count)
>> -        mpc8xxx_wdt_keepalive();
>> -    return count;
>> -}
>> -
>> -static int mpc8xxx_wdt_open(struct inode *inode, struct file *file)
>> +static int mpc8xxx_wdt_start(struct watchdog_device *w)
>>   {
>>       u32 tmp = SWCRR_SWEN;
>> -    if (test_and_set_bit(0, &wdt_is_open))
>> -        return -EBUSY;
>>
>>       /* Once we start the watchdog we can't stop it */
>>       if (nowayout)
>
> This code and the subsequent module_get can be removed; it is handled 
> by the infrastructure.
>
>
>> @@ -132,59 +125,30 @@
>>
>>       del_timer_sync(&wdt_timer);
>>
>> -    return nonseekable_open(inode, file);
>> +    return 0;
>>   }
>>
>> -static int mpc8xxx_wdt_release(struct inode *inode, struct file *file)
>> +static int mpc8xxx_wdt_stop(struct watchdog_device *w)
>>   {
>> -    if (!nowayout)
>> -        mpc8xxx_wdt_timer_ping(0);
>> -    else
>> -        mpc8xxx_wdt_pr_warn("watchdog closed");
>> -    clear_bit(0, &wdt_is_open);
>> +    mpc8xxx_wdt_timer_ping((unsigned long)w);
>
> I really dislike this typecasting back and forth.
>
> I think it would be better to move the mod_timer() call from 
> mpc8xxx_wdt_timer_ping
> into mpc8xxx_wdt_ping and call mpc8xxx_wdt_ping directly whenever 
> possible.
> From mpc8xxx_wdt_timer_ping you can then just call mpc8xxx_wdt_ping 
> with the
> typecasted parameter.
I'm not sure I understand what you mean.
mpc8xxx_wdt_ping() is called by the core when the user app writes into 
/dev/watchdog.
We don't want the set the timer in that case.
The timer is only used for when no user app has opened /dev/watchdog yet.

>
>>       return 0;
>>   }
>>
>> -static long mpc8xxx_wdt_ioctl(struct file *file, unsigned int cmd,
>> -                            unsigned long arg)
>> -{
>> -    void __user *argp = (void __user *)arg;
>> -    int __user *p = argp;
>> -    static const struct watchdog_info ident = {
>> -        .options = WDIOF_KEEPALIVEPING,
>> -        .firmware_version = 1,
>> -        .identity = "MPC8xxx",
>> -    };
>> -
>> -    switch (cmd) {
>> -    case WDIOC_GETSUPPORT:
>> -        return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
>> -    case WDIOC_GETSTATUS:
>> -    case WDIOC_GETBOOTSTATUS:
>> -        return put_user(0, p);
>> -    case WDIOC_KEEPALIVE:
>> -        mpc8xxx_wdt_keepalive();
>> -        return 0;
>> -    case WDIOC_GETTIMEOUT:
>> -        return put_user(timeout_sec, p);
>> -    default:
>> -        return -ENOTTY;
>> -    }
>> -}
>> +static struct watchdog_info mpc8xxx_wdt_info = {
>> +    .options = WDIOF_KEEPALIVEPING,
>> +    .firmware_version = 1,
>> +    .identity = "MPC8xxx",
>> +};
>>
>> -static const struct file_operations mpc8xxx_wdt_fops = {
>> -    .owner        = THIS_MODULE,
>> -    .llseek        = no_llseek,
>> -    .write        = mpc8xxx_wdt_write,
>> -    .unlocked_ioctl    = mpc8xxx_wdt_ioctl,
>> -    .open        = mpc8xxx_wdt_open,
>> -    .release    = mpc8xxx_wdt_release,
>> +static struct watchdog_ops mpc8xxx_wdt_ops = {
>> +    .owner = THIS_MODULE,
>> +    .start = mpc8xxx_wdt_start,
>> +    .stop = mpc8xxx_wdt_stop,
>>   };
>>
>> -static struct miscdevice mpc8xxx_wdt_miscdev = {
>> -    .minor    = WATCHDOG_MINOR,
>> -    .name    = "watchdog",
>> -    .fops    = &mpc8xxx_wdt_fops,
>> +static struct watchdog_device mpc8xxx_wdt_dev = {
>> +    .info = &mpc8xxx_wdt_info,
>> +    .ops = &mpc8xxx_wdt_ops,
>>   };
>>
>>   static const struct of_device_id mpc8xxx_wdt_match[];
>> @@ -196,6 +160,7 @@
>>       const struct mpc8xxx_wdt_type *wdt_type;
>>       u32 freq = fsl_get_sys_freq();
>>       bool enabled;
>> +    unsigned int timeout_sec;
>>
>>       match = of_match_device(mpc8xxx_wdt_match, &ofdev->dev);
>>       if (!match)
>> @@ -222,6 +187,7 @@
>>       else
>>           timeout_sec = timeout / freq;
>>
>> +    mpc8xxx_wdt_dev.timeout = timeout_sec;
>>   #ifdef MODULE
>>       ret = mpc8xxx_wdt_init_late();
>>       if (ret)
>> @@ -237,7 +203,7 @@
>>        * userspace handles it.
>>        */
>>       if (enabled)
>> -        mpc8xxx_wdt_timer_ping(0);
>> +        mpc8xxx_wdt_timer_ping((unsigned long)&mpc8xxx_wdt_dev);
>>       return 0;
>>   err_unmap:
>>       iounmap(wd_base);
>> @@ -249,7 +215,7 @@
>>   {
>>       mpc8xxx_wdt_pr_warn("watchdog removed");
>
> The mpc8xxx_wdt_pr_warn function is now rather unnecessary since
> it is called only once. Might as well merge it into this function.
>
>>       del_timer_sync(&wdt_timer);
>> -    misc_deregister(&mpc8xxx_wdt_miscdev);
>> +    watchdog_unregister_device(&mpc8xxx_wdt_dev);
>>       iounmap(wd_base);
>>
>>       return 0;
>> @@ -301,10 +267,11 @@
>>       if (!wd_base)
>>           return -ENODEV;
>>
>> -    ret = misc_register(&mpc8xxx_wdt_miscdev);
>> +    watchdog_set_nowayout(&mpc8xxx_wdt_dev, nowayout);
>> +
>> +    ret = watchdog_register_device(&mpc8xxx_wdt_dev);
>>       if (ret) {
>> -        pr_err("cannot register miscdev on minor=%d (err=%d)\n",
>> -               WATCHDOG_MINOR, ret);
>> +        pr_err("cannot register watchdog device (err=%d)\n", ret);
>>           return ret;
>>       }
>>       return 0;
>> diff -ur a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
>> --- a/drivers/watchdog/Kconfig
>> +++ b/drivers/watchdog/Kconfig
>> @@ -1146,6 +1146,7 @@
>>   config 8xxx_WDT
>>       tristate "MPC8xxx Platform Watchdog Timer"
>>       depends on PPC_8xx || PPC_83xx || PPC_86xx
>> +    select WATCHDOG_CORE
>>       help
>>         This driver is for a SoC level watchdog that exists on some
>>         Freescale PowerPC processors. So far this driver supports:
>>
>> ---
>> Ce courrier électronique ne contient aucun virus ou logiciel 
>> malveillant parce que la protection avast! Antivirus est active.
>> http://www.avast.com
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-watchdog" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
>>
>

