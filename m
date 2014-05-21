Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbaEUUbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 16:31:21 -0400
Received: from longford.logfs.org ([213.229.74.203]:43363 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbaEUUbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 16:31:19 -0400
Date: Wed, 21 May 2014 16:29:35 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: mix all saved registers into entropy pool
Message-ID: <20140521202934.GA30084@logfs.org>
References: <20140519211719.GA14563@logfs.org>
 <8761l0r6nc.fsf@tassilo.jf.intel.com>
 <20140520200803.GA22308@logfs.org>
 <20140521193905.GN1873@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140521193905.GN1873@two.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2014 21:39:05 +0200, Andi Kleen wrote:
> 
> > I think leaking of private keys or similar information is not a
> > concern.  But please prove me wrong.  Better you now than someone else
> > later.
> 
> While I don't have a concrete exploit it seems seems dangerous to me. 
> The LibreSSL people just removed a similar behavior from OpenSSL.

Similar, yes.  But there is a difference:
Unconditionally mixing your private key into the entropy pool yields
zero entropy.  While your private is hopefully unpredictable to an
attacker, it never changes.  OpenSSL mixed the private keys for no
benefit.

The reason why I want this patch in is to avoid a different
non-theoretical dangerous situation.  get_cycles() returns 0 on
several architectures and Ted's recent "improvements" are thus far
only noise.  Architectures could define random_get_entropy() to
something else, but no architecture does it.  Therefore we have
millions of embedded systems with interrupts as their sole entropy
source and jiffies as the only timestamp component.

To top it off, those same systems usually lack a read-write filesystem
and will not initialize /dev/random from state read out before the
last reboot.  Now try to estimate how much time has to pass since
reboot until those systems have accumulated 128 bits of entropy.  I
have not heard an estimate from anyone yet.

If you have an alternative approach to fix this very real problem
without potentially leaking private keys under conditions that also
allow more efficient attacks, I would love to know about it.  So far
this is my best attempt and it beats all alternatives I know about.
Which just shows you how horrible the alternatives are.

Also see:
http://blog.fefe.de/?ts=ada960dc
https://factorable.net/weakkeys12.extended.pdf

Jörn

--
The art of propaganda is not telling lies, but rather selecting
the truth you require and giving it mixed up with some truths
the audience wants to hear.
-- Richard Crossman
