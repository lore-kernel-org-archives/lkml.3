Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbaFMVqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 17:46:20 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:49155 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096AbaFMVqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 17:46:14 -0400
Date: Fri, 13 Jun 2014 14:46:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lan Tianyu <tianyu.lan@intel.com>
cc: rjw@rjwysocki.net, lenb@kernel.org, naszar@ya.ru,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ACPI/Battery: Retry to get Battery information if failed
 during probing
In-Reply-To: <539A60FC.1050301@intel.com>
Message-ID: <alpine.DEB.2.02.1406131445130.31981@chino.kir.corp.google.com>
References: <1402552946-14704-1-git-send-email-tianyu.lan@intel.com> <alpine.DEB.2.02.1406112354070.23724@chino.kir.corp.google.com> <53995488.20308@intel.com> <alpine.DEB.2.02.1406120025050.23724@chino.kir.corp.google.com> <53996152.2000407@intel.com>
 <alpine.DEB.2.02.1406121415150.8305@chino.kir.corp.google.com> <539A60FC.1050301@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2014, Lan Tianyu wrote:

> How about this?
> 
> -       result = acpi_battery_update(battery, false);
> -       if (result)
> +
> +       /*
> +        * Some machines'(E,G Lenovo Z480) ECs are not stable
> +        * during boot up and this causes battery driver fails to be
> +        * probed due to failure of getting battery information
> +        * from EC sometimes. After several retries, the operation
> +        * may work. So add retry code here and 20ms sleep between
> +        * every retries.
> +        */
> +       while (acpi_battery_update(battery, false) && retry--)
> +               msleep(20);
> +       if (!retry) {
> +               result = -ENODEV;
>                 goto fail;
> +       }
> +

I think you want --retry and not retry--.  Otherwise it's possible for the 
final call to acpi_battery_update() to succeed and now it's returning 
-ENODEV.
