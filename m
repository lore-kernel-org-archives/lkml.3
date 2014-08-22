Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbaHVOBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:01:32 -0400
Received: from 132.79-246-81.adsl-static.isp.belgacom.be ([81.246.79.132]:43179
	"EHLO viper.mind.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160AbaHVOB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:01:28 -0400
Message-ID: <53F74D2F.2000006@mind.be>
Date: Fri, 22 Aug 2014 16:01:19 +0200
From: Arnout Vandecappelle <arnout@mind.be>
Organization: Essensium/Mind
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH] tps65910: Work around silicon erratum SWCZ010
References: <1408709666-5927-1-git-send-email-arnout@mind.be> <53F7499D.7070103@nvidia.com>
In-Reply-To: <53F7499D.7070103@nvidia.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/14 15:46, Laxman Dewangan wrote:
> On Friday 22 August 2014 05:44 PM, Arnout Vandecappelle (Essensium/Mind) wrote:
> >  From http://www.ti.com/lit/pdf/SWCZ010 :
> >
> > Glitch on SDA-SCL not managed correctly by the I2C IP
> >
> > Impact:
> > The standard specifies that the I2C transfer should restart on a start
> > event in all cases. The current design does not support two consecutive
> > Start conditions. This can cause the first real access after such a
> > glitch to be corrupted.
> >
> > Description:
> > An unexpected glitch on SDA and SCL can generate a wrong start event.
> > In the current design, the SCL line must toggle two times to detect a
> > new start event and completely restart the I2C access; hence the real
> > start event is not detected in the case of a single SCL toggle.
> >
> > Workaround:
> > Repeat I2C access.
> >
> > The first access to the tps65910 that we do is when loading the regmap
> > in the probe function. If there has been a glitch during boot and the
> > erratum is triggered, then the regmap loading will fail with -REMOTEIO
> > since the I2C transfer is not ACKed by the tps65910.
> >
> > A simple retry will work around it, because a subsequent I2C start
> > condition is detected properly by the tps65910.
> >
> > Signed-off-by: Arnout Vandecappelle (Essensium/Mind) <arnout@mind.be>
> > ---
> > This patch is based on v3.17-rc1.
> > Build-tested with omap2plus_defconfig.
> > Runtime tested based on v3.4.97 with a custom config.
> > ---
> >   drivers/mfd/tps65910.c | 12 +++++++++++-
> >   1 file changed, 11 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
> > index f243e75..cc1ca33 100644
> > --- a/drivers/mfd/tps65910.c
> > +++ b/drivers/mfd/tps65910.c
> > @@ -487,8 +487,18 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
> >       tps65910->id = chip_id;
> >   
>
> I think one dummy read of any register unconditionally before regmap init will
> resolve this issue.
> Similar issue we face with Palmas TPS65913 and TI recommended to use dummy read
> before any valid transfer.
>

 Yeah, good idea.

 So something like

i2c_master_send(i2c, "", 1);

just before the regmap_init.

 Is abusing the empty string like that OK or should I declare a dummy buffer?

 Regards,
 Arnout


-- 
Arnout Vandecappelle arnout at mind be
Senior Embedded Software Architect +32-16-286500
Essensium/Mind http://www.mind.be
G.Geenslaan 9, 3001 Leuven, Belgium BE 872 984 063 RPR Leuven
LinkedIn profile: http://www.linkedin.com/in/arnoutvandecappelle
GPG fingerprint: 7CB5 E4CC 6C2E EFD4 6E3D A754 F963 ECAB 2450 2F1F
