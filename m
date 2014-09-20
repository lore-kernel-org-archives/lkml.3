Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbaITNSl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 09:18:41 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:43825 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567AbaITNSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 09:18:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140919214257.GA27574@kroah.com>
References: <20140918174127.GB340@redhat.com>
	<1411130664-10195-1-git-send-email-r.peniaev@gmail.com>
	<20140919214257.GA27574@kroah.com>
Date: Sat, 20 Sep 2014 22:18:39 +0900
Message-ID: <CACZ9PQVEmzCSjaVX53ZoNw0MHCGeMVpXg63+URq8rYLXns6C0w@mail.gmail.com>
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

On Sat, Sep 20, 2014 at 6:42 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Fri, Sep 19, 2014 at 09:44:24PM +0900, Roman Pen wrote:
>> The thing is that built-in modules are being inited before
>> rootfs mount.  Some of the modules can request firmware loading
>> from another thread using async 'request_firmware_nowait' call
>> on inition, so we can catch this kind of race:
>>    rootfs does not exist yet, but we are going to open and load
>>    firmware file requesting it from the kernel thread.
>>
>> Solution is simple: before any rootfs access firmware loader
>> must wait for rootfs mount.
>
> Even simpler solution, don't do that :)
>
> If your hardware needs firmware this early, and you don't put the
> firmare into the initrd/initramfs, then it will just be loaded later on,
> when the root filesystem is needed and the driver asks for it again
> (your driver is failing "nicely" and allows the firmware to be loaded
> later, right?  If not, that should be fixed...)
>
> Or, build the firmware into the kernel, I think we still have that
> option for some drivers that really wanted/needed this.
>
> What has changed recently that requires this type of patch?  What is
> wrong with the above solutions?


I definitely agree with that "do not do that", I do agree.
But, I did not find any other solution, because in my case this "to be loaded
later" really matters. The source of the problem is the rtlwifi, which randomly
delays the startup, it randomly warns me about "firmware loading failed" and
repeats loading later. This later costs around one second. For my tiny arm
setup it is important. And it happens because of this race.

So, all I want to say with this patch is:

1. 'mount / firmware loading' race exists, and it can cost time.
2. it affects the path of firmware loading (under the path I mean call
chain, not
    the path on the rootfs): sometimes firmware can be loaded on first
try by the
    request from the kernel, sometimes it can be loaded by push from userspace,
    sometimes it can be loaded from next retry from kernel
3. the firmware loading path is always unpredictable.

It turns out to be that to have predictable loading path and predictable timings
I have to build firmware into the kernel, that means that
request_firmware mechanics
does not work as expected, because it relies on the 'rootfs exists'
statement, but it is
not always true.

Frankly speaking I also do not like this patch, but as I told I did
not find any other _good_
solution . If we can discuss here better way, I can do further work
towards improvements
of request_firmware. Of course if it really makes any sense.

--
Roman
