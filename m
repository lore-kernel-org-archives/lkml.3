Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab3EGPkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 11:40:46 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:36989 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab3EGPko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 11:40:44 -0400
Message-ID: <51892092.6010907@suse.cz>
Date: Tue, 07 May 2013 17:41:06 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        "salina@us.ibm.com" <salina@us.ibm.com>, okir@suse.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 01/15] Char: lp, protect LPGETSTATUS with port_mutex
References: <1367936303-13386-1-git-send-email-jslaby@suse.cz> <201305071648.35039.arnd@arndb.de>
In-Reply-To: <201305071648.35039.arnd@arndb.de>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 04:48 PM, Arnd Bergmann wrote:
> On Tuesday 07 May 2013, Jiri Slaby wrote:
>> From: "salina@us.ibm.com" <salina@us.ibm.com>
>>
>> The patch fixes a problem in the lp driver that can cause oopses as
>> follows:
>> process A:      calls lp_write, which in turn calls
>>                 parport_ieee1284_write_compat, and that invokes
>>                 parport_wait_peripheral
>> process B:      meanwhile does an ioctl(LPGETSTATUS), which call
>>                 lp_release_parport when done. This function will set
>>                 physport->cad = NULL.
>> process A:      parport_wait_peripheral tries to dereference
>>                 physport->cad and dies
>>
>> So, protect that code with the port_mutex in order to protect against
>> simultaneous calls to lp_read/lp_write.
>>
>> Similar protection is probably required for ioctl(LPRESET)...
>>
>> This patch was done by IBM a while back and we (at suse) have that
>> since at least 2004 in our repos. Let's make it upstream.
> 
> Hmm,  it seems the driver has changed a bit since 2004, at least when
> I added the lp_mutex to lp_open()/lp_ioctl(). It's probably worth
> taking a look at the bigger picture now, to combine lp_mutex with
> lp_table[minor].port_mutex. I don't see any reason why we can't always
> use the per-device mutex.

Yeah, it looks sensible to me too to get rid of the lp_mutex, another
BKL left-over. However I don't have the hardware, the patch I attached
was taken from our tree and tested, at least some time ago. Patches to
clean that mess up welcome.

thanks,
-- 
js
suse labs
