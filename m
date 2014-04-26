Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaDZV75 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 17:59:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbaDZV74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 17:59:56 -0400
Date: Sat, 26 Apr 2014 23:59:46 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Laurent Navet <laurent.navet@gmail.com>, tiwai@suse.de,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: line6: fix possible overrun
Message-ID: <20140426215945.GC17562@mguzik.redhat.com>
References: <1398532162-23006-1-git-send-email-laurent.navet@gmail.com>
 <20140426204704.GB17562@mguzik.redhat.com>
 <20140426213137.GM26890@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140426213137.GM26890@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 12:36:21AM +0300, Dan Carpenter wrote:
> On Sat, Apr 26, 2014 at 10:47:05PM +0200, Mateusz Guzik wrote:
> > On Sat, Apr 26, 2014 at 07:09:22PM +0200, Laurent Navet wrote:
> > > The strcpy operation may write past the end of the fixed-size destination
> > > buffer if the source buffer is too large.
> > > 
> > > Found by coverity scan : CID 144979
> > > 
> > > Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
> > > ---
> > > build tested only
> > > 
> > >  drivers/staging/line6/audio.c | 5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/staging/line6/audio.c b/drivers/staging/line6/audio.c
> > > index 171d80c..65f5cd4 100644
> > > --- a/drivers/staging/line6/audio.c
> > > +++ b/drivers/staging/line6/audio.c
> > > @@ -32,9 +32,10 @@ int line6_init_audio(struct usb_line6 *line6)
> > >  
> > >  	line6->card = card;
> > >  
> > > -	strcpy(card->id, line6->properties->id);
> > > +	strncpy(card->id, line6->properties->id, (sizeof(card->id)-1));
> > >  	strcpy(card->driver, DRIVER_NAME);
> > > -	strcpy(card->shortname, line6->properties->name);
> > > +	strncpy(card->shortname, line6->properties->name,
> > > +			(sizeof(card->shortname)-1));
> > >  	/* longname is 80 chars - see asound.h */
> > >  	sprintf(card->longname, "Line6 %s at USB %s", line6->properties->name,
> > >  		dev_name(line6->ifcdev));
> > 
> > Would not it be better to return -EINVAL (or some other error) instead?
> > 
> > Now you will possibly truncate the name.
> > 
> 
> These don't come from the user, they come from the kernel.
> 
> drivers/staging/line6/driver.c
>     59  
>     60  #define L6PROP(dev_bit, dev_id, dev_name, dev_cap)\
>     61          {.device_bit = LINE6_BIT_##dev_bit, .id = dev_id,\
>     62           .name = dev_name, .capabilities = LINE6_BIT_##dev_cap}
>     63  
>     64  /* *INDENT-OFF* */
>     65  static const struct line6_properties line6_properties_table[] = {
>     66          L6PROP(BASSPODXT,     "BassPODxt",     "BassPODxt",        CTRL_PCM_HW),
>     67          L6PROP(BASSPODXTLIVE, "BassPODxtLive", "BassPODxt Live",   CTRL_PCM_HW),
>     68          L6PROP(BASSPODXTPRO,  "BassPODxtPro",  "BassPODxt Pro",    CTRL_PCM_HW),
>     69          L6PROP(GUITARPORT,    "GuitarPort",    "GuitarPort",       PCM),
>     70          L6PROP(POCKETPOD,     "PocketPOD",     "Pocket POD",       CONTROL),
>     71          L6PROP(PODHD300,      "PODHD300",      "POD HD300",        CTRL_PCM_HW),
>     72          L6PROP(PODHD400,      "PODHD400",      "POD HD400",        CTRL_PCM_HW),
>     73          L6PROP(PODHD500,      "PODHD500",      "POD HD500",        CTRL_PCM_HW),
>     74          L6PROP(PODSTUDIO_GX,  "PODStudioGX",   "POD Studio GX",    PCM),
>     75          L6PROP(PODSTUDIO_UX1, "PODStudioUX1",  "POD Studio UX1",   PCM),
>     76          L6PROP(PODSTUDIO_UX2, "PODStudioUX2",  "POD Studio UX2",   PCM),
>     77          L6PROP(PODX3,         "PODX3",         "POD X3",           PCM),
>     78          L6PROP(PODX3LIVE,     "PODX3Live",     "POD X3 Live",      PCM),
>     79          L6PROP(PODXT,         "PODxt",         "PODxt",            CTRL_PCM_HW),
>     80          L6PROP(PODXTLIVE,     "PODxtLive",     "PODxt Live",       CTRL_PCM_HW),
>     81          L6PROP(PODXTPRO,      "PODxtPro",      "PODxt Pro",        CTRL_PCM_HW),
>     82          L6PROP(TONEPORT_GX,   "TonePortGX",    "TonePort GX",      PCM),
>     83          L6PROP(TONEPORT_UX1,  "TonePortUX1",   "TonePort UX1",     PCM),
>     84          L6PROP(TONEPORT_UX2,  "TonePortUX2",   "TonePort UX2",     PCM),
>     85          L6PROP(VARIAX,        "Variax",        "Variax Workbench", CONTROL),
>     86  };
>     87  /* *INDENT-ON* */
>     88  
> 
> And sadly enough some of those ->id strings are more than 15 characters
> and a NUL which will fit in card->id.  So this overflow is real.  The
> card->shortname is a 32 char array so none of those overflow.
> 
> If we want to sovle the truncation issue then we need to think of
> shorter names for BassPODxtLive, BassPODxtPro, PODStudioUX1, and
> PODStudioUX2.
> 

In that case I suggest compile time assertions that ids and names fit and
a WARN_ON + -EINVAL in line6_init_audio to catch future offenders.

As a side note I'm not sure if pod_try_init from drivers/staging/line6/pod.c
cleans up properly after failed line6_init_audio.

-- 
Mateusz Guzik
