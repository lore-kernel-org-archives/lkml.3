Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484AbbAFSd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 13:33:28 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:56172 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464AbbAFSdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 13:33:25 -0500
Date: Tue, 6 Jan 2015 18:33:14 +0000
From: Will Deacon <will.deacon@arm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
Message-ID: <20150106183252.GA32449@arm.com>
References: <20150104190123.GA20153@amd>
 <alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr>
 <20150104201026.GA23427@amd>
 <alpine.LFD.2.11.1501041512440.18844@knanqh.ubzr>
 <20150104203724.GA16372@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150104203724.GA16372@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2015 at 08:37:24PM +0000, Pavel Machek wrote:
> On Sun 2015-01-04 15:25:02, Nicolas Pitre wrote:
> > On Sun, 4 Jan 2015, Pavel Machek wrote:
> > 
> > > On Sun 2015-01-04 15:03:02, Nicolas Pitre wrote:
> > > > If that is still unacceptable to you for whatever reason, then the least 
> > > > wrong compromize should be:
> > > > 
> > > > 	seq_printf(m, "BogoMIPS\t: 1.00\n");
> > > > 
> > > > That'D allow for those broken applications to run while making clear 
> > > > that the provided value is phony. I was about to suggest 0.00 but that 
> > > > could trigger a divide by zero error somewhere I suppose.
> > > 
> > > I don't know what 1.00 will cause, and neither do you, so what about
> > > simply reverting the bad patch?
> > 
> > Because the patch wasn't "bad".  It did solve a recurring support 
> > problem where people did actually complain on the list because the value 
> > was not what they would have liked.  Removing this meaningless value did 
> > actually fix that support issue as no more complaints came through for 
> > the last 1.3 year, and is actually the only way for user space to be 
> > fixed too.
> 
> People complain on the list, so what? People complain about systemd,
> too. We ignore them.
> 
> Alternatively, just don't touch the bogomips computation. It is not
> that much of maintainance burden. You can probably also get away with
> replacing bogomips with actual cpu frequency.
> 
> Replacing it with 1 is asking for trouble.

Peversely, I think that '1.00' would be the correct value for your libjack
case!

I had a quick look at the code, and it seems to be used to construct a
microsecond-precision timeline for things like:

	ctl->signalled_at = jack_get_microseconds();

Now, jack_get_microseconds() is:

	static inline jack_time_t
	jack_get_microseconds (void)
	{
	        return _jack_get_microseconds ();
	}

_jack_get_microseconds is a pointer that points to this guy:

	jack_time_t
	jack_get_microseconds_from_cycles (void) {
	        return get_cycles() / __jack_cpu_mhz;
	}

where __jack_cpu_mhz is the bogomips read once from /proc/cpuinfo and
get_cycles (on ARM) is this gem:

	static inline cycles_t get_cycles(void)
	{
	       struct timeval tv;
	       gettimeofday (&tv, NULL);

	       return ((cycles_t) tv.tv_sec * 1000000) + tv.tv_usec;
	}

The return value from jack_get_microseconds gets used interchangeably with
real usecond values to do things like find the audio frame at Nus into a
stream, so I don't really see how any of this can work. In this case, we
just need *a* bogomips value to stop the initialisation from failing, then
hope that pyaudio decides not to use jack after all (it falls back to some
alsa thing on my machine)

Will
