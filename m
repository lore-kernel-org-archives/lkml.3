Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbbA2PFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:05:07 -0500
Received: from keetweej.vanheusden.com ([80.101.105.103]:39894 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbbA2PFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:05:05 -0500
X-Greylist: delayed 507 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Jan 2015 10:05:05 EST
Date: Thu, 29 Jan 2015 15:56:36 +0100
From: folkert <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: [3.18.3] poll() on gpio pins broken
Message-ID: <20150129145636.GU21469@belle.intranet.vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: www.smartwinning.info
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F077C42
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F077C42
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Thu Jan 22 15:15:45 CET 2015
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For timekeeping I wrote a program which waits for interrupts on
gpio-pins and then tells the local ntp daemon the clock offset.
I'm aware of the pps support in recent kernel but that does not work
(yet) on all platforms (eg cubieboard 1).

This has worked for quite some time but no longer.

Until at least kernel 3.12 I could do:

// export gpio pin
// set direction to in
// set direction to rising
int fd = open("/sys.../value", O_RDONLY);
fdset[0].fd = fd;
fdset[0].events = POLLPRI;
fdset[0].revents = 0;
poll(fdset, 1, -1);
// at this point pin went high

So: I would setup a gpio-pin using /sys-files, and then use poll() to
wait for the interrupt triggered by the level of the gpio pin going
high.
This worked fine on all raspberry pi's I tried, a nanos g20, a beagle
bone black and a cubieboard 1.

Since kernel 3.18.3 (.4 as well) this no longer works: 

1422542104.894908947] interrupt #2459, offset -0.105091s
1422542104.895162937] interrupt #2460, offset -0.104837s
1422542104.895408928] interrupt #2461, offset -0.104591s
1422542104.895650919] interrupt #2462, offset -0.104349s
1422542104.896293896] interrupt #2463, offset -0.103706s
...

As you can see suddenly the poll returns immediately.

strace learns me:
poll([{fd=3, events=POLLPRI}], 1, -1)   = 1 ([{fd=3, revents=POLLPRI|POLLERR}])

So apparently somewhere between 3.12 and 3.18 it is no longer
allowed/possible to do poll() on a gpio-pin value device.

Am I right that something broke the abi? Or have I been doing it wrong
and did that became visible?
Please advise.

thanks

Folkert van Heusden

-- 
