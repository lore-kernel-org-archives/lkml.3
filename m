Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbaGIVel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 17:34:41 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:36493 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbaGIVek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 17:34:40 -0400
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F328573E4@ORSMSX114.amr.corp.intel.com>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
	<1404925766-32253-3-git-send-email-hskinnemoen@google.com>
	<3908561D78D1C84285E8C5FCA982C28F328573E4@ORSMSX114.amr.corp.intel.com>
Date: Wed, 9 Jul 2014 14:34:39 -0700
Message-ID: <CAFQmdRaZ-wNTFzm_CAvuCWrNGDuWWdYRzADXjmz27XgsFUgNaA@mail.gmail.com>
Subject: Re: [PATCH 2/6] x86-mce: Modify CMCI storm exit to reenable instead
 of rediscover banks.
From: Havard Skinnemoen <hskinnemoen@google.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 1:20 PM, Luck, Tony <tony.luck@intel.com> wrote:
>> The CMCI storm handler previously called cmci_reenable() when exiting a
>> CMCI storm. However, when entering a CMCI storm the bank ownership was
>> not relinquished by the affected CPUs. The CMCIs were only disabled via
>> cmci_storm_disable_banks(). The handler was updated to instead call a
>> new function, cmci_storm_enable_banks(), to reenable CMCI on the already
>> owned banks instead of rediscovering CMCI banks (which were still owned
>> but disabled).
>
> Won't this cause problems if we online a cpu during the storm. We will
> re-run the discovery algorithm and some other cpu that shares the bank
> will see MCi_CTL2{30} is zero and claim ownership.

Yes, I think you're right. We didn't test this with CPU hotplugging.

I'm at loss about how to fix it though. We need the CMCI bits to
detect shared banks, but they're not reflecting the actual state of
things at that point. If the CPU gives up ownership of the banks, then
we might just see the storm move from CPU to CPU, right?

We could keep a separate bitmask somewhere to indicate ownership, but
even if we can see that the bank is shared with some other CPU, we
don't know if it will be shared with a new CPU which we've never seen
before...

Perhaps we need to temporarily disable the storm handling when we're
bringing up a new CPU?

Havard
