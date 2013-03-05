Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab3CEWKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:10:13 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:54145 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3CEWKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:10:11 -0500
Message-ID: <51366D3E.2050903@suse.cz>
Date: Tue, 05 Mar 2013 23:10:06 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: jhovold@gmail.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>, linux-serial@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Fwd: [PATCH v2 0/4] TTY: port hangup and close fixes]
References: <1362085054.3337.20.camel@thor.lan> <51361724.4050107@suse.cz>  <1362503170.18799.33.camel@thor.lan> <51366A29.2060808@suse.cz> <1362520976.18799.134.camel@thor.lan>
In-Reply-To: <1362520976.18799.134.camel@thor.lan>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 11:02 PM, Peter Hurley wrote:
> On Tue, 2013-03-05 at 22:56 +0100, Jiri Slaby wrote:
>> On 03/05/2013 06:06 PM, Peter Hurley wrote:
>>>>> @@ -225,15 +232,13 @@ void tty_port_hangup(struct tty_port *port)
>>>>         spin_lock_irqsave(&port->lock, flags);
>>>>         port->count = 0;
>>>>         port->flags &= ~ASYNC_NORMAL_ACTIVE;
>>>> -       if (port->tty) {
>>>> +       if (port->tty)
>>>>                 set_bit(TTY_IO_ERROR, &port->tty->flags);
>>>> -               tty_kref_put(port->tty);
>>>> -       }
>>>> -       port->tty = NULL;
>>>>         spin_unlock_irqrestore(&port->lock, flags);
>>>>> +       tty_port_shutdown(port, port->tty);
>>>>
>>>> What prevents port->tty to be NULL here already?
>>>
>>> Nothing. That's why it's tested in tty_port_shutdown() above.
>>
>> I know :).
> 
> Sorry :)
> 
>> But the question is rather don't we want to pass the real
>> refcounted port->tty (take a snapshot inside the lock) instead?
> 
> I think that's why he moved the kref release to after the shutdown (via
> tty_port_set_tty()) -- but I'm tired and maybe I'm missing something
> here?

port->tty can be changed right after the unlock. So I'm thinking about
something like this:

if (port->tty)
   set_bit(TTY_IO_ERROR, &port->tty->flags);
tty = port->tty; <=== take a snapshot
spin_unlock_irqrestore(&port->lock, flags);
tty_port_shutdown(port, tty); <=== use the snapshot
set_tty_port(port, NULL); <=== put kref on that tty

-- 
js
suse labs
