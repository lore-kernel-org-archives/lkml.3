Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab3EQE5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 00:57:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35290 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752647Ab3EQE5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 00:57:18 -0400
Message-ID: <1368766637.2194.80.camel@joe-AO722>
Subject: Re: [PATCH 3/4] ipmi: Improve error messages on failed irq enable
From: Joe Perches <joe@perches.com>
To: Corey Minyard <cminyard@mvista.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Date: Thu, 16 May 2013 21:57:17 -0700
In-Reply-To: <5195A836.3010002@mvista.com>
References: <1368731067-31404-1-git-send-email-cminyard@mvista.com>
	 <1368731067-31404-4-git-send-email-cminyard@mvista.com>
	 <CALCETrXu2At7pRWReYpdFa6OgY79M4KiEKXR=beH+5FcTOL6zg@mail.gmail.com>
	 <5195A836.3010002@mvista.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-16 at 22:47 -0500, Corey Minyard wrote:
> On 05/16/2013 05:23 PM, Andy Lutomirski wrote:
> >
> >                  /* We got the flags from the SMI, now handle them. */
> >                  smi_info->handlers->get_result(smi_info->si_sm, msg, 4);
> > -               if (msg[2] != 0)
> > -                       dev_warn(smi_info->dev, "Could not enable interrupts"
> > -                                ", failed set, using polled mode.\n");
> > -               else
> > +               if (msg[2] != 0) {
> > +                       dev_warn(smi_info->dev,
> > +                                "Couldn't set irq info: %x.\n", msg[2]);
> > +                       dev_warn(smi_info->dev,
> > +                                "Maybe ok, but ipmi might run very slowly.\n");
> > +               } else
> > Minor nit: it would be nice if these warnings were collapsed into a
> > single printk -- that would save me a whitelist entry of acceptable
> > KERN_WARNING messages :)
> 
> Yeah, the trouble is that checkpatch will give a warning if you split a 
> string
> between two lines or if a line is longer than 80 characters.

Hi Corey.

Yes it will and no it won't.

	dev_<level>(struct device *, "some really really long format string that makes the line longer than 80 chars\n");

passes checkpatch without warning just fine.

I'd use something like:

			dev_warn(smi_info->dev,
				 "Couldn't set irq info: %x - this may be OK, but ipmi might run very slowly\n",
				 msg[2]);


