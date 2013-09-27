Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab3I0ThH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 15:37:07 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39710 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754516Ab3I0ThF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 15:37:05 -0400
X-Sasl-enc: BDmswVhj/7jFjPmQvoyGI0TwBnIfyIMxtPEssbIHO6CK 1380310621
Date: Fri, 27 Sep 2013 16:36:58 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Sherry Hurwitz <sherry.hurwitz@amd.com>
Cc: Borislav Petkov <bp@alien8.de>, Jacob Shin <jacob.shin@amd.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Issues with AMD microcode updates
Message-ID: <20130927193657.GA11294@khazad-dum.debian.net>
References: <20130919145834.GA4298@khazad-dum.debian.net>
 <20130919164409.GA9427@pd.tnic>
 <524221A5.9070808@amd.com>
 <20130925134922.GA14087@khazad-dum.debian.net>
 <524470A8.7090103@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524470A8.7090103@amd.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Sep 2013, Sherry Hurwitz wrote:
> We have failed to reproduce a hang while loading microcode.

I got an offer from a Debian user to test it over the weekend, let's hope
he will have more luck(?) at hitting the issue.  If he does, it should give
us sysrq+t dumps of the hung system.

> We have tested with kernel and AMD family combinations with
> normal and error condition so error paths were taken.  Obviously
> there are factors we are missing that the users are hitting.

Yeah, and it is not likely to be a kernel patch, as the users hit the issue
using non-distro kernels :-(

Maybe it is on the firmware-loader side, but one user did wait 1 hour for
the thing to get unstuck, and that would have taken care of any possible
firmware-loader timeouts.

> Any suggestions on how we improve the test matrix would be
> helpful.  We will continue the investigation but any insights are appreciated.
> 
> NOTE: kernels before 3.0 only load 1 (2k) size of microcode patch and
> therefore do not support microcode loading of family 14h, 15h, and 16h.
> Also,in a test request on another thread you suggested someone with
> family 15h revC0 to load microcode twice with an earlier patch and then
> the latest, but there has only been 1 microcode patch level published for revB2
> so that test won't work.

Well, it is the only thing I could think of, other than some nasty race
condition...

> kernel           cpu family             results             conditions
> ---------------------------------------------------------------------------------
> 2.6.38           fam10h                 load passed         normal
> 2.6.38           fam15h revC0           load failed         2.6.38 can not handle 4k patches
> 3.5.2            fam10h                 load passed         normal
> 3.5.2            fam15h revB2           load passed         loaded 637 then second load 63d
> 3.5.2            fam15h revC0           load passed         normal
> 3.5.2            fam15h revC0           load failed         used a corrupted bin file

I just looked, and the 2.6.38 hang happened for i686 and an unindentified
3-core AMD processor, and the 3.5.2 on x86-64 PREEMPT, on a fam15h model 2
stepping 0, 32-core AMD processor (Linux 3.5.2 (SMP w/32 CPU cores;
PREEMPT)).  No patterns there.

BTW, the userspace script that users reported to have hung is this:

grep -q "^vendor_id[[:blank:]]*:[[:blank:]]*.*AuthenticAMD" /proc/cpuinfo && {
if modprobe -q --first-time microcode ; then
    echo "Updating microcode on all online processors..." >&2
else
    # we have to trigger the microcode update manually
    if [ -e /sys/devices/system/cpu/microcode/reload ] ; then
	echo "Updating microcode on all online processors..." >&2
	echo 1 > /sys/devices/system/cpu/microcode/reload || {
	    echo "Kernel reported failure while updating microcode!" >&2
	}
    else
	# Try all online processors, broken kernels need this,
	# fixed kernels will accept it only on the BSP and update
	# all processors anyway, and -EINVAL all others... but we
	# don't know which one is the BSP, so we try all of them
	# and hide errors, the kernel will log any real problem.
	echo "Using per-core interface to update microcode on online processors..." >&2
	find /sys/devices/system/cpu -noleaf -type f -path '/sys/devices/system/cpu/cpu*/microcode/reload' | \
	    while read i ; do echo -n 1 2>/dev/null >"$i" || true ; done
    fi
fi
}


With the microcode driver already loaded (so, that modprobe line fails).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
