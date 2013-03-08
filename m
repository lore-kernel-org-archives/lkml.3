Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab3CHHk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 02:40:26 -0500
Received: from bitsync.net ([80.83.126.10]:34363 "EHLO bitsync.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab3CHHkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 02:40:25 -0500
X-Greylist: delayed 637 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Mar 2013 02:40:25 EST
Message-ID: <51399368.3040200@bitsync.net>
Date: Fri, 08 Mar 2013 08:29:44 +0100
From: Zlatko Calusic <zcalusic@bitsync.net>
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: Jiri Slaby <jslaby@suse.cz>, Daniel J Blueman <daniel@numascale-asia.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Steffen Persvold <sp@numascale.com>, mm <linux-mm@kvack.org>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kswapd craziness round 2
References: <5121C7AF.2090803@numascale-asia.com> <CAJd=RBArPT8YowhLuE8YVGNfH7G-xXTOjSyDgdV2RsatL-9m+Q@mail.gmail.com> <51254AD2.7000906@suse.cz> <CAJd=RBCiYof5rRVK+62OFMw+5F=5rS=qxRYF+OHpuRz895bn4w@mail.gmail.com> <512F8D8B.3070307@suse.cz> <CAJd=RBD=eT=xdEy+v3GBZ47gd47eB+fpF-3VtfpLAU7aEkZGgA@mail.gmail.com> <5138EC6C.6030906@suse.cz> <CAJd=RBC6JzXzPn9OV8UsbEjX152RcbKpuGGy+OBGM6E43gourQ@mail.gmail.com>
In-Reply-To: <CAJd=RBC6JzXzPn9OV8UsbEjX152RcbKpuGGy+OBGM6E43gourQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.03.2013 07:42, Hillf Danton wrote:
> On Fri, Mar 8, 2013 at 3:37 AM, Jiri Slaby <jslaby@suse.cz> wrote:
>> On 03/01/2013 03:02 PM, Hillf Danton wrote:
>>> On Fri, Mar 1, 2013 at 1:02 AM, Jiri Slaby <jslaby@suse.cz> wrote:
>>>>
>>>> Ok, no difference, kswap is still crazy. I'm attaching the output of
>>>> "grep -vw '0' /proc/vmstat" if you see something there.
>>>>
>>> Thanks to you for test and data.
>>>
>>> Lets try to restore the deleted nap, then.
>>
>> Oh, it seems to be nice now:
>> root       579  0.0  0.0      0     0 ?        S    Mar04   0:13 [kswapd0]
>>
> Double thanks.
>
> But Mel does not like it, probably.
> Lets try nap in another way.
>
> Hillf
>
> --- a/mm/vmscan.c	Thu Feb 21 20:01:02 2013
> +++ b/mm/vmscan.c	Fri Mar  8 14:36:10 2013
> @@ -2793,6 +2793,10 @@ loop_again:
>   				 * speculatively avoid congestion waits
>   				 */
>   				zone_clear_flag(zone, ZONE_CONGESTED);
> +
> +			else if (sc.priority > 2 &&
> +				 sc.priority < DEF_PRIORITY - 2)
> +				wait_iff_congested(zone, BLK_RW_ASYNC, HZ/10);
>   		}
>
>   		/*
> --
>

There's another bug in there, which I'm still chasing. Artificial sleeps 
like this just mask the real bug and introduce new problems (on my 4GB 
server kswapd spends all the time in those congestion wait calls). The 
problem is that the bug needs about 5 days of uptime to reveal it's ugly 
head. So far I can only tell that it was introduced somewhere between 
3.1 & 3.4.

Also, check shrink_inactive_list(), it already sleeps if really needed:

if (nr_writeback && nr_writeback >=
		(nr_taken >> (DEF_PRIORITY - sc->priority)))
	wait_iff_congested(zone, BLK_RW_ASYNC, HZ/10);

Regards,
-- 
Zlatko

