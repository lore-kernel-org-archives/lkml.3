Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab3CBM0o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 07:26:44 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:45452 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab3CBM0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 07:26:43 -0500
Message-ID: <5131EFFE.4010700@openvz.org>
Date: Sat, 02 Mar 2013 16:26:38 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130119 Firefox/10.0.11esrpre Iceape/2.7.12
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        e1000-devel@lists.sourceforge.net,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>
Subject: Re: [E1000-devel] [PATCH RESEND 3/3] e1000e: fix accessing to suspended
 device
References: <20130225051010.12689.28611.stgit@zurg>  <20130225051911.12689.11167.stgit@zurg> <512C0B59.4020209@intel.com>  <512C8889.80107@openvz.org> <1361921710.2996.19.camel@bwh-desktop.uk.solarflarecom.com>
In-Reply-To: <1361921710.2996.19.camel@bwh-desktop.uk.solarflarecom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings wrote:
> On Tue, 2013-02-26 at 14:03 +0400, Konstantin Khlebnikov wrote:
>> Waskiewicz Jr, Peter P wrote:
>>> On 2/24/2013 9:19 PM, Konstantin Khlebnikov wrote:
>>>> This patch fixes some annoying messages like 'Error reading PHY register' and
>>>> 'Hardware Erorr' and saves several seconds on reboot.
>>>
>>> Any networking-related patches should also include netdev@vger.kernel.org.
>>
>> Yeah, I forgot about this, since I came here from PCI-bus side, not from the network =)
>>
>>>
>>> I'm also a bit confused how the changes below match the patch description.
>>   >  Elaborating a bit more how the changes suppress the messages might be a good thing.
>>
>> Patch eliminates reason of these errors -- now driver will wake up
>> the device before accessing to its registers.
> [...]
>
> But e1000e calls netif_device_detach() when entering run-time suspend.
> That currently prevents any ethtool operations from running until it
> resumes.

This seems racy. dev_ethtool() runs under rtnl-lock, but suspend-resume
run asynchronously. Runtime-suspend shoudn't call netif_device_detach(),
logically device isn't dead it just take a nap for a while..

>
> (This is definitely a misfeature of either the ethtool core or e1000e.
> It is absolutely ridiculous that I can't check the PHY settings of an
> e1000e - or even driver information! - when the link is down.)

Ok link is down, but device still alive and I not see anything ridiculous
in checking its registers.

