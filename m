Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbaLCRUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 12:20:48 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:60410 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaLCRUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 12:20:45 -0500
MIME-Version: 1.0
In-Reply-To: <07ece1998971cf11077934917508c709.squirrel@codeaurora.org>
References: <1417470961-16524-1-git-send-email-jilaiw@codeaurora.org>
	<CAJAp7OjrC_huXY268XFrE+v63bWW7r8JW6XpcKPYLfvqzOjcMg@mail.gmail.com>
	<CAF6AEGts4791fkM4NzYWyGhx4HvoBUDtqsRNgjB5k=6bUOA2LA@mail.gmail.com>
	<07ece1998971cf11077934917508c709.squirrel@codeaurora.org>
Date: Wed, 3 Dec 2014 12:20:44 -0500
Message-ID: <CAF6AEGuo45PksyWTRR8HFhW9gFggJ6PnspQ9Bj3Bob_bJOwKOA@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm/msm/hdmi: add hdmi hdcp support
From: Rob Clark <robdclark@gmail.com>
To: Jilai Wang <jilaiw@codeaurora.org>
Cc: Bjorn Andersson <bjorn@kryo.se>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 12:16 PM,  <jilaiw@codeaurora.org> wrote:
>>>> +       enum hdmi_hdcp_state hdcp_state;
>>>> +       struct mutex state_mutex;
>>>> +       struct delayed_work hdcp_reauth_work;
>>>> +       struct delayed_work hdcp_auth_part1_1_work;
>>>> +       struct delayed_work hdcp_auth_part1_2_work;
>>>> +       struct work_struct hdcp_auth_part1_3_work;
>>>> +       struct delayed_work hdcp_auth_part2_1_work;
>>>> +       struct delayed_work hdcp_auth_part2_2_work;
>>>> +       struct delayed_work hdcp_auth_part2_3_work;
>>>> +       struct delayed_work hdcp_auth_part2_4_work;
>>>> +       struct work_struct hdcp_auth_prepare_work;
>>>
>>> You shouldn't use "work" as a way to express states in your state
>>> machine.
>>> Better have 1 auth work function that does all these steps, probably
>>> having
>>> them split in functions just like you do now.
>>>
>>> That way you can have 1 function running the pass of authentication,
>>> starting
>>> by checking if you're reauthing or not then processing each step one by
>>> one,
>>> sleeping inbetween them. You can have the functions return -EAGAIN to
>>> indicate
>>> that you need to retry the current operation and so on.
>>>
>>> This would split the state machine from the state executioners and
>>> simplify
>>> your code.
>>
>> As a side note (disclaimer, I'm not an hdcp expert), but I wonder if
>> eventually some of that should be extracted out into some helpers in
>> drm core.  I guess that is something we'll figure out when a 2nd
>> driver gains upstream HDCP support.  One big work w/ msleep()'s does
>> sound like it would be easier to understand (and therefore easier to
>> refactor out into helpers).
>>
>> [snip]
>>
>
> The reason that I break the partI/PartII work into these small works
> because I want to avoid to use msleep in work.
> Otherwise cancel a HDCP work may cause long delay up to several seconds.


hmm, yeah, several seconds is long enough for user to plug/unplug
several displays ;-)

But I guess a wait_event_timeout() plus a wq that is signalled on hpd
(or whenever we need to cancel) instead of msleep might do the trick?

BR,
-R
