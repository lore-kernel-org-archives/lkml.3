Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407AbaGXPHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:07:55 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49097 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758616AbaGXPHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:07:54 -0400
X-Sasl-enc: QfPvhmHA6EJzpeNwcAN225QyjB3QhCwOVzLALHeJKvwx 1406214471
Date: Thu, 24 Jul 2014 12:07:40 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 5/8] x86, microcode, intel: don't use fields from unknown
 format header
Message-ID: <20140724150740.GD32421@khazad-dum.debian.net>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
 <1406146251-8540-6-git-send-email-hmh@hmh.eng.br>
 <20140724113726.GL19239@pd.tnic>
 <20140724133059.GA32421@khazad-dum.debian.net>
 <20140724142802.GN19239@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724142802.GN19239@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2014, Borislav Petkov wrote:
> On Thu, Jul 24, 2014 at 10:30:59AM -0300, Henrique de Moraes Holschuh wrote:
> > We care about ->hdrver to get data from the header. We only care about
> > ->ldrver for the exact procedure to install it in the processor.
> 
> Does it matter?

It might.  It could break backwards-compatibility in the microcode update
distribution.

> microcode_sanity_check() errors out if any of the two are not 1 and we
> end up not applying the microcode if so.

We don't just skip that microcode, we also skip every microcode after that
one, because we _abort_ on the first error we find.  This is not the best
possible behaviour for a ldrver mismatch, where we could safely skip just
that one microcode.

Suppose you have a box that takes ldrver 1 microcode, and Intel releases
microcode for a new type of core that has a ldrver of 2, and it happens to
not be the last one in the microcode collection sent by userspace (via the
early initrd or /dev/cpu/microcode).  We might well abort before we find the
correct microcode update for that box.

It is an unlikely scenario, but AFAIK it is not impossible.  All it takes is
Intel releasing something APU-like and deciding to use the microcode update
facilities to update something that is not a CPU core.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
