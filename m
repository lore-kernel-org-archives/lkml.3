Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaAXCZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 21:25:59 -0500
Received: from nm15-vm2.access.bullet.mail.gq1.yahoo.com ([216.39.63.43]:28793
	"EHLO nm15-vm2.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751113AbaAXCZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 21:25:56 -0500
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Jan 2014 21:25:55 EST
X-Yahoo-Newman-Id: 82382.19973.bm@smtp115.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 8bLGZ_AVM1koTIhnkS.cPZlzXDsor4AkB.Uip2HhQE3SUCW
 7.oWr7DjPtFzS3LS7vSKSbAmJ9MUNPk8WiaLZVfpIA3MdY7b8IrVZXcPLoTa
 JX3wzqgyiHOMLYk_YgqJt.mRW98WXuFVM0FFL8l32M7eLF5dkO.a5pBy7Z2N
 lgayDA8zc8zRK2pZuEuGcke5bV.wVrEwRHWxDjMx1P_7oW0Q1TLQY6HODOj.
 u.A8NRRfBfl73Sc4E.onThoEeY8C8sIbiqFCFsl3OM4zpHqz5fcZPzMkOoFS
 Ghv0PmSPJjwSB0Rij_oNtqrxPUTfbQs9NRu9X1PjrLbBQ8EjAWJ8l4GQeDcp
 Qoe8V9QU.eKj3MEE6JA.ZYsCmmfYjzSON13M0Fg5SfVzZ_dDV81nW.hPacKm
 HTyek5HikUTr7JrWZgNv6j5mm4lA8m7Knume.fx0.hd6VyS9QA62LYELICCA
 fIMa8qmUXsAHbdJ5T5FhP8zO3gKzQ73ANdm42JbkD0P3tpcIyRFaKcLLRp9u
 oD.wNTLp2d9ECOaPoJLCahQSxyOPih586_NNEkIsVbPQz9L7mAmdDC2pRVyI
 cld3I1iMLsFd7GGjx9ML2X1tCWEuouWDWUzwd_u3iRiUDWYDhdBHbyZsda2y
 QK3v.FIbT8CCd1GTHqF8vVQqrYPBgpBEnj1_I225nYaE64j5_Ysw1r1FKu.1
 cNMUQTudWzWCLBBOY
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
X-Rocket-Received: from [192.168.1.4] (danielfsantos@99.70.244.137 with plain [98.138.31.74])
        by smtp115.sbc.mail.ne1.yahoo.com with SMTP; 24 Jan 2014 02:20:05 +0000 UTC
Message-ID: <52E1CE33.7040309@att.net>
Date: Thu, 23 Jan 2014 20:21:39 -0600
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>
CC: Daniel Santos <daniel.santos@pobox.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: spidev: fix hang when transfer_one_message fails
References: <1388965166-27334-1-git-send-email-daniel.santos@pobox.com> <CAMuHMdU0FRi4=YejN+3TLJCwcptHVaaGFTLPyuwzO4NH9=-cUw@mail.gmail.com> <20140123181737.GA11727@sirena.org.uk>
In-Reply-To: <20140123181737.GA11727@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2014 12:17 PM, Mark Brown wrote:
> On Thu, Jan 23, 2014 at 05:47:02PM +0100, Geert Uytterhoeven wrote:
>
>> Probably your transfer_one_message() forgot to call
>> spi_finalize_current_message()? Is this allowed in case of failure?
> Probably not, or at least we should be consistent about requiring it or
> not.

Hmm, well it sounds like the core problem is a lack of specificity about 
the interface.

1. When a message is being rejected, who is responsible for finalizing 
it, the spi subsystem or the master driver?
2. What does a non-zero return value from transfer() or 
transfer_one_message() mean? transfer() is supposed to just queue the 
message and not sleep, so it would seem appropriate that it would mean 
that the message was rejected due to something being invalid or 
unsupported (or an OOM), etc. , but transfer_one_message() is also where 
*most but not all* drivers transmit the message, so should it mean the 
message was rejected outright for being invalid/unsupported/OOM or 
should it mean a failure, such as EIO while xmitting or both?
3. Is there ever a reason to set the message's status to anything other 
than the return value of transfer()/transfer_one_message()? From a 
cursory review of mainline spi drivers, this appears to vary. Some 
drivers are always returning zero while setting the status upon error, 
some return the status and others still will set the status to one 
value, but return a different error code.

So if a non-zero return value from transfer() or transfer_one_message() 
should also be the status, I'm thinking we can have a small reduction in 
the code footprint if it's done in the spi core. However, I suppose that 
I can't properly discuss this without delving into an almost unrelated 
issue, which may render the point moot.

The only reason I'm using transfer_one_message() at all is because 
transfer() is being deprecated. My driver (currently out-of-tree) 
supports both but will prefer transfer() as long as it hasn't been 
removed or become broken ( which I'm managing via a #if 
LINUX_VERSION_CODE >= KERNEL_VERSION(4,99,99) check: 
https://github.com/daniel-santos/mcp2210-linux/blob/master/mcp2210-spi.c#L143). 
The reason is for this is that the mcp2210 driver has an internal 
command queue that manages (per its requirements) spi messages as well 
as other types of commands to the remote (via USB) device (which is both 
an spi master and gpio chip). From a cursory review of other spi drivers 
in the mainline, I can see that at least two of them do this as well: 
spi-pxa2xx and spi-bfin-v3. So perhaps we need a non-deprecated 
mechanism to do our own queuing and avoid the overhead of the spi core 
providing a thread & queue which we'll just ignore. Then, the core can 
take care of setting status and finalizing when calls to transfer() fail 
(since there should be no ambiguity about this here), but leave that up 
to the driver when calling transfer_one_message()?

Either way, I think that we need to decide and spell it out in the 
kerneldocs.

Daniel
