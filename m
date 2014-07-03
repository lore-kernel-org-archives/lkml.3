Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbaGCIWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:22:11 -0400
Received: from mail01.baslerweb.com ([80.156.24.166]:6907 "EHLO
	mail01.baslerweb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694AbaGCIWJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:22:09 -0400
Message-ID: <53B512AE.2040802@baslerweb.com>
Date: Thu, 3 Jul 2014 10:22:06 +0200
From: Stefan Klug <stefan.klug@baslerweb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <linux-usb@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] USB: zerocopy support for usbfs
References: <Pine.LNX.4.44L0.1407021532370.874-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1407021532370.874-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [172.16.50.117]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 02.07.2014 21:38, Alan Stern wrote:
> On Wed, 2 Jul 2014, Oliver Neukum wrote:
>
>> 
Stefan Klug
Software Developer

Basler AG
An der Strusbek 60-62
22926 Ahrensburg
Germany

Tel. +49 4102 463 582
Fax +49 4102 463 46 582
 
Stefan.Klug@baslerweb.com

www.baslerweb.com

Vorstand: Dr.-Ing. Dietmar Ley (Vorsitzender) · John P. Jennings · Arndt Bake · Hardy Mehl
Aufsichtsratsvorsitzender: Norbert Basler 
Basler AG · Amtsgericht Lübeck HRB 4090 · Ust-IdNr.: DE 135 098 121 · Steuer-Nr.: 30 292 04497 · WEEE-Reg.-Nr. DE 83888045
On Wed, 2014-07-02 at 17:53 +0200, Stefan Klug wrote:
>>
>>> Implementation details:
>>> The patch only touches drivers/usb/core/devio.c.
>>> In procy_do_submiturb(), it is checked if zerocopy is allowed. This is
>>> currently a rough
>>> check which compares the number of required pages to
>>> ps->dev->bus->sg_tablesize.
>> It seems to me that the check is per call, so using
>> multiple calls one could still pin unlimited amounts
>> of memory.
> usbfs keeps track of the total amount of pinned memory and enforces an
> overall limit.  It will be necessary to add the size of the transfer
> buffer to that total.
Leaving the zerocopy transfers out of this limit was intentional. I 
thought this is user-memory so we shouldn't add it to the overall limit 
as it is not allocated by usbfs.
But I didn't think of the pinning problem. So yes, I can add it to the 
overall limit.
>>> I don't know if there is more to check there.
>>> Then the user memory provided inside the usbdevfs_urb structure is
>>> pinned to
>>> physical memory using get_user_pages_fast().
>>> All the user pages are added to the scatter-gather list and the logic
>>> continues as before.
>> How do you enforce the cache coherency rules?
> There is no way to do this.  If the user program accesses memory when
> it shouldn't, the transfer might not work right.
So this one is fine, right?
>> Also you don't have a fall back if get_user_pages_fast()
>> returns less than requested. It seems to me that than you
>> ought to fall back buffered IO.
> Agreed.
Good point. I'll add the fallback to the next iteration.
