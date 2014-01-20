Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaATVoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 16:44:06 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58285 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaATVoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 16:44:04 -0500
Date: Mon, 20 Jan 2014 21:43:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        jslaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 1/2] serial: samsung: Move uart_register_driver call to
 device probe
Message-ID: <20140120214305.54f65ffa@www.etchedpixels.co.uk>
In-Reply-To: <CAHbNUh3m=uNybv=3yxmr2on=Cc0UuGrYP8zf3GMR-9RQZ394dg@mail.gmail.com>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org>
	<1390208555-27770-2-git-send-email-tushar.behera@linaro.org>
	<20140120100530.GY15937@n2100.arm.linux.org.uk>
	<CAHbNUh3m=uNybv=3yxmr2on=Cc0UuGrYP8zf3GMR-9RQZ394dg@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I had earlier submitted a patch [1] to remove the hard coded
> major/minor number for Samsung UART driver, but that was rejected
> because of userspace breakage. Without this patch, Samsung UART driver
> can't bind to the hard-coded device node. Changing the default
> major/minor will also not help to fix the objections raised in [1].
> 
> Would you please suggest a way forward?
> 
> [1] https://lkml.org/lkml/2013/12/27/2

The dynamic major/minor is the right patch. If the userspace breaks then
the userspace was broken, but I see no evidence in the discussion that
the userspace broke.

204,64 belongs to Altix so neither of the clashing drivers should use it.
We had a table to stop messes like this, and we have dynamic numbering
to stop the table being needed for the future

           50 = /dev/ttyIOC0              Altix serial card
                    ...
           81 = /dev/ttyIOC31             Altix serial card


Thats what the list says. Samsung should have followed the rules, they
didn't so they get to pick up the pieces. The Amba driver wants moving as
well. It's easy. If you want something to be ABI then make sure you get
it upstream first, if not you get to own all the pain down the line.

Hacking up the core code to paper over this crap is not on. We've been
insisting firmly and robustly for years that people don't keep borrowing
names and numbers they are not allocated, and use dynamic values whenever
possible.

If the hardware isn't present then the driver shouldn't even register
with the tty layer in the first place so it doesn't make any resource
differeneces either for properly written code.

Alan
