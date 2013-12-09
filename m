Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760980Ab3LIJen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:34:43 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:65498 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab3LIJei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:34:38 -0500
Message-ID: <1386581672.7152.108.camel@host5.omatika.ru>
Subject: Re: [PATCH 5/9] ARM: dts: provide DMA config to pxamci
From: Sergei Ianovich <ynvich@gmail.com>
To: Daniel Mack <zonque@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <cjb@laptop.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        DOCUMENTATION <linux-doc@vger.kernel.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>
Date: Mon, 09 Dec 2013 13:34:32 +0400
In-Reply-To: <52A587A0.1050503@gmail.com>
References: <1386348542-9584-1-git-send-email-ynvich@gmail.com>
	 <1386543229-1542-1-git-send-email-ynvich@gmail.com>
	 <1386543229-1542-6-git-send-email-ynvich@gmail.com>
	 <201312090233.58592.arnd@arndb.de> <52A587A0.1050503@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-09 at 10:04 +0100, Daniel Mack wrote:
> On 12/09/2013 02:33 AM, Arnd Bergmann wrote:
> > On Sunday 08 December 2013, Sergei Ianovich wrote:
> >> Non-dts implementation supply required DMA channel numbers as
> >> IORESOURCE_DMA. However, there is was no way to get them from
> >> device tree.
> > 
> > I just wrote a lengthy reply to this email to explain in what ways
> > you got it wrong, but then I saw that Daniel has already done all
> > the work in the right way in August, so nevermind that.
> > 
> > It hasn't made it upstream yet, but see http://list-archives.org/2013/08/07/linux-mtd-lists-infradead-org/patch-00-20-arm-pxa-move-core-and-drivers-to-dmaengine/f/3444199144
> > for how it's done. Maybe Daniel can comment on the status of his
> > patches.
> 
> I recently rebased all my patches on top of 3.13-rc3, and will resend in
> couple of days.
> 
> The real problem here is that by reworking the DMA related PXA bits, all
> drivers have to be changed at once, and a gradual transition seems
> impossible. For that, I was asking for help in areas where I don't have
> any hardware to test my patches on, but unfortunately, nobody got back
> to me yet.

Nice to have Daniel in this conversation. Your patch series is a big and
important work. However, I am not sure I will ever land as is exactly
for this reason.

DMA is a per-physical-device concept, not per-platform. Only the DMA
controller is per-platform. This means we need to rewrite all platform
drivers at once. This is roughly equivalent to adding a new platform
support in one patch, which is not going to work.

In patch 08/20 in the series above, you change 10% lines of the pxa mmc
driver. If we don't count boilerplate lines, this will amount to over
50%. In other word, the output is a new driver.

My proposal in to actually add new drivers for each platform device with
DMA and mark new ones EXPERIMENTAL. When they receive adequate testing
we remove the tag and mark the old one OBSOLETE. When we have a new
driver for every device presently supported, we will drop the whole old
series.

This should be very close to a gradual transition.

While we are in transition, I propose that we allow 'hackish' support
for device tree in the existing drivers. Platform devices are declared
in dtsi files, so when we move to a new driver we just change the
compatible string there. Actual devices with their one dts file won't
need any change. They will need a dtb recompile, though. This way we can
begin a migration to device tree in pxa immediately.

The patch series does just that.

