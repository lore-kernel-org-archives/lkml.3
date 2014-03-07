Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbaCGSqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 13:46:54 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:64493 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaCGSqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 13:46:53 -0500
From: Lukasz Pawelczyk <havner@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: Suspending access to opened/active /dev/nodes during application runtime
Message-Id: <E7B2439D-FF36-4353-8E1A-C58E5C33A89F@gmail.com>
Date: Fri, 7 Mar 2014 19:46:44 +0100
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        libvir-list@redhat.com, lxc-devel@lists.linuxcontainers.org,
        systemd-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem:
Has anyone thought about a mechanism to limit/remove an access to a
device during an application runtime? Meaning we have an application
that has an open file descriptor to some /dev/node and depending on
*something* it gains or looses the access to it gracefully (with or
without a notification, but without any fatal consequences).

Example:
LXC. Imagine we have 2 separate containers. Both running full operating
systems. Specifically with 2 X servers. Both running concurrently of
course. Both need the same input devices (e.g. we have just one mouse).
This creates a security problem when we want to have completely separate
environments. One container is active (being displayed on a monitor and
controlled with a mouse) while the other container runs evtest
/dev/input/something and grabs the secret password user typed in the
other.

Solutions:
The complete solution would comprise of 2 parts:
- a mechanism that would allow to temporally "hide" a device from an
open file descriptor.
- a mechanism for deciding whether application/process/namespace should
have an access to a specific device at a specific moment

Let's focus on the first problem only, as it would need to be solved
first anyway.  I haven't found anything that would allow me to do
it. There are a lot mechanisms that make it possible to restrict an
access during open():
- DAC
- ACL (controlled by hand or with uaccess)
- LSM (in general)
- device cgroups
But all of those can't do a thing when the device is already opened and
an application has a file descriptor.  I don't see such mechanism in
kernel sources either.

I do imagine that it would not be possible for every device to handle
such a thing (dri comes to mind) without breaking something (graphics
card state in dri example). But there is class of simple input/output
devices that would handle this without problems.

I did implement some proof-of-concept solution for an evdev driver by
allowing or disallowing events that go to evdev_client structure using
some arbitrary condition. But this is far from a generic solution.

My proof-of-concept is somewhat similar to this (I just found it):
http://www.spinics.net/lists/linux-input/msg25547.html
Though a little bit wider in scope. But neither is flawless nor
generic.

Has anyone had any thoughts about a similar problem?


-- 
Regards
Havner
