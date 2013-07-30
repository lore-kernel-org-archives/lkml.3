Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab3G3LnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 07:43:24 -0400
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:45881 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752523Ab3G3LnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 07:43:23 -0400
Date: Tue, 30 Jul 2013 13:33:11 +0200
From: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>
To: hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org, jonarne@jonarne.no,
        linux-kernel@vger.kernel.org, mchehab@redhat.com,
        prabhakar.csengg@gmail.com, laurent.pinchart@ideasonboard.com,
        andriy.shevchenko@linux.intel.com
Subject: Re: [RFC v3 3/3] saa7115: Implement i2c_board_info.platform_data
Message-ID: <20130730113311.GD4295@server.arpanet.local>
References: <1372894040-23922-4-git-send-email-jonarne@jonarne.no>
 <jonarne-tmp12w3123344232sd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jonarne-tmp12w3123344232sd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

Seems I've had some trouble with my mailserver that caused your message to bounce.
I had to download your email from a mailinglist archive.

On Wed, Jul 03, 2013 at 10:27:20PM -0000, hans.verkuil@cisco.com wrote:
> Hi Jon Arne,
> 
> Patches 1 & 2 look good to me. But I do have a few comments for this one:
> 
> On 07/04/2013 01:27 AM, Jon Arne J?rgensen wrote:
> > Implement i2c_board_info.platform_data handling in the driver so we can
> > make device specific changes to the chips we support.
> > 
> > I'm adding a new init table for the gm7113c chip because the old saa7113
> > init table has a illegal and wrong defaults according to the datasheet.
> > 
> > I'm also adding an option to the platform_data struct to choose the gm7113c_init
> > table even if you are writing a driver for the saa7113 chip.
> > 
> > This implementation is only adding overrides for the SAA7113 and GM7113C chips.
> > 
> > Signed-off-by: Jon Arne J?rgensen <jonarne@xxxxxxxxxx>
> > ---
> >  drivers/media/i2c/saa7115.c      | 144 ++++++++++++++++++++++++++++++++++++---
> >  drivers/media/i2c/saa711x_regs.h |  15 ++++
> >  include/media/saa7115.h          |  65 ++++++++++++++++++
> >  3 files changed, 215 insertions(+), 9 deletions(-)
> > 

[SNIP]

> > +/* SAA7113 Init codes */
> >  static const unsigned char saa7113_init[] = {
> >  	R_01_INC_DELAY, 0x08,
> >  	R_02_INPUT_CNTL_1, 0xc2,
> >  	R_03_INPUT_CNTL_2, 0x30,
> >  	R_04_INPUT_CNTL_3, 0x00,
> >  	R_05_INPUT_CNTL_4, 0x00,
> > -	R_06_H_SYNC_START, 0x89,
> > +	R_06_H_SYNC_START, 0x89,	/* Illegal value - min. value = 0x94 */
> > +	R_07_H_SYNC_STOP, 0x0d,
> > +	R_08_SYNC_CNTL, 0x88,		/* OBS. HTC = VTR Mode - Not default */
> 
> Can you mention the correct default in the comment?
> 
> > +	R_09_LUMA_CNTL, 0x01,
> > +	R_0A_LUMA_BRIGHT_CNTL, 0x80,
> > +	R_0B_LUMA_CONTRAST_CNTL, 0x47,
> > +	R_0C_CHROMA_SAT_CNTL, 0x40,
> > +	R_0D_CHROMA_HUE_CNTL, 0x00,
> > +	R_0E_CHROMA_CNTL_1, 0x01,
> > +	R_0F_CHROMA_GAIN_CNTL, 0x2a,
> > +	R_10_CHROMA_CNTL_2, 0x08,	/* Not datasheet default */
> 
> Ditto.
> 
> > +	R_11_MODE_DELAY_CNTL, 0x0c,
> > +	R_12_RT_SIGNAL_CNTL, 0x07,	/* Not datasheet default */
> 
> Ditto.
> 
> > +	R_13_RT_X_PORT_OUT_CNTL, 0x00,
> > +	R_14_ANAL_ADC_COMPAT_CNTL, 0x00,
> > +	R_15_VGATE_START_FID_CHG, 0x00,
> > +	R_16_VGATE_STOP, 0x00,
> > +	R_17_MISC_VGATE_CONF_AND_MSB, 0x00,
> > +
> > +	0x00, 0x00
> > +};

[SNIP]

