Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbaGCHsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 03:48:12 -0400
Received: from mail01.baslerweb.com ([80.156.24.166]:24856 "EHLO
	mail01.baslerweb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553AbaGCHsK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 03:48:10 -0400
Message-ID: <53B50AB7.2090709@baslerweb.com>
Date: Thu, 3 Jul 2014 09:48:07 +0200
From: Stefan Klug <stefan.klug@baslerweb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] USB: zerocopy support for usbfs
References: <Pine.LNX.4.44L0.1407021355060.874-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1407021355060.874-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [172.16.50.117]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 02.07.2014 20:24, Alan Stern wrote:
> Overall this implementation seems quite straightforward.  However, it
> appears that your email client has mangled the whitespace in the patch.
>
> The patch contains many style violations; you should run it through
> checkpatch.pl.  It also has one or two mistakes, such as the
> calculation of u for the amount of memory used.

I'll fix these...

>> Questions/Notes:
>> - I'm quite unhappy with the added member async::is_user_mem. Is there a
>> better place
>>     where I could store this information?
> No, async is the right place.  Why are you unhappy about it?
A whole byte for this flag felt a bit like an overkill, but I'm fine 
with that.

>> - I had a look at some other drivers using the get_user_pages ->
>> sg_set_page -> page_cache_release
>>     technique and didn't see any special code to handle corner cases.
>>     Are there corner cases? - Like usb controllers not supporting the
>> whole memory etc. ?
> Indeed yes.  The page addresses have to be checked against the DMA
> mask.  Also, many host controllers cannot handle arbitrary alignment.
> It would be best to require that the buffer start at a page boundary.

Is there any way to check if the host controller supports arbitrary 
alignment?
If I read the xhci spec correctly arbitrary alignment is explicitly 
permitted. In my use case
the user allocates large amounts of memory, which is passed down to 
submiturb in smaller chunks.
So asking the kernel for aligned memory for every chunk would force me 
to recombine to urbs on the user side,
adding another copy operation. So I would vote for a solution where the 
user can allocate the memory and pass it down
without restrictions.
The system should fallback to copying in kernel space, if the buffer is 
not supported by the
host-controller (but this is only the case for USB 2 and 1, right?).

>
>> - In the kernel log I see messages like:
>>     xhci_hcd 0000:00:14.0: WARN Event TRB for slot 4 ep 8 with no TDs queued?
>>     after enabling zerocopy. Any idea where this might come from?
> Not directly related; that's a bug in xhci-hcd.

Whew. That saves me a lot of trouble :-)
>
> Using a global module parameter to control the use of zerocopy (for
> anything other than debugging or testing) is a bad idea.  If you think
> people will have a reason for avoiding zerocopy then you should make it
> possible to decide for each URB, by adding a new flag to struct
> usbdevfs_urb.

I'd like to leave the parameter in for debugging purposes mostly, at 
least as long as this is not stable.
And it is a security measure. If anything goes wrong with zerocopy (are 
there buggy host-controllers out there?),
the user is able to disable it on a system wide basis.
>
> People will want to use zerocopy with isochronous transfers as well as
> bulk.  Implementing that isn't going to be quite so easy; it will be
> necessary for the user to set up a memory mapping.  In fact, once
> that's done the same mechanism could be used for bulk transfers too.
>
Yes you are right. I'll look into that. Is this a either both or nothing 
decision?
As I don't use isochronous transfers at all, it will be quite difficult 
for me to correctly test that.


Thanks a lot for your input.
Stefan

--

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
