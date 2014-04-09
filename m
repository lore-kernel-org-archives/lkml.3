Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934205AbaDITPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:15:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37478 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323AbaDITPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:15:09 -0400
Date: Wed, 9 Apr 2014 12:17:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: m.chehab@samsung.com, tj@kernel.org, rafael.j.wysocki@intel.com,
        linux@roeck-us.net, toshi.kani@hp.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [RFC PATCH 0/2] managed token devres interfaces
Message-ID: <20140409191740.GA10748@kroah.com>
References: <cover.1397050852.git.shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1397050852.git.shuah.kh@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 09:21:06AM -0600, Shuah Khan wrote:
> Media devices often have hardware resources that are shared
> across several functions. For instance, TV tuner cards often
> have MUXes, converters, radios, tuners, etc. that are shared
> across various functions. However, v4l2, alsa, DVB, usbfs, and
> all other drivers have no knowledge of what resources are
> shared. For example, users can't access DVB and alsa at the same
> time, or the DVB and V4L analog API at the same time, since many
> only have one converter that can be in either analog or digital
> mode. Accessing and/or changing mode of a converter while it is
> in use by another function results in video stream error.
> 
> A shared devres that can be locked and unlocked by various drivers
> that control media functions on a single media device is needed to
> address the above problems.
> 
> A token devres that can be looked up by a token for locking, try
> locking, unlocking will help avoid adding data structure
> dependencies between various media drivers. This token is a unique
> string that can be constructed from a common data structure such as
> struct device, bus_name, and hardware address.
> 
> The devm_token_* interfaces manage access to token resource.
> 
> Interfaces:
>     devm_token_create()
>     devm_token_destroy()
>     devm_token_lock()
>     devm_token_unlock()
> Usage:
>     Create token:
>         Call devm_token_create() with a token id which is a unique
>         string.
>     Lock token: Call devm_token_lock() to lock or try lock a token.
>     Unlock token: Call devm_token_unlock().
>     Destroy token: Call devm_token_destroy() to delete the token.
> 
> A new devres_* interface to update the status of this token resource
> to busy when locked and free when unlocked is necessary to implement
> this new managed resource.
> 
> devres_update() searches for the resource that matches supplied match
> criteria similar to devres_find(). When a match is found, it calls
> the update function caller passed in.
> 
> This patch set adds a new devres_update) interface and token devres
> interfaces.
> 
> Test Cases for token devres interfaces: (passed)
>  - Create, lock, unlock, and destroy sequence.
>  - Try lock while it is locked. Returns -EBUSY as expected.
>  - Try lock after destroy. Returns -ENODEV as expected.
>  - Unlock while it is unlocked. Returns 0 as expected. This is a no-op. 
>  - Try unlock after destroy. Returns -ENODEV as expected.

Any chance you can add these "test cases" as part of the kernel code so
it lives here for any future changes?

> Special notes for Mauro Chehab:
>  - Please evaluate if these token devres interfaces cover all media driver
>    use-cases. If not what is needed to cover them.
>  - For use-case testing, I generated a string from em28xx device, as this
>    is common for all em28xx extensions: (hope this holds true when em28xx
>    uses snd-usb-audio
>  - Construct string with (dev is struct em28xx *dev)
> 		format: "tuner:%s-%s-%d"
> 		with the following:
>    		dev_name(&dev->udev->dev)
>                 dev->udev->bus->bus_name
>                 dev->tuner_addr
>  - I added test code to em28xx_card_setup() to test the interfaces:
>    example token from this test code generated with the format above:

What would the driver changes look like to take advantage of these new
functions?

thanks,

greg k-h
