Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab3EaOLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 10:11:35 -0400
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:37908 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750837Ab3EaOL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 10:11:27 -0400
Date: Fri, 31 May 2013 16:14:20 +0200
From: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>,
        Timo Teras <timo.teras@iki.fi>, Andy Walls <awalls@md.metrocast.net>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        hans.verkuil@cisco.com, prabhakar.csengg@gmail.com,
        g.liakhovetski@gmx.de, ezequiel.garcia@free-electrons.com
Subject: Re: [RFC 1/3] saa7115: Set saa7113 init to values from datasheet
Message-ID: <20130531141420.GH2367@dell.arpanet.local>
References: <1369860078-10334-1-git-send-email-jonarne@jonarne.no>
 <1369860078-10334-2-git-send-email-jonarne@jonarne.no>
 <20130529213554.690f7eaa@redhat.com>
 <7454763a-75fe-4d98-b7ab-29b6649dc25e@email.android.com>
 <20130530052136.GF2367@dell.arpanet.local>
 <20130530083332.245e3c62@vostro>
 <20130530190001.GG2367@dell.arpanet.local>
 <20130531100827.10710841@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130531100827.10710841@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 10:08:27AM -0300, Mauro Carvalho Chehab wrote:
> Em Thu, 30 May 2013 21:00:01 +0200
> Jon Arne Jørgensen <jonarne@jonarne.no> escreveu:
> 
> > On Thu, May 30, 2013 at 08:33:32AM +0300, Timo Teras wrote:
> > > On Thu, 30 May 2013 07:21:36 +0200
> > > Jon Arne Jørgensen <jonarne@jonarne.no> wrote:
> > > 
> > > > On Wed, May 29, 2013 at 10:19:49PM -0400, Andy Walls wrote:
> > > > > Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> > > > > 
> > > > > >Em Wed, 29 May 2013 22:41:16 +0200
> > > > > >Jon Arne Jørgensen <jonarne@jonarne.no> escreveu:
> > > > > >
> > > > > >> Change all default values in the initial setup table to match the
> > > > > >table
> > > > > >> in the datasheet.
> > > > > >
> > > > > >This is not a good idea, as it can produce undesired side effects
> > > > > >on the existing drivers that depend on it, and can't be easily
> > > > > >tested.
> > > > > >
> > > > > >Please, don't change the current "default". It is, of course, OK
> > > > > >to change them if needed via the information provided inside the
> > > > > >platform data.
> > > > >
> > > > > I was going to make a comment along the same line as Mauro.  
> > > > > Please leave the driver defaults alone.  It is almost impossible to
> > > > > regression test all the different devices with a SAA7113 chip, to
> > > > > ensure the change doesn't cause someone's device to not work
> > > > > properly.
> > > > >
> > > > 
> > > > You guys are totally right.
> > > > 
> > > > What if I clone the original saa7113_init table into a new one, and
> > > > make the driver use the new one if the calling driver sets
> > > > platform_data.
> > > > 
> > > > Something like this?
> > > > 
> > > >         switch (state->ident) {
> > > >         case V4L2_IDENT_SAA7111:
> > > >         case V4L2_IDENT_SAA7111A:
> > > >                 saa711x_writeregs(sd, saa7111_init);
> > > >                 break;
> > > >         case V4L2_IDENT_GM7113C:
> > > >         case V4L2_IDENT_SAA7113:
> > > > -		saa711x_writeregs(sd, saa7113_init);
> > > > +		if (client->dev.platform_data)
> > > > +			saa711x_writeregs(sd, saa7113_new_init);
> > > > +		else
> > > > +			saa711x_writeregs(sd, saa7113_init);
> > > 
> > > I would rather have the platform_data provide the new table. Or if you
> > > think bulk of the table will be the same for most users, then perhaps
> > > add there an enum saying which table to use - and name the tables
> > > according to the chip variant it applies to.
> > > 
> > 
> > I think the bulk of the table will be the same for all drivers.
> > It's one bit here and one bit there that needs changing.
> > As the driver didn't support platform data.
> > Changing to a new init table for the drivers that implement
> > platform_data shouldn't cause any regressions.
> 
> There are several things that are very bad on passing a table via
> platform data:
> 
> 	1) you're adding saa711x-specific data at the bridge driver,
> 	   so, the saa711x code is spread on several places at the
> 	   long term;
> 
> 	2) some part of the saa711x code may override the data there, 
> 	   as it is not aware about what bits should be preserved from
> 	   the new device;
> 
> 	3) due (2), latter changes on the code are more likely to
> 	   cause regressions;
> 
> 	4) also due to (2), some hacks can be needed, in order to warn
> 	   saa711x to handle some things differently.
> 
> That's why it is a way better to add meaningful parameters telling what
> bits are needed for the driver to work with the bridge. That's also
> why we do this with all other drivers.
> 

I agree with you here.
I never planned to pass the table via platform data.

I've just posted a new version of this patch set.
Please have a look.

Best regards
Jon Arne Jørgensen

> Regards,
> Mauro
