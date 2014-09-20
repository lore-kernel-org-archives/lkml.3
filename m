Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaITPMz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 11:12:55 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:61053 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaITPMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 11:12:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140920144257.GD14094@kroah.com>
References: <20140918174127.GB340@redhat.com>
	<1411130664-10195-1-git-send-email-r.peniaev@gmail.com>
	<20140919214257.GA27574@kroah.com>
	<CACZ9PQVEmzCSjaVX53ZoNw0MHCGeMVpXg63+URq8rYLXns6C0w@mail.gmail.com>
	<20140920144257.GD14094@kroah.com>
Date: Sun, 21 Sep 2014 00:12:52 +0900
Message-ID: <CACZ9PQVccRfk60jEOWwe7fe+H0WWaRbieV2hjqZwWdXad2U3XA@mail.gmail.com>
Subject: Re: [v4 PATCH 1/1] init: fix race between rootfs mount and firmware loading
From: Roman Peniaev <r.peniaev@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ming Lei <ming.lei@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2014 at 11:42 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Sat, Sep 20, 2014 at 10:18:39PM +0900, Roman Peniaev wrote:
>> On Sat, Sep 20, 2014 at 6:42 AM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > On Fri, Sep 19, 2014 at 09:44:24PM +0900, Roman Pen wrote:
>> >> The thing is that built-in modules are being inited before
>> >> rootfs mount.  Some of the modules can request firmware loading
>> >> from another thread using async 'request_firmware_nowait' call
>> >> on inition, so we can catch this kind of race:
>> >>    rootfs does not exist yet, but we are going to open and load
>> >>    firmware file requesting it from the kernel thread.
>> >>
>> >> Solution is simple: before any rootfs access firmware loader
>> >> must wait for rootfs mount.
>> >
>> > Even simpler solution, don't do that :)
>> >
>> > If your hardware needs firmware this early, and you don't put the
>> > firmare into the initrd/initramfs, then it will just be loaded later on,
>> > when the root filesystem is needed and the driver asks for it again
>> > (your driver is failing "nicely" and allows the firmware to be loaded
>> > later, right?  If not, that should be fixed...)
>> >
>> > Or, build the firmware into the kernel, I think we still have that
>> > option for some drivers that really wanted/needed this.
>> >
>> > What has changed recently that requires this type of patch?  What is
>> > wrong with the above solutions?
>>
>>
>> I definitely agree with that "do not do that", I do agree.
>
> Great, no need for a patch, we can move on now.  :)
>
>> But, I did not find any other solution, because in my case this "to be loaded
>> later" really matters. The source of the problem is the rtlwifi, which randomly
>> delays the startup, it randomly warns me about "firmware loading failed" and
>> repeats loading later. This later costs around one second. For my tiny arm
>> setup it is important. And it happens because of this race.
>
> What "costs one second"?  I don't understand, if the firmware isn't
> there, are you timing out?  Fix the driver to do async firmware loading
> and that timeout shouldn't be an issue.

Firmware exists. Driver is built-in (this is the key, because do_initcall_level,
which inits all static stuff including built-in drivers, is started
before rootfs mount).
Driver calls request_firmware_nowait on inition, so firmware_class will attempt
to load this firmware and will randomly fail. After the possible fail
the driver will try to
load alternative firmware and also can randomly fail, because the
rootfs is still not
mounted. Then driver gives up.

>
>> So, all I want to say with this patch is:
>>
>> 1. 'mount / firmware loading' race exists, and it can cost time.
>
> Switch the driver to do async firmware loading and you should be able to
> fix this.

Under async firmware loading you mean request_firmware_nowait ?
Driver uses exactly this call.

--
Roman
