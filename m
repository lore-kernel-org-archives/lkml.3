Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaCGUvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 15:51:15 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:49560 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaCGUvN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 15:51:13 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [systemd-devel] Suspending access to opened/active /dev/nodes during application runtime
From: Lukasz Pawelczyk <havner@gmail.com>
In-Reply-To: <20140307192410.GA24453@tango.0pointer.de>
Date: Fri, 7 Mar 2014 21:51:04 +0100
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        libvir-list@redhat.com, lxc-devel@lists.linuxcontainers.org,
        systemd-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <9E972401-6FA3-439B-9531-49D1FCC8D61D@gmail.com>
References: <9D7BA6C9-9F1F-4D09-8F4F-E7DA4720FF97@gmail.com> <20140307192410.GA24453@tango.0pointer.de>
To: Lennart Poettering <mzerqung@0pointer.de>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 7 Mar 2014, at 20:24, Lennart Poettering <mzerqung@0pointer.de> wrote:

> On Fri, 07.03.14 19:45, Lukasz Pawelczyk (havner@gmail.com) wrote:
> 
>> Problem:
>> Has anyone thought about a mechanism to limit/remove an access to a
>> device during an application runtime? Meaning we have an application
>> that has an open file descriptor to some /dev/node and depending on
>> *something* it gains or looses the access to it gracefully (with or
>> without a notification, but without any fatal consequences).
> 
> logind can mute input devices as sessions are switched, to enable
> unpriviliged X11 and wayland compositors.

Would you please elaborate on this? Where is this mechanism? How does it work without kernel space support? Is there some kernel space support I’m not aware of?

>> Example:
>> LXC. Imagine we have 2 separate containers. Both running full operating
>> systems. Specifically with 2 X servers. Both running concurrently of
> 
> Well, devices are not namespaced on Linux (with the single exception of
> network devices). An X server needs device access, hence this doesn't
> fly at all.
> 
> When you enumerate devices with libudev in a container they will never
> be marked as "initialized" and you do not get any udev hotplug events in
> containers, and you don#t have the host's udev db around, nor would it
> make any sense to you if you had. X11 and friends rely on udev
> however...
> 
> Before you think about doing something like this, you need to fix the
> kernel to provide namespaced devices (good luck!)

Precisly! That’s the generic idea. I’m not for implementing it though at this moment. I just wanted to know whether anybody actually though about it or maybe someone is interested in starting such a work, etc.

>> course. Both need the same input devices (e.g. we have just one mouse).
>> This creates a security problem when we want to have completely separate
>> environments. One container is active (being displayed on a monitor and
>> controlled with a mouse) while the other container runs evtest
>> /dev/input/something and grabs the secret password user typed in the
>> other.
> 
> logind can do this for you between sessions. But such a container setup
> will never work without proper device namespacing.

So how can it do it when there is no kernel support? You mean it could be doing this if the support were there?

>> Solutions:
>> The complete solution would comprise of 2 parts:
>> - a mechanism that would allow to temporally "hide" a device from an
>> open file descriptor.
>> - a mechanism for deciding whether application/process/namespace should
>> have an access to a specific device at a specific moment
> 
> Well, there's no point in inventing any "mechanisms" like this, as long
> as devices are not namespaced in the kernel, so that userspace in
> containers can enumerate/probe/identify/... things correctly…

True. My point is about kernel space implementation. Like I wrote. I haven’t seen anything like this in kernel source and I’m well away it should be done there.
I would just like to know if anybody is interested in this, if anybody started or would like to start such a thing.

I do understand that systemd/logind would only provide a mechanism for determining who should have an access and who shouldn’t (or to be more specific it would utilize some kernel space configuration like cgroups). But the work itself has to be done in kernel space.

-- 
Regards,
Havner



