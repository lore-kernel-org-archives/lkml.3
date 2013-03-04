Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab3CDNYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 08:24:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756816Ab3CDNYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 08:24:45 -0500
Message-ID: <5134A080.9070308@redhat.com>
Date: Mon, 04 Mar 2013 08:24:16 -0500
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120601 Thunderbird/10.0.5
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
CC: Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org,
        Prarit Bhargava <prarit@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Asit Mallick <asit.k.mallick@intel.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] irq: add quirk for broken interrupt remapping on 55XX
 chipsets
References: <20130302155942.GA353@rhlx01.hs-esslingen.de>
In-Reply-To: <20130302155942.GA353@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2013 10:59 AM, Andreas Mohr wrote:
> Hi,
>
>> if ((revision == 0x13)&&  irq_remapping_enabled) {
>> +		pr_warn("WARNING WARNING WARNING WARNING WARNING
>> WARNING\n"
>> +			"This system BIOS has enabled interrupt
>> remapping\n"
>> +			"on a chipset that contains an errata making
>> that\n"
>> +			"feature unstable.  Please reboot with
>> nointremap\n"
>> +			"added to the kernel command line and contact\n"
>> +			"your BIOS vendor for an update");
>> +	}
>
> Forgive me, but ISTR that there's a special BIOS firmware quirk bug annotating
> logger warning message mechanism (have I managed to hit all keywords yet? ;)
> in the kernel which might be useful in this case.
>
>
> OK, found something (but I don't think it was the mechanism
> that ISTR - perhaps it got modernized?):
>
>
> include/linux/printk.h:
>
> /*
>   * FW_BUG
>   * Add this to a message where you are sure the firmware is buggy or
>   * behaves
>   * really stupid or out of spec. Be aware that the responsible BIOS
>   * developer
>   * should be able to fix this issue or at least get a concrete idea of
>   * the
>   * problem by reading your message without the need of looking at the
>   * kernel
>   * code.
>   *
>   * Use it for definite and high priority BIOS bugs.
>   *
>   * FW_WARN
>   * Use it for not that clear (e.g. could the kernel messed up things
>   * already?)
>   * and medium priority BIOS bugs.
>   *
>   * FW_INFO
>   * Use this one if you want to tell the user or vendor about something
>   * suspicious, but generally harmless related to the firmware.
>   *
>   * Use it for information or very low priority BIOS bugs.
>   */
>

It is not a firmware/BIOS bug. Prarit's comment to annotate it as
a HW_ERR is more accurate.  A software patch is being tested now
to see if it can do set-affinity in a manner that avoids this race
and enables IR to stay on for all these systems.  It requires
more testing to ensure the logic is valid.  This patch was
recommended as a necessary short-term fix, and to highlight to
others this possible state -- which Gerry mentioned he had.

Note: the race condition is a very small window, and could not
        be duplicated on upstream kernel on known-failing-hw b/c
        the interrupt rate dropped by 80%.

The errata's recommendation (to disable IR in the BIOS) makes
the option of a workaround impossible, since it will hide the
IR hw (no DMAR table for it).  The BIOS 'update' may be avoided,
and corrected, if testing yields positive results, and after
posting, others don't see a flaw in the logic that was missed
by other reviewers.

>
> So perhaps it is appropriate to be used here.
>
>
> HTH,
>
> Andreas Mohr
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

