Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbaAWJ02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 04:26:28 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:12463
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750820AbaAWJ0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 04:26:25 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh8275dh1de097h186068hz2dh2a8h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24d7h1155h)
Message-ID: <52E0E093.1070803@freescale.com>
Date: Thu, 23 Jan 2014 17:27:47 +0800
From: Liu Ying <Ying.Liu@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Jani Nikula'" <jani.nikula@linux.intel.com>,
        <linux-fbdev@vger.kernel.org>, <tomi.valkeinen@ti.com>,
        <plagnioj@jcrosoft.com>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH v2] backlight: turn backlight on/off when necessary
References: <1390196846-15304-1-git-send-email-Ying.Liu@freescale.com> <87sisg5pfo.fsf@intel.com> <000101cf17fe$20ac79a0$62056ce0$%han@samsung.com>
In-Reply-To: <000101cf17fe$20ac79a0$62056ce0$%han@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2014 01:44 PM, Jingoo Han wrote:
> On Wednesday, January 22, 2014 6:36 PM, Jani Nikula wrote:
>> On Mon, 20 Jan 2014, Liu Ying <Ying.Liu@freescale.com> wrote:
>>> We don't have to turn backlight on/off everytime a blanking
>>> or unblanking event comes because the backlight status may
>>> have already been what we want. Another thought is that one
>>> backlight device may be shared by multiple framebuffers. We
>>> don't hope blanking one of the framebuffers may turn the
>>> backlight off for all the other framebuffers, since they are
>>> likely being active to display something. This patch adds
>>> some logics to record each framebuffer's backlight usage to
>>> determine the backlight device use count and whether the
>>> backlight should be turned on or off. To be more specific,
>>> only one unblank operation on a certain blanked framebuffer
>>> may increase the backlight device's use count by one, while
>>> one blank operation on a certain unblanked framebuffer may
>>> decrease the use count by one, because the userspace is
>>> likely to unblank a unblanked framebuffer or blank a blanked
>>> framebuffer.
>>>
>>> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
>>> ---
>>> v1 can be found at https://lkml.org/lkml/2013/5/30/139
>>>
>>> v1->v2:
>>> * Make the commit message be more specific about the condition
>>>   in which backlight device use count can be increased/decreased.
>>> * Correct the setting for bd->props.fb_blank.
>>>
>>>  drivers/video/backlight/backlight.c |   28 +++++++++++++++++++++-------
>>>  include/linux/backlight.h           |    6 ++++++
>>>  2 files changed, 27 insertions(+), 7 deletions(-)
>>>
> 
> [.....]
>>
>> Anything backlight worries me a little, and there are actually three
>> changes bundled into one patch here:
>>
>> 1. Changing bd->props.state and bd->props.fb_blank only when use_count
>>    changes from 0->1 or 1->0.
>>
>> 2. Calling backlight_update_status() only with the above change, and not
>>    on all notifier callbacks.
>>
>> 3. Setting bd->props.fb_blank always to either FB_BLANK_UNBLANK or
>>    FB_BLANK_POWERDOWN instead of *(int *)evdata->data.

Since I have already post v3(https://lkml.org/lkml/2014/1/22/126) to change the setting for bd->props.fb_blank, the idea of the 3rd point is not very appropriate any more.

>>
>> The rationale in the commit message seems plausible, and AFAICT the code
>> does what it says on the box, so for that (and for that alone) you can
>> have my
>>
>> Reviewed-by: Jani Nikula <jani.nikula@intel.com>
>>
>> *BUT* it would be laborous to figure out whether this change in
>> behaviour might regress some drivers. I'm just punting on that. And that
>> brings us back to the three changes above - in a bisect POV it might be
>> helpful to split the patch up. Up to the maintainers.
> 
> I agree with Jani Nikula's opinion.
> Please split this patch into three patches as above mentioned.
> 

I am open to split the patch up.
However, IMHO, this patch is somewhat self-contained.
For example, if we try to create 2 patches for the 1st point and the 2nd point Jani mentioned, one patch would invent the use_count and call backlight_update_status() on all notifier callbacks(just
ignore the use_count).
Do you think this is a good patch?

It also doesn't look straightforward for me to create 2 patches for the 1st point and the 2nd point.

Please advice.

Regards,
Liu Ying

