Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbaHNNMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 09:12:37 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33227 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753902AbaHNNMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 09:12:35 -0400
X-Sasl-enc: J8nnhUYy5oSL2yympiOtWSRSexAs4du5PfzHR5ULK6Us 1408021954
Date: Thu, 14 Aug 2014 10:12:29 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: BUG: early intel microcode update violating alignment rules
Message-ID: <20140814131229.GB12624@khazad-dum.debian.net>
References: <20140809231911.GA4843@khazad-dum.debian.net>
 <20140811102245.GC4236@nazgul.tnic>
 <20140811131613.GA4541@khazad-dum.debian.net>
 <20140811140057.GA21693@pd.tnic>
 <53E910F7.1040806@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E910F7.1040806@tmr.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Aug 2014, Bill Davidsen wrote:
> Don't suppose you have anything in memory right after the microcode
> which you could put on the stack (15 bytes) slide the image up into
> alignment, load it, and put everything back. Haven't looked at the
> code or data, just tossing out an idea I used for something else
> back when.

Right after?  We don't know what will be there.  But we know what is right
before: there's enough bytes worth of microcode metadata header to align the
real microcode data to the previous 16-byte boundary.

This is a fix I should be fully capable of writing, actually.  But it will
be slower (two memcpy, two memove) and much nastier than the proper solution
using a scratch area (one memcpy).

That said, it is reported[1] that an Intel microcode update will take
anything from a couple hundred-thousand to several million cycles per
processor core.  I wouldn't lose any sleep over adding two 16-byte memcpy
and two ~32KiB memove to something that is already that expensive.  And it
will be easy to backport.

Anyway, I don't know enough to either add an initbss, or change the brk as
HPA hinted, or how easy would it be to backport that, so I will wait for
further directions.

Meanwhile, I prepared an iucode-tool v1.0.3 release that works around this
kernel issue for the benefit of the linux distros that use it[2].  It's at
https://gitorious.org/iucode-tool if anyone around here is interested.

[1] http://inertiawar.com/microcode/

[2] Debian, Ubuntu and their derivatives.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
