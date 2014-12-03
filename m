Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaLCRtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 12:49:25 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:48517 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaLCRtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 12:49:23 -0500
Message-ID: <250d9d48a62a2a46dba33a6f888fdd9e.squirrel@codeaurora.org>
In-Reply-To: <CAJAp7Oj7=v=ewdDa7USif+Ojdkym5wQyX0HtBky5JracN6phtA@mail.gmail.com>
References: <1417470961-16524-1-git-send-email-jilaiw@codeaurora.org>
    <CAJAp7OjrC_huXY268XFrE+v63bWW7r8JW6XpcKPYLfvqzOjcMg@mail.gmail.com>
    <CAF6AEGts4791fkM4NzYWyGhx4HvoBUDtqsRNgjB5k=6bUOA2LA@mail.gmail.com>
    <07ece1998971cf11077934917508c709.squirrel@codeaurora.org>
    <CAJAp7Oj7=v=ewdDa7USif+Ojdkym5wQyX0HtBky5JracN6phtA@mail.gmail.com>
Date: Wed, 3 Dec 2014 17:49:19 -0000
Subject: Re: [PATCH 2/2] drm/msm/hdmi: add hdmi hdcp support
From: jilaiw@codeaurora.org
To: "Bjorn Andersson" <bjorn@kryo.se>
Cc: "Jilai Wang" <jilaiw@codeaurora.org>, "Rob Clark" <robdclark@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-arm-msm" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.22-4.el6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Dec 3, 2014 at 9:16 AM,  <jilaiw@codeaurora.org> wrote:
> [..]
>>>>> +       enum hdmi_hdcp_state hdcp_state;
>>>>> +       struct mutex state_mutex;
>>>>> +       struct delayed_work hdcp_reauth_work;
>>>>> +       struct delayed_work hdcp_auth_part1_1_work;
>>>>> +       struct delayed_work hdcp_auth_part1_2_work;
>>>>> +       struct work_struct hdcp_auth_part1_3_work;
>>>>> +       struct delayed_work hdcp_auth_part2_1_work;
>>>>> +       struct delayed_work hdcp_auth_part2_2_work;
>>>>> +       struct delayed_work hdcp_auth_part2_3_work;
>>>>> +       struct delayed_work hdcp_auth_part2_4_work;
>>>>> +       struct work_struct hdcp_auth_prepare_work;
>>>>
>>>> You shouldn't use "work" as a way to express states in your state
>>>> machine.
>>>> Better have 1 auth work function that does all these steps, probably
>>>> having
>>>> them split in functions just like you do now.
>>>>
>>>> That way you can have 1 function running the pass of authentication,
>>>> starting
>>>> by checking if you're reauthing or not then processing each step one
>>>> by
>>>> one,
>>>> sleeping inbetween them. You can have the functions return -EAGAIN to
>>>> indicate
>>>> that you need to retry the current operation and so on.
>>>>
>>>> This would split the state machine from the state executioners and
>>>> simplify
>>>> your code.
>>>
>>> As a side note (disclaimer, I'm not an hdcp expert), but I wonder if
>>> eventually some of that should be extracted out into some helpers in
>>> drm core.  I guess that is something we'll figure out when a 2nd
>>> driver gains upstream HDCP support.  One big work w/ msleep()'s does
>>> sound like it would be easier to understand (and therefore easier to
>>> refactor out into helpers).
>>>
>>> [snip]
>>>
>>
>> The reason that I break the partI/PartII work into these small works
>> because I want to avoid to use msleep in work.
>> Otherwise cancel a HDCP work may cause long delay up to several seconds.
>>
>
> I definitely think the steps are nice size and make things easy to
> understand.
>
> If you make the steps that require a retry return out to the main
> state handling function with a -EAGAIN, then you can have check if you
> should retry or abort based on cancellation. Giving you the worst case
> cancellation time of the longest sleep...
>
> As Rob suggest you could use wait_event_timeout() or something to
> improve this, but on the other hand the worst case here seems to be
> the HZ/2 after prepare_auth; others are HZ/8, HZ/20 and HZ/50; not
> "seconds".
>
> So I would start with a simple msleep() for implementation simplicity
> and then enhance that in a follow up commit (if needed)...
>
> Regards,
> Bjorn
>

The worst wait time could be 5 seconds if the downstream device is a
REPEATER. The maximum retry time is set to 100 and the delay for each time
is HZ/20, then the maximum wait time before abort will be 5 seconds.
As you suggested, I can use the flag to notify the retry process to abort
earlier in case this work needs to be canceled which can reduce the delay
to HZ/20 then. Or as Rob's suggestion to wait for hpd event.

Thanks,
Jilai


