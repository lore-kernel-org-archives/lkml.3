Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab3IZLbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 07:31:52 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:41689 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756549Ab3IZLbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 07:31:51 -0400
Message-ID: <52441B23.7050704@hurleysoftware.com>
Date: Thu, 26 Sep 2013 07:31:47 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Fengguang Wu <fengguang.wu@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: increased vmap_area_lock contentions on "n_tty: Move buffers
 into n_tty_data"
References: <20130913005133.GA32479@localhost>	<20130913010936.GA1291@localhost>	<5238767D.1080606@hurleysoftware.com>	<20130917232214.GA11390@localhost>	<5238F252.5070905@hurleysoftware.com> <20130926003315.2e81bc84.akpm@linux-foundation.org>
In-Reply-To: <20130926003315.2e81bc84.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 03:33 AM, Andrew Morton wrote:
> On Tue, 17 Sep 2013 20:22:42 -0400 Peter Hurley <peter@hurleysoftware.com> wrote:
>
>> Looking over vmalloc.c, the critical section footprint of the vmap_area_lock
>> could definitely be reduced (even nearly eliminated), but that's a project for
>> another day :)
>
> 20bafb3d23d10 ("n_tty: Move buffers into n_tty_data") switched a
> kmalloc (which is very fast) to a vmalloc (which is very slow) without
> so much as mentioning it in the changelog.  This should have been
> picked up at review, btw.
>
> Revert that part of the patch and the problem will be solved.
>
> If we are really really worried that a ~9k kmalloc might fail or will
> be slow, then implement a fallback to vmalloc() if kmalloc(GFP_NOWARN)
> failed.  This kinda sucks, but is practical, but really should only be
> done if necessary - ie, if problems with using plain old kmalloc are
> demonstrable.
>
> Or just revert all of 20bafb3d23d10 - it was supposed to be a small
> performance improvement but turned out to be a significant performance
> loss.  Therefore zap.

I have no particular objection to reverting the entire patch.

However, it's a mischaracterization to suggest that the reason is
because vmalloc() is very slow;  without reading /proc/meminfo,
there is no performance loss.

IOW, the lock contention this patch precipitated needs to get fixed
regardless.


Regards,
Peter Hurley
