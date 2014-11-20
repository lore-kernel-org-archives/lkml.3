Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbaKTOr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 09:47:56 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:52255 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291AbaKTOry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 09:47:54 -0500
MIME-Version: 1.0
In-Reply-To: <20141120085750.GB23043@ulmo>
References: <1416004955-28749-1-git-send-email-hali@codeaurora.org>
	<CAF6AEGuFK=ZdaKF8hOwHyQOcmMR+ZMQjbwf+hL3pZm_O+t1K0w@mail.gmail.com>
	<20141120085750.GB23043@ulmo>
Date: Thu, 20 Nov 2014 09:47:53 -0500
Message-ID: <CAF6AEGuC1HT97mytZtHm=-PW_VmFASjevg1pmJR7b4HRe4RMjA@mail.gmail.com>
Subject: Re: [PATCH 1/2] drm/msm: Register irq handler for each sub-system in mdss
From: Rob Clark <robdclark@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Hai Li <hali@codeaurora.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 3:57 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Sun, Nov 16, 2014 at 09:18:47AM -0500, Rob Clark wrote:
>> On Fri, Nov 14, 2014 at 5:42 PM, Hai Li <hali@codeaurora.org> wrote:
>> > All the sub-systems in mdss share the same irq. This change provides
>> > the sub-systems with the interfaces to register/unregister their own
>> > irq handlers.
>> >
>> > With this change, struct mdp5_kms does not have to keep the hdmi or
>> > edp context.
>> >
>>
>> So, I think the point of this is to better deal w/ different hw
>> variants which do or do-not have hdmi, edp, dsi, etc..
>>
>> But, just playing devil's advocate here, it seems like it would be
>> simpler to instead just do something like:
>>
>>     if (priv->hdmi && (intr & MDP5_HW_INTR_STATUS_INTR_HDMI))
>>         hdmi_irq(0, priv->hdmi);
>>
>>     if (priv->edp && (intr & MDP5_HW_INTR_STATUS_INTR_EDP))
>>         edp_irq(0, priv->edp);
>>
>>     ... etc ...
>>
>> It is a little less elegant.  But it is also less lines of code.  I
>> guess there will be plenty of necessary complexity as we add support
>> for all mdp5 features.  So avoiding some unnecessary complexity might
>> be a good thing in the long run.
>>
>> If we really did want to make it more dynamic, we could always extend
>> 'struct mdp_irq' to take both an irq mask and an initiator id, I
>> suppose.  I'm not sure if that is overkill.  AFAICT we really only
>> have 5 different subsystems to dispatch to (mdp5 itself, and
>> dsi0/dsi1/hdmi/edp), so simply adding some if-not-null checks in
>> mdp5_irq() seems pretty reasonable to me.
>
> To me this just seems like a regular interrupt multiplexer, so
> implementing it as an irq_chip would be the most appropriate. That way
> you get all the goodness of a well-tested code base for free and you can
> simply pass in the request_{threaded_,}irq()'s dev parameter.

yup, that is what I did here:

http://cgit.freedesktop.org/~robclark/linux/commit/?h=msm-next&id=d9a7093329225ae29bae370823af13290b133a7e

there is a bit of awkwardness related to threaded handlers..  for now
I don't need threaded handlers so the solution was to not use them

> Thierry
