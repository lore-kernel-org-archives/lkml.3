Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab3IST0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 15:26:21 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43637 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751822Ab3IST0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 15:26:19 -0400
X-Sasl-enc: SceqybzHaiphSnaYR17q5yGRm1ih+GAFFAraarCIs6/N 1379618778
Date: Thu, 19 Sep 2013 16:26:15 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: Jacob Shin <jacob.shin@amd.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Issues with AMD microcode updates
Message-ID: <20130919192615.GB10055@khazad-dum.debian.net>
References: <20130919145834.GA4298@khazad-dum.debian.net>
 <20130919164409.GA9427@pd.tnic>
 <20130919181554.GA10055@khazad-dum.debian.net>
 <20130919184656.GF9412@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130919184656.GF9412@pd.tnic>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Sep 2013, Borislav Petkov wrote:
> On Thu, Sep 19, 2013 at 03:15:54PM -0300, Henrique de Moraes Holschuh wrote:
> > I can request help on debian-user or debian-devel to get someone with
> > an AMD box to help with bissection, but it is usually best if we don't
> > ask general users to bissect kernels (due to non-zero risk of data
> > corruption if the bissect hit one of the problem spots that often show
> > up during the development window).
> 
> I have a couple of AMD boxes so I can bisect - I just need a reproducer
> how to trigger.

Sure.  There are two possibilities:


Possiblity one (the most likely): hang on first microcode update:

1. Have the lastest AMD microcode update (from linux-firmware) installed to
the proper place under /lib/firmware, but NOT yet uploaded to kernel.

2. run this:

   find /sys/devices/system/cpu -noleaf -type f -path '/sys/devices/system/cpu/cpu*/microcode/reload' | while read i ; do echo -n 1 >"$i" || true ; done

If the kernel is buggy, it should hang.  If it doesn't hang for a
supposed-bad kernel (2.6.38 or 3.5.2), please check "possibility two" below.



Possibility two: hang on second microcode update in a row:

1.  Install a previous version of the AMD microcode update (which must still
be newer than what is in the processor) to /lib/firmware/...

2. Run the command (2) above.   It should not hang, and it should update the
microcode in the processor.

3. Update /lib/firmware with the latest microcode from AMD (i.e. so that the
processor will have its microcode updated TWICE).

4. Run the command (2) above.   It should hang if the kernel is buggy.





I do not have any reports of kernels 3.6 and later causing issues.  If they
do, the "reproducer" should be this, instead:

  echo -n 1 > /sys/devices/system/cpu/microcode/reload

You can get earlier versions of the AMD microcode to test "possiblity two"
from the Debian package historical archive:

http://snapshot.debian.org/archive/debian/20120710T032858Z/pool/non-free/a/amd64-microcode/amd64-microcode_1.20120117.orig.tar.bz2
http://snapshot.debian.org/archive/debian/20120915T033250Z/pool/non-free/a/amd64-microcode/amd64-microcode_1.20120910.orig.tar.bz2

The latest version of the microcode is available in linux-firmware.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
