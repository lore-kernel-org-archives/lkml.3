Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab3FDQxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:53:32 -0400
Received: from mail.candelatech.com ([208.74.158.172]:36761 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366Ab3FDQx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:53:28 -0400
Message-ID: <51AE1B81.20900@candelatech.com>
Date: Tue, 04 Jun 2013 09:53:21 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Joe Lawrence <joe.lawrence@stratus.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: Please add to stable:  module: don't unlink the module until
 we've removed all exposure.
References: <51A8E884.1080009@candelatech.com> <87ehclumhr.fsf@rustcorp.com.au> <alpine.DEB.2.02.1306022212200.10003@jlaw-desktop.mno.stratus.com> <alpine.DEB.2.02.1306030724230.19647@jlaw-desktop.mno.stratus.com> <alpine.DEB.2.02.1306031012460.22652@jlaw-desktop.mno.stratus.com> <51ACBD6A.1030304@candelatech.com> <51ACC60B.8090504@candelatech.com> <87d2s2to4z.fsf@rustcorp.com.au> <20130604100744.7cdf8777@jlaw-desktop.mno.stratus.com>
In-Reply-To: <20130604100744.7cdf8777@jlaw-desktop.mno.stratus.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 07:07 AM, Joe Lawrence wrote:
> On Tue, 04 Jun 2013 15:26:28 +0930
> Rusty Russell <rusty@rustcorp.com.au> wrote:
>
>> Do you have a backtrace of the 3.9.4 crash?  You can add "CFLAGS_module.o
>> = -O0" to get a clearer backtrace if you want...
>
> Hi Rusty,
>
> See my 3.9 stack traces below, which may or may not be what Ben had
> been seeing.  If you like, I can try a similar loop as the one you were
> testing in the other email.

My stack traces are similar.  I had better luck reproducing the problem
once I enabled lots of debugging (slub memory poisoning, lockdep,
object debugging, etc).

I'm using Fedora 17 on 2-core core-i7 (4 CPU threads total) for most of this
testing.  We reproduced on dual-core Atom system as well
(32-bit Fedora 14 and Fedora 17).  Relatively standard hardware as far
as I know.

I'll run the insmod/rmmod stress test on my patched systems
and see if I can reproduce with the patch in the title applied.

Rusty:  I'm also seeing lockups related to migration on stock 3.9.4+
(with and without the 'don't unlink the module...' patch.  Much harder
to reproduce.  But, that code appears to be mostly called during
module load/unload, so it's possible it is related.  The first
traces are from a system with local patches, applied, but a later
post by me has traces from clean upstream kernel.

Further debugging showed that this could be a race, because it seems
that all migration/ threads think they are done with their state machine,
but the atomic thread counter sits at 1, so no progress is ever made.

http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg443471.html

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

