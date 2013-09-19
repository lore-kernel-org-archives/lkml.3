Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab3ISRgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 13:36:51 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:33503 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab3ISRgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 13:36:50 -0400
Date: Thu, 19 Sep 2013 19:36:49 +0200
From: Andreas Mohr <andi@lisas.de>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Andreas Mohr <andi@lisas.de>, alsa-devel@alsa-project.org,
        krzysztof.h1@wp.pl,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] ES938 support for ES18xx driver
Message-ID: <20130919173649.GA18537@rhlx01.hs-esslingen.de>
References: <20130915184902.GA23480@rhlx01.hs-esslingen.de>
 <201309152304.27585.linux@rainbow-software.org>
 <20130915212358.GB32375@rhlx01.hs-esslingen.de>
 <201309162220.55221.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201309162220.55221.linux@rainbow-software.org>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 16, 2013 at 10:20:54PM +0200, Ondrej Zary wrote:
> +static int snd_es938_read_reg(struct snd_es938 *chip, u8 reg, u8 *out)
> +{
> +	u8 buf[8];
> +	int i = 0, res;
> +	u8 sysex[] = { MIDI_CMD_COMMON_SYSEX, 0x00, 0x00, ES938_ID,
> +		       ES938_CMD_REG_R, reg, MIDI_CMD_COMMON_SYSEX_END };
> +	unsigned long end_time;
> +
> +	snd_rawmidi_kernel_write(chip->rfile.output, sysex, sizeof(sysex));
> +
> +	memset(buf, 0, sizeof(buf));
> +	end_time = jiffies + msecs_to_jiffies(100);
> +	while (i < sizeof(buf)) {
> +		res = snd_rawmidi_kernel_read(chip->rfile.input, buf + i,
> +					      sizeof(buf) - i);
> +		if (res > 0)
> +			i += res;
> +		if (time_after(jiffies, end_time))
> +			return -1;
> +	}

Forgive me, but I seem to faintly remember that it's preferred for
user code to tend towards non-jiffies-based timing (IIRC due to
NOHZ efforts etc.).
So if that actually is the case, then one might want to change it to
less jiffies-dependent handling (use non-jiffies helpers), but then how?

> +static void snd_es938_write_reg(struct snd_es938 *chip, u8 reg, u8 val)
> +{
> +	u8 sysex[] = { MIDI_CMD_COMMON_SYSEX, 0x00, 0x00, ES938_ID,
> +		       ES938_CMD_REG_W, reg, val, MIDI_CMD_COMMON_SYSEX_END };
> +
> +	snd_rawmidi_kernel_write(chip->rfile.output, sysex, sizeof(sysex));

snd_rawmidi_kernel_write() is prototyped as const unsigned char *buf,
so perhaps...
const unsigned char buf[] = ...;?
(static const probably not so useful
e.g. since static const may be rather prone to cache misses)

Though personally I do favour u8, since "char" seems so unsuitably stringy -
but the prototype currently doesn't offer it typed that way...

(Almost-)Reviewed-By: Andreas Mohr <andim2@users.sf.net>

Andreas Mohr
