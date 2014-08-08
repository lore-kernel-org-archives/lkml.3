Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbaHHJOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 05:14:25 -0400
Received: from plane.gmane.org ([80.91.229.3]:48748 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755518AbaHHJOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 05:14:03 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [PATCH v3 RESEND] zram: auto add new devices on demand
Date: Fri, 08 Aug 2014 02:13:44 -0700
Message-ID: <ls24ca$u8q$1@ger.gmane.org>
References: <53CCEF76.4040002@gmail.com> <20140729030021.GA22707@bbox> <20140730135831.GA1098@swordfish> <20140805014917.GA27993@bbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 66-87-138-174.pools.spcsdns.net
User-Agent: KNode/4.13.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan Kim wrote:

> On Wed, Jul 30, 2014 at 10:58:31PM +0900, Sergey Senozhatsky wrote:
>> Hello,
>> 
>> On (07/29/14 12:00), Minchan Kim wrote:
>> > Hello Timofey,
>> > 

<snip>

>> > Why do you add new device unconditionally?
>> > Maybe we need new konb on sysfs or ioctl for adding new device?
>> > Any thought, guys?
>> 
>> 
>> speaking of the patch, frankly, I (almost) see no gain comparing to the
>> existing functionality.
>> 
>> speaking of the idea. well, I'm not 100% convinced yet. the use cases I
>> see around do not imply dynamic creation/resizing/etc. that said, I need
>> to think about it.
> 
> It didn't persuade me, either.
> 
> Normally, distro have some config file for adding param at module loading
> like /etc/modules. So, I think it should be done in there if someone want
> to increase the number of zram devices.

The problem here is that this requires (at least) unloading the module, and 
if it was built in requires a reboot (and futzing with the kernel command 
line, rather than /etc/modules.d)

If someone's distro already loaded the module with nr_devices=1 (the 
default, I remind you), and is using it as swap, then it may well not be a 
feasible option for them to swapoff the (potentially large) swap device and 
do the modprobe dance.

If they're running off a livecd that's using it in combination with, say, 
LVM thin provisioning in order to have a writeable system, then they are 
_completely_ screwed because you can't swapoff your rootfs.

If they're using it as a backing store for ephemeral containers or VMs, then 
they may hit _any_ static limit, when they just want to start one more 
without having to stop the existing bunch.

The swap case might be argued as "deal with it" (despite that swapoff is not 
something fun to do on a system under any real-world load, _especially_ if 
what you're trying to force off of the swap device won't fit in ram and has 
to get pushed down to a different swap device).

But any case where people put filesystems on the device should make the 
issues of only supporting the module parameter pretty apparent.

Finally, there's the issue of clutter - I may need 4 zram devices when I'm 
experimenting with something, but only the one swap device for daily use. 
Having the other three just sitting around permanently is at most an 
annoyance, a 'papercut' - but papercuts add up.

>> 
>> if we end up adding this functionality I tend to vote for sysfs knob,
>> just because it seems to be more user friendly than writing some magic
>> INTs to ioctl-d fd.

This I agree with wholeheartedly.

<snip>


