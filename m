Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbaFQB2C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 21:28:02 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:46802 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbaFQB15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 21:27:57 -0400
Date: Mon, 16 Jun 2014 18:27:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lan Tianyu <tianyu.lan@intel.com>
cc: rjw@rjwysocki.net, lenb@kernel.org, naszar@ya.ru,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI/Battery: Retry to get Battery information if failed
 during probing
In-Reply-To: <539E528B.90908@intel.com>
Message-ID: <alpine.DEB.2.02.1406161827320.21018@chino.kir.corp.google.com>
References: <1402552946-14704-1-git-send-email-tianyu.lan@intel.com> <alpine.DEB.2.02.1406112354070.23724@chino.kir.corp.google.com> <53995488.20308@intel.com> <alpine.DEB.2.02.1406120025050.23724@chino.kir.corp.google.com> <53996152.2000407@intel.com>
 <alpine.DEB.2.02.1406121415150.8305@chino.kir.corp.google.com> <539A60FC.1050301@intel.com> <alpine.DEB.2.02.1406131445130.31981@chino.kir.corp.google.com> <539E528B.90908@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014, Lan Tianyu wrote:

> >> How about this?
> >>
> >> -       result = acpi_battery_update(battery, false);
> >> -       if (result)
> >> +
> >> +       /*
> >> +        * Some machines'(E,G Lenovo Z480) ECs are not stable
> >> +        * during boot up and this causes battery driver fails to be
> >> +        * probed due to failure of getting battery information
> >> +        * from EC sometimes. After several retries, the operation
> >> +        * may work. So add retry code here and 20ms sleep between
> >> +        * every retries.
> >> +        */
> >> +       while (acpi_battery_update(battery, false) && retry--)
> >> +               msleep(20);
> >> +       if (!retry) {
> >> +               result = -ENODEV;
> >>                 goto fail;
> >> +       }
> >> +
> > 
> > I think you want --retry and not retry--.
> 
> My original purpose is to retry 5 times after the first try fails.
> If use "--retry" here, it just retries 4 times.
> 
> >  Otherwise it's possible for the 
> > final call to acpi_battery_update() to succeed and now it's returning 
> > -ENODEV.
> > 
> 
> Yes, it maybe and I will change code like the following.
> 
> while ((result = acpi_battery_update(battery, false)) && retry--)
>        msleep(20);
> if (result)
>        goto fail;
> 

Looks good.
