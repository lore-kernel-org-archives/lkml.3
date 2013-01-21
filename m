Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab3AUOKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 09:10:33 -0500
Received: from hermes.synopsys.com ([198.182.44.81]:47461 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab3AUOK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 09:10:27 -0500
Message-ID: <50FD4C47.8080805@synopsys.com>
Date: Mon, 21 Jan 2013 19:40:15 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 69/76] ARC: [Review] Multi-platform image #2: Board
 callback Infrastructure
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-70-git-send-email-vgupta@synopsys.com> <201301181505.10350.arnd@arndb.de>
In-Reply-To: <201301181505.10350.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013 08:35 PM, Arnd Bergmann wrote:
> On Friday 18 January 2013, Vineet Gupta wrote:
>> +struct machine_desc {
>> +	const char		*name;
>> +	const char		**dt_compat;
>> +
>> +	void			(*init_early)(void);
>> +	void			(*init_irq)(void);
>> +	void			(*init_time)(void);
>> +	void			(*init_machine)(void);
>> +	void			(*init_late)(void);
>> +
>> +#ifdef CONFIG_SMP
>> +	void			(*init_smp)(unsigned int);
>> +#endif
> On ARM, it turned out helpful to list these in the order in 
> which they get called. I assume that at least init_smp
> is currently not in that order.

Rightly so, which is fixed now. I also kept forgetting hence the big comment above
actually describes the exact location from where the callback is invoked. Note
that init_smp is called for each cpu.

> Also, we are slowly making some of these obsolete on
> ARM: For platforms that at DT-only, the timer and
> irq code is now in drivers/irqchip and drivers/clocksource
> and can get automatically initialized.

OK - I'll make a note. BTW init_time was a recent addition, the reason being it's
timing. For registering a clocksource, init_irq and init_smp are too early
(timekeeping not yet up) while init_machine (arch initcall) seemed too late - but
thinking again, it could well be done in there. I need to check with the relevant
platform folks.

> It probably makese sense for you to keep the above structure
> for now, but you can also think about obsoleting some
> of the calls in the future. It may be a good idea to have
> a default version for each of these but still allow overriding
> them for maximum flexibility in the platform.
>
> 	Arnd

IMHO the default has to be NULL, unless the platform has a quirk. It would be
cleaner (and easier to read) if any default was factored out into ARC common code.

-Vineet
