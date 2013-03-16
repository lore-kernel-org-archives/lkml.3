Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab3CPCK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 22:10:59 -0400
Received: from mout.web.de ([212.227.15.4]:59071 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180Ab3CPCK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 22:10:56 -0400
Message-ID: <5143D4A5.4080002@web.de>
Date: Sat, 16 Mar 2013 03:10:45 +0100
From: Soeren Moch <smoch@web.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Arnd Bergmann <arnd@arndb.de>, USB list <linux-usb@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-mm@kvack.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] USB: EHCI: fix for leaking isochronous data
References: <Pine.LNX.4.44L0.1303141719450.1194-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1303141719450.1194-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:gWRp6u6viLZPRZv34qNa2cYKNSajQ2hzpVRlX+yXvah
 AtdgF/1zJw5PpJoQ1swQRrPwdK+K608htbSDrb+Lj4RKoV0MbG
 9fv3uluAgcyAdF1CJlm7yqIYPLXfMPWqtRGxnsqKoDl3ax5DyK
 TIUx6QlwUD7W3hYvMIhmZM9QeWVOLld3LwEmUEtOpDCxnD6xWr
 wiK/YSDjMAyPIgvG3vsLA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.03.2013 22:33, Alan Stern wrote:
> Maybe a better way to go about this is, instead of printing out every
> allocation and deallocation, to keep a running counter.  You could have
> the driver print out the value of this counter every minute or so.  Any
> time the device isn't in use, the counter should be 0.

I implemented the counter. The max value is sampled at the beginning of 
end_free_itds(), the current counter value is sampled at the end of this 
function. Counter values w/o a max number are from the error path in 
itd_urb_transaction().
The number of allocated iTDs can grow to higher values (why?), but 
normally the iTDs are freed during normal operation. Due to some reason 
the number of iTDs suddenly increases until coherent pool exhaustion. 
There is no permanent memory leak, all iTDs are released when the user 
application ends. But imho several thousands of iTDs cannot be the 
intended behavior...

   Soeren


Mar 16 01:12:52 guruvdr kernel: itd_counter:42 (max:174)
Mar 16 01:12:52 guruvdr kernel: itd_counter:0 (max:174)
Mar 16 01:13:13 guruvdr kernel: itd_counter:42 (max:174)
Mar 16 01:13:13 guruvdr kernel: itd_counter:0 (max:174)
Mar 16 01:13:34 guruvdr kernel: itd_counter:87 (max:174)
Mar 16 01:13:34 guruvdr kernel: itd_counter:0 (max:174)
Mar 16 01:13:55 guruvdr kernel: itd_counter:42 (max:426)
Mar 16 01:13:55 guruvdr kernel: itd_counter:0 (max:426)
Mar 16 01:15:14 guruvdr kernel: itd_counter:249 (max:1441)
Mar 16 01:15:14 guruvdr kernel: itd_counter:0 (max:1441)
[...]
Mar 16 02:03:33 guruvdr kernel: itd_counter:0 (max:1441)
Mar 16 02:04:15 guruvdr kernel: itd_counter:150 (max:1441)
Mar 16 02:04:15 guruvdr kernel: itd_counter:0 (max:1441)
Mar 16 02:04:36 guruvdr kernel: itd_counter:42 (max:1441)
Mar 16 02:04:36 guruvdr kernel: itd_counter:0 (max:1441)
Mar 16 02:04:57 guruvdr kernel: itd_counter:42 (max:1441)
Mar 16 02:04:57 guruvdr kernel: itd_counter:0 (max:1441)
Mar 16 02:05:18 guruvdr kernel: itd_counter:42 (max:1441)
Mar 16 02:05:18 guruvdr kernel: itd_counter:0 (max:1441)
Mar 16 02:05:39 guruvdr kernel: itd_counter:42 (max:1441)
Mar 16 02:05:39 guruvdr kernel: itd_counter:0 (max:1441)
Mar 16 02:06:43 guruvdr kernel: itd_counter:254 (max:1441)
Mar 16 02:07:44 guruvdr kernel: itd_counter:968 (max:1469)
Mar 16 02:08:04 guruvdr kernel: itd_counter:1192 (max:1469)
Mar 16 02:08:46 guruvdr kernel: itd_counter:1812 (max:1854)
Mar 16 02:09:07 guruvdr kernel: itd_counter:2117 (max:2159)
Mar 16 02:09:28 guruvdr kernel: itd_counter:2482 (max:2524)
Mar 16 02:09:49 guruvdr kernel: itd_counter:2791 (max:2833)
Mar 16 02:10:10 guruvdr kernel: itd_counter:3088 (max:3409)
Mar 16 02:10:31 guruvdr kernel: itd_counter:3402 (max:3444)
Mar 16 02:10:52 guruvdr kernel: itd_counter:3689 (max:3731)
Mar 16 02:11:13 guruvdr kernel: itd_counter:3950 (max:4073)
Mar 16 02:11:34 guruvdr kernel: itd_counter:4264 (max:4306)
Mar 16 02:11:55 guruvdr kernel: itd_counter:4525 (max:4567)
Mar 16 02:12:16 guruvdr kernel: itd_counter:4803 (max:4845)
Mar 16 02:12:37 guruvdr kernel: itd_counter:5028 (max:5070)
Mar 16 02:13:19 guruvdr kernel: itd_counter:5549 (max:5843)
Mar 16 02:13:40 guruvdr kernel: itd_counter:5836 (max:5878)
Mar 16 02:14:01 guruvdr kernel: itd_counter:6133 (max:6238)
Mar 16 02:14:06 guruvdr kernel: ERROR: 1024 KiB atomic DMA coherent pool 
is too small!
Mar 16 02:14:06 guruvdr kernel: Please increase it with coherent_pool= 
kernel parameter!
Mar 16 02:14:06 guruvdr kernel: itd_counter:6275
Mar 16 02:14:06 guruvdr kernel: orion-ehci orion-ehci.0: can't init itds
Mar 16 02:14:06 guruvdr kernel: itd_counter:6275
Mar 16 02:14:06 guruvdr kernel: orion-ehci orion-ehci.0: can't init itds
Mar 16 02:14:06 guruvdr kernel: itd_counter:6275
Mar 16 02:14:06 guruvdr kernel: orion-ehci orion-ehci.0: can't init itds
Mar 16 02:14:06 guruvdr kernel: itd_counter:6275
Mar 16 02:14:06 guruvdr kernel: orion-ehci orion-ehci.0: can't init itds
Mar 16 02:14:07 guruvdr kernel: itd_counter:6275
Mar 16 02:14:07 guruvdr kernel: orion-ehci orion-ehci.0: can't init itds
Mar 16 02:14:07 guruvdr kernel: itd_counter:6275
Mar 16 02:14:07 guruvdr kernel: orion-ehci orion-ehci.0: can't init itds
Mar 16 02:14:07 guruvdr kernel: itd_counter:6275
Mar 16 02:14:07 guruvdr kernel: orion-ehci orion-ehci.0: can't init itds
Mar 16 02:14:07 guruvdr kernel: itd_counter:6275
Mar 16 02:14:07 guruvdr kernel: orion-ehci orion-ehci.0: can't init itds
Mar 16 02:14:08 guruvdr kernel: itd_counter:6275
Mar 16 02:14:08 guruvdr kernel: orion-ehci orion-ehci.0: can't init itds
Mar 16 02:14:08 guruvdr kernel: itd_counter:78 (max:6275)
Mar 16 02:14:22 guruvdr kernel: itd_counter:0 (max:6275)

