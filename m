Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab3CSA10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 20:27:26 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53388 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932825Ab3CSA1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 20:27:25 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 18 Mar 2013 17:27:24 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "Simon J. Rowe" <srowe@mose.org.uk>
Cc: lm-sensors@lm-sensors.org, tomas.winkler@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: RFC (v2): Intel QST sensor driver
Message-ID: <20130319002724.GA1843@roeck-us.net>
References: <51478535.8080107@mose.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51478535.8080107@mose.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

On Mon, Mar 18, 2013 at 09:20:53PM +0000, Simon J. Rowe wrote:
> Hello,
> 
> I've made changes to my driver for the Intel Quiet System Technology
> (QST) function that I posted at the end of last year and would again
> appreciate feedback on it.
> 
> As before the git repo can be found here:
> 
>     http://mose.dyndns.org/mei.git
> 
> 
> Changes from v1
> ---------------
> 
> The module has been re-written to be data-driven rather than use
> macros. Only v1 of the protocol is implemented but adding support for
> v2 only requires three arrays and nine stub functions to be defined.
> 
> The code has been compiled and tested on 3.9 rc2.
> 
> The code has been fixed up after running checkpatch.pl.
> 
Couple of problems I noticed when browsing through the code.

- Some functions return errors with return code 0.

	if (ret <= 0)
		goto out;
	...
out:
	return ret;

  For values of 0, the calling code will likely miss the error.

- In some cases, returned errors are replaced with another error

	if (ret < 0)
		return -EIO;

  You should return the original error.

- Try using something better than -EIO is possible. For example, you can use
  -EINVAL for invalid parameters.

- Don't use strict_str functions. Use kstr functions instead (checkpatch should
  tell you that, actually).

- Try using dev_ messages as much as possible (instead of pr_)

- Try allocating memory with devm_ functions. This way you can drop the matching
  calls to kfree().

- I notice you use kmalloc() a lot. That is ok if you know that you'll
  initialize all fields, but it is kind of risky. Better use kzalloc().
  (if you start using devm_kzalloc, the issue becomes mostly irrelevant,
  as there is no devm_kmalloc).

> I've added documents that explain the QST protocol and also the design
> of the driver.
> 
For my part I like the architecture of your driver. Wonder how difficult
it would be to implement the functionality supported by the in-kernel driver
(eg watchdog) with your infrastructure.

Overall it would be great if you and Tomas could get together and come up
with a unified implementation.

Thanks,
Guenter

> 
> Unchanged from v1
> -----------------
> 
> The driver still uses my MEI implementation. I've taken a look at the
> Intel-written driver in 3.9 and it still has no obvious way to be used
> by another driver, in the same directory or otherwise. The lack of
> documentation may mean I've overlooked something obvious.
> 
> The following patch is still required to prevent libsensors from
> ignoring the hwmon directory
> 
> diff -ur lm_sensors-3.3.1.org/lib/sysfs.c lm_sensors-3.3.1/lib/sysfs.c
> --- lm_sensors-3.3.1.org/lib/sysfs.c   2011-03-04 20:37:43.000000000 +0000
> +++ lm_sensors-3.3.1/lib/sysfs.c        2012-11-14 21:48:52.144860375 +0000
> @@ -701,6 +701,12 @@
>                 /* As of kernel 2.6.32, the hid device names don't
> look good */
>                 entry.chip.bus.nr = bus;
>                 entry.chip.addr = id;
> +       } else
> +       if (subsys && !strcmp(subsys, "intel-mei") &&
> +           sscanf(dev_name, "mei%d:%d", &bus, &fn) == 2) {
> +               entry.chip.bus.type = SENSORS_BUS_TYPE_PCI;
> +               entry.chip.bus.nr = bus;
> +               entry.chip.addr = fn;
>         } else {
>                 /* Ignore unknown device */
>                 err = 0;
> 
> PWM is still unimplemented.
> 
