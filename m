Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbaGNO7O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:59:14 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52253 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953AbaGNO7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:59:01 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53C3F033.9070408@roeck-us.net>
Date: Mon, 14 Jul 2014 07:58:59 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <Will.Deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/7] kernel: Add support for restart notifier call
 chain
References: <1405265431-4561-1-git-send-email-linux@roeck-us.net> <1405265431-4561-2-git-send-email-linux@roeck-us.net> <20140714145311.GC1112@arm.com>
In-Reply-To: <20140714145311.GC1112@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 07:53 AM, Catalin Marinas wrote:
> On Sun, Jul 13, 2014 at 04:30:25PM +0100, Guenter Roeck wrote:
>> diff --git a/include/linux/reboot.h b/include/linux/reboot.h
>> index 48bf152..120db73 100644
>> --- a/include/linux/reboot.h
>> +++ b/include/linux/reboot.h
>> @@ -38,6 +38,9 @@ extern int reboot_force;
>>   extern int register_reboot_notifier(struct notifier_block *);
>>   extern int unregister_reboot_notifier(struct notifier_block *);
>>
>> +extern int register_restart_notifier(struct notifier_block *);
>> +extern int unregister_restart_notifier(struct notifier_block *);
>> +extern void kernel_restart_notify(char *cmd);
>>
>>   /*
>>    * Architecture-specific implementations of sys_reboot commands.
>> diff --git a/kernel/reboot.c b/kernel/reboot.c
>> index a3a9e24..1bc9bf2 100644
>> --- a/kernel/reboot.c
>> +++ b/kernel/reboot.c
>> @@ -104,6 +104,87 @@ int unregister_reboot_notifier(struct notifier_block *nb)
>>   }
>>   EXPORT_SYMBOL(unregister_reboot_notifier);
>>
>> +/*
>> + *	Notifier list for kernel code which wants to be called
>> + *	to restart the system.
>> + */
>> +static BLOCKING_NOTIFIER_HEAD(restart_notifier_list);
>> +
>> +/**
>> + *	register_restart_notifier - Register function to be called to reset
>> + *				    the system
>> + *	@nb: Info about notifier function to be called
>> + *	@nb->priority:	Notifier priority. Notifiers should follow the
>> + *			following guidelines for setting priorities.
>> + *			0:	Restart notifier of last resort,
>> + *				with limited restart capabilities
>> + *			128:	Default notifier; use if no other
>> + *				notifier is expected to be available,
>> + *				and/or if restart functionality is
>> + *				sufficient to restart the entire system
>> + *			255:	Highest priority notifier, will preempt
>> + *				all other notifier functions
>
> I'm not fully convinced implying a 'notifier' is the right approach
> here. By analogy with the reboot notifier, this is something drivers
> would want to know about and do some work before the actual system
> restart (e.g. disable watchdogs as in the reboot notifier case). The
> restart notifier here is meant to perform the actual system restart.
> Arguably, the actual restart should be handled by priority 0 with some
> preparation before but we have reboot notifier already, so I don't think
> it's worth another notifier.
>
> While re-using the notifier mechanism behind the scene is fine, I think
> we should at least rename the functions to something like
> (un)register_restart_handler().
>

Fine with me. Any other comments / suggestions on the name of the function ?

Guenter


