Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125AbaGXNwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:52:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:45136 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757725AbaGXNwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:52:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,724,1400050800"; 
   d="scan'208";a="566614671"
Message-ID: <53D11293.7050606@linux.intel.com>
Date: Thu, 24 Jul 2014 17:05:07 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Julius Werner <jwerner@chromium.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>
CC: Maciej Puzio <mx34567@gmail.com>, Mathias Nyman <mathias.nyman@intel.com>,
        David Laight <David.Laight@aculab.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: xhci: Fix Set TR Dequeue Pointer cycle state for
 quirky xHCs
References: <CACH_MLWEYRaT8RPHw-tdBBJoey283w1ED_QY6yXMiqYO5pjROg@mail.gmail.com>	<CAODwPW-x3RmQ95Zs0HKYkqOUN9G+r-mueW4d9G+x7qZGhctwRw@mail.gmail.com>	<CACH_MLVpnfJjQSEf3xqF_KQzsi=E=M=Fz2khEqajg7FdNR0x_g@mail.gmail.com>	<CAODwPW9UUGYzK3-83+PNXWKP4M5H=8GmYBjrgvW2Kg6nA6ssrw@mail.gmail.com>	<063D6719AE5E284EB5DD2968C1650D6D1726E25E@AcuExch.aculab.com>	<1404846104-4959-1-git-send-email-jwerner@chromium.org>	<CACH_MLUEKbFtrN2vMHdVEpJFJ=e9adEyU=OwPMh5TcrUuRQPHw@mail.gmail.com>	<A2CA0424C0A6F04399FB9E1CD98E0304844BF057@US01WEMBX2.internal.synopsys.com> <CAODwPW_o5=Cf7W1=7zBQnNs2kQLKsQLm93BAAgd00=MeRXoH_g@mail.gmail.com>
In-Reply-To: <CAODwPW_o5=Cf7W1=7zBQnNs2kQLKsQLm93BAAgd00=MeRXoH_g@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 10:50 PM, Julius Werner wrote:
>> Hmm. Wouldn't it be safer to have a quirk for this, and only enable
>> the workaround if the Asmedia controller is detected? This code is so
>> complicated that it is difficult to see whether this could have a
>> harmful effect on controllers without the bug.
> 
> Sorry for making it complicated, but it kinda has been like that
> before already... I don't think the new patch adds much confusion on
> its own. I would really advise against making this a quirk: checking
> for it in every case essentially doesn't cost us anything (just one
> more register compare that is negligible against all the
> cache-coherent memory accesses of walking the ring), and hardcoding a
> quirk would mean that we have to identify and add every host
> controller that does this individually.
> 
> I still haven't seen anything in the XHCI spec that actually forbids
> this behavior, so it might be a perfectly legal interpretation and who
> knows how many host controllers chose to do it that way. Until we find
> them all, we would have some really bad and hard to track down bugs on
> those controllers (we really just got lucky this time that Maciej was
> able to catch it in a bisect). I think it's better to program the
> driver defensively and able to deal with unexpected situations in
> general.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

It's starting to get a bit too complicated.
xhci find_new_dequeue_state() now has four places where it can toggle the cycle bit
in addition to the cycle toggle in find_trb_seg().

In the end we really just want to do it max once.

I'll see if I can simplify the whole cycle bit code somehow.

If not, then we need to take this or revert the original patch

-Mathias

 
