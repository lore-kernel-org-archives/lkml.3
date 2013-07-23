Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab3GWIBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:01:07 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:54211 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab3GWIBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:01:06 -0400
Date: Tue, 23 Jul 2013 10:01:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Toshi Kani <toshi.kani@hp.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, dave@sr71.net,
        kosaki.motohiro@gmail.com, isimatu.yasuaki@jp.fujitsu.com,
        tangchen@cn.fujitsu.com, vasilis.liaskovitis@profitbricks.com
Subject: Re: [PATCH v2] mm/hotplug, x86: Disable ARCH_MEMORY_PROBE by default
Message-ID: <20130723080101.GB15255@gmail.com>
References: <1374256068-26016-1-git-send-email-toshi.kani@hp.com>
 <20130722083721.GC25976@gmail.com>
 <1374513120.16322.21.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374513120.16322.21.camel@misato.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Toshi Kani <toshi.kani@hp.com> wrote:

> > Could we please also fix it to never crash the kernel, even if stupid 
> > ranges are provided?
> 
> Yes, this probe interface can be enhanced to verify the firmware 
> information before adding a given memory address.  However, such change 
> would interfere its test use of "fake" hotplug, which is only the known 
> use-case of this interface on x86.

Not crashing the kernel is not a novel concept even for test interfaces...

Where does the possible crash come from - from using invalid RAM ranges, 
right? I.e. on x86 to fix the crash we need to check the RAM is present in 
the e820 maps, is marked RAM there, and is not already registered with the 
kernel, or so?

> In order to verify if a given memory address is enabled at run-time (as 
> opposed to boot-time), we need to check with ACPI memory device objects 
> on x86.  However, system vendors tend to not implement memory device 
> objects unless their systems support memory hotplug.  Dave Hansen is 
> using this interface for his testing as a way to fake a hotplug event on 
> a system that does not support memory hotplug.

All vendors implement e820 maps for the memory present at boot time.

How is the testing done by Dave Hansen? If it's done by booting with less 
RAM than available (via say the mem=1g boot parameter), and then 
hot-adding some of the missing RAM, then this could be made safe via the 
e820 maps and by consultig the physical memory maps (to avoid double 
registry), right?

How does the hotplug event based approach solve double adds? Relies on the 
hardware not sending a hot-add event twice for the same memory area or for 
an invalid memory area, or does it include fail-safes and double checks as 
well to avoid double adds and adding invalid memory? If yes then that 
could be utilized here as well.

I.e. fragility of an interface is our choice, not some natural given 
property.

Thanks,

	Ingo
