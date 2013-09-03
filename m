Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224Ab3ICBHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 21:07:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:6010 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756379Ab3ICBHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 21:07:33 -0400
X-IronPort-AV: E=Sophos;i="4.89,1009,1367942400"; 
   d="scan'208";a="8384053"
Message-ID: <52253607.9010907@cn.fujitsu.com>
Date: Tue, 03 Sep 2013 09:06:15 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH RESEND 2/3] x86, mm: Update min_pfn_mapped in add_pfn_range_mapped().
References: <1378117829-9095-1-git-send-email-tangchen@cn.fujitsu.com> <1378117829-9095-3-git-send-email-tangchen@cn.fujitsu.com> <CAE9FiQXtWc6ud6BpsvUa5F4KKEX7cT5Phj4wvZfEr6zeWZVpZA@mail.gmail.com>
In-Reply-To: <CAE9FiQXtWc6ud6BpsvUa5F4KKEX7cT5Phj4wvZfEr6zeWZVpZA@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/03 09:05:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/03 09:05:23,
	Serialize complete at 2013/09/03 09:05:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

On 09/03/2013 02:41 AM, Yinghai Lu wrote:
......
>
> Nak, you can not move that.
>
> min_pfn_mapped should not be updated before init_range_memory_mapping
> is returned. as it need to refer old min_pfn_mapped.
> and init_range_memory_mapping still init mapping from low to high locally.
> min_pfn_mapped can not be updated too early.

The current code is like this:

init_mem_mapping()
{
	while (from high to low) {
		init_range_memory_mapping()
		{
			/* Here is from low to high */
			for (from low to high) {
				init_memory_mapping()
				{
					for () {
						/* Need to refer min_pfn_mapped here */
						kernel_physical_mapping_init();
					}
					/* So if updating min_pfn_mapped here, it is too low */
					add_pfn_range_mapped();
				}
			}
		}		
	}
}

How about change the "for (from low to high)" in 
init_range_memory_mapping() to
"for_rev(from high to low)" ?
Then we can update min_pfn_mapped in add_pfn_range_mapped().

And also, the outer loop is from high to low, we can change the inner 
loop to be from high
to low too.

I think updating min_pfn_mapped in init_mem_mapping() is less readable. 
And min_pfn_mapped
and max_pfn_mapped should be updated together.

Thanks.

