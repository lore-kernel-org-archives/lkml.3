Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbaE1Vtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:49:39 -0400
Received: from mail.kernel.org ([198.145.19.201]:42281 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755671AbaE1Vth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:49:37 -0400
Date: Wed, 28 May 2014 18:49:33 -0300
From: "'Arnaldo Carvalho de Melo'" <acme@kernel.org>
To: Chris Friesen <chris.friesen@windriver.com>
Cc: David Laight <David.Laight@ACULAB.COM>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Ondrej =?iso-8859-1?Q?B=EDlka?= <neleai@seznam.cz>,
        Caitlin Bestler <caitlin.bestler@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Elie De Brauwer <eliedebrauwer@gmail.com>,
        David Miller <davem@davemloft.net>,
        Steven Whitehouse <steve@chygwyn.com>,
        =?iso-8859-1?Q?R=E9mi?= Denis-Courmont 
	<remi.denis-courmont@nokia.com>,
        Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH/RFC] Re: recvmmsg() timeout behavior strangeness [RESEND]
Message-ID: <20140528214933.GF2764@kernel.org>
References: <20140526211706.GA25474@kernel.org>
 <5384BEC5.2080607@gmail.com>
 <20140527192115.GD25474@kernel.org>
 <CAKgNAkht1vubHueYPpkRu_W5B8OYW3rPUkHeLEq5WMVbCvO47w@mail.gmail.com>
 <20140527203010.GA2764@kernel.org>
 <5385D47A.3070401@gmail.com>
 <20140528150720.GB2764@kernel.org>
 <063D6719AE5E284EB5DD2968C1650D6D1724F2A0@AcuExch.aculab.com>
 <20140528195004.GD2764@kernel.org>
 <5386563F.8000901@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5386563F.8000901@windriver.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, May 28, 2014 at 03:33:51PM -0600, Chris Friesen escreveu:
> On 05/28/2014 01:50 PM, 'Arnaldo Carvalho de Melo' wrote:
 
> >What is being discussed here is how to return the EFAULT that may happen
> >_after_ datagram processing, be it interrupted by an EFAULT, signal, or
> >plain returning all that was requested, with no errors.

> >This EFAULT _after_ datagram processing may happen when updating the
> >remaining timeout, because then how can userspace both receive the
> >number of successfully copied datagrams (in any of the cases mentioned
> >in the previous paragraph) and know that that timeout can't be used
> >because there was a problem while trying to copy it to userspace
> >(EFAULT)?
 
> How does select() handle this problem?  It updates the timeout and also
> modifies other data.
 
> Could we just check whether the timeout pointer is valid before doing
> anything else?  Of course we could still fault the page out while waiting
> for messages and then fail to fault it back in later, but that seems like a
> not-very-likely scenario.

I'll check how select behaves, and yes, I think it is not-very-likely
and what we're doing now is reasonable for datagram protocols, i.e. to
return -EFAULT when updating the timeout fails, not reporting if packets
were successfully received, i.e. they end up being "dropped", as
userspace can't easily figure out if some was received short of painting
it with some pattern and then checking the ones that aren't with that
pattern.

- Arnaldo
