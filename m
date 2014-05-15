Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbaEOWx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 18:53:58 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.97]:48354 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660AbaEOWx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 18:53:56 -0400
References: <1398561815-22033-1-git-send-email-peter@piie.net> <1399139966-10625-1-git-send-email-peter@piie.net> <20140515160508.GA27909@developer>
Message-ID: <cone.1400194431.560139.1402.1000@galar>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Mohr <andi@lisas.de>, Borislav Petkov <bp@suse.de>,
        Zhang Rui <rui.zhang@intel.com>, Javi Merino <javi.merino@arm.com>
Subject: Re: [PATCH v3 0/6] acerhdf/thermal: adding new models, appropriate
         governor and minor clean up
Date: Fri, 16 May 2014 00:53:51 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: NDA0MDk0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

Eduardo Valentin writes:

> Hello Peter,
> 
> On Sat, May 03, 2014 at 07:59:20PM +0200, Peter Feuerer wrote:
>> 
>> Hi,
>> 
>> This patch series is intended to:
>> 
>>   * Introduce "manual mode" support (Patch 1 & 2), which is needed to control
>>     the fan of a few new models.
>> 
>>   * Add an appropriate thermal governor (Patch 3 & 4).  Manipulating and
>>     fiddling around with the step-wise governor has been a very fragile thing
>>     in the past and as it broke again, I used the opportunity to add a two
>>     point thermal governor which implements the actual fan handling required by
>>     acerhdf and puts from my point of view things straight.
>> 
> 
> Can you please provide more groundings why step_wise is not working?

Step_wise does (or did) not support hysteresis functionality, so what we've
done in the past was to manipulate the fan handling within acerhdf (e.g.
reporting different trip temperature, based whether the fan is on or not).
But this was very fragile and with each change in step_wise we had to find
another method to somehow fit acerhdf into it again.  Step_wise is clearly
intended for fans which can be regulated in speed and it has some fancy
algorithms like trend monitoring which work fine there.

But for the audience of acerhdf it has always been overkill and they've noticed
broken fan control, when things changed in step_wise again.


> I had a look on bang bang proposal patch and to me, at a first glance,
> step_wise should cover the target behavior. Of course, that also depend 
> on the cooling device you attach to it.

Actually even Rui stated a while ago, creation of a separate governor would be
one thinkable solution to get a more robust solution for the two step
regulation of acerhdf.


> Is it possible to report the problems you have with step_wise? This way
> we could benefit the other users of it as well.

There is no problem in step_wise in general.  It is just so, that the 
governor is overkill for the simple on-off fan of acerhdf.

And what's the deal of having plugable governors, when you try to fit every
single feature into one gigantic?
Aren't the unix philosophies of modularity, serparation and simplicity valid
in the kernel too?

kind regards,
--peter;

> 
> 
> 
> 
>>   * Do some minor clean up like:
>>       - adding second trip point for critical temperature (Patch 5)
>>       - removing _t suffix from struct which isn't typedef and replace unsigned
>>         char by u8 (Patch 6)
>> 
>> Thanks and kind regards,
>> peter
>> 
>> 
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Andreas Mohr <andi@lisas.de>
>> Cc: Borislav Petkov <bp@suse.de>
>> Cc: Zhang Rui <rui.zhang@intel.com>
>> Cc: Javi Merino <javi.merino@arm.com>
>> 
>> 
>> Peter Feuerer (6):
>>   acerhdf: Adding support for "manual mode"
>>   acerhdf: Adding support for new models
>>   thermal: Added Bang-bang thermal governor
>>   acerhdf: Use bang-bang thermal governor
>>   acerhdf: added critical trip point
>>   acerhdf: minor clean up
>> 
>>  drivers/platform/x86/Kconfig    |   2 +-
>>  drivers/platform/x86/acerhdf.c  | 260 +++++++++++++++++++++++++---------------
>>  drivers/thermal/Kconfig         |  10 ++
>>  drivers/thermal/Makefile        |   1 +
>>  drivers/thermal/gov_bang_bang.c | 131 ++++++++++++++++++++
>>  drivers/thermal/thermal_core.c  |   5 +
>>  drivers/thermal/thermal_core.h  |   8 ++
>>  7 files changed, 321 insertions(+), 96 deletions(-)
>>  create mode 100644 drivers/thermal/gov_bang_bang.c
>> 
>> -- 
>> 1.9.2
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
