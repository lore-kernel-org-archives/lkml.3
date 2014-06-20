Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934118AbaFTPkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:40:07 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:24180 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228AbaFTPkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:40:05 -0400
Message-ID: <53A45627.6090306@oracle.com>
Date: Fri, 20 Jun 2014 11:41:27 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, mattieu.souchaud@free.fr
Subject: Re: [PATCH] x86/mce: Don't unregister CPU hotplug notifier in error
 path
References: <1403274493-1371-1-git-send-email-boris.ostrovsky@oracle.com> <20140620152312.GB11391@pd.tnic>
In-Reply-To: <20140620152312.GB11391@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2014 11:23 AM, Borislav Petkov wrote:
> On Fri, Jun 20, 2014 at 10:28:13AM -0400, Boris Ostrovsky wrote:
>> Commit 9c15a24b038f4d8da93a2bc2554731f8953a7c17 (x86/mce: Improve
>> mcheck_init_device() error handling) unregisters (or never registers)
>> MCE's hotplug notifier if an error is encountered.
> Well, mcheck_init_device() did encounter errors before that commit too,
> can you please go into detail on how exactly you're triggering this?
> Which error are you talking about exactly?

You can simulate this on baremetal by having, for example, 
misc_register() fail (just add 'err = -EOI' after the call). Or you can 
return an error right upon entry to mcheck_init_device() (I haven't 
tested that though).

Then, after you are booted do a couple of
     echo 0 > /sys/devices/system/cpu/cpu1/online
     echo 1 > /sys/devices/system/cpu/cpu1/online

Then sit still for about 10 minutes. I don't think any activity is 
necessary.

You are dead now. If you are lucky you may see messages about soft 
lockups or RCU stalls but often nothing.

> Lemme guess: some xen special handling which baremetal doesn't need.

Only in the sense that on Xen misc_register() often fails. But any 
failure on baremetal will result in the same behavior.

>
>> Since unplugging a CPU would normally result in the notifier deleting
>> MCE timer we are now left with the timer running if a CPU is removed on
>> a system where mcheck_init_device() had failed.
>>
>> If we later hotplug this CPU back we add this timer again in
>> mcheck_cpu_init()). Eventually the two timers start intefering with each
>> other, causing soft lockups or system hangs.
>>
>> We should leave the notifier always on and, in fact, set it up early
>> during the boot.
> We do leave it always on - we only unregister it if we've encountered an
> error.

Right. And I think we shouldn't because we leave undeleted timers.

-boris

