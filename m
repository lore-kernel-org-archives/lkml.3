Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbaDKMmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 08:42:25 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:45982 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754198AbaDKMmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 08:42:24 -0400
Message-ID: <5347E32B.1080002@vmware.com>
Date: Fri, 11 Apr 2014 14:42:19 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: DRM security flaws and security levels.
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

as was discussed a while ago, there are some serious security flaws with
the current drm master model, that allows a
user that had previous access or current access to an X server terminal
to access the GPU memory of the active X server, without being
authenticated to the X server and thereby also access other user's
secret information

Scenario 1a)
User 1 uses the X server, then locks the screen. User 2 then VT
switches, perhaps using fast user-switching, opens a DRM connection and
becomes authenticated with itself. It then starts to guess GEM names
used by the switched-away X server and open the corresponding objects.
Then mmaps those objects and dumps data.

Scenario 1b)
As in 1, but instead of mmaping the GEM objects, crafts a command buffer
that dumps all GPU memory to a local buffer and copies it out.

Scenario 2
User 1 logs in on X. Starts a daemon that authenticates with X. Then
logs out. User 2 logs in. User 1's daemon can now access data in a
similar fashion to what's done in 1a and 1b.

I don't think any driver is immune against all these scenarios. I think
all GEM drivers are vulnerable to 1a) and 2a), but that could be easily
fixed by only allowing GEM open of shared buffers from the same master.
I'm not sure about 1b) and 2b) but according to the driver developers,
radeon and noveau should be safe. vmwgfx should be safe against 1) but
not currently against 2 because the DRM fd is being kept open across X
server generations.

I think these flaws can be fixed in all modern drivers. For a) type
scenarios, refuse open of shared buffers that belong to other masters,
and on new X server generations, release the old master completely by
closing the FD or a special ioctl that releases master instead of drops
master.

For b) type scenarios, either provide a command verifier, per fd virtual
GPU memory or for simpler hardware:
throw out all GPU memory on master drop and block ioctls requiring
authentication until master becomes active again.

In any case, before enabling render nodes for drm we discussed a sysfs
attribute that stated the security level of the device, so that udev
could set up permissions accordingly. My suggestion is:

-1: The driver allows an authenticated client to craft command streams
that could access any part of system memory. These drivers should be
kept in staging until they are fixed.
0: Drivers that are vulnerable to any of the above scenarios.
1: Drivers that are immune against all above scenarios but allows any
authenticated client with *active* master to access all GPU memory. Any
enabled render nodes will be insecure, while primary nodes are secure.
2: Drivers that are immune against all above scenarios and can protect
clients from accessing eachother's gpu memory:
Render nodes will be secure.

Thoughts?

Thomas
