Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbaDBJp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 05:45:59 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:56450 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062AbaDBJpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 05:45:54 -0400
Message-ID: <533BDC4F.3060903@suse.cz>
Date: Wed, 02 Apr 2014 11:45:51 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: gregkh@linuxfoundation.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] serial: 8250, disable "too much work" messages
References: <1396352220-5031-1-git-send-email-jslaby@suse.cz> <20140401144057.63b3ceb5@alan.etchedpixels.co.uk>
In-Reply-To: <20140401144057.63b3ceb5@alan.etchedpixels.co.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2014 03:40 PM, One Thousand Gnomes wrote:
> On Tue,  1 Apr 2014 13:37:00 +0200
> Jiri Slaby <jslaby@suse.cz> wrote:
> 
>> The 8250 driver now reports many of these:
>>   serial8250: too much work for irq4
>> These messages turned out to be common these days with a use of
>> virtualization. I tried to increase the limit of processed characters
>> in commit e7328ae1848966181a7ac47e8ae6cddbd2cf55f3 (serial: 8250,
>> increase PASS_LIMIT) in 2011. It was raised from 256 to 512, but it is
>> still not enough, apparently.
> 
> A lot of emulations model the queue completely incorrectly. However
> simply hiding it with a pr_debug is the wrong answer - it wants fixing.
> 
> If we set a large PASS_LIMIT then it's not going to be a big loss on real
> hardware - we'll burp for a second or two and continue, but it ought to
> cure the virtualisation case.
> 
> If it doesn't we've got a bigger problem because it means we are jammed
> in the kernel spinning in an IRQ handler feeding data to a fake serial
> port that never stops being an IRQ and we end up hanging the virtualised
> OS for a long period
> 
> If that is happening then we need to actually workaround whatever
> crapware emulator is triggering it so we don't hang the guest for long
> periods if there is a big I/O.
> 
> If its a real port that is jammed our normal time around the loop on the
> LPC bus is going to be a shade over 24uS (32uS if TX is jammed on)
> 
> So we certainly ought to be able to go a bit higher without major
> crisis. Beyond that if it is still tripping then instead of whining we
> need to set IIR_NO_INT and set a polling timer to turn the IRQ back on
> next timer tick. That way a crappy emulated port can't hang the guest
> with a continual stream of data and a busted real one might actually sort
> out.

So, according to Takashi's measurements, we would need over 15000 loops
on a single port. Of course, this value is highly dependent on a system.
On my system, it is like 7 times lower (2100). And it lasts ~300ms here.

I suppose a limit like 32k loops is way too much and I just should go
and implement the polling. Or what about adding inter-character sleeps
to qemu to correspond to the speed? I can do that too, but I am not sure
if limiting the throughput will be accepted by them.

thanks,
-- 
js
suse labs
