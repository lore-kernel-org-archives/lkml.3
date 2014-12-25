Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaLYVyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 16:54:39 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:64602 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaLYVyh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 16:54:37 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 3/3] i8k: Remove laptop specific config data (fan_mult, fan_max) from driver
Date: Thu, 25 Dec 2014 22:54:34 +0100
Message-ID: <4129190.SoIGvoiPho@xps13>
User-Agent: KMail/4.14.2 (Linux/3.19.0-rc1+; KDE/4.14.2; x86_64; ; )
In-Reply-To: <201412181208.58969@pali>
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <1420702.eyL56f8lc9@xps13> <201412181208.58969@pali>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 December 2014 12:08:58 Pali Rohár wrote:
> On Wednesday 10 December 2014 14:32:16 Gabriele Mazzotta wrote:
> > On Wednesday 10 December 2014 12:51:30 Pali Rohár wrote:
> > > On Tuesday 09 December 2014 21:07:01 Pali Rohár wrote:
> > > > Now we have autodetection code for fan multiplier and
> > > > maximal fan speed so we do not need to have those
> > > > constants for each laptop in kernel driver code.
> > > > 
> > > > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > > > ---
> > > > !!!Please do not apply this patch until all affected
> > > > machines will be tested!!!
> > > > 
> > > > I tested autodetection code only on Dell Latitude E6440
> > > > (where it worked). Other machines which needs to be
> > > > tested:
> > > > 
> > > > Dell Latitude D520
> > > > Dell Latitude E6540
> > > > Dell Precision WorkStation 490
> > > > Dell Studio
> > > > Dell XPS M140 (MXC051)
> > > > ---
> > > 
> > > Can somebody else with dell laptops test this patch series?
> > 
> > i8k_get_fan_nominal_rpm() returns -22 on my XPS13, so nothing
> > changed with this patch series applied.
> > 
> > Gabriele
> 
> So your BIOS cannot report nominal_rpm and because your machine 
> is not in dmi list, all 3 patches do nothing for your machine.
> 
> But you need to set multiplier to 1, right?
> 
> What about this patch? (on top of 3/3)
> 
> --- a/drivers/char/i8k.c
> +++ b/drivers/char/i8k.c
> @@ -850,6 +850,10 @@ static int __init i8k_probe(void)
>  		 */
>  		for (fan = 0; fan < I8K_FAN_COUNT; ++fan) {
>  			i8k_fan_mult[fan] = I8K_FAN_DEFAULT_MULT;
> +			if (i8k_get_fan_rpm(fan) > I8K_FAN_MAX_RPM) {
> +				i8k_fan_mult[fan] = 1;
> +				continue;
> +			}
>  			for (val = 0; val < 256; ++val) {
>  				ret = i8k_get_fan_nominal_rpm(fan, val);
>  				if (ret > I8K_FAN_MAX_RPM) {
> 
> 

Hi,

I'm sorry for replying only now, but I couldn't follow this thread
closely and I'm a bit lost now. I haven't tested the suggested
change, but I don't think it would work in a reliable way. It's not
rare for the fan to be completely stopped, especially on boot. You
are right though, 1 is the right multiplier.


Guenter, while I was trying to catch up, I noticed that the support
for the XPS 13 [1] will be added. May I ask you which revision of
the laptop was tested? I own the 9333 one and I'm not sure that
having i8k automatically loaded is a good idea. The reason is that
reading and setting the speed of the right (and only) fan causes a
freeze of the laptop of some milliseconds, enough to be annoying and
noticeable. I'm worried of the effect this might have in the everyday
use, users might start noticing random freezes because of one
application that all the sudden is able to read the speed of the fan.
I don't if the same happens on all the other Dell systems, this is
the first and only Dell laptop I owned.

If the tested laptop wasn't the XPS13 9333 and this problem does not
exists, would it be possible to make the DMI_PRODUCT_NAME string such
that it matches only the tested revision? The string that identifies
my laptop is "XPS13 9333".

Gabriele

[1] http://www.spinics.net/lists/kernel/msg1878801.html
