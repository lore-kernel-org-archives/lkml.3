Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab3BEOIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:08:49 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:37358 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754330Ab3BEOIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:08:48 -0500
Message-ID: <1360073199.3354.48.camel@thor.lan>
Subject: Re: [PATCH 07/10] TTY: switch tty_schedule_flip
From: Peter Hurley <peter@hurleysoftware.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Jiri Slaby <jirislaby@gmail.com>, gregkh@linuxfoundation.org,
        alan@linux.intel.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Feb 2013 09:06:39 -0500
In-Reply-To: <5110EF95.4060402@suse.cz>
References: <1357224789-2853-1-git-send-email-jslaby@suse.cz>
	  <1357224789-2853-8-git-send-email-jslaby@suse.cz>
	  <1359722247.3381.16.camel@thor.lan> <510BD9E9.9000400@suse.cz>
	 <1359751171.22968.6.camel@thor.lan> <5110EF95.4060402@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-05 at 12:40 +0100, Jiri Slaby wrote:
> On 02/01/2013 09:39 PM, Peter Hurley wrote:
> > On Fri, 2013-02-01 at 16:06 +0100, Jiri Slaby wrote:
> >> On 02/01/2013 01:37 PM, Peter Hurley wrote:
> >>> On Thu, 2013-01-03 at 15:53 +0100, Jiri Slaby wrote:
> >>>> Now, we start converting tty buffer functions to actually use
> >>>> tty_port. This will allow us to get rid of the need of tty in many
> >>>> call sites. Only tty_port will needed and hence no more
> >>>> tty_port_tty_get in those paths.
> >>>>
> >>>> This is the last one: tty_schedule_flip
> >>>
> >>> [snip]
> >>>
> >>>> diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
> >>>> index 5aace4d..a9af1b9a 100644
> >>>> --- a/drivers/tty/vt/keyboard.c
> >>>> +++ b/drivers/tty/vt/keyboard.c
> >>>> @@ -307,26 +307,17 @@ int kbd_rate(struct kbd_repeat *rep)
> >>>>   */
> >>>>  static void put_queue(struct vc_data *vc, int ch)
> >>>>  {
> >>>> -	struct tty_struct *tty = vc->port.tty;
> >>>> -
> >>>>  	tty_insert_flip_char(&vc->port, ch, 0);
> >>>> -	if (tty) {
> >>>> -		tty_schedule_flip(tty);
> >>>> -	}
> >>>> +	tty_schedule_flip(&vc->port);
> >>>>  }
> >>>>  
> >>>>  static void puts_queue(struct vc_data *vc, char *cp)
> >>>>  {
> >>>> -	struct tty_struct *tty = vc->port.tty;
> >>>> -
> >>>> -	if (!tty)
> >>>> -		return;
> >>>> -
> >>>>  	while (*cp) {
> >>>>  		tty_insert_flip_char(&vc->port, *cp, 0);
> >>>>  		cp++;
> >>>>  	}
> >>>> -	tty_schedule_flip(tty);
> >>>> +	tty_schedule_flip(&vc->port);
> >>>>  }
> >>>
> >>> Umm. So even though the vt driver knows the tty has been shutdown,
> >>> keystrokes will still be buffered? And then fed to whichever tty happens
> >>> to next get installed on the same port?
> >>
> >> Unless I completely missed something, they should be flushed. If that's
> >> not the case, that's a bug. I will check next week.
> > 
> > Ok.
> > 
> > I'm fairly sure this is happening. Try repeatedly tapping arrow-down
> > while booting (I suggest a VM) and you won't be able to login at tty1
> > (ie, text mode). Repeatable 1 time in 5 or so.
> 
> I can reproduce... with 3.0! Are you sure this is new and introduced by
> the tty buffers switch?

No, I'm not sure this is new.

> > FWIW, I don't agree that the best way is to flush the flip buffers. Why
> > buffer and then schedule the cpu to do work which we already know it
> > can't do and which we're going to discard anyway?
> 
> Because the drivers needn't care whether there is any tty behind and
> listening. This simplifies and speeds up the paths _a lot_. No spin
> locks, no ttys around, no two code paths etc.

Let's defer this part of the discussion until after everything is
running solid.

> > In any event, since -next is already carrying these patches, and
> > by-design, these patches _expect_ the tty to be NULL, are you going to
> > remove the warning in flush_to_ldisc() or shall I?
> 
> I think I don't understand you here, could you elaborate?

         - CPU 0 -          |          - CPU 1 -
                            |
release_tty()               |
   .                        |
   tty->ops->shutdown()     |
      con_shutdown()        |
      .                     |
      vc->port.tty = NULL;  |
      .                     |
   tty->port->itty = NULL;  |
   .                        | puts_queue()
   .                        |    .
   .                        |    tty_schedule_flip(&vc->port);
   .                        |    .
                            |
                            | flush_to_ldisc() runs & WARNs

If driver i/o paths don't need to worry about the lifetime of the tty,
then why warn when they inevitably schedule work to a dead tty (as
above)?

Also, what ensures that flush_to_ldisc() has a valid tty when obtaining
an ldisc ref?  IOW,

        - CPU 0 -           |          - CPU 1 -
                            |
                            | flush_to_ldisc()
                            |    tty = port->itty;
                            | < scheduled away - IRQ servicing ...
tty->port->itty = NULL;     |    .
...                         |    .
free_tty_struct(tty);       |    .
                            | ... returns from IRQ service >
                            | ldisc = tty_ldisc_ref(tty);

Regards,
Peter Hurley


