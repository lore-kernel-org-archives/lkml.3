Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaK2S14 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 13:27:56 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:43512 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaK2S1z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 13:27:55 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i8k: Add support for temperature sensor labels
Date: Sat, 29 Nov 2014 19:27:52 +0100
Message-ID: <2162660.rjBG3mszUn@xps13>
User-Agent: KMail/4.14.2 (Linux/3.18.0-rc5+; KDE/4.14.2; x86_64; ; )
In-Reply-To: <201411291818.18074@pali>
References: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com> <1419444.Nxv4HBGmNA@xps13> <201411291818.18074@pali>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 November 2014 18:18:18 Pali Rohár wrote:
> On Saturday 29 November 2014 18:07:19 Gabriele Mazzotta wrote:
> > On Saturday 29 November 2014 17:09:35 Pali Rohár wrote:
> > > On Saturday 29 November 2014 17:04:07 Pali Rohár wrote:
> > > > This patch adds labels for temperature sensors if SMM
> > > > function with EAX register 0x11a3 reports it. These
> > > > informations was taken from DOS binary NBSVC.MDM.
> > > > 
> > > > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > > > ---
> > > > 
> > > >  drivers/char/i8k.c |  110
> > > > 
> > > > +++++++++++++++++++++++++++++++++++++++++----------- 1
> > > > file changed, 88 insertions(+), 22 deletions(-)
> > > 
> > > I tested patch on Latitude E6440 and i8k CPU & GPU temps
> > > match intel coretemp & amd radeion temps.
> > > 
> > > But I would like if somebody with other Dell laptop can test
> > > if temperature labels are correct...
> > 
> > I tested it on my XPS13 9333, here what sensors outputs:
> > 
> > acpitz-virtual-0
> > Adapter: Virtual device
> > temp1:        +27.8°C  (crit = +105.0°C)
> > temp2:        +29.8°C  (crit = +105.0°C)
> > 
> > coretemp-isa-0000
> > Adapter: ISA adapter
> > Physical id 0:  +62.0°C  (high = +100.0°C, crit = +100.0°C)
> > Core 0:         +62.0°C  (high = +100.0°C, crit = +100.0°C)
> > Core 1:         +61.0°C  (high = +100.0°C, crit = +100.0°C)
> > 
> > i8k-virtual-0
> > Adapter: Virtual device
> > fan2:           0 RPM
> > CPU:          +62.0°C
> > Ambient:      +49.0°C
> > SODIMM:       +46.0°C
> > temp4:            N/A
> > 
> > CPU seems to be correct, but I can't say anything on Ambient
> > and SODIMM. temp4 is constantly equal to SODIMM without this
> > patch, so I'd say N/A is correct.
> > 
> > 
> > Gabriele
> 
> It is unknown for me how to directly read Ambient and SODIMM
> temperatures (without Dell SMM functions). So we can only trust
> Dell SMM that it reporting correct values and type is really
> Ambient and SODIMM.
> 
> And about temp4:
> 
> Label is not set when SMM function fails. Original DOS NBSVC.MDM
> just ignore all sensors for which SMM type function fails.
> 
> This patch should not disable any sensor, so if you previously
> had some value (<= 128°C) and now not, then there is some bug.
> 
> Can you test this patch?
> https://git.kernel.org/cgit/linux/kernel/git/gregkh/char-misc.git/comm
> it/?h=char-misc-testing&id=723493ca59c8d81fed3e7f261165fee493a29ffa
> 
> It is possible that same value is caused by incorrect use of
> prev[] array which should be fixed by above patch.
> 
> Can you test i8k with and without above patch?

I did some more tests. What I think is happening is that temp4_label
returns -22, so I sensors prints N/A without actually reading temp4_input.

I'm doing some tests to understand what's going on with temp4_input.
It reports the value of the last temp*_input I read. If I read it right
after I loaded i8k, I get an error (-22).

The same doesn't happen for temp3_label, which constantly returns -22.

I already had https://git.kernel.org/cgit/linux/kernel/git/gregkh/char-misc.git/commit/?h=char-misc-testing&id=723493ca59c8d81fed3e7f261165fee493a29ffa
applied. Without it, things seem not to change much.
I either get an error (-22) or some incorrect values (for now always
1000) when I read temp4_input right after i8k was loaded.
Once I read some other temp*_input, I always get the last value read.
