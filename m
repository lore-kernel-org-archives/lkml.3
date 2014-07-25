Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523AbaGYTEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 15:04:25 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:56646 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753043AbaGYTEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 15:04:24 -0400
X-Sasl-enc: pIqF6NCa5aFdYjGUx6yl8a1cTgwta10IYsfopQq9tphG 1406315063
Date: Fri, 25 Jul 2014 16:04:11 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 6/8] x86, microcode, intel: total_size is valid only when
 data_size != 0
Message-ID: <20140725190411.GA21416@khazad-dum.debian.net>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
 <1406146251-8540-7-git-send-email-hmh@hmh.eng.br>
 <20140725164614.GE4421@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140725164614.GE4421@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2014, Borislav Petkov wrote:
> On Wed, Jul 23, 2014 at 05:10:49PM -0300, Henrique de Moraes Holschuh wrote:
> > According to the Intel SDM vol 3A (order code 253668-051US, June 2014),
> > on section 9.11.1, page 9-28:
> > 
> > "For microcode updates with a data size field equal to 00000000H, the
> > size of the microcode update is 2048 bytes. The first 48 bytes contain
> > the microcode update header. The remaining 2000 bytes contain encrypted
> > data."
> > 
> > "For microcode updates with a data size not equal to 00000000H, the total
> > size field specifies the size of the microcode update"
> > 
> > We were incorrectly assuming that total_size is valid when it is
> > non-zero, instead of checking data_size to be non-zero.  IOW, we were
> > trusting a reserved field to be zero in a situation where it was, in
> > fact, undefined.
> 
> I'm perfectly fine with the patch except this statement above. I can't
> parse it. What reserved field?

Yeah, that commit text could be a bit more clear...

Up to 2002/2003, Intel used an "old format" for the microcode update
containers that was always 2048 bytes in size.  That old format did not have
Data Size and Total Size fields, the quadwords at those positions in the
microcode container header were "reserved".  The microcode header of the
"old format" microcode container has a hrdver of 0x01.  You can hunt down an
old copy of the Intel SDM to validate this through its order number
(#243192).  I found one from 1999 through a Google search.

Sometime in 2002/2003 (AFAICT, for the Prescott processors), Intel
documented a new format for the microcode containers and contributed in 2003
some code to the Linux kernel microcode driver implementing support for the
new format.  This new format has Data Size and Total Size fields, as well as
the optional extended signature table.  However, it reuses the same hrdver
as the old format (0x01), and it can only be told apart from the old format
by a non-zero Data Size field.

In fact, the only reason we can even trust a Data Size of zero to mean that
the microcode container is in the old format, is because Intel reatroatively
promised that the old format would always have a zero there when they wrote
the documentation for the _new_ format.

I have a hunch that the processor flags field went through a similar
extension in the late 1990's.  I couldn't find an old enough Intel SDM to
validate this, though.

Well, enough with the archeology.

> I'd guess the packages they distribute always have total_size
> initialized properly, i.e. in the case where data_size is 0, total_size
> is 2048 anyway. This is maybe the reason why nobody hit this bug as
> get_totalsize() returning always the correct number.
> 
> Right?

Correct.

As far as I can tell, Intel has always filled the reserved fields in the
microcode data files with zeros.  That's why this bug is harmless and went
"undetected" for >10 years.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
