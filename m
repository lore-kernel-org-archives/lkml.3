Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbaJMQoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 12:44:25 -0400
Received: from wp038.webpack.hosteurope.de ([80.237.132.45]:50922 "EHLO
	wp038.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754214AbaJMQoY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 12:44:24 -0400
Date: Mon, 13 Oct 2014 18:44:22 +0200 (CEST)
From: Henning Schild <henning@hennsch.de>
Reply-To: Henning Schild <henning@hennsch.de>
To: "Deucher, Alexander" <alexander.deucher@amd.com>,
        linux-kernel@vger.kernel.org
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Message-ID: <819514162.3896.1413218662504.open-xchange@app06.ox.hosteurope.de>
In-Reply-To: <A3397C8B8B789E45844E7EC5DEAD89D05993B4D5@satlexdag05.amd.com>
References: <1413031067-26961-1-git-send-email-henning@hennsch.de> <1413031875-28053-1-git-send-email-henning@hennsch.de> <A3397C8B8B789E45844E7EC5DEAD89D05993B4D5@satlexdag05.amd.com>
Subject: RE: [PATCH] drm/radeon: remove code that can never get executed
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.4.2-Rev36
X-bounce-key: webpack.hosteurope.de;henning@hennsch.de;1413218664;e37276b4;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well i am not sure what the code actually is supposed to do. That is up to you
because you know the hardware. I just wanted to point out that right now some
code can never be reached.

I ran into the whole thing because the pointer (sadp) that gets kfreed was never
initialized (in one of the three cases). My first fix was to initialize it to
NULL, that way the kfree did not fail even if the allocation did not do
anything. Then i found the other two copies and decided to follow their scheme.

In your patch you have to make kfree depend on (sad_count > 0) or sadp needs to
be initialized with NULL. Otherwise you will get the dangling pointer kfree that
lead me to read this code.

Henning

> On October 13, 2014 at 6:08 PM "Deucher, Alexander"
> <Alexander.Deucher@amd.com> wrote:
> 
> > -----Original Message-----
> > From: Henning Schild [mailto:henning@hennsch.de]
> > Sent: Saturday, October 11, 2014 8:51 AM
> > To: linux-kernel@vger.kernel.org
> > Cc: Henning Schild; Deucher, Alexander; Rafał Miłecki
> > Subject: [PATCH] drm/radeon: remove code that can never get executed
> > 
> > Removing a code-path that can never be executed ... and its copies. If
> > drm_edid_to_speaker_allocation returns 0 the callers return. There is no
> > need to check that condition again.
> 
> I think we actually want to set the speaker allocation setup to stereo if the
> speaker allocation block is not present so I think the attached patch is
> probably the proper fix.
> 
> Alex
> 
> > 
> > Signed-off-by: Henning Schild <henning@hennsch.de>
> > ---
> > drivers/gpu/drm/radeon/dce3_1_afmt.c | 5 +----
> > drivers/gpu/drm/radeon/dce6_afmt.c | 5 +----
> > drivers/gpu/drm/radeon/evergreen_hdmi.c | 5 +----
> > 3 files changed, 3 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/radeon/dce3_1_afmt.c
> > b/drivers/gpu/drm/radeon/dce3_1_afmt.c
> > index cb76074..6d31ed8 100644
> > --- a/drivers/gpu/drm/radeon/dce3_1_afmt.c
> > +++ b/drivers/gpu/drm/radeon/dce3_1_afmt.c
> > @@ -58,10 +58,7 @@ static void
> > dce3_2_afmt_write_speaker_allocation(struct drm_encoder *encoder)
> > tmp &= ~(DP_CONNECTION | SPEAKER_ALLOCATION_MASK);
> > /* set HDMI mode */
> > tmp |= HDMI_CONNECTION;
> > - if (sad_count)
> > - tmp |= SPEAKER_ALLOCATION(sadb[0]);
> > - else
> > - tmp |= SPEAKER_ALLOCATION(5); /* stereo */
> > + tmp |= SPEAKER_ALLOCATION(sadb[0]);
> > WREG32(AZ_F0_CODEC_PIN0_CONTROL_CHANNEL_SPEAKER, tmp);
> > 
> > kfree(sadb);
> > diff --git a/drivers/gpu/drm/radeon/dce6_afmt.c
> > b/drivers/gpu/drm/radeon/dce6_afmt.c
> > index ab29f95..e6b2750 100644
> > --- a/drivers/gpu/drm/radeon/dce6_afmt.c
> > +++ b/drivers/gpu/drm/radeon/dce6_afmt.c
> > @@ -186,10 +186,7 @@ void dce6_afmt_write_speaker_allocation(struct
> > drm_encoder *encoder)
> > tmp &= ~(DP_CONNECTION | SPEAKER_ALLOCATION_MASK);
> > /* set HDMI mode */
> > tmp |= HDMI_CONNECTION;
> > - if (sad_count)
> > - tmp |= SPEAKER_ALLOCATION(sadb[0]);
> > - else
> > - tmp |= SPEAKER_ALLOCATION(5); /* stereo */
> > + tmp |= SPEAKER_ALLOCATION(sadb[0]);
> > WREG32_ENDPOINT(offset,
> > AZ_F0_CODEC_PIN_CONTROL_CHANNEL_SPEAKER, tmp);
> > 
> > kfree(sadb);
> > diff --git a/drivers/gpu/drm/radeon/evergreen_hdmi.c
> > b/drivers/gpu/drm/radeon/evergreen_hdmi.c
> > index 278c7a1..11a6b65 100644
> > --- a/drivers/gpu/drm/radeon/evergreen_hdmi.c
> > +++ b/drivers/gpu/drm/radeon/evergreen_hdmi.c
> > @@ -128,10 +128,7 @@ static void
> > dce4_afmt_write_speaker_allocation(struct drm_encoder *encoder)
> > tmp &= ~(DP_CONNECTION | SPEAKER_ALLOCATION_MASK);
> > /* set HDMI mode */
> > tmp |= HDMI_CONNECTION;
> > - if (sad_count)
> > - tmp |= SPEAKER_ALLOCATION(sadb[0]);
> > - else
> > - tmp |= SPEAKER_ALLOCATION(5); /* stereo */
> > + tmp |= SPEAKER_ALLOCATION(sadb[0]);
> > WREG32(AZ_F0_CODEC_PIN0_CONTROL_CHANNEL_SPEAKER, tmp);
> > 
> > kfree(sadb);
> > --
> > 2.0.4

>
