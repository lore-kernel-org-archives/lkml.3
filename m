Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbaIZVMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 17:12:17 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:39964 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770AbaIZVMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 17:12:15 -0400
Date: Fri, 26 Sep 2014 23:12:12 +0200
From: Andreas Mohr <andi@lisas.de>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: alsa-devel@alsa-project.org, Andreas Mohr <andi@lisas.de>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ES938 support for ES18xx driver
Message-ID: <20140926211212.GA24145@rhlx01.hs-esslingen.de>
References: <1411755805-8165-1-git-send-email-linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411755805-8165-1-git-send-email-linux@rainbow-software.org>
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Sep 26, 2014 at 08:23:25PM +0200, Ondrej Zary wrote:
> -	return snd_card_register(card);
> +	err = snd_card_register(card);
> +	if (err < 0)
> +		return err;
> +
> +	if (mpu_port[dev] > 0 && mpu_port[dev] != SNDRV_AUTO_PORT)

Should probably add comment here, like:
		/* Since ES938 support is an optional component,
		   we choose to not take into account its failure result codes
		   as reason for fatal abort of soundcard registration. */
> +		snd_es938_init(&chip->es938, card, 0, 0);
> +
> +	return 0;
>  }

OTOH completely ignoring es938 result might be undesirable,
thus it could be suitable to at least add announcing failure via a dev_warn()
in addition to the comment.


> +static int snd_es938_read_reg(struct snd_es938 *chip, u8 reg, u8 *out)
> +{
> +	u8 buf[8];
> +	int i = 0, res;
> +	u8 sysex[] = { MIDI_CMD_COMMON_SYSEX, 0x00, 0x00, ES938_ID,
> +		       ES938_CMD_REG_R, reg, MIDI_CMD_COMMON_SYSEX_END };
> +	unsigned long end_time;
> +
> +	snd_rawmidi_kernel_write(chip->rfile.output, sysex, sizeof(sysex));

long snd_rawmidi_kernel_write(struct snd_rawmidi_substream *substream,
                              const unsigned char *buf, long count);

--> constify sysex!

Also, there is a "unsigned char" vs. "u8" type ""violation"".

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

Could we somehow manage to get rid of basing the calculation on jiffies?
AFAIK the kernel is strongly steering away from jiffies-based
calculation (normalizing things on ktime instead, AFAIK, or seconds-based),
for hopefully good reasons...
(ktime is an abstract, future-proof "kernel time",
and "msecs" is an obvious human-parseable unit,
whereas jiffies is a rather hardware-specific and ugly thingy).

> +
> +	/* check reply */
> +	if (memcmp(buf, sysex, 6) || buf[7] != MIDI_CMD_COMMON_SYSEX_END)
> +		return -1;
> +
> +	if (out)
> +		*out = buf[6];

A wee bit too many literals here for my taste...
(but it's not an overly clear-cut case of a simple direct sizeof(x)
replacement OTOH, so I'm still left wondering)

> +
> +	return 0;
> +}
> +
> +static void snd_es938_write_reg(struct snd_es938 *chip, u8 reg, u8 val)
> +{
> +	u8 sysex[] = { MIDI_CMD_COMMON_SYSEX, 0x00, 0x00, ES938_ID,
> +		       ES938_CMD_REG_W, reg, val, MIDI_CMD_COMMON_SYSEX_END };

See case above.

> +static const DECLARE_TLV_DB_SCALE(db_scale_tone, -900, 300, 0);

Yup, I also wanted to make use of TLV controls in my driver -
good to see that you're doing that already :)

> +
> +static struct snd_kcontrol_new snd_es938_controls[] = {
> +ES938_MIXER_TLV("Tone Control - Bass", 0, ES938_REG_TONE, 0, 7, db_scale_tone),
> +ES938_MIXER_TLV("Tone Control - Treble", 0, ES938_REG_TONE, 4, 7, db_scale_tone),
> +ES938_MIXER("3D Control - Level", 0, ES938_REG_SPATIAL, 1, 63),
> +ES938_MIXER("3D Control - Switch", 0, ES938_REG_SPATIAL_EN, 0, 1),
> +};
> +
> +int snd_es938_init(struct snd_es938 *chip, struct snd_card *card, int device,
> +		   int subdevice)
> +{
> +	int ret, i;
> +
> +	ret = snd_rawmidi_kernel_open(card, device, subdevice,
> +			SNDRV_RAWMIDI_LFLG_OPEN | SNDRV_RAWMIDI_LFLG_APPEND,
> +			&chip->rfile);
> +	if (ret < 0) {
> +		snd_printk(KERN_WARNING "es938: unable to open MIDI device\n");
> +		return ret;
> +	}

I've been told the Fashionable Logger API Of The Week is dev_warn(),
since it's providing proper implicitly dev context decorated logging,
thus changing all affected code might be useful.
OTOH prior code happens to be making use of snd_printk currently,
so there should be an earlier commit to first convert existing parts to new API,
and then have your ES938 commit, doing a dev_warn();
or simply have some resignation and do add this line as snd_printk(), too ;)
(for a later commit to then change everything to dev_warn())


notyet-Reviewed-by: Andreas Mohr <andim2@users.sf.net>

Thanks for such an interesting addition,

Andreas Mohr

-- 
GNU/Linux. It's not the software that's free, it's you.
