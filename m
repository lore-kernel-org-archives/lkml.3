Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab3AWRHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 12:07:50 -0500
Received: from mout.web.de ([212.227.15.3]:52296 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756242Ab3AWRHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 12:07:49 -0500
Message-ID: <510018B4.9040903@web.de>
Date: Wed, 23 Jan 2013 18:07:00 +0100
From: Soeren Moch <smoch@web.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>
CC: Arnd Bergmann <arnd@arndb.de>, Jason Cooper <jason@lakedaemon.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
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
References: <20121119144826.f59667b2.akpm@linux-foundation.org> <201301171049.30415.arnd@arndb.de> <50F800EB.6040104@web.de> <201301172026.45514.arnd@arndb.de> <50FABBED.1020905@web.de> <20130119185907.GA20719@lunn.ch> <5100022D.9050106@web.de> <20130123162515.GK13482@lunn.ch>
In-Reply-To: <20130123162515.GK13482@lunn.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:mW7ofYxrZWYeX4G91+PJ7xfiz7WA76c2YN3s+SbDo2B
 5EeCX/KVLPJ3R6e/jlQKX8TsAuRQIyQbRgpwgagJcLBgSjfSWq
 wnp43hDUgX3GPLjiHV+sozlFPufIr+AG/TPgRQnXzuhDD53acX
 Uidhlnb8N/toGbRg7etXkB8pDv796KWm+kKF3zuqBl5XwPrFul
 tA98ZzMorAFiYi0rTAR1A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.01.2013 17:25, Andrew Lunn wrote:
> On Wed, Jan 23, 2013 at 04:30:53PM +0100, Soeren Moch wrote:
>> On 19.01.2013 19:59, Andrew Lunn wrote:
>>>> Please find attached a debug log generated with your patch.
>>>>
>>>> I used the sata disk and two em28xx dvb sticks, no other usb devices,
>>>> no ethernet cable connected, tuners on saa716x-based card not used.
>>>>
>>>> What I can see in the log: a lot of coherent mappings from sata_mv
>>>> and orion_ehci, a few from mv643xx_eth, no other coherent mappings.
>>>> All coherent mappings are page aligned, some of them (from orion_ehci)
>>>> are not really small (as claimed in __alloc_from_pool).
>>>>
>>>> I don't believe in a memory leak. When I restart vdr (the application
>>>> utilizing the dvb sticks) then there is enough dma memory available
>>>> again.
>>>
>>> Hi Soeren
>>>
>>> We should be able to rule out a leak. Mount debugfg and then:
>>>
>>> while [ /bin/true ] ; do cat /debug/dma-api/num_free_entries ; sleep 60 ; done
>>>
>>> while you are capturing. See if the number goes down.
>>>
>>>        Andrew
>>
>> Now I built a kernel with debugfs enabled.
>> It is not clear to me what I can see from the
>> dma-api/num_free_entries output. After reboot (vdr running) I see
>> decreasing numbers (3453 3452 3445 3430...), min_free_entries is
>> lower (3390). Sometimes the output is constant for several minutes (
>> 3396 3396 3396 3396 3396,...)
>
> We are interesting in the long term behavior. Does it gradually go
> down? Or is it stable? If it goes down over time, its clearly a leak
> somewhere.
>

Now (in the last hour) stable, occasionally lower numbers:
3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 
3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 
3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 
3396 3396 3396 3396 3396 3396 3396 3396 3396 3365 3396 3394 3396 3396 
3396 3396 3373 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 
3396 3353 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 
3394 3396 3396 3396 3396 3396 3396 3396

Before the last pool exhaustion going down:
3395 3395 3389 3379 3379 3374 3367 3360 3352 3343 3343 3343 3342 3336 
3332 3324 3318 3314 3310 3307 3305 3299 3290 3283 3279 3272 3266 3265 
3247 3247 3247 3242 3236 3236

Soeren
