Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbaAQPN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:13:27 -0500
Received: from www.linutronix.de ([62.245.132.108]:53333 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaAQPNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:13:24 -0500
Message-ID: <52D94891.80109@linutronix.de>
Date: Fri, 17 Jan 2014 16:13:21 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Nicholas Mc Guire <der.herr@hofr.at>
CC: linux-rt-users@vger.kernel.org,
        Sami Pietikainen <Sami.Pietikainen@wapice.com>,
        Jouko Haapaluoma <jouko.haapaluoma@wapice.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RT] add missing local serialization in ip_output.c
References: <20131229171154.GA23586@opentech.at> <20140117144729.GB5785@linutronix.de> <20140117145955.GA5637@opentech.at>
In-Reply-To: <20140117145955.GA5637@opentech.at>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 03:59 PM, Nicholas Mc Guire wrote:
> On Fri, 17 Jan 2014, Sebastian Andrzej Siewior wrote:
> 
>> This is what I am going to apply. It also dropped the get_cpu_light()
>> call which was added in a patch to remove the get_cpu_var() and is now
>> no longer required since we have the get_locked_var() thingy now.
>>
> 
> I do not think you can drop that - what is preventing migration now ?

Nothing but I do not see the need for it.

> 
> #define get_locked_var(lvar, var)                                       \
>         (*({                                                            \
>                 local_lock(lvar);                                       \
>                 &__get_cpu_var(var);                                    \
>         }))
> 
> No migrate_disable here - so how is this protected against migration ?

It does not. If you get here on CPU0, you the variable from CPU0. If
you get migrated to CPU1 you still use the variable from CPU0. If
another task is active on CPU0 then it will be blocked until the other
now running on CPU1 completes and releases the lock.

> Note that I did send out mail on this because I believe get_locked_var
> should actually be doing a a migrate_disable/enable but got no feedback on that
> yet.

I don't see a reason why you should not leave the CPU on which you got
access to the variable as long as you do not do any further assumption
regarding the CPU number. I don't see that this happens here.

> So for now I think you need to retain the get_cpu_light/put_cpu_light

Are you still sure?

>    
> thx!
> hofrat

Sebastian
