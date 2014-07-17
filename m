Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbaGQT5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 15:57:07 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:43779 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbaGQT5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 15:57:03 -0400
MIME-Version: 1.0
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304844BF057@US01WEMBX2.internal.synopsys.com>
References: <CACH_MLWEYRaT8RPHw-tdBBJoey283w1ED_QY6yXMiqYO5pjROg@mail.gmail.com>
	<CAODwPW-x3RmQ95Zs0HKYkqOUN9G+r-mueW4d9G+x7qZGhctwRw@mail.gmail.com>
	<CACH_MLVpnfJjQSEf3xqF_KQzsi=E=M=Fz2khEqajg7FdNR0x_g@mail.gmail.com>
	<CAODwPW9UUGYzK3-83+PNXWKP4M5H=8GmYBjrgvW2Kg6nA6ssrw@mail.gmail.com>
	<063D6719AE5E284EB5DD2968C1650D6D1726E25E@AcuExch.aculab.com>
	<1404846104-4959-1-git-send-email-jwerner@chromium.org>
	<CACH_MLUEKbFtrN2vMHdVEpJFJ=e9adEyU=OwPMh5TcrUuRQPHw@mail.gmail.com>
	<A2CA0424C0A6F04399FB9E1CD98E0304844BF057@US01WEMBX2.internal.synopsys.com>
Date: Thu, 17 Jul 2014 12:50:17 -0700
X-Google-Sender-Auth: 5z2Ttk_kn6Mp8rUM9qo_97wq82E
Message-ID: <CAODwPW_o5=Cf7W1=7zBQnNs2kQLKsQLm93BAAgd00=MeRXoH_g@mail.gmail.com>
Subject: Re: [PATCH] usb: xhci: Fix Set TR Dequeue Pointer cycle state for
 quirky xHCs
From: Julius Werner <jwerner@chromium.org>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: Maciej Puzio <mx34567@gmail.com>, Julius Werner <jwerner@chromium.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        David Laight <David.Laight@aculab.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm. Wouldn't it be safer to have a quirk for this, and only enable
> the workaround if the Asmedia controller is detected? This code is so
> complicated that it is difficult to see whether this could have a
> harmful effect on controllers without the bug.

Sorry for making it complicated, but it kinda has been like that
before already... I don't think the new patch adds much confusion on
its own. I would really advise against making this a quirk: checking
for it in every case essentially doesn't cost us anything (just one
more register compare that is negligible against all the
cache-coherent memory accesses of walking the ring), and hardcoding a
quirk would mean that we have to identify and add every host
controller that does this individually.

I still haven't seen anything in the XHCI spec that actually forbids
this behavior, so it might be a perfectly legal interpretation and who
knows how many host controllers chose to do it that way. Until we find
them all, we would have some really bad and hard to track down bugs on
those controllers (we really just got lucky this time that Maciej was
able to catch it in a bisect). I think it's better to program the
driver defensively and able to deal with unexpected situations in
general.
