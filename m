Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbaICPXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:23:07 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49570 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaICPXE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:23:04 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v3] hwspinlock: qcom: Add support for Qualcomm HW Mutex block
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20140903145508.GA16352@sonymobile.com>
Date: Wed, 3 Sep 2014 10:22:57 -0500
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>, Suman Anna <s-anna@ti.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Eric Holmberg <eholmber@codeaurora.org>,
        "Cavin, Courtney" <Courtney.Cavin@sonymobile.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <5B5C3B14-0FC8-4B4B-AE33-69030B7863D8@codeaurora.org>
References: <1409688246-16530-1-git-send-email-bjorn.andersson@sonymobile.com> <2B6A9AA9-E69F-47DF-A1E7-5C95B4E6FA94@codeaurora.org> <20140903145508.GA16352@sonymobile.com>
To: Bjorn Andersson <Bjorn.Andersson@sonymobile.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 3, 2014, at 9:55 AM, Bjorn Andersson <Bjorn.Andersson@sonymobile.com> wrote:

> On Wed 03 Sep 05:49 PDT 2014, Kumar Gala wrote:
> 
>> 
>> On Sep 2, 2014, at 3:04 PM, Bjorn Andersson <Bjorn.Andersson@sonymobile.com> wrote:
>> 
>>> Changes since v2:
>>> - MODULE_DEVICE_TABLE
>>> - Changed prefix to qcom
>>> - Cleaned up includes
>>> - Rely on reg and num-locks to figure out stride, instead of of_match data
>> 
>> I know Jeff prefers this method of computing stride, but I’m not a fan as
>> there isn’t a reason one could adjust qcom,num-locks in the dt for some
>> reason and leave regs alone.
>> 
> 
> All the current platform it's 32 consecutive mutexes with either 4 or 128 byte
> stride, so encoding it as data either way works fine. The hardware you're
> trying to describe with your dt is the addresses that spans your mutex
> registers and how many there are. So from the HW/dts pov I don't see why you
> would like to do this.
> 
> Then looking in the caf code, there is a limit of max 8 mutexes. So apparently
> there is some sort of usecase, I just don't know what or if it's valid from a
> dt pov.

I believe not all the mutexes are meant for the cores running linux.  However, I think we just expect linux to play nice and not touch anything it isn’t using explicitly.

> Going to that future awesome SoCs where it's still called tcsr-mutex, but with
> a stride of 4096 bytes makes me wonder; is that really a consecutive 128kb with
> nothing else in-between that we can ioremap?

think 64-bit machines with more address space to burn and wanting to separate resources to use MMUs for protection.

> I.e. can we really reuse this driver straight off for that SoC?

I dont see why not.

>>> diff --git a/Documentation/devicetree/bindings/hwlock/qcom-hwspinlock.txt b/Documentation/devicetree/bindings/hwlock/qcom-hwspinlock.txt
>>> +- compatible:
>>> +	Usage: required
>>> +	Value type: <string>
>>> +	Definition: must be one of:
>>> +		    "qcom,sfpb-mutex",
>>> +		    "qcom,tcsr-mutex”
>> 
>> I dont get the purpose of having different compatible strings if there is no
>> difference in the code between them.
>> 
> 
> The semantics are the same, but there are no mutex registers in the tcsr block
> in e.g 8960, so the name is just missleading. I assume that's why you didn't
> follow caf and used the compatible "sfpb" in the first place?

What do you expect the 8960 dt node to look like?  I’m not 100% against ‘sfpb’

I’m feel like we we should use compat for stride, so we’d end up with something like:

qcom,sfpb-mutex: stride 4 bytes, base: 0x01200604, reset: 0x01200600
qcom,tcsr-mutex: stride 128 bytes, base: 0xFD484000, reset: 0xFD485380
qcom,tcsr-4k-mutex: stride 4k bytes, base: 0x740000, reset: 0x767000

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

