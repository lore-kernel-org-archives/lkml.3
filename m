Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaBJS27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:28:59 -0500
Received: from mail-vb0-f41.google.com ([209.85.212.41]:38095 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbaBJS24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 13:28:56 -0500
MIME-Version: 1.0
In-Reply-To: <1391820619-25487-4-git-send-email-courtney.cavin@sonymobile.com>
References: <1391820619-25487-1-git-send-email-courtney.cavin@sonymobile.com>
	<1391820619-25487-4-git-send-email-courtney.cavin@sonymobile.com>
Date: Mon, 10 Feb 2014 12:28:54 -0600
Message-ID: <CAL_JsqL7Ba2KJCP7YoUU-Z-rdq6zzWiRM3E3gbs7wgDZxVCtww@mail.gmail.com>
Subject: Re: [RFC 3/6] mailbox: pl320: migrate to mbox framework
From: Rob Herring <robherring2@gmail.com>
To: Courtney Cavin <courtney.cavin@sonymobile.com>
Cc: s-anna@ti.com, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Tony Lindgren <tony@atomide.com>, omar.ramirez@copitl.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Langsdorf <mark.langsdorf@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 7, 2014 at 6:50 PM, Courtney Cavin
<courtney.cavin@sonymobile.com> wrote:
> We don't remove the legacy methods here, but we mark them as deprecated
> in the hopes that people with the ability to properly test modifications
> can adapt its users.

The DT for highbank is pretty much fixed at this point. So adopting
this will need a way to register without DT. Unfortunately, I don't
have access to h/w either ATM.

I should note that this driver is very much highbank specific and not
really a generic pl320 driver. The pl320 has up to 8 mailboxes and 8
interrupts. How it is used from there is a software decision. I've
never seen any other user, but it could be done quite differently from
how it is used in highbank. In the case of highbank, we assigned a tx
and rx mailbox. While both the management core and linux side have all
8 interrupts wired up, we have assigned an interrupt to each side. I
suppose you could have the interrupt tied to each mailbox, but really
they are unrelated in the pl320 as each mailbox message could have
multiple targets (interrupts). Probably splitting this between a pl320
lib and platform specific drivers would be the right split if there
are ever other users.


> -       ipc_irq = adev->irq[0];
> -       ret = request_irq(ipc_irq, ipc_handler, 0, dev_name(&adev->dev), NULL);
> +       pl->adapter.dev = &adev->dev;
> +       pl->adapter.ops = &pl320_mbox_ops;
> +       pl->adapter.nchannels = 1;

Shouldn't this be 2? The 2 channels here are not a single
bi-directional channel in any way. They are completely independent and
have unrelated events. For example we originally defined having 3
mailboxes where we had 2 tx mailboxes for fast and slow messages, but
we ultimately decided everything could be a single tx mailbox. Event
completion is handled synchronously via the pl320's handshake
mechanism. I'd imagine you could have a protocol where you have async
completions via an rx mailbox instead.

Rob
