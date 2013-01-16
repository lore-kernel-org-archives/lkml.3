Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab3API4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 03:56:22 -0500
Received: from mout.web.de ([212.227.15.3]:53497 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157Ab3API4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 03:56:20 -0500
Message-ID: <50F66B1B.40301@web.de>
Date: Wed, 16 Jan 2013 09:55:55 +0100
From: Soeren Moch <smoch@web.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v2] mm: dmapool: use provided gfp flags for all dma_alloc_coherent()
 calls
References: <20121119144826.f59667b2.akpm@linux-foundation.org> <1353421905-3112-1-git-send-email-m.szyprowski@samsung.com> <50F3F289.3090402@web.de> <20130115165642.GA25500@titan.lakedaemon.net> <20130115175020.GA3764@kroah.com> <20130115201617.GC25500@titan.lakedaemon.net> <20130115215602.GF25500@titan.lakedaemon.net> <50F5F1B7.3040201@web.de> <20130116024014.GH25500@titan.lakedaemon.net> <50F61D86.4020801@web.de>
In-Reply-To: <50F61D86.4020801@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:/V6ToJMdPRtNV57annveKxpD7lx6bWdCnHxsZlB9H3T
 t/UtdIkCsElcbfqNoxl03LRGfQ+UTwbUwjxBpCOyqeYa/ikZKt
 CRVtNoN0rEhmLoe+Gs526kblSG+7tEMqGyXdvGgmvyy3wSw6l/
 LvOpzn45CeAhqWWs5hR+x+EA/XKDdjgMjI6/Ihe690Hvy1ll2a
 fKww3FJ/dh/VfR4wkqBWw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.01.2013 04:24, Soeren Moch wrote:
> On 16.01.2013 03:40, Jason Cooper wrote:
>> Soeren,
>>
>> On Wed, Jan 16, 2013 at 01:17:59AM +0100, Soeren Moch wrote:
>>> On 15.01.2013 22:56, Jason Cooper wrote:
>>>> On Tue, Jan 15, 2013 at 03:16:17PM -0500, Jason Cooper wrote:
>>>>> If my understanding is correct, one of the drivers (most likely one)
>>>>> either asks for too small of a dma buffer, or is not properly
>>>>> deallocating blocks from the per-device pool.  Either case leads to
>>>>> exhaustion, and falling back to the atomic pool.  Which subsequently
>>>>> gets wiped out as well.
>>>>
>>>> If my hunch is right, could you please try each of the three dvb
>>>> drivers
>>>> in turn and see which one (or more than one) causes the error?
>>>
>>> In fact I use only 2 types of DVB sticks: em28xx usb bridge plus drxk
>>> demodulator, and dib0700 usb bridge plus dib7000p demod.
>>>
>>> I would bet for em28xx causing the error, but this is not thoroughly
>>> tested. Unfortunately testing with removed sticks is not easy, because
>>> this is a production system and disabling some services for the long
>>> time we need to trigger this error will certainly result in unhappy
>>> users.
>>
OK, I could trigger the error
   ERROR: 1024 KiB atomic DMA coherent pool is too small!
   Please increase it with coherent_pool= kernel parameter!
only with em28xx sticks and sata, dib0700 sticks removed.

>> Just out of curiosity, what board is it?
>
> The kirkwood board? A modified Guruplug Server Plus.
em28xx sticks: "TerraTec Cinergy HTC Stick HD" and "PCTV Quatro Stick"
dib0700 sticks: "WinTV-NOVA-TD Stick"
>>
>>> I will see what I can do here. Is there an easy way to track the buffer
>>> usage without having to wait for complete exhaustion?
>>
>> DMA_API_DEBUG
>
> OK, maybe I can try this.
>>
>>> In linux-3.5.x there is no such problem. Can we use all available memory
>>> for dma buffers here on armv5 architectures, in contrast to newer
>>> kernels?
>>
>> Were the loads exactly the same when you tested 3.5.x?
>
> Exactly the same, yes.
>
>> I looked at the
>> changes from v3.5 to v3.7.1 for all four drivers you mentioned as well
>> as sata_mv.
>>
>> The biggest thing I see is that all of the media drivers got shuffled
>> around into their own subdirectories after v3.5.  'git show -M 0c0d06c'
>> shows it was a clean copy of all the files.
>>
>> What would be most helpful is if you could do a git bisect between
>> v3.5.x (working) and the oldest version where you know it started
>> failing (v3.7.1 or earlier if you know it).
>>
> I did not bisect it, but Marek mentioned earlier that commit
> e9da6e9905e639b0f842a244bc770b48ad0523e9 in Linux v3.6-rc1 introduced
> new code for dma allocations. This is probably the root cause for the
> new (mis-)behavior (due to my tests 3.6.0 is not working anymore).

I don't want to say that Mareks patch is wrong, probably it triggers a
bug somewhere else! (in em28xx?)

> I'm not very familiar with arm mm code, and from the patch itself I
> cannot understand what's different. Maybe CONFIG_CMA is default
> also for armv5 (not only v6) now? But I might be totally wrong here,
> maybe someone of the mm experts can explain the difference?
>
Regards,
Soeren

