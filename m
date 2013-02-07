Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945950Ab3BGXGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 18:06:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64047 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab3BGXGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 18:06:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
Date: Thu, 7 Feb 2013 23:05:41 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michal Simek <monstr@monstr.eu>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        dahinds@users.sourceforge.net
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <5113C818.9050307@synopsys.com> <CACxGe6srNmX+qL+5BBFOzTHtQLRcw+4Aqjexy0Y=Vbh3XqPWPA@mail.gmail.com>
In-Reply-To: <CACxGe6srNmX+qL+5BBFOzTHtQLRcw+4Aqjexy0Y=Vbh3XqPWPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302072305.41712.arnd@arndb.de>
X-Provags-ID: V02:K0:JRoVSMPTpjx9Sh1iZJgelU2u9Qu7XZwoXncfhv3ahXT
 1bfBL99fqBwvJWsSkjICtSqXp2zgzOj3el46XSCWrO9SOND+U0
 SsYi3kXgaekMrzSD60ngnentQizoLlFSiGq1IAOMxpt5TEutBR
 iL4xJ1Tm/WNq1cFQBU+P1iPKYf0PgBWgYdMWe8cF2xnSbdS+vv
 CPjAv3et+/kxa8HLap21CGUUnNvEeMukUWtTjGeOz/21oSk9sC
 z7wGmYQDu54qbBl07UZcB0pwM3dEQiNBfFzj+2aJKIw5OGo/W2
 Icb/xAFbdpwRJWnOZzE1nUm981TfQ2UmY8/BTy4r/k6704vkUx
 V/4vIjHyjmUqnv/GcWd4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2013, Grant Likely wrote:
> On Thu, Feb 7, 2013 at 3:28 PM, Alexey Brodkin

> Starting with register (non-data) access. The bus bindings are such
> that on both BE and LE systems a native 16 bit read results in the
> bits being in the correct order. On powerpc, you want to do a BE read
> because the device appears as a BE device, and on LE systems a LE read
> is wanted because that is how the device is wired. So far this makes
> sense and matches the driver.

Well, until you get a little-endian PowerPC system with this
device ;). I heard people are plannng to put those into
production systems. I would assume that the device would
still use big-endian registers, so the rule about PowerPC
using the BE accessors still holds, but it stops making
sense.

> The same is true for the data port. A BE read does the right thing on
> a BE platform, and LE read on a LE platform. (again, this is all about
> bus attachment). However, the difference is what is then done with the
> data.

Well, except that we cannot use the ioread16be_rep function,
which is made for the case where the bus does not swap.

Of course, as long as the driver is only ever used to access
the same non-removable block device and you don't change
the driver, it does not matter at all whether you swap bytes
on the data port or not, because they are swapped on both
read and write, and it's just storage. Only if you try to
read the device with a "correct" driver, you will see a problem
if it was written with a "wrong" driver.

> The ironic thing is that if the BE PPC/MB hardware engineers hadn't
> swapped the bytelanes then we would *still* have to do special thinks
> in the hardware; except it would be the data port accesses that would
> need extra work, instead of the other registers.

No, we would juse use the _rep() functions if they had done it right,
just like any other driver with this problem.

	Arnd
