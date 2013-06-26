Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab3FZNZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:25:42 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59081 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab3FZNZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:25:41 -0400
Message-ID: <51CAEA90.90200@ti.com>
Date: Wed, 26 Jun 2013 16:20:16 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [RFC] ARM: OMAP2+: omap_device: add pinctrl handling
References: <1371826990-25820-1-git-send-email-grygorii.strashko@ti.com> <CACRpkdY=m1b9Lh27+wHP8FQ4SbVZKmAOCGhxe59aP+TcuR9QaA@mail.gmail.com> <20130625065811.GZ5523@atomide.com>
In-Reply-To: <20130625065811.GZ5523@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

On 06/25/2013 09:58 AM, Tony Lindgren wrote:
> * Linus Walleij <linus.walleij@linaro.org> [130624 05:13]:
>> On Fri, Jun 21, 2013 at 5:03 PM, Grygorii Strashko
>> <grygorii.strashko@ti.com> wrote:
>>
>>> Hence, add pinctrl handling in omap_device core:
>>> 1) on PM runtime resume
>>> - switch pinctrl state to "default" (todo: "active")
>>> 2) on PM runtime suspend
>>> - switch pinctrl state to "idle"
>>> 3) during system wide suspend
>>> - switch pinctrl state to "sleep" or "idle" if omap_device core disables device
>>> - switch pinctrl state to "sleep" if device is disabled already
> Do you need a separate setting for "idle" and "sleep", or are
> they the same?
>
>>> 4) during system wide resume
>>> - switch pinctrl state to "default" (todo: "active") if omap_device core has
>>>    disabled  device during suspend
>>> - switch pinctrl state to "idle" if device was already disabled before suspend
>> I don't understand step 4.
>>
>> I get the creeps about whether the system is runtime suspended
>> or runtime resumed when we come to resume proper, so I need
>> Kevin to have a look at this.
>>
>> Apart from that it looks good.
>>
>> Stephen and Tony are trying to figure out the details of whether "active"
>> is necessary or not in a related thread I think.
Thanks for your comments.

I've prepared diagram to illustrate how does this work:
                                                  +
                                                  |
                                                  |  .probe()
                                                  |
                                            +-----v--------+
                                            |              |
                                            |  default     |
                                            |              |
                                            +----+--+------+
                                                 |  |
                               pm_runtime_get()  |  | pm_runtime_put()
                              +------------------+ +------------------+
|                                        |
                       +------v--------+ pm_runtime_put() +-------v-------+
                       | +----------------------->               |
           +----------->  Active       |      pm_runtime_get() | 
Idle        <--------------+
           |           | <-----------------------+               
|              |
           |           +-------+-------+ +-------+-------+              |
           | |.suspend_noirq()                       
|.suspend_noirq()      |
           | |                                       
|                      |
           | |                                       
|                      |
           | |                                       
|                      |
           | |                                       
|                      |
           |           +-------v-------+ +-------v--------+             |
           |           |               | |                |             |
           +-----------+  Sleep        ------+                 | 
Sleep         +-------------+
       .resume_noirq() |               |     | |                
|.resume_noirq()
                       +-------|-------+     | +----------------+
                               |   Idle      |
                               +-------------+

The "Sleep" pinctrl state is optional - if "sleep" state isn't defined
then "Idle" pinctrl state will be used during suspend.

As per above pinctrl state transition diagram - I think, that:
- if "idle" or "sleep" states are defined then "active" state have to be 
defined too.
So, pinctrl core should detect such situation and generate a warning.

 From my point of view, we should have "active" state - it would allow 
to avoid additional
runtime overhead and handle properly the case when drivers are used as 
loadable modules.
In this case, after boot, device's pinctrl registers can have HW default 
values (after reset) or
can be configured to some safe (off) state from board file (board's 
"default" configuration).
Driver module will activate its PINs when loaded and need to restore 
safe (off) PINs state when
unloaded.
As result, it seems, we should have "off" state which can be used when 
driver's module is removed.

So, final list of default pnctrl states may be defined as "default", 
"active", "idle", "sleep", "off":
- "active", "idle", "sleep": will be handled by omap_device core
- "default", "off": will be handled by driver itself (or Device core).



> Yes we should have that sorted out over next few weeks, so let's
> just wait a little while on all these dynamic remuxing patches
> to avoid churn.
>
> Regards,
>
> Tony

Regards,
- grygorii