> > +	if (data->saa7113_r08_htc) {
> > +		work = saa711x_read(sd, R_08_SYNC_CNTL);
> > +		work &= ~SAA7113_R_08_HTC_MASK;
> > +		work |= ((*data->saa7113_r08_htc) << SAA7113_R_08_HTC_OFFSET);
> > +		if (*data->saa7113_r08_htc != SAA7113_HTC_RESERVED) {
> > +			v4l2_dbg(1, debug, sd,
> > +				"set R_08 HTC [Mask 0x%02x] [Value 0x%02x]\n",
> > +				SAA7113_R_08_HTC_MASK, *data->saa7113_r08_htc);
> 
> I would leave out the check against RESERVED (see also my comment later in the
> header) and the debug messages in this function. You can always dump the registers
> with v4l2-dbg, so I don't think they add a lot.
> 
> > +			saa711x_write(sd, R_08_SYNC_CNTL, work);
> > +		}
> > +	}
> > +
> > +	if (data->saa7113_r10_vrln) {
> > +		work = saa711x_read(sd, R_10_CHROMA_CNTL_2);
> > +		work &= ~SAA7113_R_10_VRLN_MASK;
> > +		if (*data->saa7113_r10_vrln)
> > +			work |= (1 << SAA7113_R_10_VRLN_OFFSET);
> > +
> > +		v4l2_dbg(1, debug, sd,
> > +			 "set R_10 VRLN [Mask 0x%02x] [Value 0x%02x]\n",
> > +			 SAA7113_R_10_VRLN_MASK, *data->saa7113_r10_vrln);
> > +		saa711x_write(sd, R_10_CHROMA_CNTL_2, work);
> > +	}
> > +
> > +	if (data->saa7113_r10_ofts) {
> > +		work = saa711x_read(sd, R_10_CHROMA_CNTL_2);
> > +		work &= ~SAA7113_R_10_OFTS_MASK;
> > +		work |= (*data->saa7113_r10_ofts << SAA7113_R_10_OFTS_OFFSET);
> > +		v4l2_dbg(1, debug, sd,
> > +			"set R_10 OFTS [Mask 0x%02x] [Value 0x%02x]\n",
> > +			SAA7113_R_10_OFTS_MASK, *data->saa7113_r10_ofts);
> > +		saa711x_write(sd, R_10_CHROMA_CNTL_2, work);
> > +	}
> > +
> > +	if (data->saa7113_r12_rts0) {
> > +		work = saa711x_read(sd, R_12_RT_SIGNAL_CNTL);
> > +		work &= ~SAA7113_R_12_RTS0_MASK;
> > +		work |= (*data->saa7113_r12_rts0 << SAA7113_R_12_RTS0_OFFSET);
> > +		if (*data->saa7113_r12_rts0 != SAA7113_RTS_DOT_IN) {
> 
> I would replace this with a WARN_ON and add a comment as well.
> 
> > +			v4l2_dbg(1, debug, sd,
> > +				"set R_12 RTS0 [Mask 0x%02x] [Value 0x%02x]\n",
> > +				SAA7113_R_12_RTS0_MASK,
> > +				*data->saa7113_r12_rts0);
> > +			saa711x_write(sd, R_12_RT_SIGNAL_CNTL, work);
> > +		}
> > +	}
> > +

[SNIP]

> > +/* Register 0x08 "Horizontal time constant" [Bit 3..4]:
> > + * Should be set to "Fast Locking Mode" according to the datasheet,
> > + * and that is the default setting in the gm7113c_init table.
> > + * saa7113_init sets this value to "VTR Mode". */
> > +enum saa7113_r08_htc {
> > +	SAA7113_HTC_TV_MODE = 0x00,
> > +	SAA7113_HTC_VTR_MODE,		/* Default for saa7113_init */
> > +	SAA7113_HTC_RESERVED,		/* DO NOT USE */
> 
> If it shouldn't be used, then it shouldn't be defined :-) So drop it,
> 
> > +	SAA7113_HTC_FAST_LOCKING_MODE	/* Default for gm7113c_init */
> 
> and instead use this:
> 
> 	SAA7113_HTC_FAST_LOCKING_MODE = 0x03	/* Default for gm7113c_init */
> 
> > +};
> > +

[SNIP]

> 
> Regards,
> 
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@xxxxxxxxxxxxxxx
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I'll fix the patch according to your comments.
Thanks for the review.

Best regards,
Jon Arne

