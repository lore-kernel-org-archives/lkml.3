Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab3EHVSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:18:06 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:53926 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750774Ab3EHVSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:18:05 -0400
Message-ID: <518AC108.2000906@hurleysoftware.com>
Date: Wed, 08 May 2013 17:18:00 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: 3.9+ tty lockdep trace.
References: <20130501154723.GB11841@redhat.com> <20130506180020.GB1309@redhat.com> <20130506184059.GA22897@kroah.com> <51890C31.3000203@hurleysoftware.com> <20130507150423.GA13062@redhat.com> <51893B68.1010907@hurleysoftware.com> <20130507180009.GA16771@redhat.com>
In-Reply-To: <20130507180009.GA16771@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 02:00 PM, Dave Jones wrote:
> On Tue, May 07, 2013 at 01:35:36PM -0400, Peter Hurley wrote:
>   > On 05/07/2013 11:04 AM, Dave Jones wrote:
>   > > On Tue, May 07, 2013 at 10:14:09AM -0400, Peter Hurley wrote:
>   > >
>   > >   > >> Just hit this again, by switching tty's during bootup.
>   > >   > >> The previous time was switching from X to console iirc, so that seems to be
>   > >   > >> the key to triggering this.
>   > >   > >
>   > >   > > Sorry for not getting back to this sooner, merge window fun...
>   > >   > >
>   > >   > > Anyway, Peter, could this be something that your ldisc patches are
>   > >   > > triggering?
>   > >   >
>   > >   > Yes, although early analysis also suggests the lockdep splat is possible
>   > >   > regardless, just much less likely.
>   > >   >
>   > >   > I looked at this over the weekend, but I wasn't able to determine (in
>   > >   > the limited time I had available) if the splat was valid; ie., if the
>   > >   > cpu states could actually be concurrent and result in deadlock.
>   > >   >
>   > >   > I need to study the VT_DISALLOCATE ioctl in more detail which I plan
>   > >   > to do this week.
>   > >
>   > > I don't know if it proves/disproves anything, but shortly before the dump
>   > > gets printed, everything is kind of locked up. I can switch tty's, but
>   > > the gettys on them are dead to the world until after the dump.
>   > >
>   > > ISTR a pause for a while when I hit this switching from X too.
>   >
>   > It would help to know the steps to reproduce. For example, you mention
>   > unresponsive gettys but the VT_DISALLOCATE ioctl doesn't work (and isn't
>   > designed to) on open ttys.
>
> Hmm, dunno. I booted up, and tried to log in on tty1 (no X on that box), and after
> I entered my password everything just hung for a while. I flipped to tty2
> to try and log in as root, but after changing tty, I just got a blinking cursor.
> 10 seconds or so later, lockdep spew.

Ok, Dave, thanks for the extra information; that makes sense now.

systemd optionally uses the VT_DISALLOCATE ioctl to free the VT. So when
getty on tty2 died because of some error, systemd exercises the VT_DISALLOCATE
ioctl which generates the lockdep splat.

I'm still trying to figure out if the states can actually overlap; they're
not supposed to, but the VT_DISALLOCATE ioctl is not particularly
defensive and I suspect that overlap is possible.

It's somewhat unfortunate that systemd chose to use a really antiquated
and fundamentally unsafe ioctl like VT_DISALLOCATE. Even when I fix this
lockdep splat, bad things may still be possible.

I'm certain that the lockdep warning has nothing to do with your
login delay; if you want to send me sysrq+t output when that happens again,
I'd be willing to look over it for the underlying problem.

Regards,
Peter Hurley
