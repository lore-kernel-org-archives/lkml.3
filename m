Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202AbbAGCIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:08:10 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:53032 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933151AbbAGCHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:07:51 -0500
X-Greylist: delayed 461 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Jan 2015 21:07:49 EST
Date: Tue, 6 Jan 2015 19:59:55 -0600
From: David Fries <David@Fries.net>
To: Mariusz Gorski <marius.gorski@gmail.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] w1: slaves: w1_therm: Add sysfs entry for current
 temperature
Message-ID: <20150107015955.GA14323@spacedout.fries.net>
References: <1420554596-10250-1-git-send-email-marius.gorski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420554596-10250-1-git-send-email-marius.gorski@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Tue, 06 Jan 2015 19:59:56 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 03:29:54PM +0100, Mariusz Gorski wrote:
> DS18B20 and it's brothers are pretty popular in the RaspberryPi world
> when it comes to temperature measurement. All tutorials on the Internet
> use the same way of parsing the output of the w1_slave sysfs file.
> These patches add a dedicated sysfs entry called 'temp' whose only job
> is to output the current temperature.
> 
> What could be improved here is the way how dev->bus_mutex is locked/unlocked,
> which is split right now between two functions - maybe it would be better
> to move all dev->bus_mutex locking into read_rom() and introduce another
> mutex for protecting the slave's structures (e.g. family_data).

As to adding another mutex, there are enough little mutexes around the
one wire system that it already feels like a mess and I tried to get 
all the race conditions that I could.

I think you don't understand what the bus_mutex protects.  It protects
other devices from accessing the one wire bus.  The way you coded it,
temp_show will allow only one temperature sensor to be accessed and
read at a time, considering it takes 750 ms that's holding up the bus
for a long time, and depending on how the devices are connected, isn't
needed.  If the temperature sensor is parasite powered, nothing else
can use the bus while it is converting, if it has dedicated power,
other slaves can be accessed at the same time.

I second using a standard sensor attribute if there is one appropriate
rather than here.  I didn't in my application, but then I wasn't 
adding a new method to get the same data, I was using the existing 
netlink method.  If it does get added to a standard sensor access
method, I do request that it be optional (like w1_therm which I don't
use), and not sit there polling the sensor for the current temperature
every X seconds when no one is using the data (OpenBSD does this, or
at least last I saw, and you have no idea how old the sensor data
reading is or have any control over how often it will poll it).

I have 15 DS18B20 temperature sensors scattered around the house on a 
single one wire network.  I don't use the w1_therm system, I talk
through netlink to the kernel.  This has the advantage of being an
asynchronous socket based interface so I can write a packet to request
each sensor to do a conversion, get the write command status, and then
after a timeout, write another to get a return, then read back the
data.

Using the sysfs means blocking while the read is in progress.  Reading
15 means either taking at least 11.250 seconds as you read them
serially, or having 15 threads blocked on one read each (provided they
don't block the other readers).

Thanks for Cc'ing me on this.

> Mariusz Gorski (2):
>   w1: slaves: w1_therm: Extract read_rom function
>   w1: slaves: w1_therm: Add temp attribute
> 
>  drivers/w1/slaves/w1_therm.c | 83 ++++++++++++++++++++++++++++++++++----------
>  1 file changed, 65 insertions(+), 18 deletions(-)
> 
> -- 
> 2.2.1

-- 
David Fries <david@fries.net>    PGP pub CB1EE8F0
http://fries.net/~david/
