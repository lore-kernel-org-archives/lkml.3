Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbaCOQJm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 12:09:42 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:62502 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbaCOQJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 12:09:40 -0400
MIME-Version: 1.0
In-Reply-To: <1394898081.30941.5.camel@jlt4.sipsolutions.net>
References: <20140305125703.GA7193@localhost> <20140305132317.GB10880@localhost>
 <20140308121138.GA8359@localhost> <20140312173446.GD2983@piware.de>
 <CABPxzYLJA-gQjw2CwmL63dYEQ35h073k_vsp1uEM0B-sAmEwKQ@mail.gmail.com>
 <1394896841.30941.4.camel@jlt4.sipsolutions.net> <CABPxzYJXQR=t6u33uFT5dU2y6sKK1QhCbBn+t4TmmNfVhNk5gw@mail.gmail.com>
 <1394898081.30941.5.camel@jlt4.sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Sat, 15 Mar 2014 21:39:18 +0530
Message-ID: <CABPxzYKGoCDwosqZ12f0godkgT=qy_QQyDuBLmR=_5s03y6V5g@mail.gmail.com>
Subject: Re: [mac80211_hwsim] BUG: unable to handle kernel paging request at ce1db404
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Martin Pitt <martin.pitt@ubuntu.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 9:11 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2014-03-15 at 21:03 +0530, Krishna Chaitanya wrote:
>
>> > > what RC are u using? Default should be minstrel, i dont see
>> > > a reason for rc alloc to fail (remote reason kmalloc failure),
>> > > so did you disable RC completely? No prints either w.r.t RC either in
>> > > dmesg?
>> >
>> > Pay attention to the .config.
>> >
>> Missed the attachment, thanks for pointing.
>> As guessed the rate control is empty causing the registration fail.
>
> It still shouldn't crash though. Looks like there's a fix in this
> thread, can somebody verify & post it?
>
Yes, it should not crash. The change suggested by martin is not correct
there is no double free as the the list he mentioned will be empty.
(Only after successful registration we will add the radio to the list)

the problem here is platform_driver_unregister internally calls the
driver_unregister
which tries to get the kobject through get_device, but we have already
freed the kobject using
device_unregister (which calls device_del which frees the kobject).

In other failures cases we use mac80211_hwsim_free() and return, so the call to
platform_driver_unregister is not there, hence no crash.
