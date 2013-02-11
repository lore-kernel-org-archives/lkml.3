Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880Ab3BKQIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 11:08:37 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51370 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757651Ab3BKQIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 11:08:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
Date: Mon, 11 Feb 2013 16:08:29 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, dahinds@users.sourceforge.net
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <201302111543.46196.arnd@arndb.de> <CAHTX3dJ6pZWyGB=6T22wA_wR-Tqty+4Nywm84g_n4djTv-cT=g@mail.gmail.com>
In-Reply-To: <CAHTX3dJ6pZWyGB=6T22wA_wR-Tqty+4Nywm84g_n4djTv-cT=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302111608.29304.arnd@arndb.de>
X-Provags-ID: V02:K0:g/FZssOwNksQ6yEhoNuHrIcPZMBtBTHECe43ezeFLAM
 TPWXiVeLLkyU99E51bWliVJr7NNjZAIWZXMTjPQRmM4xxaqzIG
 1GfOASuBEJZF08Ri09U8GnwpvqBWjccJLnAYvLYlc+wJiREdHg
 zNCl73DLw6TI4cMX3+vLc/uzCZHcNaoebAwTo916bJ+85WSmOp
 eiZwJqE8qfKlv+yf3G1Ev+9kVKBuS/Oq/MgeB8Z1cHAfxDWNV7
 j3ET7Tnc6ZTnh+Sv+v4ARmw9VZxoAn3fkqd9V18f/Yaw5Gwhom
 mj4G9fBUJfiNyD5BeD3XtHG3Z/XoA/iOMJjRxQUmnA3pzxeeMI
 vMxTM2TXc1QLcSwdsrBo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2013, Michal Simek wrote:
> Unfortunately no. Another is spi/i2c (sysace as we discuss in this
> thread), probably icap
> network drivers are ok because they are not shared.
> Timer when it is moved to clocksource(not important right now)
> xilinx gpio is using __raw IO functions which is incorrect on arm in
> connection to barriers.
> 
> But it reminds me that maybe the easiest solution is not to use endian
> accessors just use two simple macros which should work on all systems.
> 
> #define <name>_readreg(offset)          ({__raw_readl(offset); rmb(); })
> #define <name>_writereg(offset, val)    ({wmb(); __raw_writel(val, offset); })
> 
> which is probably the faster solution which add minimum additional code
> to driver and can also remove endian detection code.

I tend to disagree. You should never assume that a device is the same
endianess as the the CPU, and you should try not to use the __raw_*
accessors in device drivers either.

In particular, ARM can run both big- and little-endian even though
big-endian is rarely used, so you need to know the endianess for
the device you are talking to rather than assume that it knows
what the CPU does at the time.

	Arnd
