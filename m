Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbaJWPoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 11:44:11 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:50861 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaJWPoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 11:44:09 -0400
Date: Thu, 23 Oct 2014 08:44:04 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Tommy Will <tommywill2011@gmail.com>, Hans de Goede <hdegoede@redhat.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] input: alps: Reset mouse before identifying it
Message-ID: <20141023154404.GA18714@dtor-ws>
References: <1412329392-5580-1-git-send-email-pali.rohar@gmail.com>
 <201410152010.39507@pali>
 <20141015182256.GE8625@dtor-ws>
 <201410191307.41313@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201410191307.41313@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 01:07:41PM +0200, Pali Rohár wrote:
> On Wednesday 15 October 2014 20:22:56 Dmitry Torokhov wrote:
> > On Wed, Oct 15, 2014 at 08:10:39PM +0200, Pali Rohár wrote:
> > > On Wednesday 15 October 2014 20:00:11 Dmitry Torokhov wrote:
> > > > On Wed, Oct 15, 2014 at 07:57:37PM +0200, Pali Rohár wrote:
> > > > > On Wednesday 15 October 2014 19:43:15 Dmitry Torokhov 
> wrote:
> > > > > > On Wed, Oct 15, 2014 at 02:53:11PM +0200, Pali Rohár 
> wrote:
> > > > > > > On Tuesday 14 October 2014 08:08:34 Dmitry Torokhov
> > > 
> > > wrote:
> > > > > > > > On Fri, Oct 03, 2014 at 11:47:59AM +0200, Hans de
> > > > > > > > Goede
> > > > > 
> > > > > wrote:
> > > > > > > > > Hi,
> > > > > > > > > 
> > > > > > > > > Thanks for working on this!
> > > > > > > > > 
> > > > > > > > > On 10/03/2014 11:43 AM, Pali Rohár wrote:
> > > > > > > > > > On some systems after starting computer
> > > > > > > > > > function alps_identify() does not detect dual
> > > > > > > > > > ALPS touchpad+trackstick device correctly and
> > > > > > > > > > detect only touchpad.
> > > > > > > > > > 
> > > > > > > > > > Resetting ALPS device before identifiying it
> > > > > > > > > > fixing this problem and both parts touchpad
> > > > > > > > > > and trackstick are detected.
> > > > > > > > > > 
> > > > > > > > > > Signed-off-by: Pali Rohár
> > > > > > > > > > <pali.rohar@gmail.com> Tested-by: Pali Rohár
> > > > > > > > > > <pali.rohar@gmail.com>
> > > > > > > > > 
> > > > > > > > > Looks good and seems sensible:
> > > > > > > > > 
> > > > > > > > > Acked-by: Hans de Goede <hdegoede@redhat.com>
> > > > > > > > 
> > > > > > > > *sigh* I am not really happy about this, as we
> > > > > > > > making boot longer and longer for people without
> > > > > > > > ALPS touchpads. It would be better if we only
> > > > > > > > reset the mouse when we knew we are dealing with
> > > > > > > > ALPS, and even better if we only reset it when we
> > > > > > > > suspected that we missed trackstick. Any chance
> > > > > > > > of doing this?
> > > > > > > > 
> > > > > > > > Thanks.
> > > > > > > 
> > > > > > > Dmitry, problem is that function check which
> > > > > > > detecting trackstick does not working when I start
> > > > > > > my laptop from power-off state and do not reset
> > > > > > > PS/2 device. But detecting ALPS touchpad looks like
> > > > > > > working. So if do not like this idea, what about
> > > > > > > doing something like this in alps_dectect function?
> > > > > > > 
> > > > > > > int alps_detect(...)
> > > > > > > {
> > > > > > > ...
> > > > > > > /* detect if device is ALPS */
> > > > > > > if (alps_identify(...) < 0)
> > > > > > > return -1;
> > > > > > > /* now we know that device is ALPS */
> > > > > > > if (!(flags & ALPS_DUALPOINT)) {
> > > > > > > /* reset it and identify again, maybe there is
> > > > > > > trackstick */ psmouse_reset(...);
> > > > > > > alps_identify(...);
> > > > > > > }
> > > > > > > ...
> > > > > > > }
> > > > > > > 
> > > > > > > It will does not affect non ALPS devices (because
> > > > > > > first identify call will fail), but will affect
> > > > > > > ALPS devices without trackstick (because identify
> > > > > > > will be called twice and reset too).
> > > > > > 
> > > > > > I think this is a step in right direction. Do you know
> > > > > > what exactly fails in alps_identify() on your box if
> > > > > > you do not call psmouse_reset?
> > > > > > 
> > > > > > Thanks.
> > > > > 
> > > > > Yes, I know. It is failing in
> > > > > alps_probe_trackstick_v3(). It calls
> > > > > alps_command_mode_read_reg(...) and it returns 0 which
> > > > > means trackstick is not there.
> > > > 
> > > > OK, so can we try sticking psmouse_reset() there? This
> > > > will limit the exposure of the new delay.
> > > > 
> > > > Thanks.
> > > 
> > > Sorry, but I think this is not safe. Function psmouse_reset
> > > will reset device (set it to relative mode, etc...) and
> > > before and after alps_probe_trackstick_v3() are called
> > > other functions. So it could break something else.
> > 
> > We might need to repeat bits of alps_identify() after
> > resetting the mouse, you are right. It should still be doable
> > though.
> 
> What about checking "E6 report" and if that pass reset device and 
> do full alps_identify? With check for "E6 report" we can filter 
> probably all PS/2 devices which are not ALPS.
> 

Why don't you pull alps_probe_trackstick_v3() from alps_identify(),
rename it into __alps_identify() and then have real alps_identify be:

static int alps_identfy(struct psmouse *psmouse, struct alps_data *priv)
{
	int error;

	error = __alps_identify(psmouse, priv);
	if (error)
		return error;

	if (priv->proto_version == ALPS_PROTO_V3 &&
	    (priv->flags & ALPS_IS_RUSHMORE)) {
		/*
		 * Some Dell Lattitudes may not always recognize
		 * tracksticks without resetting the device.
		 */
		psmouse_reset(psmouse);

		error =  __alps_identify(psmouse, priv);
		if (error)
			return error;

		if (alps_probe_trackstick_v3(psmouse,
					     ALPS_REG_BASE_RUSHMORE))
			priv->flags &= ~ALPS_DUALPOINT;
	}

	return 0;
}

This way you minimize number of devices exposed to extra reset.

Thanks.

-- 
Dmitry
