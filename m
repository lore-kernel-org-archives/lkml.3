Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab3GSVIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 17:08:04 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:35858 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab3GSVIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 17:08:01 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1307191012330.1055-100000@iolanthe.rowland.org>
References: <1374191339-10124-1-git-send-email-mcgrof@do-not-panic.com> <Pine.LNX.4.44L0.1307191012330.1055-100000@iolanthe.rowland.org>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 19 Jul 2013 14:07:39 -0700
X-Google-Sender-Auth: gTMEhUcpwL3jiujZR6JSEJbOAdw
Message-ID: <CAB=NE6XmxX0UQkbchU_AKJOyENcn0auBGMPzru5C4nohg_v1sQ@mail.gmail.com>
Subject: Re: [PATCH] backports: backport drvdata = NULL core driver fixes
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "backports@vger.kernel.org" <backports@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Julia Lawall <julia.lawall@lip6.fr>, linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 7:17 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 18 Jul 2013, Luis R. Rodriguez wrote:
>
>> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
>>
>> The Linux kernel had tons of code which at times cleared the
>> drvdata upon probe failure or release. There are however a bunch
>> of drivers that didn't clear this.
>>
>> Commit 0998d063 implmented clearing this upon device_release_driver()
>> and dealt with probe failure on driver_probe_device(). After this the
>> kernel was cleaned up separately with *tons* of patches to remove all
>> these driver specific settings given that the clearing is now done
>> internally by the device core.
>>
>> Instead of ifdef'ing code back in for older code where it was properly
>> in place backport this by piggy backing the new required code upon the
>> calls used in place. There is a small race here upon device_release_driver()
>> but we can live with that theoretical race.
>>
>> Due to the way we hack this backport we can't use a separate namespace
>> as we have with other symbols.
>>
>> mcgrof@frijol ~/linux-stable (git::master)$ git describe --contains \
>>       0998d0631001288a5974afc0b2a5f568bcdecb4d
>> v3.6-rc1~99^2~14^2~17
>>
>> commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
>> Author: Hans de Goede <hdegoede@redhat.com>
>> Date:   Wed May 23 00:09:34 2012 +0200
>>
>>     device-core: Ensure drvdata = NULL when no driver is bound
>>
>>     1) drvdata is for a driver to store a pointer to driver specific data
>>     2) If no driver is bound, there is no driver specific data associated with
>>        the device
>>     3) Thus logically drvdata should be NULL if no driver is bound.
>>
>>     But many drivers don't clear drvdata on device_release, or set drvdata
>>     early on in probe and leave it set on probe error. Both of which results
>>     in a dangling pointer in drvdata.
>>
>>     This patch enforce for drvdata to be NULL after device_release or on probe
>>     failure.
>>
>>     Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> This is not a very good idea.  Although setting drvdata to NULL allowed
> a lot of code to be removed, it also exposed a bunch of hidden bugs --
> drivers were using the drvdata value even after their remove function
> returned.

Eek, have we not SmPL'ify'd a proof yet to ensure code like this no
longer exists? Julia? :)

> Several commits have been applied to fix those bugs.

I actualy found *tons* !

> Finding and backporting them and their dependencies will not be easy.

May the SmPL proof be with us.

> I suggest this patch not be applied.

Thanks for the review Alan!

  Luis
