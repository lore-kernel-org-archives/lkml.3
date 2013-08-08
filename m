Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab3HHFvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 01:51:05 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:57968 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755445Ab3HHFvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 01:51:02 -0400
Message-ID: <520331C1.4060406@c-s.fr>
Date: Thu, 08 Aug 2013 07:50:57 +0200
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: Wim Van Sebroeck <wim@iguana.be>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: [v2] Enhanced support for MPC8xx/8xxx watchdog
References: <201302280852.r1S8qMYu003742@localhost.localdomain> <20130625230431.GA29393@home.buserror.net>
In-Reply-To: <20130625230431.GA29393@home.buserror.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 26/06/2013 01:04, Scott Wood a écrit :
> On Thu, Feb 28, 2013 at 09:52:22AM +0100, LEROY Christophe wrote:
>> This patch modifies the behaviour of the MPC8xx/8xxx watchdog. On the MPC8xx,
>> at 133Mhz, the maximum timeout of the watchdog timer is 1s, which means it must
>> be pinged twice a second. This is not in line with the Linux watchdog concept
>> which is based on a default watchdog timeout around 60s.
>> This patch introduces an intermediate layer between the CPU and the userspace.
>> The kernel pings the watchdog at the required frequency at the condition that
>> userspace tools refresh it regularly.
>> Existing parameter 'timeout' is renamed 'hw_time'.
>> The new parameter 'timeout' allows to set up the userspace timeout.
>> The driver also implements the WDIOC_SETTIMEOUT ioctl.
>>
>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>>
>>
>> diff -ur linux-3.7.9/drivers/watchdog/mpc8xxx_wdt.c linux/drivers/watchdog/mpc8xxx_wdt.c
>> --- linux-3.7.9/drivers/watchdog/mpc8xxx_wdt.c	2013-02-17 19:53:32.000000000 +0100
>> +++ linux/drivers/watchdog/mpc8xxx_wdt.c	2013-02-27 16:00:07.000000000 +0100
>> @@ -52,10 +52,17 @@
>>   static struct mpc8xxx_wdt __iomem *wd_base;
>>   static int mpc8xxx_wdt_init_late(void);
>>   
>> -static u16 timeout = 0xffff;
>> -module_param(timeout, ushort, 0);
>> +#define WD_TIMO 10			/* Default timeout = 10 seconds */
> If the default Linux watchdog timeout is normally 60 seconds, why is it 10
> here?
Looks like each driver has its own default value, but agreed, I change 
it to 60 seconds

>> +static uint timeout = WD_TIMO;
>> +module_param(timeout, uint, 0);
>>   MODULE_PARM_DESC(timeout,
>> -	"Watchdog timeout in ticks. (0<timeout<65536, default=65535)");
>> +	"Watchdog SW timeout in seconds. (0 < timeout < 65536s, default = "
>> +				__MODULE_STRING(WD_TIMO) "s)");
>> +static u16 hw_timo = 0xffff;
>> +module_param(hw_timo, ushort, 0);
>> +MODULE_PARM_DESC(hw_timo,
>> +	"Watchdog HW timeout in ticks. (0 < hw_timo < 65536, default = 65535)");
> hw_timeout would be more legibile -- this is a public interface.
Ok
>
>>   static bool reset = 1;
>>   module_param(reset, bool, 0);
>> @@ -72,10 +79,12 @@
>>    * to 0
>>    */
>>   static int prescale = 1;
>> -static unsigned int timeout_sec;
>> +static unsigned int hw_timo_sec;
>>   
>> +static int wdt_auto = 1;
> bool, and add a comment indicating what this means.
Ok
>
>>   static unsigned long wdt_is_open;
>>   static DEFINE_SPINLOCK(wdt_spinlock);
>> +static unsigned long wdt_last_ping;
>>   
>>   static void mpc8xxx_wdt_keepalive(void)
>>   {
>> @@ -91,9 +100,20 @@
>>   
>>   static void mpc8xxx_wdt_timer_ping(unsigned long arg)
>>   {
>> -	mpc8xxx_wdt_keepalive();
>> -	/* We're pinging it twice faster than needed, just to be sure. */
>> -	mod_timer(&wdt_timer, jiffies + HZ * timeout_sec / 2);
>> +	if (wdt_auto)
>> +		wdt_last_ping = jiffies;
>> +
>> +	if (jiffies - wdt_last_ping <= timeout * HZ) {
> So timeout cannot be more than UINT_MAX / HZ...  Might want to check for
> that, just in case.
Ok.
>
> What happens if there's a race?  If another CPU updates wdt_last_ping in
> parallel, then you could see wdt_last_ping greater than the value you
> read for jiffies.  Since this is an unsigned comparison, it will fail to
> call keepalive.  You might get saved by pinging it twice as often as
> necessary, but you shouldn't rely on that.
Euh ... This watchdog is integrated inside the CPU, so there is no 
chance that any external CPU get access to it.
>
>> +		mpc8xxx_wdt_keepalive();
>> +		/* We're pinging it twice faster than needed, to be sure. */
>> +		mod_timer(&wdt_timer, jiffies + HZ * hw_timo_sec / 2);
>> +	}
>> +}
>> +
>> +static void mpc8xxx_wdt_sw_keepalive(void)
>> +{
>> +	wdt_last_ping = jiffies;
>> +	mpc8xxx_wdt_timer_ping(0);
>>   }
> This isn't new with this patch, but it looks like
> mpc8xxx_wdt_keepalive() can be called either from timer context, or with
> interrupts enabled... yet it uses a bare spin_lock() rather than an
> irq-safe version.  This should be fixed.
Ok, I'll propose another patch for that. Indeed, is the spin_lock needed 
at all ? If we get two writes interleaved, it will make it anyway.

Christophe

