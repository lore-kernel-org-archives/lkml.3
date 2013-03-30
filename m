Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab3C3Ul2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 16:41:28 -0400
Received: from smtp-out-090.synserver.de ([212.40.185.90]:1073 "EHLO
	smtp-out-090.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab3C3UlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 16:41:21 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 25491
Message-ID: <51574E71.7010403@metafoo.de>
Date: Sat, 30 Mar 2013 21:43:29 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6]  Make return type of i2c_del_adapter() (and i2c_del_mux_adapter())
 void
References: <1362853009-20789-1-git-send-email-lars@metafoo.de> <20130330211352.07530db7@endymion.delvare>
In-Reply-To: <20130330211352.07530db7@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2013 09:13 PM, Jean Delvare wrote:
> Hi Lars,
> 
> On Sat,  9 Mar 2013 19:16:43 +0100, Lars-Peter Clausen wrote:
>> Currently i2c_del_adapter() returns 0 on success and potentially an error code
>> on failure. Unfortunately this doesn't mix too well with the Linux device driver
>> model. (...)
> 
> I see:
> 
> struct device_driver {
> 	(...)
> 	int (*probe) (struct device *dev);
> 	int (*remove) (struct device *dev);
>
> So the driver core does allow remove functions to return an error.

Well, the return type is int, but the return value is never checked. So you
can return an error value, but the device driver core is going to care and
the device is still removed. So any code which does return an error in it's
probe function in the assumption that this means the device will still be
present is broken and leaves the system in an undefined state. So if that
happens the kernel will probably crash sooner or later, or if you are lucky
you only created a few resources leaks.

And no we can't change the core to handle errors from a drivers remove
callback. It's a basic inherent property of the Linux device driver model
that any device can be removed at any time.

> Are you going to fix all subsystems as you are doing for i2c now, and then
> change device_driver.remove to return void? If not, I don't see the
> point of changing it in i2c.
> 

As I said it's a bug if a driver returns an error in its remove function.
And the fact that the return type of the remove callback is int is pretty
much misleading in this regard, so the long term goal is to make the return
type void. But that's a long way to go until we get there, fixing the return
type of i2c_del_adapter() is kind of the low hanging fruit.

- Lars
